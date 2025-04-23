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

function module:Get(plr: Player)
	local p = power.guest

	-- power from sapphire military
	local r = plr:GetRankInGroup(id)
	local k, v = next(rp)
	while k do
		p = r >= k and math.max(v, p) or p
		k, v = next(rp, k)
	end

	-- private server
	local o = game.PrivateServerOwnerId == plr.UserId
	p = o and power.owner or p

	return p, p > 0
end

return module
