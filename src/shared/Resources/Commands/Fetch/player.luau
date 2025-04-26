--!strict

local Fetch = script.Parent
local Match = require(Fetch.Match)

local Players = game:GetService("Players")

return function(s)
    local v = Match(s, Players:GetPlayers())
    assert(v and v:IsA("Player"))
    
    return v
end