--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Classes = ReplicatedStorage:WaitForChild("Classes")
local Remote = require(Classes.Remote)

task.wait(3)
local event = Remote.new("chat")

event:FireServer(":team %R b")

task.wait(1)
event:FireServer(":spawn")

task.wait(1)
event:FireServer(":kick t Noob!")