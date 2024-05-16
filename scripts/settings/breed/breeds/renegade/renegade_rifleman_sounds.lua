-- chunkname: @scripts/settings/breed/breeds/renegade/renegade_rifleman_sounds.lua

local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sound_data = {
	events = {
		foley_drastic_long = "wwise/events/minions/play_shared_foley_traitor_guard_light_drastic_long",
		foley_movement_long = "wwise/events/minions/play_shared_foley_traitor_guard_light_movement_long",
		foley_movement_short = "wwise/events/minions/play_shared_foley_traitor_guard_light_movement_short",
		run_foley = "wwise/events/minions/play_shared_foley_traitor_guard_light_run",
		stop_vce = "wwise/events/minions/stop_all_enemy_traitor_guard_rifleman_vce",
		vce_breathing_running = "wwise/events/minions/play_enemy_traitor_guard_rifleman_breathing_running_vce",
		vce_death = "wwise/events/minions/play_enemy_traitor_guard_rifleman_death_quick_vce",
		vce_death_gassed = "wwise/events/minions/play_enemy_traitor_guard_rifleman_death_long_gassed_vce",
		vce_death_long = "wwise/events/minions/play_enemy_traitor_guard_rifleman_death_long_vce",
		vce_grunt = "wwise/events/minions/play_enemy_traitor_guard_rifleman_grunt_vce",
		vce_hurt = "wwise/events/minions/play_enemy_traitor_guard_rifleman_hurt_vce",
		vce_melee_attack_short = "wwise/events/minions/play_enemy_traitor_guard_rifleman_melee_attack_short_vce",
		vce_suppressed = "wwise/events/minions/play_enemy_traitor_guard_rifleman_supressed_vce",
	},
	use_proximity_culling = {
		stop_vce = false,
		vce_death = false,
		vce_death_long = false,
		vce_hurt = false,
	},
}

table.add_missing(sound_data.events, RenegadeCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, RenegadeCommonSounds.use_proximity_culling)

return sound_data
