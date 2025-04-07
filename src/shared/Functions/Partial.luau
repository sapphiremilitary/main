--!strict

return function(f: any, ...)
    local args = {...}
    local function c()
        return f(unpack(args))
    end

    return c
end