--!strict

return function(f: any, ...): ...any
	local a = { pcall(f, ...) }
	local s = a[1]
	if not s then
		local e = debug.traceback()
		warn(e)
	end

	return unpack(a)
end
