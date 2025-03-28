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

function module:SetUID(object: Instance)
	-- object has an attribute or object shouldn't be registered
	if object:GetAttribute("uid") or not table.find(reg, object.ClassName) then
		return
	end

	local i = #ids + 1
	object:SetAttribute("uid", i)
	table.insert(ids, i, object)

	sanitize(object)
end

function module:GetUID(object: Instance)
	local uid = object:GetAttribute("uid")

	return uid
end

function sanitize(o: Instance)
	local c

	local function rm(p)
		if not p then
			-- reserving uid for 5 seconds
			local i = table.find(ids, o) :: number
			local guid = HttpService:GenerateGUID(true)
			ids[i] = guid
			task.wait(5)

			-- releasing uid
			i = table.find(ids, guid) :: number
			table.remove(ids, i)

			c:Disconnect()
		end
	end

	c = o:GetPropertyChangedSignal("Parent"):Connect(rm)
end

return module
