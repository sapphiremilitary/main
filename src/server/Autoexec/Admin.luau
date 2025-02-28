--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Classes = ReplicatedStorage:WaitForChild("Classes")
local Callback = require(Classes.Callback)
local Remote = require(Classes.Remote)

local Resources = ReplicatedStorage:WaitForChild("Resources")
local Commands = require(Resources.Commands)

local module = {}

function module:init()
	local c = Callback.new("chat", exec)
	Remote:BindToHeader("char", c)
end

function exec(tbl: {string}, plr: Player)
	local msg = tbl[1]
	assert(msg and msg:match("^:") and #msg > 1) -- msg is a command

	-- splitting message into arguments
	msg = msg:sub(2, #msg)
	local args = {}
	for v in msg:gmatch("[%w%p%%]+") do
		table.insert(args, v)
	end

	-- finding command
	local cmd
	local k, v = next(Commands)
	while not cmd and v do
		cmd = table.find(v.words, args[1]) and v
		k, v = next(Commands, k)
	end
	assert(cmd)
	table.remove(args, 1)

	-- getting expected argument of command (converts our strings into a type)
	local kv = {}
	for i, find in cmd.fetch do
		local s = args[i]
		table.insert(kv, find(s, plr))
	end

	cmd.call(kv, cmd.func)
end

return module
