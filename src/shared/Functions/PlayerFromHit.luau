--!strict

local Players = game:GetService("Players")

return function(...: BasePart)
    local a = {...}

    local l = {}
    for _, i in a do
        local c = i:FindFirstAncestorWhichIsA("Model")
        local p = c and Players:GetPlayerFromCharacter(c)

        if p and not table.find(l, p) then
            table.insert(l, p)
        end
    end

    return unpack(l)
end