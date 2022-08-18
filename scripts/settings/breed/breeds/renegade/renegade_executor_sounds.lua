local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sounds = {
	footstep_land = "wwise/events/minions/play_minion_footsteps_boots_heavy_land",
	vce_death = "wwise/events/minions/play_enemy_traitor_executor__death_quick_vce",
	vce_special_attack = "wwise/events/minions/play_enemy_traitor_executor__special_attack_vce",
	vce_grunt = "wwise/events/minions/play_enemy_traitor_executor__grunt_vce",
	vce_death_long = "wwise/events/minions/play_enemy_traitor_executor__death_long_vce",
	vce_breathing_running = "wwise/events/minions/play_enemy_traitor_executor__running_breath_vce",
	vce_hurt = "wwise/events/minions/play_enemy_traitor_executor__hurt_vce",
	swing_foley = "wwise/events/minions/play_shared_foley_chaos_ogryn_elites_medium_drastic_short",
	vce_melee_attack_short = "wwise/events/minions/play_enemy_traitor_executor__melee_attack_short_vce",
	vce_death_gassed = "wwise/events/minions/play_enemy_traitor_executor__death_long_gassed_vce",
	foley_movement_long = "wwise/events/minions/play_shared_foley_chaos_ogryn_elites_heavy_movement_long",
	swing = "wwise/events/weapon/play_minion_swing_chainaxe",
	footstep = "wwise/events/minions/play_minion_footsteps_boots_heavy",
	run_foley = "wwise/events/minions/play_shared_foley_traitor_guard_heavy_run"
}

table.add_missing(sounds, RenegadeCommonSounds)

return sounds
