-- chunkname: @scripts/settings/breed/breeds/chaos/chaos_poxwalker_bomber_sounds.lua

local sound_data = {
	events = {
		body_impact = "wwise/events/minions/play_minion_poxwalker_bomber_body_impact",
		foley = "wwise/events/minions/play_enemy_poxwalker_bomber_chains_metal_foley",
		footstep = "wwise/events/minions/play_minion_poxwalker_bomber_footstep_boots_heavy",
		footstep_land = "wwise/events/minions/play_minion_footsteps_boots_heavy_land",
		ground_impact = "wwise/events/minions/play_enemy_foley_body_impact_medium_ground_gore",
		run_breath = "wwise/events/minions/play_minion_poxwalker_bomber_run_breath",
		vce_hurt = "wwise/events/minions/play_minion_poxwalker_bomber_run_breath",
	},
	use_proximity_culling = {
		body_impact = false,
		foley = false,
		footstep = false,
		footstep_land = false,
		run_breath = false,
	},
}

return sound_data
