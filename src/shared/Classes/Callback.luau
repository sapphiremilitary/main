--!strict

local module = {}

module.new = function(header: string, f: (...any) -> ())
	return function(s: string, ...)
		local _ = s == header and f(...)
	end
end

return module
