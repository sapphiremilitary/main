--!strict

local Players = game:GetService("Players")

local Fetch = script.Parent
local Match = require(Fetch.Match)

return function(s: string)
    local v = Match(s, Players:GetPlayers())
    assert(v)
    
    return v
end