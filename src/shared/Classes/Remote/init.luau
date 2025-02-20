--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local remoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")
assert(remoteEvent)

local Buffer = require(script.Buffer)

local module = {}

module.new = function(header: string)
	local event = {}

	function event:FireClient(plr, ...)
		assert(RunService:IsServer())
		local packet = Buffer.new(header, ...)
		remoteEvent:FireClient(plr, packet)
	end

	function event:FireServer(...)
		assert(RunService:IsClient())
		local packet = Buffer.new(header, ...)
		remoteEvent:FireServer(packet)
	end

	return event
end

function module:BindToHeader(header: string, func: (...any) -> ())
	local function send(packet: buffer, plr: Player?)
		local data = Buffer:Read(packet)
		if data[1] == header then
			table.remove(data, 1)
			func(plr, unpack(data))
		elseif data == header then
			func(plr)
		end
	end

	local function readc(packet: any)
		send(packet)
	end

	local function reads(plr: Player, packet: any)
		if typeof(packet) == "buffer" then
			send(packet, plr)
		end
	end

	local c = RunService:IsClient() and remoteEvent.OnClientEvent:Connect(readc)
		or remoteEvent.OnServerEvent:Connect(reads)
	return c
end

return module
