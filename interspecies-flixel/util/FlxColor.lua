local bit = require "bit"

---@class FlxColor
local FlxColor = {}

local colors = {
    TRANSPARENT = 0x00000000,
	WHITE = 0xFFFFFFFF,
	GRAY = 0xFF808080,
	BLACK = 0xFF000000,

	GREEN = 0xFF008000,
	LIME = 0xFF00FF00,
	YELLOW = 0xFFFFFF00,
	ORANGE = 0xFFFFA500,
	RED = 0xFFFF0000,
	PURPLE = 0xFF800080,
	BLUE = 0xFF0000FF,
	BROWN = 0xFF8B4513,
	PINK = 0xFFFFC0CB,
	MAGENTA = 0xFFFF00FF,
	CYAN = 0xFF00FFFF
}

function FlxColor.fromHEX(hex)
    return {bit.band(bit.rshift(hex, 16), 0xFF) / 255, bit.band(bit.rshift(hex, 8), 0xFF) / 255, bit.band(hex, 0xFF) / 255, bit.band(bit.rshift(hex, 24), 0xFF) / 255}
end

function FlxColor.fromString(str)
    local hex = tonumber(str:gsub("#", "0x"))
    return FlxColor.fromHEX(hex)
end

for i, v in pairs(colors) do
    FlxColor[i] = FlxColor.fromHEX(v)
end

return FlxColor