local sound_data = {
	events = {
		footstep_land = "wwise/events/minions/play_chaos_spawn_leap_land",
		footstep_hand = "wwise/events/minions/play_chaos_spawn_hand_step",
		footstep_scuff = "wwise/events/minions/play_chaos_spawn_scuff_step",
		vce_3_attack_combo = "wwise/events/minions/play_chaos_spawn_vce_3_attack_combo",
		vce_4_attack_combo = "wwise/events/minions/play_chaos_spawn_vce_4_attack_combo",
		vce_eat = "wwise/events/minions/play_chaos_spawn_vce_eat",
		footstep_tentacle = "wwise/events/minions/play_chaos_spawn_tentacle_step",
		vce_attack_long = "wwise/events/minions/play_chaos_spawn_vce_attack_long",
		vce_leap = "wwise/events/minions/play_chaos_spawn_vce_leap",
		footstep_small = "wwise/events/minions/play_chaos_spawn_small_step",
		vce_stop = "wwise/events/minions/stop_chaos_spawn_vce",
		footstep = "wwise/events/minions/play_chaos_spawn_big_step",
		vce_attack_short = "wwise/events/minions/play_chaos_spawn_vce_attack_short"
	},
	use_proximity_culling = {
		footstep_land = false,
		footstep_hand = false,
		vce_4_attack_combo = false,
		vce_eat = false,
		vce_3_attack_combo = false,
		vce_leap = false,
		footstep_tentacle = false,
		vce_attack_long = false,
		footstep_small = false,
		footstep = false,
		vce_attack_short = false
	}
}

return sound_data
