local FlxVersion = require "interspecies-flixel.system.FlxVersion"

local AssetFrontEnd = require "interspecies-flixel.system.frontEnds.AssetFrontEnd"

---@class FlxG : class
local FlxG = class("FlxG")

---@type FlxVersion
FlxG.VERSION = FlxVersion(1, 0, 0)

FlxG.animationTimeScale = 1

---@type AssetFrontEnd
FlxG.assets = AssetFrontEnd()

FlxG.state = nil

function FlxG:setup(g, w, h)
    self.game = g
    self.width = w
    self.height = h
end

return FlxG