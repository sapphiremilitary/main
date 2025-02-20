--!strict

return function(plr: Player)
    local char = plr.Character
    if char then
        Instance.new("ForceField", char)
    end
end