-- External Services
local TroopControllerProfile = require(script.Parent.TroopControllerProfile)
local Types = require(script.Parent.Types)

-- Internal Services
local require = require(script.Parent.Parent.loader).load(script)

local Maid = require("Maid")

local TroopController = {}
TroopController.ServiceName = "TroopController"

function TroopController:Init(serviceBag)
	assert(not self._serviceBag, "[TroopController] - Service already initalized.")

	-- Variables
	self._serviceBag = serviceBag
	self._troopCache = {}

	-- Services
	self._maid = Maid.new()
end

function TroopController:Start()
	local players = game:GetService("Players")

	players.PlayerAdded:Connect(function(a0: Player)
		self:CreateTroop("TroopName", a0)
	end)
end

-- ================================
-- ========= Private API ==========
-- ================================

-- ================================
-- ========== Public API ==========
-- ================================

--[[
	@param troopName string -- The name of the troop you want to create.
	@param player Instance -- The player object you want to cache the troop to.
]]
function TroopController:CreateTroop(troopName: string, player: Instance)
	if typeof(player) ~= "Instance" then
		warn(string.format("[TroopController] - Type of player %q is not a valid type.", tostring(typeof(player))))
		return
	end

	if typeof(troopName) ~= "string" then
		warn(
			string.format("[TroopController] - Type of troopName %q is not a valid type.", tostring(typeof(troopName)))
		)
		return
	end

	local playerTroops: Types.PlayerTroopCache = self._troopCache[player.UserId]

	if not playerTroops then
		warn(
			string.format(
				"[TroopControllerService] - No playerCache found for UserId %q creating a new playerCache...",
				player.UserId
			)
		)
		self._troopCache[player.UserId] = TroopControllerProfile.createPlayerCache(player)
	end

	local newTroop = TroopControllerProfile.createTroop(troopName)

	table.insert(self._troopCache[player.UserId].Troops, newTroop)
	print(self._troopCache)
end

function TroopController:Destory() end

return TroopController
