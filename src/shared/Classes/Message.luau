--!strict

local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Messages = ReplicatedStorage:WaitForChild("Messages")
local Functions = ReplicatedStorage:WaitForChild("Functions")

local Try = require(Functions.Try)

local module = {}

module.new = function(header: string, deleteOnRead: boolean?)
	local m = {}

	local function call(v, r)
		if typeof(v) == "table" then
			v = HttpService:JSONEncode(v)
		end

		check(v)
		local t = all(r)
		new(header, v, deleteOnRead, t)
	end

	function m:Send(v)
		Try(call, v)
	end

	function m:SendTo(recipients: { Player }, v)
		Try(call, v, recipients)
	end

	return m
end

function module:BindToHeader(f: any)
	local function call(m: ForceField)
		assert(m:IsA("ForceField"))
		local c = module:Read(m)
		f(c.header, c.value)
	end

	local function try(m: ForceField)
		Try(call)
	end

	local c = Messages.ChildAdded:Connect(try)
	return c
end

function module:Read(msg: ForceField)
	local h, v, d, r =
		msg:GetAttribute("h"), 
		msg:GetAttribute("v"), 
		msg:GetAttribute("d"), 
		msg:GetAttribute("r")

	if r then
		assert(RunService:IsClient())

		local t = HttpService:JSONDecode(r)
		local i = table.find(t, Players.LocalPlayer.Name)
		assert(i)
	end

	v = typeof(v) == "string" and HttpService:JSONDecode(v) or v
	if d then
		msg:Destroy()
	end

	local c = {}
	c.header = h
	c.value = v

	return c
end

function new(h, v, d, p)
	local ff = Instance.new("ForceField") -- ForceField is the quickest Instance to create
	ff.Name = HttpService:GenerateGUID(true)
	ff:SetAttribute("h", h)
	ff:SetAttribute("v", v)
	ff:SetAttribute("d", d)
	ff:SetAttribute("r", p)
	ff.Parent = Messages
	Debris:AddItem(ff, 5)
	return ff
end

function check(v)
	script:SetAttribute("v", v or 1)
	local c = script:GetAttribute("v")
	assert(c)
end

function all(r: any?)
	local c, s = RunService:IsClient(), RunService:IsServer()
	assert(r and #r > 1 and s or c)

	local T
	local t = r or {}
	for i, plr in t do
		t[i] = plr.Name
		T = HttpService:JSONEncode(t)
	end

	return T
end

return module
