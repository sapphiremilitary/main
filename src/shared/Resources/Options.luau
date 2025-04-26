--!strict

local group

function new(v)
	local o = {}
	o.value = v
	o.group = group

	function o:Bind(s: RBXScriptSignal, f)
		s:Connect(f)
	end

	return o
end

local module = {}

group = "Display"
module.Bloom = new(true)
module.DepthOfField = new(false)
module.Materials = new(true)
module.Shadows = new(true)
module.SunRays = new(true)

group = "Keybinds"
module.Chat = new(Enum.KeyCode.Slash)
module.Crouch = new(Enum.KeyCode.C)
module.Menu = new(Enum.KeyCode.M)
module.Ping = new(Enum.UserInputType.MouseButton3)
module.Reload = new(Enum.KeyCode.R)
module.Sprint = new(Enum.KeyCode.F)

return module
