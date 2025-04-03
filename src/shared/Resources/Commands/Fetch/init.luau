--!strict

local Close = require(script.Close)
local Insert = require(script.Insert)
local P = require(script.P)
local Player = require(script.Player)
local Random = require(script.Random)
local Team = require(script.Team)

local module = {}

function module.Player(str: string, plr: Player)
    local tbl = {}

    local function set(n: string)
        if n == "close" then
            Insert(Close(plr), tbl)
        elseif n == "me" then
            table.insert(tbl, plr)
        elseif n == "random" then
            table.insert(tbl, Random())
        elseif n:match("^%%%a") then
            Insert(P(n), tbl)
        else
            table.insert(tbl, Player(n))
        end
    end

    if str then
        for n in str:gmatch("[%w%%]+") do
            n = string.lower(n)
            set(n)
        end
    else
        table.insert(tbl, plr)
    end

    return tbl
end

function module.Team(str: string)
    local t = Team(str)

    return t
end

function module.Unpack(str: string)
    return str
end

return module