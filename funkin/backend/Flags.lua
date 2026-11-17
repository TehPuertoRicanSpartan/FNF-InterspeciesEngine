local Flags = {}

Flags.VERSION = "0.0.1"

Flags.RATINGS = {
    {name = "sick", ms = 100/3, score = 350, accuracy = 1, splash = true},
    {name = "good", ms = 125, score = 200, accuracy = 0.75, splash = false},
    {name = "bad", ms = 150, score = 100, accuracy = 0.5, splash = false},
    {name = "shit", ms = 1000/6, score = 50, accuracy = 0.25, splash = false},
}

function Flags.refresh()
    -- TODO: make this function once mod support is implemented
end

return Flags