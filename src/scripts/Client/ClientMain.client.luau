--[[
	@class ClientMain
]]
local RemoteEvents = game.ReplicatedStorage.Shared.RemoteEvents
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Plr = Players.LocalPlayer

local loader = game:GetService("ReplicatedStorage"):WaitForChild("IronsOfHeartRblx"):WaitForChild("loader")
local require = require(loader).bootstrapGame(loader.Parent)

local serviceBag = require("ServiceBag").new()
serviceBag:GetService(require("IronsOfHeartRblxServiceClient"))
serviceBag:Init()
serviceBag:Start()

RemoteEvents.OnMouseInputRequest.OnClientInvoke = function()
	local Mouse = Plr:GetMouse()

	return Mouse.Hit
end

-- Move to the client bridge probably..?
local isListening = false

RemoteEvents.OnTroopSelected.OnClientEvent:Connect(function(troop)
	isListening = true

	Connection = UserInputService.InputBegan:Connect(function(inputObject: InputObject, GPE: boolean)
		if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
			local PlrMouse = Plr:GetMouse()
			local Mouse = PlrMouse.Hit.Position
			RemoteEvents.OnMoveTroopRequest:FireServer(Mouse, troop)

			Connection:Disconnect()
			Connection = nil
			isListening = false
		end
	end)
end)
