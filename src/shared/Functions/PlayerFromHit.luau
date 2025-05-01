--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Functions = ReplicatedStorage:WaitForChild("Functions")

local Table = require(Functions.Table)

function get(i)
	local c = i:FindFirstAncestorWhichIsA("Model")
	local p = c and Players:GetPlayerFromCharacter(c)

	return p
end

return function(...: BasePart)
	local a = { ... }
	local l = {}

	for _, i in a do
		local p = get(i)

		local d: any
		d = table.find(l, p)
		d = not d and p

		table.insert(l, d)
		Table.clean(l)
	end

	return unpack(l)
end
