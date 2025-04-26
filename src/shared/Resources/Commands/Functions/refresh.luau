--!strict

return function(p: Player)
    local c = p.Character
    if c then
        local pivot = c:GetPivot()
        p:LoadCharacter()

        assert(p.Character)
        p.Character:PivotTo(pivot)
    else
        p:LoadCharacter()
    end
end