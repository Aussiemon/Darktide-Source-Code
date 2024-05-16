-- chunkname: @scripts/settings/breed/breeds/renegade/renegade_sniper_sounds.lua

local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sound_data = {
	events = {
		footstep = "wwise/events/minions/play_netgunner_footsteps",
		run_foley_special = "wwise/events/minions/play_minion_sniper_run_foley",
		stop_vce = "wwise/events/minions/stop_all_traitor_guard_sniper",
		vce_death = "wwise/events/minions/play_traitor_guard_sniper__death_quick_vce",
		vce_death_long = "wwise/events/minions/play_traitor_guard_sniper__death_long_vce",
		vce_grunt = "wwise/events/minions/play_traitor_guard_sniper__hurt_vce",
		vce_hurt = "wwise/events/minions/play_traitor_guard_sniper__hurt_vce",
	},
	use_proximity_culling = {
		footstep = false,
		footstep_land = false,
		run_foley_special = false,
		stop_vce = false,
		vce_death = false,
		vce_death_long = false,
		vce_hurt = false,
	},
}

table.add_missing(sound_data.events, RenegadeCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, RenegadeCommonSounds.use_proximity_culling)

return sound_data
