--!strict

local Players = game:GetService("Players")

return function()
    local t = Players:GetPlayers()
    local r: any 
    r = Random.new()
    r = t[r:NextInteger(1, #t)]
    
    return r
end