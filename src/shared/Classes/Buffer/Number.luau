--!strict

local format = {
	i8 = 1,
	u8 = 2,
	i16 = 3,
	u16 = 4,
	i32 = 5,
	u32 = 6,
	f32 = 7,
	f64 = 8,
}

local module = {}

function module:Count(tbl: {})
	local c = 0
	for _, _ in tbl do
		c += 1
	end
	return c
end

function module:GetBytes(x: number)
	local bits = math.log(math.max(1, math.abs(x)), 2)

	local len = math.max(1, math.ceil(bits / 8))
	local t = { 1, 2, 4, 8 }
	while not table.find(t, len) and len < 8 do
		len += 1
	end

	local _, r = math.modf(x)
	if not (r == 0) then
		len = len > 4 and 8 or 4
	end
	assert(len < 8)

	return len
end

function module:GetReadFormat(i: number)
	local k, v = next(format)
	while not (v == i) do
		k, v = next(format, k)
	end

	local f = buffer[`read{k}`]
	return f
end

function module:GetWriteFormat(x: number)
	local len = module:GetBytes(x)
	len *= 8 -- bit conversion

	local _, r = math.modf(x)
	local s = `{not (r == 0) and "f" or x >= 0 and "u" or x < 0 and "i"}{len}`
	local f = buffer[`write{s}`]
	return f, format[s]
end

return module
