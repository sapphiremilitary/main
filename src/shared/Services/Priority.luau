--!strict

local RunService = game:GetService("RunService")

local avg = 0
local ft = 0
local i = 0

local module = {}

module.init = function()
	task.spawn(set)
end

function set()
	while true do
		local t = RunService.Heartbeat:Wait()

		avg = ft >= 1 and ft / i or avg
		ft = ft < 1 and ft + t or 0
		i = ft > 0 and i + 1 or 0
	end
end

return module
