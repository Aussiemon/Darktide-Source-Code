-- chunkname: @scripts/settings/breed/breeds/chaos/chaos_hound_sounds.lua

local sound_data = {
	events = {
		footstep_land = "wwise/events/minions/play_enemy_chaos_hound_footstep_land",
		ground_impact = "wwise/events/minions/play_enemy_foley_body_impact_medium_ground_gore",
		sfx_breath = "wwise/events/minions/play_enemy_chaos_hound_vce_breath",
		foley = "wwise/events/minions/play_enemy_chaos_hound_footstep_foley",
		sfx_death = "wwise/events/minions/play_enemy_chaos_hound_death",
		sfx_growl_probability = "wwise/events/minions/play_enemy_chaos_hound_vce_growl_probability",
		sfx_leap = "wwise/events/minions/play_enemy_chaos_hound_vce_leap",
		sfx_bark = "wwise/events/minions/play_enemy_chaos_hound_vce_bark",
		sfx_growl = "wwise/events/minions/play_enemy_chaos_hound_vce_growl",
		footstep = "wwise/events/minions/play_enemy_chaos_hound_footstep",
		sfx_hurt = "wwise/events/minions/play_enemy_chaos_hound_hurt"
	},
	use_proximity_culling = {
		footstep_land = false,
		ground_impact = false,
		sfx_breath = false,
		foley = false,
		sfx_death = false,
		sfx_growl_probability = false,
		sfx_leap = false,
		sfx_bark = false,
		sfx_growl = false,
		footstep = false,
		sfx_hurt = false
	}
}

return sound_data
