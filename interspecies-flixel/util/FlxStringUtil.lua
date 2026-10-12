local FlxMath = require "interspecies-flixel.math.FlxMath"

---@class FlxStringUtil
local FlxStringUtil = {}

function FlxStringUtil.formatTime(a, ms)
    ms = ms or false
    return a >= 3600 and string.format("%d:%02d:%02d" .. (ms and ".%03d" or ""), a / 3600, (a / 60) % 60, a % 60, (a * 1000) % 1000) or string.format("%d:%02d" .. (ms and ".%03d" or ""), a / 60, a % 60, (a * 1000) % 1000)
end

function FlxStringUtil.formatBytes(b, p)
    p = p or 2
    local units = {"Bytes", "kB", "MB", "GB", "TB", "PB"}
    local curUnit = 1
    while b >= 1024 and curUnit < #units do
        b = b / 1024
        curUnit = curUnit + 1
    end
    return FlxMath.roundDecimal(b, p) .. units[curUnit]
end

return FlxStringUtil