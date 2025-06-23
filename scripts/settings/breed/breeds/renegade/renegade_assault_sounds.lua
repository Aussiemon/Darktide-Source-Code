-- chunkname: @scripts/settings/breed/breeds/renegade/renegade_assault_sounds.lua

local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sound_data = {
	events = {
		foley_drastic_long = "wwise/events/minions/play_shared_foley_traitor_guard_light_drastic_long",
		vce_death = "wwise/events/minions/play_enemy_traitor_smg_rusher_death_quick_vce",
		foley_movement_short = "wwise/events/minions/play_shared_foley_traitor_guard_light_movement_short",
		stop_vce = "wwise/events/minions/stop_all_enemy_traitor_smg_rusher_vce",
		vce_death_long = "wwise/events/minions/play_enemy_traitor_smg_rusher_death_long_vce",
		vce_suppressed = "wwise/events/minions/play_enemy_traitor_smg_rusher_suppressed_vce",
		vce_hurt = "wwise/events/minions/play_enemy_traitor_smg_rusher_hurt_vce",
		vce_grunt = "wwise/events/minions/play_enemy_traitor_smg_rusher_grunt_vce",
		pull_sprint = "wwise/events/minions/play_minion_frag_grenade_pull_sprint",
		vce_death_gassed = "wwise/events/minions/play_enemy_traitor_smg_rusher_death_long_gassed_vce",
		vce_melee_attack_charged = "wwise/events/minions/play_enemy_traitor_smg_rusher_melee_attack_charged_vce",
		foley_movement_long = "wwise/events/minions/play_shared_foley_traitor_guard_light_movement_long",
		swing = "wwise/events/weapon/play_minion_swing_1h_sword",
		vce_melee_attack_short = "wwise/events/minions/play_enemy_traitor_smg_rusher_melee_attack_short_vce",
		run_foley = "wwise/events/minions/play_shared_foley_traitor_guard_light_run"
	},
	use_proximity_culling = {
		pull_sprint = false,
		vce_melee_attack_short = false,
		vce_melee_attack_charged = false,
		stop_vce = false
	}
}

table.add_missing(sound_data.events, RenegadeCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, RenegadeCommonSounds.use_proximity_culling)

return sound_data
