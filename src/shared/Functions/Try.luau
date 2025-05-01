--!strict

return function(f: any, ...): ...any
	local a = { pcall(f, ...) }
	if not a[1] then
		local t = debug.traceback()
		warn(t)
	end

	return unpack(a)
end
