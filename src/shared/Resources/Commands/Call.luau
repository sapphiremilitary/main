--!strict

local module = {}

module.recursive = function(t: {}, f: (...any) -> ())
	-- list of players
	local l = t[1]

	-- additional arguments
	local T = { unpack(t) }
	table.remove(T, 1)

	for _, v in l do
		f(v, unpack(T))
	end
end

module.unpack = function(t: {}, f: () -> ())
	f(unpack(t))
end

return module
