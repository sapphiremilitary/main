--!strict

local module = {}

module.new = function(header: string, f: any)
	assert(typeof(f) == "function")

	local c = {}
	c.func = f

	function c:Disable()
		c.func = nil
	end

	function c:Enable()
		c.func = f
	end

	setmetatable(c, {
		__call = function(tbl, h: string, ...)
			if h == header and c.func then
				c.func(...)
			end
		end,
	})

	return c
end

return module
