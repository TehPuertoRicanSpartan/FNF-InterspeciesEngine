---@class FunkinPaths
local Paths = {}

Paths.loadedAssets = {
    persistent = {},
    images = {},
    sounds = {},
    music = {},
}

function Paths.getPath(file, type, folders)
    folders = folders or {"addons", "mods", "assets"}

    local name = ""
    for _, folder in ipairs({"addons", "mods", "assets"}) do
        name = folder .. "/" .. (folder ~= "assets" and ("insert mod here") .. "/" or "") .. file
        if love.filesystem.getInfo((love.filesystem.isFused() and "root/" or "") .. name, type) ~= nil then
            return name
        end
    end
    return name
end

function Paths.getFile(file, folders)
    return Paths.getPath(file, "file", folders)
end

function Paths.getFolder(file, folders)
    return Paths.getPath(file, "directory", folders)
end

function Paths.image(key, folders)
    local file = Paths.getPath("images/" .. key .. ".png", "file", folders)
    if file ~= nil then
        Paths.loadedAssets.images[key] = Paths.loadedAssets.images[key] or love.graphics.newImage(key)
        return Paths.loadedAssets.images[key]
    end
end

function Paths.sound(key, folders)
    local file = Paths.getPath("sounds/" .. key .. ".ogg", "file", folders)
    if file ~= nil then
        Paths.loadedAssets.sounds[key] = Paths.loadedAssets.sounds[key] or love.audio.newSource(key, "stream")
        return Paths.loadedAssets.sounds[key]
    end
end

function Paths.music(key, folders)
    local file = Paths.getPath("music/" .. key .. ".ogg", "file", folders)
    if file ~= nil then
        Paths.loadedAssets.music[key] = Paths.loadedAssets.music[key] or love.audio.newSource(key, "stream")
        return Paths.loadedAssets.music[key]
    end
end

function Paths.clear()
    for _, p in ipairs({"images", "sounds", "music"}) do
        for k, v in pairs(Paths.loadedAssets[p]) do
            v:release()
        end
    end
    collectgarbage("collect")
end

return Paths