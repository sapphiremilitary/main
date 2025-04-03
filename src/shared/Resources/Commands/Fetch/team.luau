--!strict

local Fetch = script.Parent
local Match = require(Fetch.Match)

local Teams = game:GetService("Teams")

return function(str: string)
    local t = Match(str, Teams:GetTeams())
    assert(t and t:IsA("Team"))

    return t
end