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

module.new = function(header: string, once: boolean?)
	local m = {}

	local function call(v, r: { Player }?)
		-- creating message
		v = adapt(v)
		check(v)
		local t = all(r)
		new(header, v, once, t)
	end

	function m:Fire(value)
		Try(call, value)
	end

	function m:FireClients(recipients: { Player }, value)
		Try(call, value, recipients)
	end

	return m
end

function module:BindToHeader(f: (string, ...any) -> ())
	local function call(m: ForceField)
		local c = module:Read(m)
		f(c.header, c.value)
	end

	local function try(m: ForceField)
		Try(call, m)
	end

	local c = Messages.ChildAdded:Connect(try)
	return c
end

function module:Read(ff: ForceField)
	-- getting message values
	local h = ff:GetAttribute("h") :: string?
	local v = ff:GetAttribute("v") :: any
	local o = ff:GetAttribute("o") :: boolean?
	local r = ff:GetAttribute("r") :: string?
	assert(h)

	if r then
		assert(RunService:IsClient())

		-- checking if message can be read
		local t = HttpService:JSONDecode(r)
		local i = table.find(t, Players.LocalPlayer.Name)
		assert(i)
	end

	if o then
		ff:Destroy()
	end

	local c = {}
	c.header = h
	c.value = v

	return c
end

function new(h: string, v: any, o: boolean?, p: string?)
	-- creating message
	local ff = Instance.new("ForceField")
	ff.Name = HttpService:GenerateGUID(true)
	ff:SetAttribute("h", h)
	ff:SetAttribute("v", v)
	ff:SetAttribute("o", o)
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

function adapt(v)
	local t
	if typeof(v) == "table" then
		t = HttpService:JSONDecode(v)
	end

	return t or v
end

function all(r: { Player }?)
	-- checking recipients
	local s = RunService:IsServer()
	local c = r and s
	assert(c or not s)

	local v

	-- converting list into json
	local T = {} :: any
	local t = r or T
	for i, p in t do
		t[i] = p.Name
		v = HttpService:JSONEncode(t)
	end

	return v
end

return module
