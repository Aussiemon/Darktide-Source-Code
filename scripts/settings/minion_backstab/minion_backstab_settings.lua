-- chunkname: @scripts/settings/minion_backstab/minion_backstab_settings.lua

local minion_backstab_settings = {
	melee_backstab_dot = 0.52,
	melee_backstab_event = "wwise/events/player/play_backstab_indicator_melee",
	melee_elite_backstab_event = "wwise/events/player/play_backstab_indicator_melee_elite",
	ranged_backstab_dot = 0.3,
	ranged_backstab_event = "wwise/events/player/play_backstab_indicator_ranged",
}

return settings("MinionBackstabSettings", minion_backstab_settings)
