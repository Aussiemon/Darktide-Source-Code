local sound_data = {
	events = {
		footstep_land = "wwise/events/minions/play_chaos_spawn_leap_land",
		footstep_hand = "wwise/events/minions/play_chaos_spawn_hand_step",
		footstep_scuff = "wwise/events/minions/play_chaos_spawn_scuff_step",
		vce_3_attack_combo = "wwise/events/minions/play_chaos_spawn_vce_3_attack_combo",
		vce_4_attack_combo = "wwise/events/minions/play_chaos_spawn_vce_4_attack_combo",
		vce_move_sweep = "wwise/events/minions/play_chaos_spawn_vce_move_sweep",
		footstep_tentacle = "wwise/events/minions/play_chaos_spawn_tentacle_step",
		vce_claw_slam = "wwise/events/minions/play_chaos_spawn_vce_claw_slam",
		vce_leap = "wwise/events/minions/play_chaos_spawn_vce_leap",
		footstep_small = "wwise/events/minions/play_chaos_spawn_small_step",
		vce_eat = "wwise/events/minions/play_chaos_spawn_vce_eat",
		footstep = "wwise/events/minions/play_chaos_spawn_big_step",
		vce_sweep = "wwise/events/minions/play_chaos_spawn_vce_sweep"
	},
	use_proximity_culling = {
		footstep_land = false,
		footstep_hand = false,
		vce_4_attack_combo = false,
		vce_move_sweep = false,
		vce_3_attack_combo = false,
		vce_leap = false,
		footstep_tentacle = false,
		vce_claw_slam = false,
		vce_eat = false,
		footstep_small = false,
		footstep = false,
		vce_sweep = false
	}
}

return sound_data
