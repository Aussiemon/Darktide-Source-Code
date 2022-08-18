local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sounds = {
	foley_drastic_long = "wwise/events/minions/play_shared_foley_traitor_guard_medium_drastic_long",
	vce_death = "wwise/events/minions/play_traitor_guard_netgunner_death_quick_vce",
	foley_drastic_short = "wwise/events/minions/play_netgunner_drastic_short",
	run_foley_special = "wwise/events/minions/play_netgunner_run_foley_special",
	vce_death_long = "wwise/events/minions/play_traitor_guard_netgunner_death_long_vce",
	footstep_land = "wwise/events/minions/play_minion_footsteps_boots_heavy_land",
	vce_hurt = "wwise/events/minions/play_traitor_guard_netgunner_hurt_vce",
	vce_grunt = "wwise/events/minions/play_traitor_guard_netgunner_grunt_vce",
	vce_stop = "wwise/events/minions/stop_all_traitor_netgunner",
	vce_breathing_running = "wwise/events/minions/play_traitor_guard_netgunner_breathing_running_vce",
	vce_laugh = "wwise/events/minions/play_traitor_guard_netgunner_laugh_vce",
	footstep_special = "wwise/events/minions/play_netgunner_footsteps",
	run_foley = "wwise/events/minions/play_shared_foley_traitor_guard_medium_run"
}

table.add_missing(sounds, RenegadeCommonSounds)

return sounds
