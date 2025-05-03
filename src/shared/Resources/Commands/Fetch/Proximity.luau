--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Functions = ReplicatedStorage:WaitForChild("Functions")
local GetCharacters = require(Functions.GetCharacters)
local Table = require(Functions.Table)

function pos(c: Model)
    local p = c:GetPivot()
    local v = p.Position

    return v
end

return function(p: Player, ...)
    assert(p.Character)
    local o = pos(p.Character)

    local l = GetCharacters()

    local v = {}   
    for _, c in l do
        local at = pos(c)
        local d = (o - at).Magnitude
        if d <= 30 or ... then
            p = Players:GetPlayerFromCharacter(c)
            table.insert(v, p)
        end
    end
    Table.remove(v, nil)

    return v
end