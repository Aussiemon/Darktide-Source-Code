local minion_backstab_settings = {
	melee_backstab_dot = 0.5,
	ranged_backstab_event = "wwise/events/player/play_backstab_indicator_ranged",
	ranged_backstab_dot = 0.3,
	melee_backstab_event = "wwise/events/player/play_backstab_indicator_melee"
}

return settings("MinionBackstabSettings", minion_backstab_settings)
