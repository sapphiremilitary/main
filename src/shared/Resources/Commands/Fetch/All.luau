--!strict

local Players = game:GetService("Players")

return function()
    local p = Players:GetPlayers()
    
    return p
end