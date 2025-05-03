--!strict

local module = {}

module.clone = function(t: { any })
	local c = {}
	for k, v in t do
		local T = typeof(v) == "table"
		t[k] = T and module.clone(v) or v
	end

	return c
end

module.remove = function(t: {}, f)
	-- removing all occurances of f from t
	local i = table.find(t, f)
	while i do
		table.remove(t, i)
		i = table.find(t, f)
	end

	return i
end

return module
