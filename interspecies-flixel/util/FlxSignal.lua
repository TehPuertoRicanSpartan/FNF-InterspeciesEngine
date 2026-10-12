---@class FlxSignal : class
local FlxSignal = class("FlxSignal")

function FlxSignal:init()
    self.listeners = {}
end

function FlxSignal:dispatch()
    for k, v in pairs(self.listeners) do
        v.func()
        if v.once then
            table.remove(self.listeners, k)
        end
    end
end

function FlxSignal:add(func)
    table.insert(self.listeners, {func = func, once = false})
end

function FlxSignal:addOnce(func)
    table.insert(self.listeners, {func = func, once = true})
end

return FlxSignal