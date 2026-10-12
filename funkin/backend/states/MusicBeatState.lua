local FlxState = require "interspecies-flixel.FlxState"
local Conductor = require "funkin.backend.conductor"

---@class FunkinMusicBeatState : FlxState
local MusicBeatState = FlxState:extend()

function MusicBeatState:init()
    ---@type FunkinConductor
    self.conductor = Conductor()
    self.curDecStep = 0
    self.curStep = 0
    self.curDecBeat = 0
    self.curBeat = 0
    self.curDecSection = 0
    self.curSection = 0
end

function MusicBeatState:update(dt)
    local oldStep = self.curStep
    local oldBeat = self.curBeat
    local oldSection = self.curSection

    if self.currentChange.bpm > 0 then
        self.conductor.bpm = self.currentChange.bpm
    end
    if self.currentChange.sig ~= nil then
        self.conductor.timeSignature = self.currentChange.timeSignature
    end

    -- Conductor's set_bpm and set_timeSignature doesn't work for some reason
    self.conductor:updateValues()

    self:updateStep()
    self:updateBeat()
    self:updateSection()

    if oldStep < self.curStep then self:stepHit() end
    if oldBeat < self.curBeat then self:beatHit() end
    if oldSection < self.curSection then self:sectionHit() end

    MusicBeatState.super.update(self, dt)
end

local floor = math.floor
function MusicBeatState:updateSection()
    self.curDecSection = ((self.currentChange.stepTime / 4) / self.conductor.timeSignature[1]) + ((self.conductor.songPosition - self.currentChange.songTime) / self.conductor.sectionLength)
    self.curSection = floor(self.curDecSection)
end

function MusicBeatState:updateBeat()
    self.curDecBeat = (self.currentChange.stepTime / 4) + ((self.conductor.songPosition - self.currentChange.songTime) / self.conductor.crochet)
    self.curBeat = floor(self.curDecBeat)
end

function MusicBeatState:updateStep()
    self.curDecStep = self.currentChange.stepTime + ((self.conductor.songPosition - self.currentChange.songTime) / self.conductor.stepCrochet)
    self.curStep = floor(self.curDecStep)
end

local lastChange = {
    timeSignature = {0, 0},
    stepTime = 0,
    songTime = 0,
    bpm = 0
}
function MusicBeatState:get_currentChange()
    for _, change in pairs(self.conductor.bpmChangeMap) do
        if self.conductor.songPosition >= change.songTime then
            lastChange = change
        end
    end
    return lastChange
end

function MusicBeatState:stepHit() end
function MusicBeatState:beatHit() end
function MusicBeatState:sectionHit() end

return MusicBeatState