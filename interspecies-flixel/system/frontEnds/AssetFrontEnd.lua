---@class AssetFrontEnd : class
local AssetFrontEnd = class("AssetFrontEnd")

AssetFrontEnd.defaultSoundExtension = ".mp3"

function AssetFrontEnd:init()
end

---@param id string
---@param type FlxAssetType?
function AssetFrontEnd:exists(id, type)

end

---@param id string
---@param type FlxAssetType
---@param useCache boolean
---@param logStyle any
function AssetFrontEnd:getAsset(id, type, useCache, logStyle)
end

return AssetFrontEnd