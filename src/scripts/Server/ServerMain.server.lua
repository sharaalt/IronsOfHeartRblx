--[[
	@class ServerMain
]]
local ServerScriptService = game:GetService("ServerScriptService")

local loader = ServerScriptService.IronsOfHeartRblx:FindFirstChild("LoaderUtils", true).Parent
local require = require(loader).bootstrapGame(ServerScriptService.IronsOfHeartRblx)

local serviceBag = require("ServiceBag").new()
serviceBag:GetService(require("IronsOfHeartRblxService"))
serviceBag:Init()
serviceBag:Start()