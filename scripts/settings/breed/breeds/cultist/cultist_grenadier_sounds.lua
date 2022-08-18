local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sounds = {
	footstep_land = "wwise/events/minions/play_minion_footsteps_barefoot_land",
	footstep = "wwise/events/minions/play_minion_footsteps_wrapped_feet",
	run_foley = "wwise/events/minions/play_shared_minion_cloth_leather_run_foley"
}

table.add_missing(sounds, RenegadeCommonSounds)

return sounds
