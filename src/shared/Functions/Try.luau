--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Functions = ReplicatedStorage:WaitForChild("Functions")

local Table = require(Functions.Table)

function log(t)
	-- splitting traceback into table
	local c = debug.traceback("", 2)
	local s = string.split(c, "\n")
	Table.remove(s, "")
	for i, v in s do
		local m = v:match("^([^%s]*)") :: string
		s[i] = m
	end
	
	-- creating error string
	s[1] = t
	local e = table.concat(s, "\n")
	e = "\n" .. e

	warn(e)
end

return function(f: (...any) -> any, ...): ...any
	-- xpcall propagates the error up the call stack
	local a = { xpcall(f, log, ...) }

	return unpack(a)
end
