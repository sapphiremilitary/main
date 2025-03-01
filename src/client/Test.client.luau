--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Classes = ReplicatedStorage:WaitForChild("Classes")
local Remote = require(Classes.Remote)

task.wait(3)
local event = Remote.new("chat")

event:FireServer(":ff")
task.wait(3)
event:FireServer(":unff %r")