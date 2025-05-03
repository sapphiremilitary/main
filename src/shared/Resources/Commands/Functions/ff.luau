--!strict

return function(p: Player)
    local c = p.Character
    if c then
        Instance.new("ForceField", c)
    end
end