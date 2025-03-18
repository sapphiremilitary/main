--!strict

local module = {}

function module:Try(f: any, ...): (...any)
	local a = { pcall(f, ...) } -- varargs
    local s = a[1]
	if not s then
        local err = a[2]
		warn(err)
	end

	return unpack(a)
end

return module
