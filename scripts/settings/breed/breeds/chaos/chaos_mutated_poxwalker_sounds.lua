-- chunkname: @scripts/settings/breed/breeds/chaos/chaos_mutated_poxwalker_sounds.lua

local sound_data = {
	events = {
		footstep_land = "wwise/events/minions/play_minion_footsteps_barefoot_land",
		ground_impact = "wwise/events/minions/play_enemy_foley_body_impact_medium_ground_gore",
		foley_drastic_short = "wwise/events/minions/play_minion_poxwalker_mutated_drastic_short",
		foley_neck_snap = "wwise/events/minions/play_enemy_poxwalker_mutated_foley_neck_snap",
		foley_rib_cage_snap = "wwise/events/minions/play_enemy_poxwalker_mutated_foley_ribcage_snap",
		vce_death_long = "wwise/events/minions/play_enemy_poxwalker_mutated_vce_death_long",
		vce_hurt = "wwise/events/minions/play_enemy_poxwalker_mutated_vce_hurt",
		vce_grunt = "wwise/events/minions/play_enemy_poxwalker_mutated_vce_grunt",
		vce_stop_all = "wwise/events/minions/stop_all_enemy_poxwalker_vce",
		vce_special_attack = "wwise/events/minions/play_enemy_poxwalker_mutated_vce_special_attack",
		vce_death_short = "wwise/events/minions/play_enemy_poxwalker_mutated_vce_death_short",
		run_breath = "wwise/events/minions/play_enemy_poxwalker_vce_run_breath",
		swing = "wwise/events/weapon/play_minion_swing_1h_sword",
		footstep = "wwise/events/minions/play_minion_footsteps_barefoot",
		vce_attack = "wwise/events/minions/play_enemy_poxwalker_mutated_vce_attack",
		run_foley = "wwise/events/minions/play_shared_minion_cloth_leather_run_foley"
	},
	use_proximity_culling = {
		vce_attack = false,
		vce_stop_all = false,
		vce_special_attack = false
	}
}

return sound_data
