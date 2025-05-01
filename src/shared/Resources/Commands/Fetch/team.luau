--!strict

local Fetch = script.Parent
local Match = require(Fetch.Match)

local Teams = game:GetService("Teams")

return function(s)
    local t = Match(s, Teams:GetTeams())
    assert(t)

    return t
end