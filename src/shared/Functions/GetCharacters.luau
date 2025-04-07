--!strict

local Players = game:GetService("Players")

return function()
    local c = {}
    for _, plr in Players:GetPlayers() do
        table.insert(c, plr.Character)
    end

    return c
end