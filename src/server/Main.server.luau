--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Functions = ReplicatedStorage:WaitForChild("Functions")
local Pcall = require(Functions.Pcall)

local Autoexec = ServerScriptService:WaitForChild("Autoexec")

function init(m: ModuleScript)
	assert(m and m:IsA("ModuleScript"))
	local tbl = require(m) :: { init: () -> () }
	assert(tbl.init)
	tbl.init()
end

function try(m: Instance)
	Pcall(init, m)
end

local c = Autoexec:GetChildren()
for _, m in c do
	try(m)
end
Autoexec.ChildAdded:Connect(try)
