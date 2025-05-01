--!strict

return function(p)
    local c = p.Character
    if c then
        local ff = c:FindFirstChild("ForceField")
        while ff do
            ff:Destroy()
            ff = c:FindFirstChild("ForceField")
        end
    end
end