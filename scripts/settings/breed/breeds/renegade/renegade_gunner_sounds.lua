-- chunkname: @scripts/settings/breed/breeds/renegade/renegade_gunner_sounds.lua

local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sound_data = {
	events = {
		footstep_land = "wwise/events/minions/play_minion_footsteps_boots_heavy_land",
		vce_death = "wwise/events/minions/play_enemy_traitor_gunner_death_quick_vce",
		vce_melee_attack_short = "wwise/events/minions/play_enemy_traitor_gunner_melee_attack_vce",
		stop_vce = "wwise/events/minions/stop_all_traitor_gunner_vce",
		vce_death_long = "wwise/events/minions/play_enemy_traitor_gunner_death_long_vce",
		vce_suppressed = "wwise/events/minions/play_enemy_traitor_gunner_supressed_vce",
		vce_hurt = "wwise/events/minions/play_enemy_traitor_gunner_hurt_vce",
		vce_grunt = "wwise/events/minions/play_enemy_traitor_gunner_grunt_vce",
		vce_death_gassed = "wwise/events/minions/play_enemy_traitor_gunner_death_long_vce",
		swing = "wwise/events/weapon/play_minion_swing_1h_sword",
		footstep = "wwise/events/minions/play_minion_footsteps_boots_heavy",
		run_foley = "wwise/events/minions/play_shared_foley_traitor_guard_heavy_run"
	},
	use_proximity_culling = {
		footstep_land = false,
		vce_death = false,
		stop_vce = false,
		vce_death_long = false,
		footstep = false,
		vce_hurt = false
	}
}

table.add_missing(sound_data.events, RenegadeCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, RenegadeCommonSounds.use_proximity_culling)

return sound_data
