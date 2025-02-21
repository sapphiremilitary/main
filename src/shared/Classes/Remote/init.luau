--!strict
--[[
	Provides a method for sending data to the server or client. When FireClient or FireServer are invoked,
	the supplied arguments are packed into a buffer and sent. Conversely, the BindToHeader method is used to read
	the data being sent.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local remoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")

local Buffer = require(script.Buffer)

local module = {}

module.new = function(header: string)
	local event = {}

	-- Server -> Client
	function event:FireClient(plr, ...)
		assert(RunService:IsServer())
		local packet = Buffer.new(header, ...)
		remoteEvent:FireClient(plr, packet)
	end

	-- Client -> Server
	function event:FireServer(...)
		assert(RunService:IsClient())
		local packet = Buffer.new(header, ...)
		remoteEvent:FireServer(packet)
	end

	return event
end

function module:BindToHeader(header: string, f: (...any) -> ())
	local function decode(packet: buffer, plr: Player?)
		local data = Buffer:Read(packet)
		


		if data[1] == header then
			table.remove(data, 1)
			f(plr, unpack(data))
		elseif data == header then
			f(plr)
		end
	end

	local function readc(packet: any)
		decode(packet)
	end

	local function reads(plr: Player, packet: any)
		if typeof(packet) == "buffer" and buffer.len(packet) < 1024 then
			decode(packet, plr)
		else -- player is exploiting

		end
	end

	local c = RunService:IsClient() and remoteEvent.OnClientEvent:Connect(readc)
		or remoteEvent.OnServerEvent:Connect(reads)
	return c -- returns connection so we can disconnect if needed
end

return module
