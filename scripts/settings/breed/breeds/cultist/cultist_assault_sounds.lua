﻿-- chunkname: @scripts/settings/breed/breeds/cultist/cultist_assault_sounds.lua

local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sound_data = {
	events = {
		footstep = "wwise/events/minions/play_minion_footsteps_wrapped_feet",
		footstep_land = "wwise/events/minions/play_minion_footsteps_barefoot_land",
		run_foley = "wwise/events/minions/play_shared_minion_cloth_leather_run_foley",
		stop_vce = "wwise/events/minions/stop_all_enemy_cultist_rusher_male_vce",
		swing = "wwise/events/weapon/play_minion_swing_1h_sword",
		vce_breathing_running = "wwise/events/minions/play_enemy_cultist_rusher_male__breathing_running_vce",
		vce_death = "wwise/events/minions/play_enemy_cultist_rusher_male__death_quick_vce",
		vce_death_gassed = "wwise/events/minions/play_enemy_cultist_rusher_male__death_long_gassed_vce",
		vce_death_long = "wwise/events/minions/play_enemy_cultist_rusher_male__death_long_vce",
		vce_grunt = "wwise/events/minions/play_enemy_cultist_rusher_male__grunt_vce",
		vce_hurt = "wwise/events/minions/play_enemy_cultist_rusher_male__hurt_vce",
		vce_melee_attack_charged = "wwise/events/minions/play_enemy_cultist_rusher_male__melee_attack_charged_vce",
		vce_melee_attack_short = "wwise/events/minions/play_enemy_cultist_rusher_male__melee_attack_vce",
		vce_suppressed = "wwise/events/minions/play_enemy_cultist_rusher_male__hurt_vce",
		vce_switch_to_melee = "wwise/events/minions/play_enemy_cultist_rusher_male__switch_to_melee_vce",
	},
	use_proximity_culling = {
		stop_vce = false,
		vce_death = false,
		vce_death_long = false,
		vce_hurt = false,
	},
}

table.add_missing(sound_data.events, RenegadeCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, RenegadeCommonSounds.use_proximity_culling)

return sound_data
