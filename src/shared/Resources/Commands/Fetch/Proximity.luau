--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Functions = ReplicatedStorage:WaitForChild("Functions")

local Table = require(Functions.Table)

function pos(c)
    local p: any
    p = c:GetPivot()
    p = p.Position

    return p
end

return function(p, ...)
    assert(p.Character)
    local o = pos(p.Character)

    local t = {}
    for _, p in Players:GetPlayers() do
        table.insert(t, p.Character)
    end
    Table.clean(t)

    local l = {}
    for _, c in t do
        local at = pos(c)
        local d = (o - at).Magnitude

        if d <= 30 or ... then
            local T = Players:GetPlayerFromCharacter(c)
            table.insert(t, T)
        end
    end

    return l
end