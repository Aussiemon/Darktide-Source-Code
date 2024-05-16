-- chunkname: @scripts/settings/breed/breeds/renegade/renegade_grenadier_sounds.lua

local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sound_data = {
	events = {
		foley_drastic_long = "wwise/events/minions/play_shared_foley_traitor_guard_light_drastic_long",
		footstep = "wwise/events/minions/play_traitor_guard_grenadier_footsteps",
		footstep_land = "wwise/events/minions/play_minion_footsteps_boots_heavy_land",
		pull_sprint = "wwise/events/minions/play_traitor_guard_grenadier_pull_sprint",
		run_foley_special = "wwise/events/minions/play_enemy_guard_grenadier_movement_foley",
		vce_death = "wwise/events/minions/play_traitor_guard_grenadier__death_quick_vce",
		vce_death_long = "wwise/events/minions/play_traitor_guard_grenadier__death_long_vce",
		vce_grunt = "wwise/events/minions/play_traitor_guard_grenadier__grunt_vce",
		vce_hurt = "wwise/events/minions/play_traitor_guard_grenadier__hurt_vce",
		vce_stop = "wwise/events/minions/stop_all_traitor_grenadier_vce",
	},
	use_proximity_culling = {
		footstep = false,
		footstep_land = false,
		pull_sprint = false,
		run_foley_special = false,
		vce_death = false,
		vce_death_long = false,
		vce_hurt = false,
	},
}

table.add_missing(sound_data.events, RenegadeCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, RenegadeCommonSounds.use_proximity_culling)

return sound_data
