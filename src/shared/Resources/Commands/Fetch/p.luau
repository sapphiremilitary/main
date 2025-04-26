--!strict

local Fetch = script.Parent
local Match = require(Fetch.Match)

local Teams = game:GetService("Teams")

return function(s)
    local T = s:match("%a+")
    assert(T)
    s = T
    
    local t = Match(s, Teams:GetTeams())
    assert(t and t:IsA("Team"))
    local plrs = t:GetPlayers()
    
    return plrs
end