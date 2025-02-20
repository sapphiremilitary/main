--!strict

local formats = { "u8", "i8", "u16", "i16", "u32", "i32", "f32", "f64" }
local uids: { [string]: number } = {
	string = 1,
	boolean = 2,
	number = 3,
	Vector3 = 4,
	CFrame = 5,
	tblop = 6, -- table initialization
	tblcl = 7, -- table termination
}

local module = {}

module.new = function(...)
	local args = { ... }
	local var = #args > 1 and args or args[1]
	local uid = getUid(var)
	assert(uid)
	local size = sizeof(var)
	assert(size <= 1024) -- 1mb
	local packet = buffer.create(size)
	write(packet, 0, uid, var)
	return packet
end

function module:Read(packet: buffer)
	local value = read(packet, 0)
	return value
end

function read(packet: buffer, offset: number): (any, number)
	local uid = buffer.readu8(packet, offset)
	local n = getn(uids)
	assert(uid <= n)

	local function iread(i: number): {}
		local tbl = {}
		for i = 1, i do
			local v, size = read(packet, offset)
			tbl[#tbl + 1] = v
			offset += size
		end
		return tbl
	end

	local value: any
	local len = 0

	if uid == uids.string then
		n = buffer.readu8(packet, offset + 1)
		value = buffer.readstring(packet, offset + 2, n)
		len += 2 + n
	elseif uid == uids.boolean then
		n = buffer.readu8(packet, offset + 1)
		value = n == 1
		len += 2
	elseif uid == uids.number then
		local fi = buffer.readu8(packet, offset + 1)
		local func = buffer[`read{formats[fi]}`]
		value = func(packet, offset + 2)
		local size = ilen(value)
		len += 2 + size
	elseif uid == uids.Vector3 then
		offset += 1
		local tbl = iread(3)
		value = Vector3.new(tbl[1], tbl[2], tbl[3])
		len += sizeof(value)
	elseif uid == uids.CFrame then
		offset += 1
		local tbl = iread(12)
		value = CFrame.new(
			tbl[1],
			tbl[2],
			tbl[3],
			tbl[4],
			tbl[5],
			tbl[6],
			tbl[7],
			tbl[8],
			tbl[9],
			tbl[10],
			tbl[11],
			tbl[12]
		)
		len += sizeof(value)
	elseif uid == uids.tblop then
		value = {}
		offset += 1
		local kv
		repeat
			local v, size = read(packet, offset)
			offset += size
			if not kv then
				kv = v
			else
				value[kv] = v
				kv = nil
			end
			uid = buffer.readu8(packet, offset)
		until uid == uids.tblcl
		len += sizeof(value)
	end

	return value, len
end

function write(packet: buffer, offset: number, uid: number, value: any)
	local n = getn(uids)
	assert(uid <= n)

	local function twrite(tbl: {})
		for i = 1, #tbl do
			local v = tbl[i]
			local size = sizeof(v)
			uid = getUid(v)
			write(packet, offset + 1, uid, v)
			offset += size
			i += 1
		end
	end

	if uid == uids.string then
		assert(#value <= 255)
		buffer.writeu8(packet, offset, uids.string)
		buffer.writeu8(packet, offset + 1, #value)
		buffer.writestring(packet, offset + 2, value)
	elseif uid == uids.boolean then
		buffer.writeu8(packet, offset, uids.boolean)
		buffer.writeu8(packet, offset + 1, value and 1 or 0)
	elseif uid == uids.number then
		buffer.writeu8(packet, offset, uids.number)
		local fstr = format(value)
		local i = table.find(formats, fstr)
		assert(i)
		buffer.writeu8(packet, offset + 1, i)
		local func = buffer[`write{fstr}`] :: (b: buffer, offset: number, value: number) -> ()
		func(packet, offset + 2, value)
	elseif uid == uids.Vector3 then
		buffer.writeu8(packet, offset, uids.Vector3)
		twrite({ value.X, value.Y, value.Z })
	elseif uid == uids.CFrame then
		buffer.writeu8(packet, offset, uids.CFrame)
		twrite({ value:GetComponents() })
	elseif uid == uids.tblop then
		buffer.writeu8(packet, offset, uids.tblop)
		local pairs = {}
		for k, v in value do
			table.insert(pairs, k)
			table.insert(pairs, v)
		end
		twrite(pairs)
		offset += 1
		buffer.writeu8(packet, offset, uids.tblcl)
	end
end

function getn(tbl: {})
	local n = 0
	for _, _ in tbl do
		n += 1
	end
	return n
end

function sizeof(value: any)
	local function tlen(tbl: {}?)
		local i = 0
		for k, v in tbl or value do
			i += not tbl and sizeof(k) or 0
			i += sizeof(v)
		end
		return i
	end

	local get = {
		string = typeof(value) == "string" and #value,
		boolean = 0,
		number = typeof(value) == "number" and ilen(value),
		Vector3 = typeof(value) == "Vector3" and tlen({ value.X, value.Y, value.Z }) - 1,
		CFrame = typeof(value) == "CFrame" and tlen({ value:GetComponents() }) - 1,
		table = typeof(value) == "table" and tlen(),
	}
	local size = 2 + get[typeof(value)]
	return size
end

function format(num: number)
	local fstr
	local len = ilen(num)
	local _, f = math.modf(num)
	if f > 0 or len >= 4 then
		local n = math.ceil(len / 4) * 4 * 8
		fstr = `f{n}`
	else
		local bits = len <= 2 and len * 8 or math.ceil(len / 32) * 32
		local s = num < 0 and "i" or "u"
		fstr = `{s}{bits}`
	end
	return fstr
end

function getUid(value: any): number
	local uid = uids[typeof(value)] or (typeof(value) == "table" and uids.tblop or 0)
	return uid
end

function ilen(num: number): number
    local len

	local bits = math.log(math.max(1, math.abs(num)), 2)
	local i = 0
	while not table.find({ 1, 2, 4, 8 }, len) do
		len = math.ceil(bits / 8) + i
		i += 1
	end
	local _, f = math.modf(num) -- number is a float, 4 byte minimum
	if not (f == 0) then
		len = math.clamp(len, 4, 8)
	end

	return len
end

return module