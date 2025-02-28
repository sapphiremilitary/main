--!strict

local Call = require(script.Call)
local Fetch = require(script.Fetch)

local module = {
	{
		call = Call.recursive,
		fetch = { Fetch.Player },
		func = require(script.Functions.ff),
		words = { "ff", "forcefield" },
	},
	{
		call = Call.recursive,
		fetch = { Fetch.Player },
		func = require(script.Functions.unff),
		words = { "unff", "unforcefield" },
	},
	{
		call = Call.recursive,
		fetch = { Fetch.Player },
		func = require(script.Functions.respawn),
		words = { "spawn", "respawn" },
	},
	{
		call = Call.recursive,
		fetch = { Fetch.Player },
		func = require(script.Functions.refresh),
		words = { "re", "refresh" },
	},
	{
		call = Call.recursive,
		fetch = { Fetch.Player, Fetch.Unpack },
		filter = true,
		func = require(script.Functions.kick),
		power = true,
		words = { "kick" },
	},
	{
		call = Call.recursive,
		fetch = { Fetch.Player, Fetch.Team },
		func = require(script.Functions.team),
		words = { "team" },
	},
} :: {
	{
		call: (...any) -> (),
		fetch: { (string, Player) -> any },
		filter: boolean?,
		func: (...any) -> (),
		words: { string },
	}
}

return module
