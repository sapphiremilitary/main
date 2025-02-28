--!strict

local Fetch = script.Parent
local match = require(Fetch.match)

local Teams = game:GetService("Teams")

return function(str: string)
    local t = match(str, Teams:GetTeams())
    assert(t and t:IsA("Team"))

    return t
end