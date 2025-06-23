-- chunkname: @scripts/settings/breed/breeds/chaos/chaos_ogryn_executor_sounds.lua

local ChaosOgrynCommonSounds = require("scripts/settings/breed/breeds/chaos/chaos_ogryn_common_sounds")
local sound_data = {
	events = {
		foley_drastic = "wwise/events/minions/play_shared_foley_chaos_ogryn_elites_heavy_drastic_short",
		vce_death = "wwise/events/minions/play_enemy_chaos_ogryn_armoured_executor_a__death_vce",
		vce_special_attack = "wwise/events/minions/play_enemy_chaos_ogryn_armoured_executor_a__special_attack_vce",
		stop_vce = "wwise/events/minions/stop_all_chaos_ogryn_executor_vce",
		executor_sweep = "wwise/events/weapon/play_minion_swing_2h_blunt_large_sweep",
		vce_long_attack = "wwise/events/minions/play_enemy_chaos_ogryn_armoured_executor_a__special_attack_vce",
		vce_hurt = "wwise/events/minions/play_enemy_chaos_ogryn_armoured_executor_a__hurt_vce",
		vce_grunt = "wwise/events/minions/play_enemy_chaos_ogryn_armoured_executor_a__grunt_vce",
		executor_cleave = "wwise/events/weapon/play_minion_swing_2h_blunt_large_cleave",
		vce_running_breaths = "wwise/events/minions/play_enemy_chaos_ogryn_armoured_executor_a__running_breath_vce",
		vce_short_attack = "wwise/events/minions/play_enemy_chaos_ogryn_armoured_executor_a__melee_attack_vce",
		foley_movement_long = "wwise/events/minions/play_shared_foley_chaos_ogryn_elites_heavy_movement_long",
		ground_impact = "wwise/events/minions/play_shared_foley_armoured_body_fall_large",
		run_foley = "wwise/events/minions/play_shared_foley_chaos_ogryn_elites_heavy_run"
	},
	use_proximity_culling = {
		vce_short_attack = false,
		foley_drastic = false,
		vce_special_attack = false,
		executor_cleave = false,
		executor_sweep = false,
		vce_long_attack = false
	}
}

table.add_missing(sound_data.events, ChaosOgrynCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, ChaosOgrynCommonSounds.use_proximity_culling)

return sound_data
