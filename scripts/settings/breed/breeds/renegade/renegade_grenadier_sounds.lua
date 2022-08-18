local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sounds = {
	foley_drastic_long = "wwise/events/minions/play_shared_foley_traitor_guard_light_drastic_long",
	vce_death = "wwise/events/minions/play_traitor_guard_grenadier__death_quick_vce",
	footstep_land = "wwise/events/minions/play_minion_footsteps_boots_heavy_land",
	vce_death_long = "wwise/events/minions/play_traitor_guard_grenadier__death_long_vce",
	vce_hurt = "wwise/events/minions/play_traitor_guard_grenadier__hurt_vce",
	vce_grunt = "wwise/events/minions/play_traitor_guard_grenadier__grunt_vce",
	vce_stop = "wwise/events/minions/stop_all_traitor_grenadier_vce",
	footstep_special = "wwise/events/minions/play_traitor_guard_grenadier_footsteps",
	run_foley_special = "wwise/events/minions/play_enemy_guard_grenadier_movement_foley"
}

table.add_missing(sounds, RenegadeCommonSounds)

return sounds
