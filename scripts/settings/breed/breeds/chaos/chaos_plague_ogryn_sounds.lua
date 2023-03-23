local sound_data = {
	events = {
		foley_belly = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_belly_bounce",
		ground_impact = "wwise/events/minions/play_enemy_foley_body_impact_large_ground",
		sfx_footstep_land = "wwise/events/minions/play_plague_ogryn_footsteps_land",
		sfx_enemy_vce_run_noise = "wwise/events/minions/play_enemy_plague_ogryn_vce_run_noise",
		foley = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_movement_foley",
		footstep = "wwise/events/minions/play_footstep_boots_heavy_plague_ogryn",
		sfx_footstep_slide = "wwise/events/minions/play_plague_ogryn_footstep_slide"
	},
	use_proximity_culling = {
		footstep = false,
		sfx_footstep_land = false,
		sfx_enemy_vce_run_noise = false
	}
}

return sound_data
