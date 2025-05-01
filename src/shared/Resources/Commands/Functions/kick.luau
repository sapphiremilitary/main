--!strict

return function(p, ...)
    local r = select(1, ...)
    assert(typeof(r) == "string")
    p:Kick(r)
end