--!strict

return function(f: any, ...): ...any
	local a = { pcall(f, ...) }
	local s = a[1]
	if not s then
		local t = debug.traceback()
		warn(t)
	end

	return unpack(a)
end
