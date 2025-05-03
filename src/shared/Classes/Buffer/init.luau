--!strict

local Number = require(script.Number)

local uids: { [string]: number } = {
	string = 1,
	boolean = 2,
	number = 3,
	Vector3 = 4,
	CFrame = 5,
	tblop = 6,
	tblcl = 7,
}

local module = {}

module.new = function(...)
	-- checking if var can be serialized
	local a = { ... }
	local v = #a > 1 and a or { a[1] }
	local u = getUid(v)
	assert(u > 0)

	-- creating packet
	local s = sizeof(v)
	assert(s <= 1024) -- 1kb
	local p = buffer.create(s)
	write(p, 0, u, v)

	return p
end

function module:Read(packet: buffer)
	local v = read(packet, 0)

	-- returning data from packet
	local d = {}
	d.header = v[1] :: string
	table.remove(v, 1)
	d.value = { unpack(v) }

	return d
end

function read(p: buffer, o: number): (any, number)
	-- retrieving uid
	local u = buffer.readu8(p, o)
	assert(u > 0)

	local function dive(i: number): {}
		local t = {}
		for i = 1, i do
			local v, l = read(p, o)
			table.insert(t, v)
			o += l
		end

		return t
	end

	local v: any
	local r = 0

	if u == uids.string then
		-- first byte at offset is string length
		o += 1
		local l = buffer.readu8(p, o)
		o += 1
		v = buffer.readstring(p, o, l)
		r += 2 + l
	elseif u == uids.boolean then
		-- converting number to boolean
		o += 1
		v = buffer.readu8(p, o)
		v = v == 1
		r += 2
	elseif u == uids.number then
		o += 1
		local i = buffer.readu8(p, o)
		local f = Number:GetReadFormat(i)
		o += 1
		v = f(p, o)
		local s = Number:GetBytes(v)
		r += 2 + s
	elseif u == uids.Vector3 then
		-- reads the next 3 values
		o += 1
		local tbl = dive(3)
		v = Vector3.new(tbl[1], tbl[2], tbl[3])
		r += sizeof(v)
	elseif u == uids.CFrame then
		o += 1
		local tbl = dive(12)
		v = CFrame.new(
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
		r += sizeof(v)
	elseif u == uids.tblop then
		v = {}
		o += 1

		-- writes to v until a terminator is found
		local T
		repeat
			local t, s = read(p, o)
			o += s
			if not T then
				T = t
			else
				v[T] = t
				T = nil
			end
			u = buffer.readu8(p, o)
		until u == uids.tblcl
		r += sizeof(v)
	end

	return v, r
end

function write(p: buffer, o: number, u: number, v: any)
	assert(u > 0)

	local function loop(t: {})
		-- writes each variable to p
		for i = 1, #t do
			local T = t[i]
			local s = sizeof(T)
			u = getUid(T)
			write(p, o + 1, u, T)
			o += s
			i += 1
		end
	end

	if u == uids.string then
		-- uid, len, string
		buffer.writeu8(p, o, uids.string)
		o += 1
		buffer.writeu8(p, o, #v)
		o += 1
		buffer.writestring(p, o, v)
	elseif u == uids.boolean then
		buffer.writeu8(p, o, uids.boolean)
		o += 1
		buffer.writeu8(p, o, v and 1 or 0)
	elseif u == uids.number then
		-- uid, format, number
		buffer.writeu8(p, o, uids.number)
		local f, i = Number:GetWriteFormat(v)
		o += 1
		buffer.writeu8(p, o, i)
		o += 1
		f(p, o, v)
	elseif u == uids.Vector3 then
		buffer.writeu8(p, o, uids.Vector3)
		loop({ v.X, v.Y, v.Z })
	elseif u == uids.CFrame then
		buffer.writeu8(p, o, uids.CFrame)
		loop({ v:GetComponents() })
	elseif u == uids.tblop then
		buffer.writeu8(p, o, uids.tblop)
		local t = {}
		for k, T in v do
			table.insert(t, k)
			table.insert(t, T)
		end
		loop(t)
		o += 1
		buffer.writeu8(p, o, uids.tblcl)
	end
end

function sizeof(v: any)
	local u = getUid(v)
	assert(u > 0)

	local function len(t: {})
		local i = 0
		for k, T in t do
			i += sizeof(k)
			i += sizeof(T)
		end

		return i
	end

	local l

	if u == uids.string then
		l = 2 + #v
	elseif u == uids.boolean then
		l = 2
	elseif u == uids.number then
		local s = Number:GetBytes(v)
		l = 2 + s
	elseif u == uids.Vector3 then
		-- subtracting 1 byte since len assumes we're counting a table
		l = 2 + len({ v.X, v.Y, v.Z }) - 1
	elseif u == uids.CFrame then
		l = 2 + len({ v:GetComponents() }) - 1
	elseif u == uids.tblop then
		l = 2 + len(v)
	end

	return l
end

function getUid(v)
	local t = typeof(v)
	local u = uids[t] or t == "table" and uids.tblop or 0

	return u
end

return module
