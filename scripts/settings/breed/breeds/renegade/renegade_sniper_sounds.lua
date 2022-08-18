local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sounds = {
	vce_hurt = "wwise/events/minions/play_traitor_guard_sniper__hurt_vce",
	vce_death = "wwise/events/minions/play_traitor_guard_sniper__death_quick_vce",
	vce_grunt = "wwise/events/minions/play_traitor_guard_sniper__hurt_vce",
	stop_vce = "wwise/events/minions/stop_all_traitor_guard_sniper",
	vce_death_long = "wwise/events/minions/play_traitor_guard_sniper__death_long_vce",
	footstep_special = "wwise/events/minions/play_netgunner_footsteps",
	run_foley_special = "wwise/events/minions/play_minion_sniper_run_foley"
}

table.add_missing(sounds, RenegadeCommonSounds)

return sounds
