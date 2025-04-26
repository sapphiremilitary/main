--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Functions = ReplicatedStorage:WaitForChild("Functions")
local Run = ServerScriptService:WaitForChild("Run")

local Try = require(Functions.Try)

function init(m: ModuleScript)
	assert(m and m:IsA("ModuleScript"))
	local tbl = require(m) :: { init: () -> () }
	assert(tbl.init)
	tbl.init()
end

function try(m: Instance)
	Try(init, m)
end

Run.ChildAdded:Connect(try)
local c = Run:GetChildren()
for _, m in c do
	try(m)
end
