-- chunkname: @scripts/managers/mission_buffs/mission_buffs_settings.lua

local mission_buffs_settings = {}

mission_buffs_settings.filtering_categories = table.enum("regular", "jackpot", "ability", "grenade")
mission_buffs_settings.filtering_categories_pick_rate_per_wave = {
	wave_3 = {
		ability = 5,
		grenade = 3,
		jackpot = 1,
		regular = 1,
	},
	wave_6 = {
		ability = 3,
		grenade = 3,
		jackpot = 3,
		regular = 3,
	},
	wave_9 = {
		ability = 5,
		grenade = 5,
		jackpot = 2,
		regular = 0,
	},
}

return mission_buffs_settings
