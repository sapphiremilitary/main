--!strict

return function(plr: Player, ...)
    local r = select(1, ...)
    assert(not r or typeof(r) == "string") -- reason is nil or reason is a string
    plr:Kick(r)
end