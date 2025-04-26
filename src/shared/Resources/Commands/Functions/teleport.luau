--!strict

return function(p1: Player, p2: Player)
    local c1, c2 = p1.Character, p2.Character
    assert(c1 and c2)
    c1:PivotTo(c2:GetPivot())
end