-- chunkname: @scripts/settings/breed/breeds/chaos/chaos_ogryn_houndmaster_sounds.lua

local ChaosOgrynCommonSounds = require("scripts/settings/breed/breeds/chaos/chaos_ogryn_common_sounds")
local sound_data = {
	events = {
		executor_cleave = "wwise/events/minions/play_chaos_hound_master_charge",
		executor_sweep = "wwise/events/minions/play_minion_houndmaster_blunt_large_cleave",
		foley_drastic = "wwise/events/minions/play_chaos_hound_master_foley",
		foley_movement_long = "wwise/events/minions/play_chaos_hound_master_foley",
		footstep = "wwise/events/minions/play_chaos_spawn_big_step",
		footstep_land = "wwise/events/minions/play_chaos_spawn_leap_land",
		ground_impact = "wwise/events/minions/play_shared_foley_armoured_body_fall_large",
		run_foley = "wwise/events/minions/play_chaos_hound_master_foley",
		stop_vce = "wwise/events/minions/stop_all_enemy_chaos_ogryn_houndmaster",
		swing = "wwise/events/minions/play_chaos_hound_master_swing_rod",
		vce_death = "wwise/events/minions/play_enemy_chaos_ogryn_houndmaster__death_vce",
		vce_grunt = "wwise/events/minions/play_enemy_hound_master_vce_idle_breath",
		vce_grunt_long = "wwise/events/minions/play_chaos_hound_master_taunt_vce",
		vce_hurt = "wwise/events/minions/play_enemy_chaos_ogryn_houndmaster__hurt_vce",
		vce_long_attack = "wwise/events/minions/play_chaos_hound_master_charge_vce",
		vce_melee_attack_final_vce = "wwise/events/minions/play_enemy_chaos_ogryn_houndmaster__melee_attack_final_vce",
		vce_melee_attack_normal = "wwise/events/minions/play_enemy_chaos_ogryn_houndmaster__melee_attack_normal_vce",
		vce_melee_attack_short = "wwise/events/minions/play_enemy_chaos_ogryn_houndmaster__melee_attack_short_vce",
	},
	use_proximity_culling = {
		vce_long_attack = false,
		vce_melee_attack_final_vce = false,
		vce_melee_attack_normal = false,
		vce_melee_attack_short = false,
	},
}

table.add_missing(sound_data.events, ChaosOgrynCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, ChaosOgrynCommonSounds.use_proximity_culling)

return sound_data
