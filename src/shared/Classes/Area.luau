--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Functions = ReplicatedStorage:WaitForChild("Functions")
local GetCharacters = require(Functions.GetCharacters)
local PlayerFromHit = require(Functions.PlayerFromHit)

local module = {}

module.new = function(cf: CFrame, s: Vector3, Rate: () -> number)
	local a = {}
	local e = true
	local i = {}

	a.Entered = Instance.new("BindableEvent")
	a.Removed = Instance.new("BindableEvent")

	function a:Destroy()
		e = false
		a.Entered:Destroy()
		a.Removed:Destroy()
	end

	function a:Move(to: CFrame)
		cf = to
	end

	local function listen()
		while e do
			local l = module.GetPlayers(cf, s)
			if #l > #i then
				a.Entered:Fire(l)
			elseif #l < #i then
				a.Removed:Fire(l)
			end
			i = l

			local r = Rate()
			task.wait(r) -- preventing race conditions
		end
	end

	task.spawn(listen)

	return a
end

function module.GetPlayers(...)
	local p = OverlapParams.new()
	p.FilterType = Enum.RaycastFilterType.Include
	local c = GetCharacters()
	p:AddToFilter(c)

	local a = select(1, ...)
	local h = typeof(a) == "table" and a or workspace:GetPartBoundsInBox(a, select(2, ...), p)
	local l = { PlayerFromHit(unpack(h)) }

	return l
end

function module:Raise(p: BasePart, length: number)
	local cf = p.CFrame * CFrame.new(0, p.Size.Y / 2, 0)
	local g = cf * CFrame.new(0, length, 0)
	cf = cf:Lerp(g, 0.5)

	return cf
end

return module
