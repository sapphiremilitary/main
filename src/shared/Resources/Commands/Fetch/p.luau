--!strict

local Teams = game:GetService("Teams")

local Fetch = script.Parent
local Match = require(Fetch.Match)

return function(s: string)
    local T = s:match("%a+")
    assert(T)
    s = T
    
    local t = Match(s, Teams:GetTeams())
    assert(t)
    local l = t:GetPlayers()
    
    return l
end