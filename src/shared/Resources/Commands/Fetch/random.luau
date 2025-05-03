--!strict

local Players = game:GetService("Players")

return function()
    local t = Players:GetPlayers()
    local r = Random.new()
    
    local i = r:NextInteger(1, #t)
    local p = t[i]

    return p
end