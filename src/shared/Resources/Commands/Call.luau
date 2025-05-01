--!strict

local module = {}

module.recursive = function(t, f)
	local at = t[1]

	local T = { unpack(t) }
	table.remove(T, 1)
	for _, v in at do
		f(v, unpack(T))
	end
end

module.unpack = function(t, f)
	f(unpack(t))
end

return module
