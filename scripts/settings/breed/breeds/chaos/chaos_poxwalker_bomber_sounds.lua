local sound_data = {
	events = {
		footstep_land = "wwise/events/minions/play_minion_footsteps_boots_heavy_land",
		ground_impact = "wwise/events/minions/play_enemy_foley_body_impact_medium_ground_gore",
		run_breath = "wwise/events/minions/play_minion_poxwalker_bomber_run_breath",
		body_impact = "wwise/events/minions/play_minion_poxwalker_bomber_body_impact",
		foley = "wwise/events/minions/play_enemy_poxwalker_bomber_chains_metal_foley",
		footstep = "wwise/events/minions/play_minion_poxwalker_bomber_footstep_boots_heavy",
		vce_hurt = "wwise/events/minions/play_minion_poxwalker_bomber_run_breath"
	},
	use_proximity_culling = {
		footstep_land = false,
		run_breath = false,
		body_impact = false,
		foley = false,
		footstep = false
	}
}

return sound_data
