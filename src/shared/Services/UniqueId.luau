--!strict

local HttpService = game:GetService("HttpService")

local ids: { any } = {}

local module = {}

function module:SetUID(object: Instance)
	-- assuring object doesn't have an existing uid
	local a = object:GetAttribute("uid")
	if a then
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
    local c: RBXScriptConnection

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

    local s = o:GetPropertyChangedSignal("Parent")
	c = s:Connect(rm)
end

return module
