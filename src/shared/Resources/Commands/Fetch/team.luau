--!strict

local Teams = game:GetService("Teams")

local Fetch = script.Parent
local Match = require(Fetch.Match)

return function(s: string)
    local t = Match(s, Teams:GetTeams())
    assert(t)

    return t
end