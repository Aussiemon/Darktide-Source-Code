-- chunkname: @scripts/settings/breed/breeds/renegade/renegade_netgunner_sounds.lua

local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sound_data = {
	events = {
		foley_drastic_long = "wwise/events/minions/play_shared_foley_traitor_guard_medium_drastic_long",
		foley_drastic_short = "wwise/events/minions/play_netgunner_drastic_short",
		footstep = "wwise/events/minions/play_netgunner_footsteps",
		footstep_land = "wwise/events/minions/play_minion_footsteps_boots_heavy_land",
		run_foley = "wwise/events/minions/play_shared_foley_traitor_guard_medium_run",
		run_foley_special = "wwise/events/minions/play_netgunner_run_foley_special",
		vce_breathing_running = "wwise/events/minions/play_traitor_guard_netgunner_breathing_running_vce",
		vce_death = "wwise/events/minions/play_traitor_guard_netgunner_death_quick_vce",
		vce_death_long = "wwise/events/minions/play_traitor_guard_netgunner_death_long_vce",
		vce_grunt = "wwise/events/minions/play_traitor_guard_netgunner_grunt_vce",
		vce_hurt = "wwise/events/minions/play_traitor_guard_netgunner_hurt_vce",
		vce_laugh = "wwise/events/minions/play_traitor_guard_netgunner_laugh_vce",
		vce_stop = "wwise/events/minions/stop_all_traitor_netgunner",
	},
	use_proximity_culling = {
		foley_drastic_short = false,
		footstep = false,
		footstep_land = false,
		run_foley_special = false,
		vce_death = false,
		vce_death_long = false,
		vce_hurt = false,
		vce_laugh = false,
	},
}

table.add_missing(sound_data.events, RenegadeCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, RenegadeCommonSounds.use_proximity_culling)

return sound_data
