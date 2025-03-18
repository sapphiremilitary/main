--!strict

local Players = game:GetService("Players")

local module = {}

module.new = function(origin: Vector3, direction: Vector3, filter: { Instance }?)
    local r = {}

    local p = RaycastParams.new()
    p.IgnoreWater = true
    p:AddToFilter(filter or {})

    -- calculating size of ray
    local h = origin + direction
    local d = (origin - h).Magnitude
    local s = Vector3.new(0.5, 0.5, d)

    -- instance from raycast
    local i

    local hit = workspace:Blockcast(CFrame.new(origin), s, direction, p)
    if hit then
        -- converting hit to char
        local c = hit.Instance:FindFirstAncestorOfClass("Model")
        local f = c and Players:GetPlayerFromCharacter(c)

        -- char or hit
        i = f and c or hit.Instance
    end
    
    function r:GetInstance()
        return i
    end

    function r:Include(team: Team?)
        local f = i and i:IsA("Model") and Players:GetPlayerFromCharacter(i)
        local c = f and f.Team == team and i

        return c
    end

    return r
end

return module