--!strict

local module = {}

module.clone = function()
	local t = {}
	for k, v in t do
		local T = typeof(v)
		t[k] = T == "table" and module.clone(v) or v
	end

	return t
end

return module
