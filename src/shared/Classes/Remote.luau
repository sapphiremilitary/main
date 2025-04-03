--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Functions = ReplicatedStorage:WaitForChild("Functions")
local Pcall = require(Functions.Pcall)

local Classes = ReplicatedStorage:WaitForChild("Classes")
local Buffer = require(Classes.Buffer)

local remoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")

local module = {}

module.new = function(header: string)
	local event = {}

	local function call(rs: boolean, d: {}, f: (...any) -> (), t)
		assert(rs)
		local p = Buffer.new(header, unpack(d))
		local _ = t and f(remoteEvent, t, p) or f(remoteEvent, p)
	end

	-- Server -> Client
	function event:FireClient(plr, ...)
		Pcall(call, RunService:IsServer(), { ... }, remoteEvent.FireClient, plr)
	end

	-- Client -> Server
	function event:FireServer(...)
		Pcall(call, RunService:IsClient(), { ... }, remoteEvent.FireServer)
	end

	return event
end

function module:BindToHeader(callback: any)
	local function call(p: buffer, ...)
		assert(typeof(p) == "buffer")
		local d = Buffer:Read(p)
		callback(d.header, d.value, ...)
	end

	local function tryl(p: buffer)
		Pcall(call, p)
	end

	local function trys(plr: Player, p: buffer)
		Pcall(call, p, plr)
	end

	local c = RunService:IsServer() and remoteEvent.OnServerEvent:Connect(trys)
		or remoteEvent.OnClientEvent:Connect(tryl)
	return c
end

return module
