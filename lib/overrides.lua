table.unpack = unpack

math.round = function(v)
    return v < 0 and math.ceil(v - 0.5) or math.floor(v + 0.5)
end

-- https://stackoverflow.com/a/7615129
string.split = function(inputstr, sep)
    sep = sep or '%s'
    local t = {}
    for field, s in string.gmatch(inputstr, "([^"..sep.."]*)("..sep.."?)") do
        table.insert(t, field)
        if s == "" then
            return t
        end
    end
end

table.indexOf = function(t, x, from)
    local from_t = nil
    if from then
        from_t = t
        for i = 1, from do
            t[i] = nil
        end
    end
    for i, v in pairs(from_t or t) do
        if v == x then
            return i
        end
    end
    return 0
end

_G.switch = function(v, t)
    local f = nil
    for k, _ in pairs(t) do
        if type(k) == "table" then
            if k[table.indexOf(k, v)] ~= nil then
                f = t[k]
                break
            end
        end
    end
    f = f or (t[v] or t.default or function() end)

    f()
end