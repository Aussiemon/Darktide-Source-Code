-- chunkname: @scripts/settings/breed/breeds/chaos/chaos_spawn_sounds.lua

local sound_data = {
	events = {
		footstep = "wwise/events/minions/play_chaos_spawn_big_step",
		footstep_hand = "wwise/events/minions/play_chaos_spawn_hand_step",
		footstep_land = "wwise/events/minions/play_chaos_spawn_leap_land",
		footstep_scuff = "wwise/events/minions/play_chaos_spawn_scuff_step",
		footstep_small = "wwise/events/minions/play_chaos_spawn_small_step",
		footstep_tentacle = "wwise/events/minions/play_chaos_spawn_tentacle_step",
		vce_3_attack_combo = "wwise/events/minions/play_chaos_spawn_vce_3_attack_combo",
		vce_4_attack_combo = "wwise/events/minions/play_chaos_spawn_vce_4_attack_combo",
		vce_attack_long = "wwise/events/minions/play_chaos_spawn_vce_attack_long",
		vce_attack_short = "wwise/events/minions/play_chaos_spawn_vce_attack_short",
		vce_chatter = "wwise/events/minions/play_chaos_spawn_vce_chatter",
		vce_death = "wwise/events/minions/play_chaos_spawn_vce_death",
		vce_eat = "wwise/events/minions/play_chaos_spawn_vce_eat",
		vce_hurt = "wwise/events/minions/play_chaos_spawn_vce_hurt",
		vce_leap = "wwise/events/minions/play_chaos_spawn_vce_leap",
		vce_leap_short = "wwise/events/minions/play_chaos_spawn_vce_leap_short",
		vce_stop = "wwise/events/minions/stop_chaos_spawn_vce",
	},
	use_proximity_culling = {
		footstep = false,
		footstep_hand = false,
		footstep_land = false,
		footstep_scuff = false,
		footstep_small = false,
		footstep_tentacle = false,
		vce_3_attack_combo = false,
		vce_4_attack_combo = false,
		vce_attack_long = false,
		vce_attack_short = false,
		vce_chatter = false,
		vce_death = false,
		vce_eat = false,
		vce_hurt = false,
		vce_leap = false,
		vce_leap_short = false,
		vce_stop = false,
	},
}

return sound_data
