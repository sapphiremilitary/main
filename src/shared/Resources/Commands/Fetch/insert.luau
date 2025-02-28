--!strict

return function(from: {}, into: {})
    for _, v in from do
        table.insert(into, v)
    end
end