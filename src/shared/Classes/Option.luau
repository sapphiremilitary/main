--!strict

local group

local module = {}

module.new = function(v)
	local o = {}
	o.value = v
	o.group = group

	function o:Bind(s: RBXScriptSignal, f: ({ value: any }) -> ())
		s:Connect(f)
	end

	return o
end

function module:SetGroup(to)
	group = to
end

return module
