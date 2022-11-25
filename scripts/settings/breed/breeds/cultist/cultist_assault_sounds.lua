local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sounds = {
	footstep_land = "wwise/events/minions/play_minion_footsteps_barefoot_land",
	vce_death = "wwise/events/minions/play_enemy_cultist_rusher_male__death_quick_vce",
	range_aim = "wwise/events/weapon/play_weapon_ads_foley_lasgun_3rd_p",
	stop_vce = "wwise/events/minions/stop_all_enemy_cultist_rusher_male_vce",
	vce_death_long = "wwise/events/minions/play_enemy_cultist_rusher_male__death_long_vce",
	vce_melee_attack_short = "wwise/events/minions/play_enemy_cultist_rusher_male__melee_attack_vce",
	vce_hurt = "wwise/events/minions/play_enemy_cultist_rusher_male__hurt_vce",
	vce_grunt = "wwise/events/minions/play_enemy_cultist_rusher_male__grunt_vce",
	vce_switch_to_melee = "wwise/events/minions/play_enemy_cultist_rusher_male__switch_to_melee_vce",
	vce_death_gassed = "wwise/events/minions/play_enemy_cultist_rusher_male__death_long_gassed_vce",
	vce_breathing_running = "wwise/events/minions/play_enemy_cultist_rusher_male__breathing_running_vce",
	vce_suppressed = "wwise/events/minions/play_enemy_cultist_rusher_male__hurt_vce",
	swing = "wwise/events/weapon/play_minion_swing_1h_sword",
	footstep = "wwise/events/minions/play_minion_footsteps_wrapped_feet",
	run_foley = "wwise/events/minions/play_shared_minion_cloth_leather_run_foley"
}

table.add_missing(sounds, RenegadeCommonSounds)

return sounds
