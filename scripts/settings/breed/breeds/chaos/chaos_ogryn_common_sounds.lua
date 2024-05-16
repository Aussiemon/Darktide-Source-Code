-- chunkname: @scripts/settings/breed/breeds/chaos/chaos_ogryn_common_sounds.lua

local sound_data = {
	events = {
		footstep = "wwise/events/minions/play_minion_footsteps_chaos_ogryn",
		footstep_land = "wwise/events/minions/play_minion_footsteps_chaos_ogryn_land",
		footstep_stomp = "wwise/events/minions/play_minion_footsteps_chaos_ogryn_stomp",
		ground_impact = "wwise/events/minions/play_enemy_foley_body_impact_large_ground",
		run_foley = "wwise/events/minions/play_shared_foley_chaos_ogryn_elites_medium_run",
	},
	use_proximity_culling = {
		footstep = false,
		footstep_land = false,
		footstep_stomp = false,
	},
}

return sound_data
