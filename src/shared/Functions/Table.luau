--!strict

local module = {}

module.duplicate = function()
	local t = {}
	for k, v in t do
		local T = typeof(v)
		if T == "table" then
			t[k] = module.duplicate(v)
		else
			t[k] = v
		end
	end

	return t
end

return module
