--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local autoexec = ServerScriptService:WaitForChild("Autoexec")

local Services = ReplicatedStorage:WaitForChild("Services")
local Pcall = require(Services.Pcall)

function init(m: ModuleScript)
	assert(m and m:IsA("ModuleScript"))
	local tbl = require(m) :: { init: () -> () }
	assert(tbl.init)
	tbl.init()
end

function try(m: Instance)
	Pcall:Try(init, m)
end

local c = autoexec:GetChildren()
for _, m in c do
	try(m)
end
autoexec.ChildAdded:Connect(try)
