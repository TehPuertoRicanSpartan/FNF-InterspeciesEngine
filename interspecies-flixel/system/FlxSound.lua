local FlxBasic = require "interspecies-flixel.FlxBasic"

---@class FlxSound : FlxBasic
local FlxSound = FlxBasic:extend("FlxSound")

function FlxSound:init()
    self.super.init(self)
    self:reset()
end

function FlxSound:reset()
    self:destroy()

    self.x = 0
    self.y = 0

    self._time = 0
    self._paused = false
    self._volume = 1.0
    self._volumeAdjust = 1.0
    self.looped = false
    self.loopTime = 0.0
    self.endTime = 0.0
    self._target = nil
    self._radius = 0
    self._proximityPan = false
    self.visible = false
    self.amplitude = 0
    
end

return FlxSound