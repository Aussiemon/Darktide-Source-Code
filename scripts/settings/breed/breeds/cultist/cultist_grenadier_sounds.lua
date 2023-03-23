local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sound_data = {
	events = {
		footstep_land = "wwise/events/minions/play_minion_footsteps_barefoot_land",
		footstep = "wwise/events/minions/play_minion_footsteps_wrapped_feet",
		run_foley = "wwise/events/minions/play_shared_minion_cloth_leather_run_foley"
	},
	use_proximity_culling = {}
}

table.add_missing(sound_data.events, RenegadeCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, RenegadeCommonSounds.use_proximity_culling)

return sound_data
