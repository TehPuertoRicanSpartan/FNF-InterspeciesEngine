-- this is NOT the unused chart converter from ludum dare, it's actually being used for parsing legacy and codename charts into the engine's new charting format
-- 👍

local requireFormat = function(f) return require("funkin.backend.chartparser.formats." .. f) end
local json = require "lib.json"
local Paths = require "funkin.backend.util.Paths"

---@type FunkinChartParserLegacy
local Legacy = requireFormat("Legacy")

---@type FunkinChartParserCodename
local Codename = requireFormat("Codename")

---@class FunkinChartParser
local ChartParser = {}

function ChartParser.parseSong(song, diff)
    local chartString = love.filesystem.read(Paths.getPath("songs/" .. song .. "/data/" .. diff .. ".json", "file"))
    local chartData = json.decode(chartString)

    if chartData.interspeciesFormat then
        return chartData
    elseif chartData.codenameChart then
        local meta = json.decode(love.filesystem.read(Paths.getPath("songs/" .. song .. "/data/meta.json", "file")))
        return Codename.parse(chartData, meta)
    else
        local eventString = love.filesystem.read(Paths.getPath("songs/" .. song .. "/data/events.json", "file"))
        local eventData = eventString and json.decode(eventString) or chartData

        return Legacy.parse(chartData, eventData)
    end
end

return ChartParser