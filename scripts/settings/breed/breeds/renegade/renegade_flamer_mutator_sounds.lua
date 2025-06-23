﻿-- chunkname: @scripts/settings/breed/breeds/renegade/renegade_flamer_mutator_sounds.lua

local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sound_data = {
	events = {
		foley_drastic_long = "wwise/events/minions/play_shared_foley_traitor_guard_medium_drastic_long",
		vce_death = "wwise/events/minions/play_enemy_traitor_guard_flamer_mutator_short_death_vce",
		run_foley_special = "wwise/events/minions/play_enemy_cultist_flamer_foley_tank",
		stop_vce = "wwise/events/minions/stop_all_enemy_traitor_guard_flamer_mutator_vce",
		vce_death_long = "wwise/events/minions/play_enemy_traitor_guard_flamer_mutator_death_long_vce",
		run_foley = "wwise/events/minions/play_shared_foley_traitor_guard_medium_run",
		vce_hurt = "wwise/events/minions/play_enemy_traitor_guard_flamer_mutator_hurt_vce",
		vce_grunt = "wwise/events/minions/play_enemy_traitor_guard_flamer_mutator_grunt_vce",
		footstep_land = "wwise/events/minions/play_minion_footsteps_boots_heavy_land",
		vce_death_gassed = "wwise/events/minions/play_enemy_traitor_guard_flamer_mutator_death_long_gassed_vce",
		vce_breathing_running = "wwise/events/minions/play_enemy_traitor_guard_flamer_mutator_breathing_running_vce",
		footstep = "wwise/events/minions/play_traitor_guard_grenadier_footsteps",
		foley_movement_short = "wwise/events/minions/play_shared_foley_traitor_guard_medium_drastic_short"
	},
	use_proximity_culling = {
		vce_death_long = false,
		vce_death = false,
		vce_hurt = false,
		stop_vce = false
	}
}

table.add_missing(sound_data.events, RenegadeCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, RenegadeCommonSounds.use_proximity_culling)

return sound_data
