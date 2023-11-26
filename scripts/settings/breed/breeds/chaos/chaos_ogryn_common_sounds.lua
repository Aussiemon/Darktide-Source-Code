-- chunkname: @scripts/settings/breed/breeds/chaos/chaos_ogryn_common_sounds.lua

local sound_data = {
	events = {
		footstep_land = "wwise/events/minions/play_minion_footsteps_chaos_ogryn_land",
		ground_impact = "wwise/events/minions/play_enemy_foley_body_impact_large_ground",
		footstep = "wwise/events/minions/play_minion_footsteps_chaos_ogryn",
		footstep_stomp = "wwise/events/minions/play_minion_footsteps_chaos_ogryn_stomp",
		run_foley = "wwise/events/minions/play_shared_foley_chaos_ogryn_elites_medium_run"
	},
	use_proximity_culling = {}
}

return sound_data
