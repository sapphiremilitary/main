--!strict

local HttpService = game:GetService("HttpService")

local reg = {
	"Humanoid",
	"Model",
	"Tool",
	"Part",
	"MeshPart",
	"WedgePart",
	"CornerWedgePart",
	"TrussPart",
	"SpawnLocation",
	"Seat",
	"VehicleSeat",
	"UnionOperation",
}

local ids: { any } = {}

local module = {}

function module:SetUID(obj: Instance)
	-- obj has an attribute or obj can't be registered
	if obj:GetAttribute("uid") or not table.find(reg, obj.ClassName) then
		return
	end

	local i = #ids + 1
	obj:SetAttribute("uid", i)
	table.insert(ids, i, obj)

	clean(obj)
end

function module:GetUID(obj: Instance)
	local uid = obj:GetAttribute("uid")

	return uid
end

function clean(o: Instance)
	local c
	
	local function rm(p)
		if not p then
			-- reserving uid for 5 seconds
			local i = table.find(ids, o) :: number
			local g = HttpService:GenerateGUID(true)
			ids[i] = g
			task.wait(5)

			-- releasing uid
			i = table.find(ids, g) :: number
			table.remove(ids, i)

			c:Disconnect()
		end
	end

	local s = o:GetAttributeChangedSignal("Parent")
	c = s:Connect(rm)
end

return module
