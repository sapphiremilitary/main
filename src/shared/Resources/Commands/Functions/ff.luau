--!strict

return function(p)
    local c = p.Character
    if c then
        Instance.new("ForceField", c)
    end
end