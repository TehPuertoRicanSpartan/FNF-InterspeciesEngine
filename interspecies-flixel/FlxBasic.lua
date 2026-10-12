---@class FlxBasic : class
local FlxBasic = class("FlxBasic")

function FlxBasic:init()
    self.active = true
    self.visible = true
    self.alive = true
    self.exists = true
end

function FlxBasic:destroy()
    self.exists = false
end

function FlxBasic:kill()
    self.alive = false
    self.exists = false
end

function FlxBasic:revive()
    self.alive = true
    self.exists = true
end

function FlxBasic:update(dt) end
function FlxBasic:draw() end

return FlxBasic