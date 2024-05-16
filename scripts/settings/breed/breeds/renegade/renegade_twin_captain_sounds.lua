-- chunkname: @scripts/settings/breed/breeds/renegade/renegade_twin_captain_sounds.lua

local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sound_data = {
	events = {
		foley_drastic_long = "wwise/events/minions/play_minion_twin_foley_kick",
		footstep = "wwise/events/minions/play_minion_captain_footsteps",
		footstep_land = "wwise/events/minions/play_minion_captain_footsteps_land",
		ground_impact = "wwise/events/minions/play_enemy_foley_body_impact_large_ground",
		pull_sprint = "wwise/events/minions/play_cultist_grenadier_pull_sprint",
		run_foley = "wwise/events/minions/play_minion_captain_drastic_short",
		run_foley_special = "wwise/events/minions/play_cultist_grenadier_run_foley",
		vce_breathing_running = "wwise/events/minions/play_minion_captain__breathing_running_vce",
		vce_combo_attack_single = "wwise/events/minions/play_minion_captain__combo_attack_single_vce",
		vce_death_quick = "wwise/events/minions/play_minion_captain__death_quick_vce",
		vce_force_field_overload = "wwise/events/minions/play_minion_captain__force_field_overload_vce",
		vce_grunt = "wwise/events/minions/play_minion_captain__grunt_vce",
		vce_kick = "wwise/events/minions/play_minion_captain__kick_vce",
		vce_melee_attack_charged = "wwise/events/minions/play_minion_captain__melee_attack_charged_vce",
		vce_melee_attack_charged_long = "wwise/events/minions/play_minion_captain__melee_attack_charged_long_vce",
		vce_melee_attack_short = "wwise/events/minions/play_minion_captain__melee_attack_short_vce",
		vce_mocking_laughter = "wwise/events/minions/play_minion_captain__mocking_laughter_vce",
	},
	use_proximity_culling = {
		foley_drastic_long = false,
		footstep = false,
		footstep_land = false,
		vce_breathing_running = false,
		vce_combo_attack_single = false,
		vce_death_quick = false,
		vce_force_field_overload = false,
		vce_grunt = false,
		vce_kick = false,
		vce_melee_attack_charged = false,
		vce_melee_attack_charged_long = false,
		vce_melee_attack_short = false,
		vce_mocking_laughter = false,
	},
}

table.add_missing(sound_data.events, RenegadeCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, RenegadeCommonSounds.use_proximity_culling)

return sound_data
