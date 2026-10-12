local FlxGroup = require "interspecies-flixel.group.FlxGroup"

---@class FlxState : FlxGroup
local FlxState = FlxGroup:extend("FlxState")

function FlxState:create() end

function FlxState:switchTo(state)
    return true -- did you change the state succesfully? no, but yes. (B-TODO)
end

return FlxState