---@class FlxMath
local FlxMath = {}

---@param v number
---@param p number
function FlxMath.roundDecimal(v, p)
    local a = 10 ^ p
    return math.round(v * a) / a
end

---@param v number
---@param min number
---@param max number
function FlxMath.bound(v, min, max)
    return math.max(math.min(v, max), min)
end

---@param a number
---@param b number
---@param t number
function FlxMath.lerp(a, b, t)
    return a + t * (b - a)
end

---@param v number
---@param min number
---@param max number
function FlxMath.wrap(v, min, max)
    local range = max - min + 1

    if v < min then
        v = v + (range * math.floor((min - v) / range + 1))
    end

    return min + (v - min) % range
end

---@param v number
---@param t1 number
---@param d1 number
---@param t2 number
---@param d2 number
function FlxMath.remapToRange(v, t1, d1, t2, d2)
    return t2 + (v - t1) * ((d2 - t2) / (t1 - d1))
end

return FlxMath