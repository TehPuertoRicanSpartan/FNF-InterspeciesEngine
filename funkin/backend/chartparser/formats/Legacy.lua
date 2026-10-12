---@class FunkinChartParserLegacy
local Legacy = {}

function Legacy.parse(data, eventData)
    local formatStr = function(a) return (a:lower()):gsub(" ", "-") end

    local input = data.song
    local output = {}

    -- initialize the metadata
    output.meta = {
        title = input.song,
        times = {
            {
                time = 0,
                bpm = input.bpm,
                sig = {input.notes[1].sectionBeats ~= nil and input.notes[1].sectionBeats or 4, 4}
            }
        },
        characters = {
            op = input.player2,
            gf = input.gfVersion or "gf",
            bf = input.player1
        },
        stage = input.stage or "stage"
    }

    -- initialize the chart
    output.chart = {
        speed = input.speed,
        events = {},
        notes = {
            opponent = {},
            player = {}
        }
    }

    local addEvent = function(t, e, v, f)
        table.insert(output.chart.events, {
            time = t,
            name = e,
            values = v,
            type = f or nil,
        })
    end

    if eventData ~= nil then
        if eventData.song then
            local eventInput = eventData.song
            if eventInput.events then -- psych engine >= v0.5.1 events
                for _, v in pairs(eventInput.events) do
                    for _, e in pairs(v[2]) do
                        addEvent(v[1], formatStr(e[1]), {v1 = e[2], v2 = e[3]}, "psych")
                    end
                end
            elseif eventInput.notes then -- psych engine <= v0.5 / hypno's lullaby events
                for _, s in pairs(eventInput.notes) do
                    for _, n in pairs(s.sectionNotes) do
                        if n[2] == -1 then
                            addEvent(n[1], formatStr(n[3]), {v1 = n[4], v2 = n[5]}, "psych")
                        end
                    end
                end
            end
        elseif eventData.events then -- fps plus events
            local eventInput = eventData.events
            for _, e in pairs(eventInput.events) do
                local props = string.split(e[4], ";")

                local values = {}
                for i, v in pairs(props) do
                    if i ~= 1 then
                        values["v" .. i - 1] = v
                    end
                end
                addEvent(e[2], e[1], values, "fps+")
            end
        end
    end

    local psych_v1 = input.format ~= nil and input.format:sub(1, 8) == "psych_v1" or false
    local curbpm, time, lastHit, lastSectionBeats = input.bpm, 0, true, output.meta.times[1].sig[1]
    for _, s in pairs(input.notes) do
        local hit = s.mustHitSection
        if lastHit ~= hit then
            addEvent(time, "camera-focus", {dir = hit and 1 or 0})
            lastHit = hit
        end

        local timeChange = {}
        if (s.changeBPM ~= nil and s.changeBPM) and (s.bpm ~= curbpm) then
            curbpm = s.bpm

            timeChange.time = time
            timeChange.bpm = curbpm
        end

        if s.sectionBeats ~= nil and s.sectionBeats ~= lastSectionBeats then
            timeChange.time = time
            timeChange.sig = {s.sectionBeats, 4}
            lastSectionBeats = s.sectionBeats
        end

        if timeChange.time ~= nil then
            table.insert(output.meta.times, timeChange)
        end

        if s.events ~= nil then -- this is how andromeda engine charts work. well, at least in the latest commit.
            for _, v in pairs(s.events) do
                for _, e in pairs(v.events) do
                    local values = {}
                    for k, v2 in pairs(e.args) do
                        values["v" .. k] = v2
                    end

                    addEvent(v.time, e.name, values, "andromeda")
                end
            end
        end

        for _, n in pairs(s.sectionNotes) do
            --[[
                n[1] returns the time of the note.
                n[2] returns the lane of the note.
                - mustHitSection or the chart being made with psych engine v1 reverses the lanes.
                - if it returns "-1", that means it's an event in psych engine v0.5 or below and hypno's lullaby.
                n[3] returns its sustain length.
                n[4] returns the note type if it exists.
                - "true" or "1" indicates that it's an alt note.
                - altAnim also makes it an alt note.
            ]]

            if n[2] == -1 then
                addEvent(n[1], formatStr(n[3]), {v1 = n[4], v2 = n[5]}, "psych")
            else
                local lane = (psych_v1 or hit) and (n[2] < 4 and n[2] + 4 or n[2] - 4) or n[2]
                local note = {
                    time = n[1],
                    lane = (lane % 4) + 1,
                    length = n[3] or 0,
                }
                if s.altAnim and lane < 4 then note.values = {type = "alt"} end
                if n[4] ~= nil and n[4] ~= 0 then note.values = {type = (n[4] == true or n[4] == 1 or n[4] == "Alt Animation") and "alt" or formatStr(tostring(n[4]))} end

                local pos = lane >= 4 and "player" or "opponent"
                table.insert(output.chart.notes[pos], note)
            end
        end

        time = time + (((60 / curbpm) * 1000) * (s.sectionBeats ~= nil and s.sectionBeats or (s.lengthInSteps or 16) / 4))
    end

    local timedArrays = {output.chart.notes.player, output.chart.notes.opponent, output.chart.events, output.meta.times}
    for _, v in pairs(timedArrays) do
        table.sort(v, function(a, b) return a.time < b.time end)
    end

    return output
end

return Legacy