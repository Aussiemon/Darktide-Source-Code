-- chunkname: @scripts/settings/breed/breeds/cultist/cultist_mutant_sounds.lua

local sound_data = {
	events = {
		climb_impact = "wwise/events/minions/play_enemy_foley_body_impact_medium_ground",
		footstep = "wwise/events/minions/play_mutant_charger_footstep_boots_heavy",
		footstep_land = "wwise/events/minions/play_minion_footsteps_chaos_ogryn_land",
		ground_impact = "wwise/events/minions/play_enemy_foley_body_impact_large_ground",
		run_breath = "wwise/events/minions/play_enemy_mutant_charger_run_breath",
		run_foley = "wwise/events/minions/play_enemy_mutant_charger_run_rattle",
	},
	use_proximity_culling = {
		footstep = false,
		footstep_land = false,
		run_breath = false,
		run_foley = false,
	},
}

return sound_data
