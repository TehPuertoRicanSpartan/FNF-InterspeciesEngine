local Paths = require "funkin.backend.util.Paths"
local Script = require "funkin.backend.scripting.Script"
local FlxGroup = require "interspecies-flixel.group.FlxGroup"

---@class FunkinStage : class
local Stage = class("Stage")

function Stage:init(name)
    ---@type FunkinScript
    self.script = Script(Paths.getPath("scripts/stages/" .. name .. ".lua", "file"))

    ---@type FlxGroup
    self.background = FlxGroup()

    ---@type FlxGroup
    self.foreground = FlxGroup()

    self.script:set("self", self)
end

function Stage:add(obj, fg)
    local layer = fg and self.foreground or self.background
    layer:add(obj)
end

return Stage