--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Services = ReplicatedStorage:WaitForChild("Services")
local Priority = require(Services.Priority)

local module = {}

module.init = function()
    Priority.init()
end

return module