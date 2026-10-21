local FlxStringUtil = require "interspecies-flixel.util.FlxStringUtil"
local Paths = require "funkin.backend.util.Paths"

local FPSCounter = class()

local format = "%dfps/%s"
local font = love.graphics.newFont(Paths.getFile("fonts/DOSGothic.ttf"), 16)

function FPSCounter:init()
    self._canvas = love.graphics.newCanvas()
    self.text = format:format(love.timer.getDelta(), FlxStringUtil.formatBytes(collectgarbage("count") * 1024))
end

function FPSCounter:update(dt)
    self.text = format:format(love.timer.getFPS(), FlxStringUtil.formatBytes(collectgarbage("count") * 1024))
end

function FPSCounter:reset(text)
    love.graphics.setCanvas(self._canvas)
    love.graphics.clear()

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, font:getWidth(text) + 6, font:getHeight(text) - 2)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(text, font, 3, 0)

    love.graphics.setCanvas()
end

function FPSCounter:set_text(v)
    if v ~= self.text then
        self:reset(v)
    end
    rawset(self, "text", v)
    return v
end

function FPSCounter:draw()
    love.graphics.push()
        love.graphics.setColor(1, 1, 1, 0.4)
        love.graphics.draw(self._canvas)
    love.graphics.pop()
end

return FPSCounter