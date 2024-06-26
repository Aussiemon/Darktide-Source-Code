﻿-- chunkname: @scripts/settings/breed/breeds/chaos/chaos_newly_infected_sounds.lua

local sound_data = {
	events = {
		footstep = "wwise/events/minions/play_footstep_boots_medium_enemy",
		footstep_land = "wwise/events/minions/play_footstep_boots_land_medium_enemy",
		ground_impact = "wwise/events/minions/play_enemy_foley_body_impact_medium_ground",
		run_foley = "wwise/events/minions/play_shared_minion_cloth_leather_run_foley",
		stop_vce = "wwise/events/minions/stop_all_enemy_newly_infected_vce",
		swing = "wwise/events/weapon/play_minion_swing_1h_sword",
		vce_breathing_running = "wwise/events/minions/play_enemy_chaos_newly_infected_breathing_running_vce",
		vce_death = "wwise/events/minions/play_enemy_chaos_newly_infected_death_quick_vce",
		vce_death_gassed = "wwise/events/minions/play_enemy_chaos_newly_infected_death_long_gassed_vce",
		vce_death_long = "wwise/events/minions/play_enemy_chaos_newly_infected_death_long_vce",
		vce_grunt = "wwise/events/minions/play_enemy_chaos_newly_infected_hurt_vce",
		vce_hurt = "wwise/events/minions/play_enemy_chaos_newly_infected_hurt_vce",
		vce_melee_attack_charged = "wwise/events/minions/play_enemy_chaos_newly_infected_melee_attack_charged_vce",
		vce_melee_attack_short = "wwise/events/minions/play_enemy_chaos_newly_infected_melee_attack_short_vce",
		vce_passive_idle_cough = "wwise/events/minions/play_enemy_chaos_newly_infected_idle_vce",
		vce_passive_idle_itchy = "wwise/events/minions/play_enemy_chaos_newly_infected_idle_vce",
	},
	use_proximity_culling = {
		stop_vce = false,
		vce_melee_attack_charged = false,
		vce_melee_attack_short = false,
	},
}

return sound_data
