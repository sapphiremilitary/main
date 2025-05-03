--!strict

local Call = require(script.Call)
local Fetch = require(script.Fetch)
local Functions = require(script.Functions)

local module = {
	{
		call = Call.recursive,
		fetch = { Fetch.Player },
		func = Functions.ff,
		words = { "ff", "forcefield" },
	},
	{
		call = Call.recursive,
		fetch = { Fetch.Player },
		func = Functions.unff,
		words = { "unff", "unforcefield" },
	},
	{
		call = Call.recursive,
		fetch = { Fetch.Player },
		func = Functions.respawn,
		words = { "spawn", "respawn" },
	},
	{
		call = Call.recursive,
		fetch = { Fetch.Player },
		func = Functions.refresh,
		words = { "re", "refresh" },
	},
	{
		call = Call.recursive,
		fetch = { Fetch.Player, Fetch.Unpack },
		filter = true,
		func = Functions.kick,
		words = { "kick" },
	},
	{
		call = Call.recursive,
		fetch = { Fetch.Player, Fetch.Team },
		func = Functions.team,
		words = { "team" },
	},
	{
		call = Call.recursive,
		fetch = { Fetch.Player, Fetch.Player },
		func = Functions.teleport,
		words = { "tp", "teleport" },
	},
} :: {
	{
		call: (...any) -> (),
		fetch: { (string, ...any) -> any },
		filter: boolean?,
		func: (Player, ...any) -> (),
		words: { string },
	}
}

return module
