--!strict

return function(str: string, tbl: { Instance })
    str = string.lower(str)
    local sub = str:sub(1, 1)
    local i = 1

    local m = {}
    local function imatch()
        for _, obj in tbl do
            local ns = obj.Name:sub(1, i)
            ns = string.lower(ns)
            local p = `^{sub}`
            table.insert(m, ns:match(p) and obj or nil)
        end
    end

    imatch()
    while #m > 1 and #str > 1 do
        tbl = {}
        i += 1
        imatch()
    end
    return m[1]
end