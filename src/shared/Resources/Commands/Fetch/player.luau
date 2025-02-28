--!strict

local Fetch = script.Parent
local match = require(Fetch.match)

local Players = game:GetService("Players")

return function(str: string)
    local v = match(str, Players:GetPlayers())
    assert(v and v:IsA("Player"))
    
    return v
end