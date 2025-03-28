--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Functions = ReplicatedStorage:WaitForChild("Functions")
local PlayerFromHit = require(Functions.PlayerFromHit)

local module = {}

module.new = function(origin: Vector3, direction: Vector3)
    local r = {}

    local p = RaycastParams.new()
    p.IgnoreWater = true

    -- calculating size of ray
    local h = origin + direction
    local d = (origin - h).Magnitude
    local s = Vector3.new(0.5, 0.5, d)

    -- instance from raycast
    local i

    local hit = workspace:Blockcast(CFrame.new(origin), s, direction, p)
    i = hit and (PlayerFromHit(hit.Instance) or hit.Instance)

    function r:GetInstance()
        return i
    end

    function r:Include(team: Team?)
        local v = i:IsA("Player") and i.Team == team
        v = v and i

        return v
    end

    return r
end

return module