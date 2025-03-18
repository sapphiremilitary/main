--!strict

function c(tbl: any)
    local t = {}

    for k, v in t do
        local T = typeof(v)
        t[k] = T == "table" and c(v) or v
    end

    return t
end

return c