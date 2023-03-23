local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sound_data = {
	events = {
		vce_melee_attack_short = "wwise/events/minions/play_enemy_traitor_scout_shocktrooper_melee_attack_short_vce",
		vce_death = "wwise/events/minions/play_enemy_traitor_scout_shocktrooper_death_quick_vce",
		stop_vce = "wwise/events/minions/stop_all_traitor_guard_shocktrooper_vce",
		vce_death_long = "wwise/events/minions/play_enemy_traitor_scout_shocktrooper_death_long_vce",
		vce_hurt = "wwise/events/minions/play_enemy_traitor_scout_shocktrooper_hurt_vce",
		vce_grunt = "wwise/events/minions/play_enemy_traitor_scout_shocktrooper_grunt_vce",
		vce_death_gassed = "wwise/events/minions/play_enemy_traitor_scout_shocktrooper_death_long_gassed_vce",
		swing = "wwise/events/weapon/play_minion_swing_1h_sword",
		vce_suppressed = "wwise/events/minions/play_enemy_traitor_scout_shocktrooper_suppressed_vce",
		run_foley = "wwise/events/minions/play_shared_foley_traitor_guard_heavy_run_type_2"
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
