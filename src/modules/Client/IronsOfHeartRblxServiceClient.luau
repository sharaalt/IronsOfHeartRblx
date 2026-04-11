--[=[
	@class IronsOfHeartRblxServiceClient
]=]

local require = require(script.Parent.loader).load(script)

local IronsOfHeartRblxServiceClient = {}
IronsOfHeartRblxServiceClient.ServiceName = "IronsOfHeartRblxServiceClient"

function IronsOfHeartRblxServiceClient:Init(serviceBag: ServiceBag.ServiceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	-- External
	self._serviceBag:GetService(require("CmdrServiceClient"))

	-- Internal
	self._serviceBag:GetService(require("IronsOfHeartRblxTranslator"))
end

return IronsOfHeartRblxServiceClient
