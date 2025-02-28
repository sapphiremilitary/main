--!strict

local close = require(script.close)
local insert = require(script.insert)
local p = require(script.p)
local player = require(script.player)
local random = require(script.random)
local team = require(script.team)

local module = {}

function module.Player(str: string, plr: Player)
    local tbl = {}

    local function set(n: string)
        if n == "close" then
            insert(close(plr), tbl)
        elseif n == "me" then
            table.insert(tbl, plr)
        elseif n == "random" then
            table.insert(tbl, random())
        elseif n:match("^%%%a") then
            insert(p(n), tbl)
        else
            table.insert(tbl, player(n))
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
    local t = team(str)

    return t
end

function module.Unpack(str: string)
    return str
end

return module