--!strict

local Players = game:GetService("Players")

return function()
    local tbl = Players:GetPlayers()
    local r = Random.new()
    return tbl[r:NextInteger(1, #tbl)]
end