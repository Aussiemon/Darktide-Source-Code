local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sounds = {
	footstep_land = "wwise/events/minions/play_footstep_boots_land_medium_enemy",
	vce_death = "wwise/events/minions/play_enemy_traitor_gunner_death_quick_vce",
	vce_melee_attack_short = "wwise/events/minions/play_enemy_traitor_gunner_melee_attack_vce",
	stop_vce = "wwise/events/minions/stop_all_traitor_trenchfighter_vce",
	vce_death_long = "wwise/events/minions/play_enemy_traitor_gunner_death_long_vce",
	vce_suppressed = "wwise/events/minions/play_enemy_traitor_gunner_supressed_vce",
	vce_hurt = "wwise/events/minions/play_enemy_traitor_gunner_hurt_vce",
	vce_grunt = "wwise/events/minions/play_enemy_traitor_gunner_grunt_vce",
	vce_death_gassed = "wwise/events/minions/play_enemy_traitor_gunner_death_long_gassed_vce",
	swing = "wwise/events/weapon/play_minion_swing_1h_sword",
	footstep = "wwise/events/minions/play_footstep_boots_medium_enemy",
	run_foley = "wwise/events/minions/play_enemy_guard_shocktrooper_movement_foley"
}

table.add_missing(sounds, RenegadeCommonSounds)

return sounds
