--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Services = ReplicatedStorage:WaitForChild("Services")
local Work = require(Services.Work)

local module = {}

module.init = function()
    Work.init()
end

return module