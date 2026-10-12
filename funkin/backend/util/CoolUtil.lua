local FlxMath = require "interspecies-flixel.math.FlxMath"

---@class FunkinCoolUtil
local CoolUtil = {}

local exp = math.exp
function CoolUtil.lerpDecay(a, b, d, dt)
    dt = dt or love.timer.getDelta()
    return FlxMath.lerp(a, b, exp(-dt * d))
end

local log = math.log
function CoolUtil.lerpPercentageToDecay(t, fps)
    fps = fps or 60
    return -fps * log(t)
end

function CoolUtil.lerpFPS(a, b, t, fps, dt)
    return CoolUtil.lerpDecay(a, b, CoolUtil.lerpPercentageToDecay(t, fps), dt)
end

return CoolUtil