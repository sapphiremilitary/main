--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Classes = ReplicatedStorage:WaitForChild("Classes")
local Remote = require(Classes.Remote)

wait(3)
local event = Remote.new("chat")
event:FireServer(":ff")