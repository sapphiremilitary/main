--!strict

return function(p: Player, ...)
    local r = select(1, ...)
    assert(not r or typeof(r) == "string") -- reason is nil or reason is a string
    p:Kick(r)
end