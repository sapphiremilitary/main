--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Classes = ReplicatedStorage:WaitForChild("Classes")
local Message = require(Classes.Message)
local Remote = require(Classes.Remote)

local Resources = ReplicatedStorage:WaitForChild("Resources")
local Commands = require(Resources.Commands)
local Match = require(Resources.Match)

local module = {}

function module:init()
	Remote:BindToHeader("verify", verify)
	Remote:BindToHeader("chat", parse)
end

function verify(plr)
	local message = Message.new("verify", RunService:IsStudio(), true)
	message:SendTo({ plr })
end

function parse(plr, msg: string)
	local function random()
		local plrs = Players:GetPlayers()
		local r = plrs[math.random(1, #plrs)]
		return r
	end

	local function isplit(str: string)
		local s = {}
		for word in str:gmatch("%w+") do
			table.insert(s, word)
		end
		return s
	end

	if msg:match("^:") and #msg > 1 then
		local sub = msg:sub(2, #msg)
		local split = isplit(sub)

		local str = split[1]
		local k, v = next(Commands)
		local cmd
		while not cmd and k do
			cmd = table.find(v.words, str) and v
			k, v = next(Commands, k)
		end

		if cmd then
			local plrs = {}
			if split[2] then
				for id in split[2]:gmatch("%w+") do
					if id == "me" then
						table.insert(plrs, plr)
					elseif id == "random" then
						local r = random()
						table.insert(plrs, r)
					else
						local m = Match(id, Players:GetPlayers())
						table.insert(plrs, m)
					end
				end
			else
				plrs = { plr }
			end

			for _, plr in plrs do
				local t = split[3]
				cmd.func(plr, t)
			end
		end
	end
end

return module
