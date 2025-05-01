--!strict

local module = {}

module.clean = function(t: {})
	for k, v in t do
		t[k] = v or nil
	end

	local i = table.find(t, nil)
	while i do
		table.remove(t, i)
		i = table.find(t, nil)
	end
end

module.clone = function()
	local t = {}
	for k, v in t do
		local c = typeof(v) == "table"
		t[k] = c and module.clone(v) or v
	end

	return t
end

return module
