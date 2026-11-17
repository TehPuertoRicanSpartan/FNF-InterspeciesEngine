local FPSCounter = require "funkin.debug.FPSCounter"
local FlxGame = require "interspecies-flixel.FlxGame"
local FlxColor = require "interspecies-flixel.util.FlxColor"

local PlayState = require "funkin.states.PlayState"
local ChartParser = require "funkin.backend.chartparser.ChartParser"

local funkin = {}

_G.Flags = require "funkin.backend.Flags"
funkin.fpsCounter = FPSCounter()

local game

function funkin.load()
    if love.filesystem.isFused() then
        love.filesystem.mount(love.filesystem.getSourceBaseDirectory(), "root")
    end
    for _, file in pairs(love.filesystem.getDirectoryItems(love.filesystem.isFused() and "root/" or "" .. "assets")) do
        print(file)
    end

	PlayState.SONG = ChartParser.parseSong("monster", "hard")
    game = FlxGame(1280, 720, PlayState())
	game.enableScissor = (love.system.getOS() ~= "Android" or love.system.getOS() ~= "iOS")
end

function funkin.update(dt)
    game:update(dt)
    funkin.fpsCounter:update(dt)

    if love.keyboard.isDown("f4") then love.event.push("errorhandler") end
end

function funkin.draw()
    game:draw()
    funkin.fpsCounter:draw()
end

local utf8 = require("utf8")

local function error_printer(msg, layer)
	print((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
end

function funkin.errorhandler(msg)
	msg = tostring(msg)

	error_printer(msg, 2)

	if not love.window or not love.graphics or not love.event then
		return
	end

	if not love.graphics.isCreated() or not love.window.isOpen() then
		local success, status = pcall(love.window.setMode, 800, 600)
		if not success or not status then
			return
		end
	end

	-- Reset state.
	if love.mouse then
		love.mouse.setVisible(true)
		love.mouse.setGrabbed(false)
		love.mouse.setRelativeMode(false)
		if love.mouse.isCursorSupported() then
			love.mouse.setCursor()
		end
	end
	if love.joystick then
		-- Stop all joystick vibrations.
		for i,v in ipairs(love.joystick.getJoysticks()) do
			v:setVibration()
		end
	end
	if love.audio then love.audio.stop() end

	love.graphics.reset()
	local font = love.graphics.newFont("assets/fonts/DOSGothic.ttf", 16)

	love.graphics.setColor(1, 1, 1)

	local trace = debug.traceback()

	love.graphics.origin()

	local sanitizedmsg = {}
	for char in msg:gmatch(utf8.charpattern) do
		table.insert(sanitizedmsg, char)
	end
	sanitizedmsg = table.concat(sanitizedmsg)

	local err = {}

	table.insert(err, "Error\n")
	table.insert(err, sanitizedmsg)

	if #sanitizedmsg ~= #msg then
		table.insert(err, "Invalid UTF-8 string in error message.")
	end

	table.insert(err, "\n")

	for l in trace:gmatch("(.-)\n") do
		if not l:match("boot.lua") then
			l = l:gsub("stack traceback:", "Traceback\n")
			table.insert(err, l)
		end
	end

	local p = table.concat(err, "\n")

	p = p:gsub("\t", "")
	p = p:gsub("%[string \"(.-)\"%]", "%1")

	local function draw()
		if not love.graphics.isActive() then return end
		local pos = 70
		love.graphics.clear(89/255, 157/255, 220/255)

        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.printf(p, font, pos + 1, pos + 1, love.graphics.getWidth() - pos)

        love.graphics.setColor(1, 1, 1, 1)
		love.graphics.printf(p, font, pos, pos, love.graphics.getWidth() - pos)

		love.graphics.present()
	end

	local fullErrorText = p
	local function copyToClipboard()
		if not love.system then return end
		love.system.setClipboardText(fullErrorText)
		p = p .. "\nCopied to clipboard!"
	end

	if love.system then
		p = p .. "\n\nPress Ctrl+C or tap to copy this error"
	end

	return function()
		love.event.pump()

		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return 1
			elseif e == "keypressed" and a == "escape" then
				return 1
			elseif e == "keypressed" and a == "c" and love.keyboard.isDown("lctrl", "rctrl") then
				copyToClipboard()
			elseif e == "touchpressed" then
				local name = love.window.getTitle()
				if #name == 0 or name == "Untitled" then name = "Game" end
				local buttons = {"OK", "Cancel"}
				if love.system then
					buttons[3] = "Copy to clipboard"
				end
				local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
				if pressed == 1 then
					return 1
				elseif pressed == 3 then
					copyToClipboard()
				end
			end
		end

		draw()

		if love.timer then
			love.timer.sleep(0.1)
		end
	end

end

return funkin