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

function module:BindToHeader(header: string, func: (any) -> any)
	local function invoke(object: Instance)
		assert(object:IsA("ForceField"))
		local snip = module:Read(object)
		if snip.header == header then
			func(snip.value)
		end
	end

	local c = messages.ChildAdded:Connect(invoke)
	return c
end

function module:Read(msg: ForceField)
	local header, value, deleteOnRead, recipients =
		msg:GetAttribute("header") :: string,
		msg:GetAttribute("value") :: any,
		msg:GetAttribute("deleteOnRead") :: boolean?,
		msg:GetAttribute("recipients") :: string?

	if recipients then
		assert(RunService:IsClient())

		local temp = HttpService:JSONDecode(recipients)
		local i = table.find(temp, Players.LocalPlayer.Name)
		assert(i)
	end

	value = typeof(value) == "string" and HttpService:JSONDecode(value) or value
	if deleteOnRead then
		msg:Destroy()
	end

	local snippetObject = {
		header = header,
		value = value,
	}

	return snippetObject
end

function new(header: string, value: any, deleteOnRead: boolean?, plrs: string?)
	local forceField = Instance.new("ForceField") -- ForceField is the quickest Instance to create
	forceField.Name = HttpService:GenerateGUID(true)
	forceField:SetAttribute("header", header)
	forceField:SetAttribute("value", value)
	forceField:SetAttribute("deleteOnRead", deleteOnRead)
	forceField:SetAttribute("recipients", plrs)
	forceField.Parent = messages
	Debris:AddItem(forceField, 5)
	return forceField
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