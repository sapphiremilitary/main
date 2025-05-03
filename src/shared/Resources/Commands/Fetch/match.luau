--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Functions = ReplicatedStorage:WaitForChild("Functions")
local Table = require(Functions.Table)

return function<T>(s: string, t: { T }): T?
	s = string.lower(s)
	local b = s:sub(1, 1)
	local i = 1

	local m = {}

	local function set()
		for _, obj in t do
			-- getting name substring
			local w = obj :: any
			local c = w.Name:sub(1, i)
			c = string.lower(c)

			-- inserting if name matches b
			local o = c:match(`^{b}`) and obj
			table.insert(m, o)
		end
		Table.remove(m, false)
	end

	-- matching s
	set()
	while #m > 1 and #s > 1 do
		m = {}
		i += 1
		set()
		b = s:sub(1, i)
	end

	local v = m[1]

	return v
end
