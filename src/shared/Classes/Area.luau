--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Functions = ReplicatedStorage:WaitForChild("Functions")
local PlayerFromHit = require(Functions.PlayerFromHit)

local module = {}

module.new = function(cframe: CFrame, size: Vector3)
	local a = {}
	a.Entered = Instance.new("BindableEvent")
	a.Removed = Instance.new("BindableEvent")

	local e = true
	function a:Destroy()
		e = false
		a.Entered:Destroy()
		a.Removed:Destroy()
	end

	local function chars()
		local c = {}
		for _, plr in Players:GetPlayers() do
			table.insert(c, plr.Character)
		end

		return c
	end

	local i = {}
	local function listen()
		while e do
			local p = OverlapParams.new()
			p.FilterType = Enum.RaycastFilterType.Include
			local c = chars()
			p:AddToFilter(c)

			local h = workspace:GetPartBoundsInBox(cframe, size, p)
			local l = { PlayerFromHit(unpack(h)) }

			if #l > #i then
				a.Entered:Fire(l)
			elseif #l < #i then
				a.Removed:Fire(l)
			end
			i = l

			task.wait(0.1) -- preventing race conditions
		end
	end
	task.spawn(listen)

	return a
end

function module:Raise(p: BasePart, length: number)
	local cf = p.CFrame * CFrame.new(0, p.Size.Y/2, 0)
	local g = cf * CFrame.new(0, length, 0)
	cf = cf:Lerp(g, 0.5)

	return cf
end

return module
