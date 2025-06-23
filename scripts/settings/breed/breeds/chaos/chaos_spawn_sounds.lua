-- chunkname: @scripts/settings/breed/breeds/chaos/chaos_spawn_sounds.lua

local sound_data = {
	events = {
		vce_4_attack_combo = "wwise/events/minions/play_chaos_spawn_vce_4_attack_combo",
		vce_death = "wwise/events/minions/play_chaos_spawn_vce_death",
		vce_3_attack_combo = "wwise/events/minions/play_chaos_spawn_vce_3_attack_combo",
		footstep_hand = "wwise/events/minions/play_chaos_spawn_hand_step",
		footstep_tentacle = "wwise/events/minions/play_chaos_spawn_tentacle_step",
		vce_eat = "wwise/events/minions/play_chaos_spawn_vce_eat",
		vce_stop = "wwise/events/minions/stop_chaos_spawn_vce",
		footstep_land = "wwise/events/minions/play_chaos_spawn_leap_land",
		footstep_scuff = "wwise/events/minions/play_chaos_spawn_scuff_step",
		vce_chatter = "wwise/events/minions/play_chaos_spawn_vce_chatter",
		vce_leap = "wwise/events/minions/play_chaos_spawn_vce_leap",
		vce_leap_short = "wwise/events/minions/play_chaos_spawn_vce_leap_short",
		vce_hurt = "wwise/events/minions/play_chaos_spawn_vce_hurt",
		vce_attack_long = "wwise/events/minions/play_chaos_spawn_vce_attack_long",
		footstep_small = "wwise/events/minions/play_chaos_spawn_small_step",
		footstep = "wwise/events/minions/play_chaos_spawn_big_step",
		vce_attack_short = "wwise/events/minions/play_chaos_spawn_vce_attack_short"
	},
	use_proximity_culling = {
		vce_4_attack_combo = false,
		vce_death = false,
		vce_3_attack_combo = false,
		footstep_hand = false,
		footstep_tentacle = false,
		vce_eat = false,
		vce_stop = false,
		footstep_land = false,
		footstep_scuff = false,
		vce_chatter = false,
		vce_leap = false,
		vce_leap_short = false,
		vce_hurt = false,
		vce_attack_long = false,
		footstep_small = false,
		footstep = false,
		vce_attack_short = false
	}
}

return sound_data
