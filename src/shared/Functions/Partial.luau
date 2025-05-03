--!strict

return function(f: (...any) -> any, ...)
    local a = {...}
    local function c()
        return f(unpack(a))
    end

    return c
end