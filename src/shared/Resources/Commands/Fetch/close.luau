--!strict

local Players = game:GetService("Players")

return function(p: Player)
    local c = p.Character
    local o = c and c:GetPivot().Position or Vector3.zero

    local t = {}
    for _, p in Players:GetPlayers() do
        table.insert(t, p.Character)
    end

    local l = {}
    for _, T in t do
        local h = T:GetPivot().Position
        local d = (o - h).Magnitude
        if d <= 30 then
            table.insert(t, Players:GetPlayerFromCharacter(c))
        end
    end

    return l
end