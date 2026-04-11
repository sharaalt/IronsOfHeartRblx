--[=[
	@class IronsOfHeartRblxService
]=]

local require = require(script.Parent.loader).load(script)

local ServiceBag = require("ServiceBag")

local IronsOfHeartRblxService = {}
IronsOfHeartRblxService.ServiceName = "IronsOfHeartRblxService"

function IronsOfHeartRblxService:Init(serviceBag: ServiceBag.ServiceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	-- External
	self._serviceBag:GetService(require("CmdrService"))

	-- Internal
	self._serviceBag:GetService(require("IronsOfHeartRblxTranslator"))
	self._serviceBag:GetService(require("TroopController"))
end

return IronsOfHeartRblxService
