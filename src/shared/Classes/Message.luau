--!strict

local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Functions = ReplicatedStorage:WaitForChild("Functions")
local Pcall = require(Functions.Pcall)

local messages = ReplicatedStorage:WaitForChild("Messages")

local module = {}

module.new = function(header: string, deleteOnRead: boolean?)
	local msg = {}

	local function call(v: any, r: any)
		-- checking if value can be converted to an attribute
		local T = typeof(v)
		v = T == "table" and HttpService:JSONEncode(v) or v
		script:SetAttribute("v", v)
		assert(script:GetAttribute("v"))

		-- converting recipient list into a name list
		assert(r and #r > 1 and RunService:IsServer() or RunService:IsClient())
		local t = r or {}
		for i, plr in t do
			t[i] = plr.Name
		end
		t = #t > 1 and HttpService:JSONEncode(t) or nil

		new(header, v, deleteOnRead, t)
	end

	msg.Send = function(value: any)
		Pcall(call, value)
	end

	function msg:SendTo(recipients: { Player }, value: any)
		Pcall(call, value, recipients)
	end

	return msg
end

function module:BindToHeader(callback: any)
	local function call(m: ForceField)
		assert(m:IsA("ForceField"))
		local c = module:Read(m)
		callback(c.header, c.value)
	end

	local function try(m: ForceField)
		Pcall(call)
	end

	local c = messages.ChildAdded:Connect(try)
	return c
end

function module:Read(msg: ForceField)
	local h, v, dor, rec =
		msg:GetAttribute("h") :: string,
		msg:GetAttribute("v") :: any,
		msg:GetAttribute("dor") :: boolean?,
		msg:GetAttribute("rec") :: string?

	if rec then
		assert(RunService:IsClient())

		local temp = HttpService:JSONDecode(rec)
		local i = table.find(temp, Players.LocalPlayer.Name)
		assert(i)
	end

	v = typeof(v) == "string" and HttpService:JSONDecode(v) or v
	if dor then
		msg:Destroy()
	end

	local c = {}
	c.header = h
	c.value = v

	return c
end

function new(h: string, v: any, dor: boolean?, plrs: string?)
	local ff = Instance.new("ForceField") -- ForceField is the quickest Instance to create
	ff.Name = HttpService:GenerateGUID(true)
	ff:SetAttribute("h", h)
	ff:SetAttribute("v", v)
	ff:SetAttribute("dor", dor)
	ff:SetAttribute("rec", plrs)
	ff.Parent = messages
	Debris:AddItem(ff, 5)
	return ff
end

return module
