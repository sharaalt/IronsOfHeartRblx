--[[
	@class ClientMain
]]
local RemoteEvents = game.ReplicatedStorage.Shared.RemoteEvents
local Players = game:GetService("Players")
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
