local Gamestate = require "lib.gamestate"
---@class FlxG
local FlxG = require "interspecies-flixel.FlxG"

---@class FlxGame : class
local FlxGame = class("FlxGame")

local function switchState(state)
    Gamestate.switch(state)
    FlxG.state = Gamestate.current()
end

function FlxGame:init(w, h, state)
    love.window.setMode(w, h, {resizable = true})
    self.enableScissor = true
    FlxG:setup(self, w, h)

    Gamestate.registerEvents({})
    switchState(state)
end

FlxG.switchState = function(state)
    if Gamestate.current():switchTo(state) then
        switchState(state)
    end
end

function FlxGame:update(dt)
    Gamestate.update(dt)
end

function FlxGame:draw()
    local scale = (love.graphics.getPixelWidth() / love.graphics.getPixelHeight()) > (FlxG.width / FlxG.height) and love.graphics.getPixelHeight() / FlxG.height or love.graphics.getPixelWidth() / FlxG.width

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.push()
        love.graphics.translate(
            (love.graphics.getPixelWidth() - (FlxG.width * scale)) / 2,
            (love.graphics.getPixelHeight() - (FlxG.height * scale)) / 2
        )
        love.graphics.scale(scale, scale)
        if self.enableScissor then
            love.graphics.setScissor(
                (love.graphics.getPixelWidth() - (FlxG.width * scale)) / 2,
                (love.graphics.getPixelHeight() - (FlxG.height * scale)) / 2,
                FlxG.width * scale,
                FlxG.height * scale
            )
        end

        love.graphics.clear(0, 0, 0)
        Gamestate.draw()
    love.graphics.pop()
    if self.enableScissor then love.graphics.setScissor() end -- popping doesn't work with scissor inside push, so this is needed for shit outside the game, like fps counters
end

return FlxGame