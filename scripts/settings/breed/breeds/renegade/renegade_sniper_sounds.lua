local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sound_data = {
	events = {
		vce_grunt = "wwise/events/minions/play_traitor_guard_sniper__hurt_vce",
		vce_death = "wwise/events/minions/play_traitor_guard_sniper__death_quick_vce",
		stop_vce = "wwise/events/minions/stop_all_traitor_guard_sniper",
		vce_death_long = "wwise/events/minions/play_traitor_guard_sniper__death_long_vce",
		footstep = "wwise/events/minions/play_netgunner_footsteps",
		vce_hurt = "wwise/events/minions/play_traitor_guard_sniper__hurt_vce",
		run_foley_special = "wwise/events/minions/play_minion_sniper_run_foley"
	},
	use_proximity_culling = {
		vce_death = false,
		stop_vce = false,
		vce_death_long = false,
		footstep = false,
		vce_hurt = false,
		run_foley_special = false
	}
}

table.add_missing(sound_data.events, RenegadeCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, RenegadeCommonSounds.use_proximity_culling)

return sound_data
