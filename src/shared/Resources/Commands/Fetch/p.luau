--!strict

local Fetch = script.Parent
local Match = require(Fetch.Match)

local Teams = game:GetService("Teams")

return function(str: string)
    local s = str:match("%a+")
    assert(s)
    str = s
    
    local t = Match(str, Teams:GetTeams())
    assert(t and t:IsA("Team"))
    local plrs = t:GetPlayers()
    
    return plrs
end