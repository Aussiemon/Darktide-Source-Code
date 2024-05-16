-- chunkname: @scripts/settings/breed/breeds/renegade/renegade_executor_sounds.lua

local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sound_data = {
	events = {
		foley_movement_long = "wwise/events/minions/play_shared_foley_chaos_ogryn_elites_heavy_movement_long",
		footstep = "wwise/events/minions/play_minion_footsteps_boots_heavy",
		footstep_land = "wwise/events/minions/play_minion_footsteps_boots_heavy_land",
		ground_impact = "wwise/events/minions/play_shared_foley_armoured_body_fall_medium",
		run_foley = "wwise/events/minions/play_shared_foley_traitor_guard_heavy_run",
		swing = "wwise/events/weapon/play_minion_swing_chainaxe",
		swing_foley = "wwise/events/minions/play_shared_foley_chaos_ogryn_elites_medium_drastic_short",
		vce_breathing_running = "wwise/events/minions/play_enemy_traitor_executor__running_breath_vce",
		vce_death = "wwise/events/minions/play_enemy_traitor_executor__death_quick_vce",
		vce_death_gassed = "wwise/events/minions/play_enemy_traitor_executor__death_long_gassed_vce",
		vce_death_long = "wwise/events/minions/play_enemy_traitor_executor__death_long_vce",
		vce_grunt = "wwise/events/minions/play_enemy_traitor_executor__grunt_vce",
		vce_hurt = "wwise/events/minions/play_enemy_traitor_executor__hurt_vce",
		vce_melee_attack_short = "wwise/events/minions/play_enemy_traitor_executor__melee_attack_short_vce",
		vce_special_attack = "wwise/events/minions/play_enemy_traitor_executor__special_attack_vce",
	},
	use_proximity_culling = {
		footstep = false,
		footstep_land = false,
		swing = false,
		vce_melee_attack_short = false,
		vce_special_attack = false,
	},
}

table.add_missing(sound_data.events, RenegadeCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, RenegadeCommonSounds.use_proximity_culling)

return sound_data
