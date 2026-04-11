export type PlayerTroopCache = {
	CacheAge: number,
	Troops: { TroopTable },
}

export type TroopTable = {
	TroopName: string,
	TroopHealth: number,
	TroopMorale: number,
	TroopDamage: number,
	UnitSize: number,
}

local Types = {}

return Types
