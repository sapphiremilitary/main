--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Classes = ReplicatedStorage:WaitForChild("Classes")
local Callback = require(Classes.Callback)
local Message = require(Classes.Message)
local Remote = require(Classes.Remote)

local module = {}

-- RemoteFunction implementation
function module:GetResponse(header: string, ...)
	assert(RunService:IsClient())

	-- creates callback, sets "v" as our data
	local v
	local function set(...)
		v = { ... }
	end
	local cb = Callback.new(header, set)

	-- prompts server to invoke callback, setting our value
	local event = Remote.new(header)
	event:FireServer(...)
	local t = Message:BindToHeader(cb)

	local c = os.clock()
	repeat
		task.wait()
	until v or os.clock() - c > 5
	t:Disconnect()

	-- returns v or nil
	v = v or {}
	return unpack(v)
end

return module
