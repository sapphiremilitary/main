--!strict

return function(f: (...any) -> any, ...)
    local args = {...}
    local function c()
        return f(unpack(args))
    end

    return c
end