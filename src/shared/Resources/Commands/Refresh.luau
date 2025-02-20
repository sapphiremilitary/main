--!strict

return function(plr: Player)
    local char = plr.Character
    if char then
        local pivot = char:GetPivot()
        plr:LoadCharacter()
        assert(plr.Character)
        plr.Character:PivotTo(pivot)
    else
        plr:LoadCharacter()
    end
end