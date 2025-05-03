--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Functions = ReplicatedStorage:WaitForChild("Functions")
local Run = ServerScriptService:WaitForChild("Run")

local Try = require(Functions.Try)

function init(m: ModuleScript)
	local f = require :: (ModuleScript) -> { init: () -> ()? }
	local t = f(m)

	assert(t.init)
	t.init()
end

function try(m: Instance)
	Try(init, m)
end

Run.ChildAdded:Connect(try)
local c = Run:GetChildren()
for _, m in c do
	try(m)
end
