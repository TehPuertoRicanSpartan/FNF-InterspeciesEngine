local MusicBeatState = require "funkin.backend.states.MusicBeatState"
local FlxG = require "interspecies-flixel.FlxG"
local Paths = require "funkin.backend.util.Paths"
local Script = require "funkin.backend.scripting.Script"
local CoolUtil = require "funkin.backend.util.CoolUtil"
local PlaceholderStrumline = require "funkin.gameplay.notes.PlaceholderStrumline"

local PlayState = MusicBeatState:extend("PlayState")

local songs = {}

function PlayState:init()
    PlayState.super.init(self)
    self.conductor:mapBPMChanges(PlayState.SONG.meta.times)
    self.conductor.songPosition = self.conductor.crochet * -5
end

function PlayState:create()
    self.script = Script(Paths.getFile("scripts/test.lua"))
    self.script:call("create")

    self.opponentStrumline = PlaceholderStrumline(PlayState.SONG, "opponent")
    self.playerStrumline = PlaceholderStrumline(PlayState.SONG, "player")

    self.opponentStrumline.x = 96
    self.playerStrumline.x = (FlxG.width / 2) + 96

    PlayState.super.create()
    self.script:call("createPost")
end

local cameraZoom = 1

function PlayState:update(dt)
    if love.keyboard.isDown("space") then
        FlxG.switchState(require "funkin.states.TestState")
    end

    if self.conductor.songPosition >= self.conductor.offset then
        for _, v in pairs({"Inst", "Voices"}) do
            if songs[v] == nil then
                songs[v] = love.audio.newSource("assets/songs/" .. (PlayState.SONG.meta.title:lower()):gsub(" ", "-") .. "/" .. v .. ".ogg", "stream")
                songs[v]:play()
            end
        end
    end
    self.conductor.songPosition = self.conductor.songPosition + (dt * 1000)

    self.script:call("update", dt)

    self.opponentStrumline.songPosition = self.conductor.songPosition
    self.playerStrumline.songPosition = self.conductor.songPosition

    cameraZoom = CoolUtil.lerpFPS(1, cameraZoom, 0.95, 60, dt)

    PlayState.super.update(self, dt)

    self.script:call("updatePost", dt)
end

function PlayState:draw()
    love.graphics.print("bpm: " .. self.conductor.bpm .. "\ncurStep: " .. self.curStep .. " / curBeat: " .. self.curBeat .. " / curSection: " .. self.curSection, 5, 5)

    love.graphics.scale(cameraZoom, cameraZoom)
    love.graphics.translate(-(FlxG.width / 2) * (cameraZoom - 1), -(FlxG.height / 2) * (cameraZoom - 1))
    love.graphics.push()
        love.graphics.setColor(1, 0, 1)
        self.opponentStrumline:draw()
        love.graphics.setColor(0, 1, 1)
        self.playerStrumline:draw()
    love.graphics.pop()
end

function PlayState:stepHit()
    self.script:call("stepHit", self.curStep)

    if songs["Voices"] ~= nil and math.abs((songs["Voices"]:tell() * 1000) - (self.conductor.songPosition - self.conductor.offset)) > 20 then
        self:resyncVocals()
    end

    self.script:call("stepHitPost", self.curStep)
end

function PlayState:beatHit()
    self.script:call("beatHit", self.curBeat)

    if self.curBeat < 0 then
        -- handle countdown
        return
    end

    if self.curBeat % 4 == 0 then
        cameraZoom = cameraZoom + 0.03
    end

    self.script:call("beatHitPost", self.curBeat)
end

function PlayState:resyncVocals()
    if songs["Inst"] ~= nil and songs["Voices"] ~= nil then
        self.conductor.songPosition = (songs["Inst"]:tell() * 1000) + self.conductor.offset
        songs["Voices"]:seek(songs["Inst"]:tell())
    end
end

return PlayState