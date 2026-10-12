---@class FlxPoint : class
local FlxPoint = class("FlxPoint")

function FlxPoint:init(x, y)
    self:set(x, y)
end

function FlxPoint:set(x, y)
    self.x = x or 0
    self.y = y or 0
    return self
end

function FlxPoint:add(x, y)
    self.x = self.x + x
    self.y = self.y + y
    return self
end

function FlxPoint:subtract(x, y)
    self.x = self.x - x
    self.y = self.y - y
    return self
end

function FlxPoint:scale(x, y)
    self.x = self.x * x
    self.y = self.y * (y or x)
    return self
end

return FlxPoint