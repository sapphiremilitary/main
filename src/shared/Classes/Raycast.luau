--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Functions = ReplicatedStorage:WaitForChild("Functions")
local PlayerFromHit = require(Functions.PlayerFromHit)

local module = {}

module.new = function(origin: Vector3, direction: Vector3)
    local r = {}

    local p = RaycastParams.new()
    p.IgnoreWater = true

    local at = origin + direction
    local d = (origin - at).Magnitude
    local s = Vector3.new(0.5, 0.5, d)
    local cf = CFrame.new(origin)

    local i
    local h = workspace:Blockcast(cf, s, direction, p)
    i = h and (PlayerFromHit(h.Instance) or h.Instance)

    function r:GetInstance()
        return i
    end

    function r:Filter(team: Team?)
        local p: any
        p = i:IsA("Player") and i.Team == team
        p = p and i

        return p
    end

    return r
end

return module