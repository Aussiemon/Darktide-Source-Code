local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sounds = {
	foley_drastic_long = "wwise/events/minions/play_shared_foley_traitor_guard_light_drastic_long",
	vce_death = "wwise/events/minions/play_enemy_traitor_guard_rifleman_death_quick_vce",
	run_foley = "wwise/events/minions/play_shared_foley_traitor_guard_light_run",
	stop_vce = "wwise/events/minions/stop_all_enemy_traitor_guard_rifleman_vce",
	vce_death_long = "wwise/events/minions/play_enemy_traitor_guard_rifleman_death_long_vce",
	vce_suppressed = "wwise/events/minions/play_enemy_traitor_guard_rifleman_supressed_vce",
	vce_hurt = "wwise/events/minions/play_enemy_traitor_guard_rifleman_hurt_vce",
	vce_grunt = "wwise/events/minions/play_enemy_traitor_guard_rifleman_grunt_vce",
	vce_death_gassed = "wwise/events/minions/play_enemy_traitor_guard_rifleman_death_long_gassed_vce",
	foley_movement_long = "wwise/events/minions/play_shared_foley_traitor_guard_light_movement_long",
	vce_breathing_running = "wwise/events/minions/play_enemy_traitor_guard_rifleman_breathing_running_vce",
	vce_melee_attack_short = "wwise/events/minions/play_enemy_traitor_guard_rifleman_melee_attack_short_vce",
	foley_movement_short = "wwise/events/minions/play_shared_foley_traitor_guard_light_movement_short"
}

table.add_missing(sounds, RenegadeCommonSounds)

return sounds
