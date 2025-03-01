--!strict

return function(plr1: Player, plr2: Player)
    local c1, c2 = plr1.Character, plr2.Character
    assert(c1 and c2)
    c1:PivotTo(c2:GetPivot())
end