-- chunkname: @scripts/settings/breed/breeds/chaos/chaos_ogryn_bulwark_sounds.lua

local ChaosOgrynCommonSounds = require("scripts/settings/breed/breeds/chaos/chaos_ogryn_common_sounds")
local sound_data = {
	events = {
		vce_short_attack = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__melee_attack_vce",
		vce_death = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__death_vce",
		vce_special_attack = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__special_attack_vce",
		stop_vce = "wwise/events/minions/stop_all_chaos_ogryn_bulwark_vce",
		left_gear_foley = "wwise/events/minions/play_enemy_gear_large_metal_shield_foley",
		vce_long_attack = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__special_attack_vce",
		vce_hurt = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__hurt_vce",
		vce_grunt = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__grunt_vce",
		swing = "wwise/events/minions/play_combat_weapon_bulwark_shield_swing",
		foley_drastic = "wwise/events/minions/play_enemy_bulwark_ogryn_foley_drastic_short",
		vce_running_breaths = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__running_breath_vce",
		foley_movement_long = "wwise/events/minions/play_enemy_bulwark_ogryn_foley_movement_long",
		hit_own_shield = "wwise/events/minions/play_weapon_bulwark_shield_hit",
		vce_grunt_long = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__grunt_long_vce"
	},
	use_proximity_culling = {
		vce_short_attack = false,
		vce_long_attack = false,
		vce_special_attack = false,
		foley_drastic = false
	}
}

table.add_missing(sound_data.events, ChaosOgrynCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, ChaosOgrynCommonSounds.use_proximity_culling)

return sound_data
