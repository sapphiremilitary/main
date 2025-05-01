--!strict

return function(f, ...)
    local args = {...}
    local function c()
        return f(unpack(args))
    end

    return c
end