--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Functions = ReplicatedStorage:WaitForChild("Functions")
local Table = require(Functions.Table)

return function<T>()
	local c: { T } = {}
	for _, p in Players:GetPlayers() do
		table.insert(c, p.Character)
	end
	Table.remove(c, nil)

	return c
end
