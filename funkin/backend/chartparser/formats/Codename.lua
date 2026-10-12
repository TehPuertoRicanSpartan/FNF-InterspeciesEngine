---@class FunkinChartParserCodename
local Codename = {}

function Codename.parse(data, meta)
    local formatStr = function(a) return (a:lower()):gsub(" ", "-") end

    local output = {}

    -- initialize the metadata
    output.meta = {
        title = meta.displayName,
        times = {
            {
                time = 0,
                bpm = meta.bpm,
                sig = {meta.beatsPerMeasure or meta.beatsPerMesure or 4, meta.stepsPerBeat and math.floor(16 / meta.stepsPerBeat) or 4}
            }
        },
        characters = {}, -- don't identify them... for now...
        stage = data.stage
    }

    -- initialize the chart
    output.chart = {
        speed = data.scrollSpeed,
        events = {},
        notes = {
            opponent = {},
            player = {},
            extra = {}
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

    for _, e in pairs(data.events) do
        --print(e.name .. ":" .. tostring(unpack(e.params)))
        if e.name == "BPM Change" then
            table.insert(output.meta.times, {
                time = e.time,
                bpm = e.params[1]
            })
        elseif e.name == "Time Signature Change" then
            table.insert(output.meta.times, {
                time = e.time,
                sig = {e.params[1], e.params[2]}
            })
        else
            if e.name == "Camera Movement" then
                addEvent(e.time, "camera-focus", {dir = e.params[1]})
            else
                addEvent(e.time, formatStr(e.name), e.params, "codename")
            end
        end
    end

    for _, strumline in pairs(data.strumLines) do
        local pos
        switch(strumline.type, {
            [0] = function() pos = "op" end,
            [1] = function() pos = "bf" end,
            [2] = function() pos = "gf" end,
        })
        if output.meta.characters[pos] == nil then
            output.meta.characters[pos] = strumline.characters[1]
        end

        for _, n in pairs(strumline.notes) do
            local hit = strumline.type == 1
            local note = {
                time = n.time,
                lane = n.id + 1,
                length = n.sLen
            }
            if n.type ~= 0 then note.values = {type = formatStr(data.noteTypes[n.type])} end

            table.insert(output.chart.notes[hit and "player" or "opponent"], note)
        end
    end

    local timedArrays = {output.chart.notes.player, output.chart.notes.opponent, output.chart.events, output.meta.times}
    for _, v in pairs(timedArrays) do
        table.sort(v, function(a, b) return a.time < b.time end)
    end

    return output
end

return Codename