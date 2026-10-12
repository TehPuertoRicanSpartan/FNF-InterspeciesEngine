---@class FlxVelocity
local FlxVelocity = {}

function FlxVelocity.computeVelocity(velocity, acceleration, drag, max, dt)
    if acceleration ~= 0 then
        velocity = velocity + (acceleration * dt)
    elseif drag ~= 0 then
        local ddrag = drag * dt
        if velocity - ddrag > 0 then
            velocity = velocity - ddrag
        elseif velocity + ddrag < 0 then
            velocity = velocity + ddrag
        else
            velocity = 0
        end
    end

    if velocity ~= 0 and max ~= 0 then
        if velocity > max then
            velocity = max
        elseif velocity < -max then
            velocity = -max
        end
    end

    return velocity
end

return FlxVelocity