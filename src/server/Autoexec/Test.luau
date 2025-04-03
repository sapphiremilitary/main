--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Classes = ReplicatedStorage:WaitForChild("Classes")
local Area = require(Classes.Area)

local module = {}

module.init = function()
	local p = workspace:WaitForChild("Part") :: Part
    p.BrickColor = BrickColor.Red()
	local cf = Area:Raise(p, 100)

	local a = Area.new(cf, Vector3.new(p.Size.X, 100, p.Size.Z), 0.1)

    local function draw(l: { Player })
		local c = #l > 0 and BrickColor.Green() or BrickColor.Red()
        p.BrickColor = c
	end
    a.Entered.Event:Connect(draw)
    a.Removed.Event:Connect(draw)
end

return module
