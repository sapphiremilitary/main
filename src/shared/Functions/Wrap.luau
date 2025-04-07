--!strict

return function(f: (...any) -> any, ...)
    local args = {...}
    local function call()
        return f(unpack(args))
    end

    return call
end