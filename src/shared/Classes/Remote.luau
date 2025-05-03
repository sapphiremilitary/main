--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Functions = ReplicatedStorage:WaitForChild("Functions")
local Classes = ReplicatedStorage:WaitForChild("Classes")
local Buffer = require(Classes.Buffer)
local RemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")
local Try = require(Functions.Try)

local module = {}

module.new = function(header: string)
	local e = {}

	local function call(t: { any }, p)
		assert(p and RunService:IsServer() or RunService:IsClient())
		local d = Buffer.new(header, unpack(t))
		local _ = p and RemoteEvent:FireClient(p, d) or RemoteEvent:FireServer(d)
	end

	function e:FireClient(p: Player, ...)
		Try(call, { ... }, p)
	end

	function e:FireServer(...)
		Try(call, { ... })
	end

	return e
end

function module:BindToHeader(f: (string, ...any) -> ())
	local function call(...)
		local c = RunService:IsServer()
		local a = {...}

		-- getting buffer and player
		local b = c and a[2] or a[1]
		local p = c and a[1]
		assert(typeof(b) == "buffer")
		assert(buffer.len(b) <= 1024)
		
		-- invoking callback
		local t = Buffer:Read(b)
		f(t.header, t.value, p)
	end

	local function try(...)
		Try(call, ...)
	end
	
	local s = RunService:IsServer()
	local c = s and RemoteEvent.OnServerEvent:Connect(try) or RemoteEvent.OnClientEvent:Connect(try)
	return c
end

return module
