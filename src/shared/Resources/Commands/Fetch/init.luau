--!strict

local All = require(script.All)
local Close = require(script.Close)
local Insert = require(script.Insert)
local P = require(script.P)
local Player = require(script.Player)
local Random = require(script.Random)
local Team = require(script.Team)

local module = {}

function module.Player(str: string, plr: Player)
    local t = {}

    local function set(n: string)
        if n == "all" then
            table.insert(t, All())
        elseif n == "close" then
            Insert(Close(plr), t)
        elseif n == "me" then
            table.insert(t, plr)
        elseif n == "random" then
            table.insert(t, Random())
        elseif n:match("^%%%a") then
            Insert(P(n), t)
        else
            table.insert(t, Player(n))
        end
    end

    if str then
        for n in str:gmatch("[%w%%]+") do
            n = string.lower(n)
            set(n)
        end
    else
        table.insert(t, plr)
    end

    return t
end

function module.Team(str: string)
    local t = Team(str)

    return t
end

function module.Unpack(str: string)
    return str
end

return module