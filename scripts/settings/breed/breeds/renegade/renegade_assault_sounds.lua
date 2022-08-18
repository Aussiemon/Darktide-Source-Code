local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sounds = {
	foley_drastic_long = "wwise/events/minions/play_shared_foley_traitor_guard_light_drastic_long",
	vce_death = "wwise/events/minions/play_enemy_traitor_smg_rusher_death_quick_vce",
	range_aim = "wwise/events/weapon/play_weapon_ads_foley_lasgun_3rd_p",
	stop_vce = "wwise/events/minions/stop_all_enemy_traitor_smg_rusher_vce",
	vce_death_long = "wwise/events/minions/play_enemy_traitor_smg_rusher_death_long_vce",
	vce_suppressed = "wwise/events/minions/play_enemy_traitor_smg_rusher_suppressed_vce",
	vce_hurt = "wwise/events/minions/play_enemy_traitor_smg_rusher_hurt_vce",
	vce_grunt = "wwise/events/minions/play_enemy_traitor_smg_rusher_grunt_vce",
	foley_movement_short = "wwise/events/minions/play_shared_foley_traitor_guard_light_movement_short",
	vce_death_gassed = "wwise/events/minions/play_enemy_traitor_smg_rusher_death_long_gassed_vce",
	foley_movement_long = "wwise/events/minions/play_shared_foley_traitor_guard_light_movement_long",
	swing = "wwise/events/weapon/play_minion_swing_1h_sword",
	vce_melee_attack_short = "wwise/events/minions/play_enemy_traitor_smg_rusher_melee_attack_short_vce",
	run_foley = "wwise/events/minions/play_shared_foley_traitor_guard_light_run"
}

table.add_missing(sounds, RenegadeCommonSounds)

return sounds
