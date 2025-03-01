--!strict
-- provides functionality for client to server requests (RemoteFunctions)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Classes = ReplicatedStorage:WaitForChild("Classes")
local Callback = require(Classes.Callback)
local Message = require(Classes.Message)
local Remote = require(Classes.Remote)

local module = {}

function module:GetResponse(header: string, ...)
    assert(RunService:IsClient())

    local v
    local function set(...)
        v = {...}
    end
    local cb = Callback.new(header, set)

    local event = Remote.new(header)
    event:FireServer(...)
    local t = Message:BindToHeader(cb)
    local c = os.clock()
    repeat
        task.wait()
    until v or os.clock() - c > 5
    t:Disconnect()
    
    v = v or {}
    return unpack(v)
end

return module