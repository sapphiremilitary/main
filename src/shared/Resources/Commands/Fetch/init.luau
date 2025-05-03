--!strict

local All = require(script.All)
local Insert = require(script.Insert)
local P = require(script.P)
local Player = require(script.Player)
local Proximity = require(script.Proximity)
local Random = require(script.Random)
local Team = require(script.Team)

local module = {}

function module.Player(s: string, p: Player)
    local t = {}

    local function set(n)
        if n == "all" then
            Insert(All(), t)
        elseif n == "close" then
            Insert(Proximity(p), t)
        elseif n == "far" then
            Insert(Proximity(p, true), t)
        elseif n == "me" then
            table.insert(t, p)
        elseif n == "random" then
            table.insert(t, Random())
        elseif n:match("^%%%a") then
            Insert(P(n), t)
        else
            table.insert(t, Player(n))
        end
    end

    if s then
        for m in s:gmatch("[%w%%]+") do
            m = string.lower(m)
            set(m)
        end
    else
        table.insert(t, p)
    end

    return t
end

function module.Team(s: string)
    local t = Team(s)

    return t
end

function module.Unpack(s: string)
    return s
end

return module