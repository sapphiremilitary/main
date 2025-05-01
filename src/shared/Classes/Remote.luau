--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Functions = ReplicatedStorage:WaitForChild("Functions")
local Classes = ReplicatedStorage:WaitForChild("Classes")
local RemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")

local Try = require(Functions.Try)
local Buffer = require(Classes.Buffer)

local module = {}

module.new = function(header: string)
	local event = {}

	local function call(rs, d, f: (...any) -> (), t)
		assert(rs)

		local p = Buffer.new(header, unpack(d))
		local _ = t and f(RemoteEvent, t, p) or f(RemoteEvent, p)
	end

	-- Server -> Client
	function event:FireClient(plr, ...)
		local s = RunService:IsServer()
		local f = RemoteEvent.FireClient

		Try(call, s, { ... }, f, plr)
	end

	-- Client -> Server
	function event:FireServer(...)
		local c = RunService:IsClient()
		local f = RemoteEvent.FireServer

		Try(call, c, { ... }, f)
	end

	return event
end

function module:BindToHeader(f: any)
	local function call(p, ...)
		assert(typeof(p) == "buffer")
		local d = Buffer:Read(p)
		f(d.header, d.value, ...)
	end

	local function tryl(p)
		Try(call, p)
	end

	local function trys(plr, p)
		Try(call, p, plr)
	end

	local c = RunService:IsServer() and RemoteEvent.OnServerEvent:Connect(trys)
		or RemoteEvent.OnClientEvent:Connect(tryl)
	return c
end

return module
