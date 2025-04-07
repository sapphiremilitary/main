--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Functions = ReplicatedStorage:WaitForChild("Functions")
local Partial = require(Functions.Partial)

local m = 0

local module = {}

module.init = function()
	task.spawn(set)
end

function module:Benchmark(f: any, ...)
	local c = os.clock()
	f(...)
	c = os.clock() - c

	return c
end

function module:GetRate(T: number)
	local function get()
		local r = 1 - m
		r *= 0.05 -- 5% performance impact at most
		r = 1 / (r / T)

		return r
	end

	local f = Partial(get, T)

	return f
end

function set()
	local i = 0
	local t = 0

	while RunService:IsRunning() do
		local c = os.clock()
		RunService.Heartbeat:Wait()
		c = os.clock() - c

		m = t >= 1 and t / i or m
		t = t < 1 and t + c or 0
		i = t > 0 and i + 1 or 0
	end
end

return module
