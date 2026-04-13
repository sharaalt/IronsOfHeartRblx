-- External Services
local RemoteEvents = game.ReplicatedStorage.Shared.RemoteEvents
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

	RemoteEvents.OnMoveTroopRequest.OnServerEvent:Connect(
		function(player: Player, mousePosition: Vector3, troopInstance: BasePart)
			print(mousePosition)
			local translatedPosition = Vector3.new(mousePosition.x, 0, mousePosition.z)
			local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0)
			local tweenService = game:GetService("TweenService")

			local tween = tweenService:Create(troopInstance, tweenInfo, { Position = translatedPosition })

			tween:Play()

			troopInstance:SetAttribute("isSelected", false)
		end
	)
end
-- ================================
-- ========= Private API ==========
-- ================================
function TroopController:_handleClick(player: Player, troopInstance: Instance)
	if typeof(player) ~= "Instance" then
		warn(string.format("[TroopController] - Type of player %q is not a valid type.", tostring(typeof(player))))
		return
	end

	local Mouse: Instance = RemoteEvents.OnMouseInputRequest:InvokeClient(player)

	local isSelected = troopInstance:GetAttribute("isSelected")

	if isSelected then
		warn(string.format("[TroopControllerService] - Troop with name %q is already selected.", troopInstance.Name))
		return
	end

	RemoteEvents.OnTroopSelected:FireClient(player, troopInstance)
end

-- ================================
-- ========== Public API ==========
-- ================================
--[[
	@param troopName string -- The name of the troop you want to create.
	@param player Instance -- The player object you want to cache the troop to.
	@return ()
]]
function TroopController:CreateTroop(troopName: string, player: Player): ()
	if typeof(player) ~= "Instance" then -- Makes sure the args are valid types.
		warn(string.format("[TroopController] - Type of player %q is not a valid type.", tostring(typeof(player))))
		return
	end

	if typeof(troopName) ~= "string" then
		warn(
			string.format("[TroopController] - Type of troopName %q is not a valid type.", tostring(typeof(troopName)))
		)
		return
	end

	local playerTroops: Types.PlayerTroopCache = self._troopCache[player.UserId] -- Checks for the player cache

	if not playerTroops then -- If one doesn't exist create a new player cache.
		warn(
			string.format(
				"[TroopControllerService] - No playerCache found for UserId %q creating a new playerCache...",
				player.UserId
			)
		)
		self._troopCache[player.UserId] = TroopControllerProfile.createPlayerCache(player)
	end

	local newTroop = TroopControllerProfile.createTroop(troopName) -- Creates a new troop

	self._maid:GiveTask(newTroop.TroopObject.TroopClick.MouseClick:Connect(function() -- Hook up to the click function
		self:_handleClick(player, newTroop.TroopObject)
	end))

	table.insert(self._troopCache[player.UserId].Troops, newTroop) -- Push the newTroop to the playerCache

	print(
		string.format(
			"[TroopControllerService] - Sucessfully created a new troop and cached to player with UserId %q",
			tostring(player.UserId)
		)
	)
	return
end

function TroopController:Destroy()
	self._maid:DoCleaning()
	print("[TroopControllerService] - Sucessfully destroyed.")
end

return TroopController
