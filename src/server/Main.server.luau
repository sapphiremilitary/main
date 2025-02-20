--!strict

local ServerScriptService = game:GetService("ServerScriptService")

local autoexec = ServerScriptService:FindFirstChild("Autoexec")
if not autoexec then
	autoexec = Instance.new("Folder", ServerScriptService)
	autoexec.Name = "autoexec"
end

function init(module: ModuleScript)
	assert(module:IsA("ModuleScript"))
	local name = module:GetFullName()
	local m = require(module) :: { init: (self: any) -> any }
	assert(m.init)
	local c = os.clock()
	m:init()
	print(`{name} - {os.clock() - c} ms`)
end

function call(module: ModuleScript)
	local _, err = pcall(init :: (ModuleScript) -> string?, module)
	if err then
		warn(err)
	end
end

local modules = autoexec:GetChildren() :: { ModuleScript }
for _, module in modules do
	call(module)
end
autoexec.ChildAdded:Connect(call)
