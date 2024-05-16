-- chunkname: @scripts/settings/breed/breeds/chaos/chaos_ogryn_bulwark_sounds.lua

local ChaosOgrynCommonSounds = require("scripts/settings/breed/breeds/chaos/chaos_ogryn_common_sounds")
local sound_data = {
	events = {
		foley_drastic = "wwise/events/minions/play_enemy_bulwark_ogryn_foley_drastic_short",
		foley_movement_long = "wwise/events/minions/play_enemy_bulwark_ogryn_foley_movement_long",
		hit_own_shield = "wwise/events/minions/play_weapon_bulwark_shield_hit",
		left_gear_foley = "wwise/events/minions/play_enemy_gear_large_metal_shield_foley",
		stop_vce = "wwise/events/minions/stop_all_chaos_ogryn_bulwark_vce",
		swing = "wwise/events/minions/play_combat_weapon_bulwark_shield_swing",
		vce_death = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__death_vce",
		vce_grunt = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__grunt_vce",
		vce_grunt_long = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__grunt_long_vce",
		vce_hurt = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__hurt_vce",
		vce_long_attack = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__special_attack_vce",
		vce_running_breaths = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__running_breath_vce",
		vce_short_attack = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__melee_attack_vce",
		vce_special_attack = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__special_attack_vce",
	},
	use_proximity_culling = {
		foley_drastic = false,
		vce_long_attack = false,
		vce_short_attack = false,
		vce_special_attack = false,
	},
}

table.add_missing(sound_data.events, ChaosOgrynCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, ChaosOgrynCommonSounds.use_proximity_culling)

return sound_data
