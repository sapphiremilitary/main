--!strict

local module = {}

-- first argument in tbl is a list
module.recursive = function(tbl: {}, f: (...any) -> ())
    local at = tbl[1]
    assert(at and typeof(at) == "table")

    local T = {unpack(tbl)}
    table.remove(T, 1)
    for _, v in at do
        f(v, unpack(T))
    end
end

-- tbl is shallow
module.unpack = function(tbl: {}, f: (...any) -> ())
    f(unpack(tbl))
end

return module