local FlxState = require "interspecies-flixel.FlxState"

---@class FunkinTestState : FlxState
local TestState = FlxState:extend("TestState")

function TestState:create()
    print("test")
end

return TestState