--!strict

local Players = game:GetService("Players")

return function()
    local t = Players:GetPlayers()
    local r = Random.new()
    
    return t[r:NextInteger(1, #t)]
end