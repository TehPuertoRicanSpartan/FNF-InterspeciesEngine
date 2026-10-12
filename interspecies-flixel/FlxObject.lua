local FlxBasic = require "interspecies-flixel.FlxBasic"
local FlxPoint = require "interspecies-flixel.math.FlxPoint"
local FlxVelocity = require "interspecies-flixel.math.FlxVelocity"

---@class FlxObject : FlxBasic
local FlxObject = FlxBasic:extend()

---@param x number
---@param y number
---@param w number
---@param h number
function FlxObject:init(x, y, w, h)
    FlxObject.super.init(self)

    self.x = x or 0
    self.y = y or 0
    self.width = w or 0
    self.height = h or 0

    self.moves = true
    self.angle = 0

    self:initVars()
end

function FlxObject:initVars()
    ---@type FlxPoint
    self.scrollFactor = FlxPoint(1, 1)

    self:initMotionVars()
end

function FlxObject:initMotionVars()
    ---@type FlxPoint
    self.velocity = FlxPoint()

    ---@type FlxPoint
    self.acceleration = FlxPoint()

    ---@type FlxPoint
    self.drag = FlxPoint()

    ---@type FlxPoint
    self.maxVelocity = FlxPoint(10000, 10000)

    self.angularVelocity = 0
    self.angularAcceleration = 0
    self.angularDrag = 0
    self.maxAngular = 10000
end

function FlxObject:update(dt)
    if self.moves then
        self:updateMotion(dt)
    end
end

function FlxObject:updateMotion(dt)
    local velocityDelta = 0.5 * (FlxVelocity.computeVelocity(self.angularVelocity, self.angularAcceleration, self.angularDrag, self.maxAngular, dt) - self.angularVelocity)
    self.angularVelocity = self.angularVelocity + velocityDelta
    self.angle = self.angle + (self.angularVelocity * dt)
    self.angularVelocity = self.angularVelocity + velocityDelta

    velocityDelta = 0.5 * (FlxVelocity.computeVelocity(self.velocity.x, self.acceleration.x, self.drag.x, self.maxVelocity.x, dt) - self.velocity.x)
    self.velocity.x = self.velocity.x + velocityDelta
    local delta = self.velocity.x * dt
    self.velocity.x = self.velocity.x + velocityDelta
    self.x = self.x + delta

    velocityDelta = 0.5 * (FlxVelocity.computeVelocity(self.velocity.y, self.acceleration.y, self.drag.y, self.maxVelocity.y, dt) - self.velocity.y)
    self.velocity.y = self.velocity.y + velocityDelta
    delta = self.velocity.y * dt
    self.velocity.y = self.velocity.y + velocityDelta
    self.y = self.y + delta
end

function FlxObject:getMidpoint()
    return FlxPoint(self.x + self.width * 0.5, self.y + self.height * 0.5)
end

return FlxObject