--!strict

local Fetch = script.Parent
local Match = require(Fetch.Match)

local Players = game:GetService("Players")

return function(str: string)
    local v = Match(str, Players:GetPlayers())
    assert(v and v:IsA("Player"))
    
    return v
end