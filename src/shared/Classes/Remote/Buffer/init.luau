--!strict
--[[
	Used to serialize most data (see: uids) types we'll be sending over the network. A hard 1024 byte limit (1kb)
	is set on buffers.
]]

local Number = require(script.Number)

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
	assert(uid) -- checking if var can be serialized

	local size = sizeof(var)
	assert(size <= 1024) -- 1kb
	local packet = buffer.create(size)
	write(packet, 0, uid, var)

	return packet
end

function module:Read(packet: buffer)
	local v = read(packet, 0)
	return v
end

function read(packet: buffer, o: number): (any, number)
	local uid = buffer.readu8(packet, o) -- getting uid of byte
	local n = Number:Count(uids)
	assert(uid <= n) -- checking if proceeding data can be read

	local function iread(i: number): {}
		local tbl = {}
		for i = 1, i do
			local v, len = read(packet, o)
			table.insert(tbl, v)
			o += len
		end
		return tbl
	end

	local v: any
	local len = 0

	if uid == uids.string then
		o += 1
		local strlen = buffer.readu8(packet, o) -- length of string
		o += 1
		v = buffer.readstring(packet, o, strlen)
		len += 2 + strlen -- uid + strlen + #str
	elseif uid == uids.boolean then
		o += 1
		v = buffer.readu8(packet, o)
		v = v == 1
		len += 2 -- uid + value
	elseif uid == uids.number then
		o += 1
		local i = buffer.readu8(packet, o)
		local f = Number:GetReadFormat(i)
		o += 1
		v = f(packet, o)
		local s = Number:GetBytes(v)
		len += 2 + s
	elseif uid == uids.Vector3 then
		o += 1
		local tbl = iread(3)
		v = Vector3.new(tbl[1], tbl[2], tbl[3])
		len += sizeof(v)
	elseif uid == uids.CFrame then
		o += 1
		local tbl = iread(12)
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
		len += sizeof(v)
	elseif uid == uids.tblop then -- table write
		v = {}
		o += 1
		local kv
		repeat
			local rv, s = read(packet, o)
			o += s
			if not kv then
				kv = rv
			else
				v[kv] = rv
				kv = nil
			end
			uid = buffer.readu8(packet, o)
		until uid == uids.tblcl
		len += sizeof(v)
	end

	return v, len
end

function write(packet: buffer, o: number, uid: number, v: any)
	local n = Number:Count(uids)
	assert(uid <= n)

	local function iwrite(tbl: {})
		for i = 1, #tbl do
			local tv = tbl[i]
			local s = sizeof(tv)
			uid = getUid(tv)
			write(packet, o + 1, uid, tv)
			o += s
			i += 1
		end
	end

	if uid == uids.string then
		buffer.writeu8(packet, o, uids.string)
		o += 1
		buffer.writeu8(packet, o, #v)
		o += 1
		buffer.writestring(packet, o, v)
	elseif uid == uids.boolean then
		buffer.writeu8(packet, o, uids.boolean)
		o += 1
		buffer.writeu8(packet, o, v and 1 or 0)
	elseif uid == uids.number then
		buffer.writeu8(packet, o, uids.number)
		local f, i = Number:GetWriteFormat(v)
		o += 1
		buffer.writeu8(packet, o, i)
		o += 1
		f(packet, o, v)
	elseif uid == uids.Vector3 then
		buffer.writeu8(packet, o, uids.Vector3)
		iwrite({ v.X, v.Y, v.Z })
	elseif uid == uids.CFrame then
		buffer.writeu8(packet, o, uids.CFrame)
		iwrite({ v:GetComponents() })
	elseif uid == uids.tblop then
		buffer.writeu8(packet, o, uids.tblop)
		local p = {}
		for k, tv in v do
			table.insert(p, k)
			table.insert(p, tv)
		end
		iwrite(p)
		o += 1
		buffer.writeu8(packet, o, uids.tblcl)
	end
end

function sizeof(v: any)
	local uid = getUid(v)
	local n = Number:Count(uids)
	assert(uid <= n)

	local function ilen(tbl: {})
		local i = 0
		for k, tv in tbl do
			i += sizeof(k)
			i += sizeof(tv)
		end
		return i
	end

	local len

	if uid == uids.string then
		len = 2 + #v
	elseif uid == uids.boolean then
		len = 2
	elseif uid == uids.number then
		local s = Number:GetBytes(v)
		len = 2 + s
	elseif uid == uids.Vector3 then
		len = 2 + ilen({ v.X, v.Y, v.Z }) - 1 -- -1 since ilen assumes we're counting a table (which has an extra byte for a terminator)
	elseif uid == uids.CFrame then
		len = 2 + ilen({ v:GetComponents() }) - 1
	elseif uid == uids.tblop then
		len = 2 + ilen(v)
	end

	return len
end

function getUid(v)
	local t = typeof(v)
	local uid = uids[t] or t == "table" and uids.tblop or 0
	return uid
end

return module
