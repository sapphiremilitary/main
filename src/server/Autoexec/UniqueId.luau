--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Services = ReplicatedStorage:WaitForChild("Services")
local UniqueId = require(Services.UniqueId)

local module = {}

function module:init()
    local function reg(o: Instance)
        UniqueId:SetUID(o)
    end

    for _, o in workspace:GetChildren() do
        task.defer(reg, o)
    end
    workspace.ChildAdded:Connect(reg)
end

return module