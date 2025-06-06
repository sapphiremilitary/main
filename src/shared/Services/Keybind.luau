--!strict

local ContextActionService = game:GetService("ContextActionService")

local b = {}
local r: { Enum.KeyCode | Enum.UserInputType } = {
	Enum.KeyCode.Space,
	Enum.KeyCode.W,
	Enum.KeyCode.A,
	Enum.KeyCode.S,
	Enum.KeyCode.D,
	Enum.KeyCode.I,
	Enum.KeyCode.O,
	Enum.UserInputType.MouseButton1,
	Enum.UserInputType.MouseButton2,
}

local module = {}

module.new = function(
	name: string,
	f: (string, Enum.UserInputState, InputObject) -> any,
	key: Enum.KeyCode | Enum.UserInputType
)
	local kb = {}
	kb.key = key
	kb.name = name

	check(key)

	function kb:Bind()
		local e = find(kb.key)
		while e do
			local kb = b[e]
			kb:Unbind()
			e = find(key)
		end

		table.insert(b, kb)
		bind(name, f, false, kb.key)
	end

	function kb:Swap(k)
		check(k)
		kb:Unbind()

		local e = find(k)
		if e then
			local t = b[e]
			t:Unbind()
			t.key = kb.key
			t:Bind()
		end

		kb.key = k
		kb:Bind()
	end

	function kb:Unbind()
		local i = table.find(b, kb)
		table.remove(b, i)
		ContextActionService:UnbindAction(name)
	end

	return kb
end

function bind(...)
	ContextActionService:BindAction(...)
end

function check(k)
	assert(not table.find(r, k))
end

function find(f)
	-- finds index of keybind whose key matches f
	local k
	for i, kb in b do
		if kb.key == f then
			k = i
			break
		end
	end

	return k
end

function module:GetKeybinds()
	-- creates a list of keybinds
	local a = {}
	for _, kb in b do
		a[kb.name] = kb.key.Name
	end

	return a
end

return module
