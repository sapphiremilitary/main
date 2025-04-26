--!strict

local Fetch = script.Parent
local Match = require(Fetch.Match)

local Teams = game:GetService("Teams")

return function(s)
    local t = Match(s, Teams:GetTeams())
    assert(t and t:IsA("Team"))

    return t
end