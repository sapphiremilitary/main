--!strict

local power = {
	guest = 0,
	mod = 1,
	admin = 2,
	owner = 3,
}

local id = 2878500
local rp = {
	[40] = power.mod,
	[95] = power.admin,
	[254] = power.owner,
}

local module = {}

function module:Get(p: Player)
	local c = power.guest

	-- setting group power
	local r = p:GetRankInGroup(id)
	local k, v = next(rp)
	while k do
		c = r >= k and math.max(v, c) or c
		k, v = next(rp, k)
	end

	-- private server power
	local o = game.PrivateServerOwnerId == p.UserId
	c = o and power.owner or c

	return c, c > 0
end

return module
