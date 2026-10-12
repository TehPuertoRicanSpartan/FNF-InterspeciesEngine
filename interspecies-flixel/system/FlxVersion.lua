---@class FlxVersion
local FlxVersion = class("FlxVersion")

FlxVersion.sha = ""

---@param major integer
---@param minor integer
---@param patch integer
function FlxVersion:init(major, minor, patch)
    self.major = major
    self.minor = minor
    self.patch = patch
end

function FlxVersion:toString()
    local sha = self.sha
    local major, minor, patch = self.major, self.minor, self.patch
    local formatted = "InterspeciesFlixel " .. major .. "." .. minor .. "." .. patch

    if sha and sha ~= "" then
        formatted = formatted .. "-" .. sha
    end

    return formatted
end

return FlxVersion