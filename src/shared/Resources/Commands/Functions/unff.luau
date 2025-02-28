--!strict

return function(plr: Player)
    local char = plr.Character
    if char then
        local ff = char:FindFirstChildOfClass("ForceField")
        while ff do
            ff:Destroy()
            ff = char:FindFirstChildOfClass("ForceField")
        end
    end
end