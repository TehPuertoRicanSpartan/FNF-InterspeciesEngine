-- todo: once FlxSprite and FlxCamera is implemented, remove this and reimplement the strums

local FlxG = require "interspecies-flixel.FlxG"

---@class FunkinPlaceholderStrumline : class
local PlaceholderStrumline = class("PlaceholderStrumline")

function PlaceholderStrumline:init(song, pos)
    self.songPosition = 0

    self.x = 0
    self.scrollSpeed = 1
    self.notes = {}

    self.pressKeys = {
        "left",
        "down",
        "up",
        "right",
    }

    self.keys = {
        [self.pressKeys[1]]    = self.pressKeys[1],
        [self.pressKeys[2]]    = self.pressKeys[2],
        [self.pressKeys[3]]    = self.pressKeys[3],
        [self.pressKeys[4]]    = self.pressKeys[4],

        ["a"]                  = self.pressKeys[1],
        ["s"]                  = self.pressKeys[2],
        ["w"]                  = self.pressKeys[3],
        ["d"]                  = self.pressKeys[4],
    }

    self.pressed = {
        [self.pressKeys[1]]    = false,
        [self.pressKeys[2]]    = false,
        [self.pressKeys[3]]    = false,
        [self.pressKeys[4]]    = false,
    }

    self:load(song, pos)
end

function PlaceholderStrumline:load(data, pos)
    self.scrollSpeed = data.chart.speed
    self.notes = data.chart.notes[pos]
end

function PlaceholderStrumline:clearPressed()
    for key, _ in pairs(self.pressed) do
        self.pressed[key] = false
    end
end

function PlaceholderStrumline:updatePressed()
    for key, pressKey in pairs(self.keys) do
        local pressed = love.keyboard.isDown(key)
        if pressed then
            self.pressed[pressKey] = pressed
        end
    end
end

function PlaceholderStrumline:update(dt)
    self:clearPressed()
    self:updatePressed()
end

function PlaceholderStrumline:draw()
    for i = 0, 3 do
        local keyIndex = i + 1
        local key = self.pressKeys[keyIndex]
        local pressed = self.pressed[key]

        local mode = "line"
        if pressed then
            mode = "fill"
        end

        love.graphics.rectangle(mode, self.x + (i * 112), 50, 96, 96)
    end

    for _, note in pairs(self.notes) do
        local time = note.time
        local lane = note.lane - 1
        local lenght = note.length

        local y = (time - self.songPosition) * (0.45 * self.scrollSpeed)
        if y < FlxG.height then
            if note.length > 0 then
                local length = lenght * (0.45 * self.scrollSpeed)
                love.graphics.setColor(1, 1, 1, 0.5)
                love.graphics.rectangle("fill", self.x + (lane * 112), 50 + math.max(0, y), 96, (y >= 0 and length or math.max(0, y + length)))
            end
            if y >= 0 then
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.rectangle("fill", self.x + (lane * 112), 50 + y, 96, 96)
            end
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
end

return PlaceholderStrumline