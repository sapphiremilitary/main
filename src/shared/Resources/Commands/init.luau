--!strict

local module = {
	{
		func = require(script.FF),
		words = { "ff", "forcefield" },
	},
	{
		func = require(script.Unff),
		words = { "unff", "unforcefield" },
	},
	{
		func = require(script.Respawn),
		words = { "spawn", "respawn" },
	},
	{
		func = require(script.Refresh),
		words = { "re", "refresh" },
	},
	{
		func = require(script.Kick),
		words = { "kick" },
	},
} :: {
	{
		func: (Player, ...any) -> (),
		words: { string },
	}
}

return module
