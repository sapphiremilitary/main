--!strict

type message = {
	Send: (self: any) -> (),
	SendTo: (self: any, { Player }) -> (),
}

type snippet = {
	header: string,
	value: any,
}

local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Services = ReplicatedStorage:WaitForChild("Services")
local Pcall = require(Services.Pcall)

local messages = ReplicatedStorage:WaitForChild("Messages")

local module = {}

module.new = function(header: string, value: any, deleteOnRead: boolean?)
	value = checkType(value)
	assert(value)

	local msg = {} :: message

	local function create(plrs: any)
		plrs = plrs or {}
		for i, plr in plrs do
			plrs[i] = plr.Name
		end
		plrs = #plrs > 1 and HttpService:JSONEncode(plrs) or nil
		new(header, value, deleteOnRead, plrs)
	end

	msg.Send = function()
		create()
	end

	function msg:SendTo(plrs)
		assert(RunService:IsServer())
		create(plrs)
	end

	return msg
end

function module:BindToHeader(header: string, callback: any)
	local function call(m: ForceField)
		assert(m:IsA("ForceField"))
		local c = module:Read(m)
		callback(c.header, c.value)
	end

	local function try(m: ForceField)
		Pcall:Try(call)
	end

	local c = messages.ChildAdded:Connect(try)
	return c
end

function module:Read(msg: ForceField)
	local h, v, dor, rec =
		msg:GetAttribute("header") :: string,
		msg:GetAttribute("value") :: any,
		msg:GetAttribute("deleteOnRead") :: boolean?,
		msg:GetAttribute("recipients") :: string?

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
	ff:SetAttribute("header", h)
	ff:SetAttribute("value", v)
	ff:SetAttribute("deleteOnRead", dor)
	ff:SetAttribute("recipients", plrs)
	ff.Parent = messages
	Debris:AddItem(ff, 5)
	return ff
end

function checkType(var: any): any
	local types = {
		string = true,
		UDim2 = true,
		Vector3 = true,
		NumberRange = true,
		boolean = true,
		BrickColor = true,
		EnumItem = true,
		Rect = true,
		number = true,
		Color3 = true,
		NumberSequence = true,
		Font = true,
		UDim = true,
		Vector2 = true,
		ColorSequence = true,
		CFrame = true,
		table = true,
	}
	assert(types[typeof(var)])
	if typeof(var) == "table" then
		var = HttpService:JSONEncode(var)
	end
	return var
end

return module