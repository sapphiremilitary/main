--!strict
--[[
	Provides a method for sending data to the server or client. When FireClient or FireServer are invoked,
	the supplied arguments are packed into a buffer and sent. Conversely, the BindToHeader method is used to read
	the data being sent.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Services = ReplicatedStorage:WaitForChild("Services")
local Pcall = require(Services.Pcall)

local remoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")

local Buffer = require(script.Buffer)

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
		Pcall:Try(call, RunService:IsServer(), { ... }, remoteEvent.FireClient, plr)
	end

	-- Client -> Server
	function event:FireServer(...)
		Pcall:Try(call, RunService:IsClient(), { ... }, remoteEvent.FireServer)
	end

	return event
end

function module:BindToHeader(header: string, callback: any)
	local function call(p: buffer, ...)
		assert(typeof(p) == "buffer")
		local d = Buffer:Read(p)
		callback(d.header, d.value, ...)
	end

	local function tryl(p: buffer)
		Pcall:Try(call, p)
	end

	local function trys(plr: Player, p: buffer)
		Pcall:Try(call, p, plr)
	end

	local c = RunService:IsServer() and remoteEvent.OnServerEvent:Connect(trys)
		or remoteEvent.OnClientEvent:Connect(tryl)
	return c
end

return module
