--!strict

local module = {}

function module:Try(f: any, ...)
    local s, v = pcall(f, ...)
    if not s then
        warn(v)
    end

    return s, v
end

return module