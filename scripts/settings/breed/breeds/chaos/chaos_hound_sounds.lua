-- chunkname: @scripts/settings/breed/breeds/chaos/chaos_hound_sounds.lua

local sound_data = {
	events = {
		foley = "wwise/events/minions/play_enemy_chaos_hound_footstep_foley",
		footstep = "wwise/events/minions/play_enemy_chaos_hound_footstep",
		footstep_land = "wwise/events/minions/play_enemy_chaos_hound_footstep_land",
		ground_impact = "wwise/events/minions/play_enemy_foley_body_impact_medium_ground_gore",
		sfx_bark = "wwise/events/minions/play_enemy_chaos_hound_vce_bark",
		sfx_breath = "wwise/events/minions/play_enemy_chaos_hound_vce_breath",
		sfx_death = "wwise/events/minions/play_enemy_chaos_hound_death",
		sfx_growl = "wwise/events/minions/play_enemy_chaos_hound_vce_growl",
		sfx_growl_probability = "wwise/events/minions/play_enemy_chaos_hound_vce_growl_probability",
		sfx_hurt = "wwise/events/minions/play_enemy_chaos_hound_hurt",
		sfx_leap = "wwise/events/minions/play_enemy_chaos_hound_vce_leap",
	},
	use_proximity_culling = {
		foley = false,
		footstep = false,
		footstep_land = false,
		ground_impact = false,
		sfx_bark = false,
		sfx_breath = false,
		sfx_death = false,
		sfx_growl = false,
		sfx_growl_probability = false,
		sfx_hurt = false,
		sfx_leap = false,
	},
}

return sound_data
