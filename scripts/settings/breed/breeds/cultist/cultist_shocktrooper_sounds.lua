-- chunkname: @scripts/settings/breed/breeds/cultist/cultist_shocktrooper_sounds.lua

local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sound_data = {
	events = {
		footstep_land = "wwise/events/minions/play_minion_footsteps_barefoot_land",
		vce_death = "wwise/events/minions/play_enemy_cultist_shocktrooper_a__death_quick_vce",
		vce_melee_attack_short = "wwise/events/minions/play_enemy_cultist_shocktrooper_a__melee_attack_vce",
		stop_vce = "wwise/events/minions/stop_all_enemy_cultist_shocktrooper_a_vce",
		vce_stagger = "wwise/events/minions/play_enemy_cultist_shocktrooper_a__stagger_vce",
		vce_breathing_running = "wwise/events/minions/play_enemy_cultist_shocktrooper_a__breathing_running_vce",
		vce_hurt = "wwise/events/minions/play_enemy_cultist_shocktrooper_a__hurt_vce",
		vce_grunt = "wwise/events/minions/play_enemy_cultist_shocktrooper_a__hurt_vce",
		swing = "wwise/events/weapon/play_minion_swing_1h_sword",
		footstep = "wwise/events/minions/play_minion_footsteps_wrapped_feet",
		run_foley = "wwise/events/minions/play_shared_foley_traitor_guard_heavy_run_type_2"
	},
	use_proximity_culling = {
		footstep_land = false,
		vce_death = false,
		vce_melee_attack_short = false,
		stop_vce = false,
		footstep = false,
		vce_hurt = false
	}
}

table.add_missing(sound_data.events, RenegadeCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, RenegadeCommonSounds.use_proximity_culling)

return sound_data
