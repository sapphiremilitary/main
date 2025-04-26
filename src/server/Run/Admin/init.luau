--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Classes = ReplicatedStorage:WaitForChild("Classes")
local Resources = ReplicatedStorage:WaitForChild("Resources")

local Callback = require(Classes.Callback)
local Commands = require(Resources.Commands)
local Remote = require(Classes.Remote)

local module = {}

function module:init()
	local chat = Callback.new("chat", exec)
	Remote:BindToHeader(chat)
end

function exec(t, p)
	local m = t[1]
	assert(m and m:match("^:") and #m > 1)

	local a = split(m)
	local c = find(a)
	local f = fetch(c, a, p)

	c.call(f, c.func)
end

function fetch(c, a, p)
	local d = {}
	for i, f in c.fetch do
		local s = a[i]
		table.insert(d, f(s, p))
	end

	return d
end

function find(a)
	local cmd
	local k, v
	repeat
		k, v = next(Commands, k)
		local f = table.find(v.words, a[1])
		cmd = f and v
	until cmd or not v
	assert(cmd)

	table.remove(a, 1)

	return cmd
end

function split(m)
	m = m:sub(2, #m)
	local a = {}
	for v in m:gmatch("[%w%p%%]+") do
		table.insert(a, v)
	end

	return a
end

return module
