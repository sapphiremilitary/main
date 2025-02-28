--!strict

local Players = game:GetService("Players")

return function(plr: Player)
    local c = plr.Character
    local o = c and c:GetPivot().Position or Vector3.zero

    local tbl = {}
    for _, plr in Players:GetPlayers() do
        table.insert(tbl, plr.Character)
    end

    local t = {}
    for _, char in tbl do
        local at = char:GetPivot().Position
        local d = (o - at).Magnitude
        if d <= 30 then
            table.insert(t, Players:GetPlayerFromCharacter(char))
        end
    end
    tbl = t

    return tbl
end