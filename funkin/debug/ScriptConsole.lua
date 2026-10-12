-- this is for softcoding scripts ONLY! any hardcoded prints will be shown in LOVE2D's console
local Paths = require "funkin.backend.util.Paths"

---@class FunkinScriptConsole : class
local ScriptConsole = class()

local font = love.graphics.newFont(Paths.getFile("fonts/DOSGothic.ttf"), 16)

function ScriptConsole:init()
    self.__messages = {}
    self.__canvas = love.graphics.newCanvas()

    self.visible = true
    self.messages = {}
end

function ScriptConsole:print(msg)
    local index = table.indexOf(self.__messages, msg)
    if index ~= 0 then
        self.messages[index].times = self.messages[index].times + 1
    else
        table.insert(self.__messages, msg)
        table.insert(self.messages, {msg = msg, times = 1})
    end
    self:reset()
end

function ScriptConsole:reset()
    --love.graphics.setCanvas()
end

function ScriptConsole:draw()
    love.graphics.push()
        love.graphics.setColor(1, 1, 1, 0.4)
        love.graphics.draw(self.__canvas)
    love.graphics.pop()
end

return ScriptConsole