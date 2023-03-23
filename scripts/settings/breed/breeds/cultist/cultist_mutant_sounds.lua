local sound_data = {
	events = {
		footstep_land = "wwise/events/minions/play_minion_footsteps_chaos_ogryn_land",
		ground_impact = "wwise/events/minions/play_enemy_foley_body_impact_large_ground",
		climb_impact = "wwise/events/minions/play_enemy_foley_body_impact_medium_ground",
		run_breath = "wwise/events/minions/play_enemy_mutant_charger_run_breath",
		footstep = "wwise/events/minions/play_mutant_charger_footstep_boots_heavy",
		run_foley = "wwise/events/minions/play_enemy_mutant_charger_run_rattle"
	},
	use_proximity_culling = {
		footstep_land = false,
		footstep = false,
		run_foley = false,
		run_breath = false
	}
}

return sound_data
