﻿-- chunkname: @scripts/settings/breed/breeds/renegade/renegade_melee_sounds.lua

local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sound_data = {
	events = {
		foley_drastic_long = "wwise/events/minions/play_shared_foley_traitor_guard_medium_drastic_long",
		foley_movement_short = "wwise/events/minions/play_shared_foley_traitor_guard_medium_movement_short",
		run_foley = "wwise/events/minions/play_shared_foley_traitor_guard_medium_run",
		stop_vce = "wwise/events/minions/stop_all_traitor_trenchfighter_vce",
		swing = "wwise/events/weapon/play_minion_swing_1h_sword",
		vce_breathing_running = "wwise/events/minions/play_enemy_traitor_trenchfighter_breathing_running_vce",
		vce_death = "wwise/events/minions/play_enemy_traitor_trenchfighter_death_quick_vce",
		vce_death_gassed = "wwise/events/minions/play_enemy_traitor_trenchfighter_death_long_gassed_vce",
		vce_death_long = "wwise/events/minions/play_enemy_traitor_trenchfighter_death_long_vce",
		vce_grunt = "wwise/events/minions/play_enemy_traitor_trenchfighter_grunt_vce",
		vce_hurt = "wwise/events/minions/play_enemy_traitor_trenchfighter_hurt_vce",
		vce_idle = "wwise/events/minions/play_enemy_traitor_trenchfighter_idle_itchy_vce",
		vce_melee_attack_charged = "wwise/events/minions/play_enemy_traitor_trenchfighter_melee_attack_charged_vce",
		vce_melee_attack_short = "wwise/events/minions/play_enemy_traitor_trenchfighter_melee_attack_short_vce",
		vce_passive_idle_aggro = "wwise/events/minions/play_enemy_traitor_trenchfighter_idle_aggro_vce",
		vce_passive_idle_cough = "wwise/events/minions/play_enemy_traitor_trenchfighter_idle_cough_vce",
		vce_passive_idle_itchy = "wwise/events/minions/play_enemy_traitor_trenchfighter_idle_itchy_vce",
	},
	use_proximity_culling = {
		stop_vce = false,
		vce_melee_attack_charged = false,
		vce_melee_attack_short = false,
	},
}

table.add_missing(sound_data.events, RenegadeCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, RenegadeCommonSounds.use_proximity_culling)

return sound_data
