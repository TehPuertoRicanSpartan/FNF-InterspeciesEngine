require "lib.overrides"

_G.class = require "lib.30log"

local funkin = require "funkin"

function love.load()
    funkin.load()
end

function love.update(dt)
    funkin.update(dt)
end

function love.draw()
    funkin.draw()
end

function love.errorhandler(msg)
    return funkin.errorhandler(msg)
end