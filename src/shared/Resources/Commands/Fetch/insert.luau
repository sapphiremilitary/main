--!strict

return function(f: {}, i: {})
    for _, v in f do
        table.insert(i, v)
    end
end