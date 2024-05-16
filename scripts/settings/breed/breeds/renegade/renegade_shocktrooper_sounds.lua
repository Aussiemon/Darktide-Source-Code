-- chunkname: @scripts/settings/breed/breeds/renegade/renegade_shocktrooper_sounds.lua

local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sound_data = {
	events = {
		run_foley = "wwise/events/minions/play_shared_foley_traitor_guard_heavy_run_type_2",
		stop_vce = "wwise/events/minions/stop_all_traitor_guard_shocktrooper_vce",
		swing = "wwise/events/weapon/play_minion_swing_1h_sword",
		vce_death = "wwise/events/minions/play_enemy_traitor_scout_shocktrooper_death_quick_vce",
		vce_death_gassed = "wwise/events/minions/play_enemy_traitor_scout_shocktrooper_death_long_gassed_vce",
		vce_death_long = "wwise/events/minions/play_enemy_traitor_scout_shocktrooper_death_long_vce",
		vce_grunt = "wwise/events/minions/play_enemy_traitor_scout_shocktrooper_grunt_vce",
		vce_hurt = "wwise/events/minions/play_enemy_traitor_scout_shocktrooper_hurt_vce",
		vce_melee_attack_short = "wwise/events/minions/play_enemy_traitor_scout_shocktrooper_melee_attack_short_vce",
		vce_suppressed = "wwise/events/minions/play_enemy_traitor_scout_shocktrooper_suppressed_vce",
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
