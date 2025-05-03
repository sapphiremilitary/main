--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Functions = ReplicatedStorage:WaitForChild("Functions")
local GetCharacters = require(Functions.GetCharacters)
local PlayerFromHit = require(Functions.PlayerFromHit)

local module = {}

module.new = function(cf: CFrame, size: Vector3, Rate: () -> number)
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

	local function set()
		while e do
			local l = get(cf, size)
			if #l > #i then
				a.Entered:Fire(l)
			elseif #l < #i then
				a.Removed:Fire(l)
			end
			i = l

			-- preventing race conditions
			local r = Rate()
			task.wait(r)
		end
	end

	task.spawn(set)

	return a
end

function get(...)
	local a = {...}

	local p = OverlapParams.new()
	p.FilterType = Enum.RaycastFilterType.Include
	local c = GetCharacters()
	p:AddToFilter(c)

	-- storing players in area
	local t = a[1]
	local h = typeof(t) == "table" and t or workspace:GetPartBoundsInBox(t, a[2], p)
	local l = { PlayerFromHit(unpack(h)) }

	return l
end

function module:Raise(p: BasePart, length: number)
	-- assures our area is flush with part
	local cf = p.CFrame * CFrame.new(0, p.Size.Y / 2, 0)
	local g = cf * CFrame.new(0, length, 0)
	cf = cf:Lerp(g, 0.5)

	return cf
end

return module
