local minion_backstab_settings = {
	ranged_backstab_event = "wwise/events/player/play_backstab_indicator_ranged",
	melee_elite_backstab_event = "wwise/events/player/play_backstab_indicator_melee_elite",
	ranged_backstab_dot = 0.3,
	melee_backstab_event = "wwise/events/player/play_backstab_indicator_melee",
	melee_backstab_dot = 0.52
}

return settings("MinionBackstabSettings", minion_backstab_settings)
