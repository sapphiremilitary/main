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

function module:GetBytes(x: number)
	-- converts x to bytes
	local T = x
	T = math.max(1, math.abs(x))
	T = math.log(math.max(T), 2)
	T = math.ceil(T / 8)

	local function find(t: number)
		local l = { 1, 2, 4, 8 }
		local i = table.find(l, t)

		return i
	end

	-- setting our byte size to the closest usable vablue
	local i = math.max(1, T)
	while not find(i) and i < 8 do
		i += 1
	end

	-- accounting for floating point values
	local _, r = math.modf(x)
	i = (r > 0 or r < 0) and (i > 4 and 8 or 4) or i
	i = x > 2 ^ 32 - 1 and 8 or i
	assert(i <= 8)

	return i
end

function module:GetReadFormat(i: number)
	-- obtaining format from u8
	local k, v = next(format)
	while not (v == i) do
		k, v = next(format, k)
	end

	local f = buffer[`read{k}`] :: (buffer, number) -> any
	return f
end

function module:GetWriteFormat(x: number)
	-- length of x
	local l = module:GetBytes(x)
	l *= 8

	local _, r = math.modf(x)
	local s = `{(not (r == 0) or l > 32) and "f" or x >= 0 and "u" or x < 0 and "i"}{l}`
	local f = buffer[`write{s}`] :: (buffer, number, number) -> ()

	return f, format[s]
end

return module
