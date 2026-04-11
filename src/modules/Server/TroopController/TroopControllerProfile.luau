local Types = require(script.Parent.Types)

local TroopProfile = {}

function TroopProfile.createPlayerCache(player: Instance): Types.PlayerTroopCache
	if typeof(player) ~= "Instance" then
		warn(
			string.format("[TroopControllerProfile] - Type of player %q is not a valid type.", tostring(typeof(player)))
		)
		return
	end

	local tbl: Types.PlayerTroopCache = {
		CacheAge = os.clock(),
		Troops = {},
	}

	return tbl
end

function TroopProfile.createTroop(troopName: string): Types.TroopTable
	if typeof(troopName) ~= "string" then
		warn(
			string.format(
				"[TroopControllerProfile] - Type of troopName %q is not a valid type.",
				tostring(typeof(troopName))
			)
		)
		return
	end

	local tbl: Types.TroopTable = {
		TroopName = troopName,
		TroopHealth = 100,
		TroopDamage = 5,
		TroopMorale = 100,
		UnitSize = 50,
	}

	return tbl
end

return TroopProfile
