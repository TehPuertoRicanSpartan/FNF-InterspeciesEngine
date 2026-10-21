local Conductor = class("Conductor")

Conductor.bpm = 100
Conductor.songPosition = 0
Conductor.offset = 0

Conductor.safeFrames = 10
Conductor.safeZoneOffset = (Conductor.safeFrames / 60) * 1000

Conductor.bpmChangeMap = {}
Conductor.timeSignature = {4, 4}

function Conductor:init() end

function Conductor:mapBPMChanges(times)
    self.bpmChangeMap = {}

    table.sort(times, function(a, b) return a.time < b.time end)
    local curBPM = times[1].bpm
    local curSig = times[1].sig or {4, 4}
    local totalSteps = 0
    local lastTime = 0

    for _, change in pairs(times) do
        local deltaTime = change.time - lastTime
        local stepCrochet = (((60 / curBPM) * 1000) * (4 / curSig[2])) / 4

        totalSteps = totalSteps + (deltaTime / stepCrochet)
        lastTime = change.time

        if change.sig ~= nil then curSig = change.sig end
        if change.bpm ~= curBPM then curBPM = change.bpm end
        table.insert(self.bpmChangeMap, {
            timeSignature = curSig,
            stepTime = totalSteps,
            songTime = change.time,
            bpm = curBPM
        })
    end

    self.bpm = times[1].bpm
    self.timeSignature = times[1].sig
end

function Conductor:updateValues()
    rawset(self, "crochet", ((60 / self.bpm) * 1000) * (4 / self.timeSignature[2]))
    rawset(self, "stepCrochet", self.crochet / 4)
    rawset(self, "sectionLength", self.crochet * self.timeSignature[1])
end

function Conductor:set_bpm(v)
    if type(v) ~= "number" then return end

    rawset(self, "bpm", v)
    self:updateValues()
end

function Conductor:set_timeSignature(v)
    if type(v) ~= "table" then return end

    rawset(self, "timeSignature", v)
    self:updateValues()
end

function Conductor:set_crochet() end
function Conductor:set_stepCrochet() end
function Conductor:set_sectionLength() end

return Conductor