--!strict

return function(s, t)
    s = string.lower(s)
    local sub = s:sub(1, 1)
    local i = 1

    local m = {}
    local function imatch()
        for _, obj in t do
            local ns = obj.Name:sub(1, i)
            ns = string.lower(ns)
            local p = `^{sub}`
            table.insert(m, ns:match(p) and obj or nil)
        end
    end

    imatch()
    while #m > 1 and #s > 1 do
        t = {}
        i += 1
        imatch()
    end
    
    return m[1]
end