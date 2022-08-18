local ChaosOgrynCommonSounds = require("scripts/settings/breed/breeds/chaos/chaos_ogryn_common_sounds")
local sounds = {
	foley_drastic = "wwise/events/minions/play_enemy_bulwark_ogryn_foley_drastic_short",
	vce_death = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__death_vce",
	vce_special_attack = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__special_attack_vce",
	stop_vce = "wwise/events/minions/stop_all_chaos_ogryn_bulwark_vce",
	left_gear_foley = "wwise/events/minions/play_enemy_gear_large_metal_shield_foley",
	vce_long_attack = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__special_attack_vce",
	vce_hurt = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__hurt_vce",
	vce_grunt = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__grunt_vce",
	vce_running_breaths = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__running_breath_vce",
	vce_short_attack = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__melee_attack_vce",
	swing = "wwise/events/minions/play_combat_weapon_bulwark_shield_swing",
	foley_movement_long = "wwise/events/minions/play_enemy_bulwark_ogryn_foley_movement_long",
	hit_own_shield = "wwise/events/minions/play_weapon_bulwark_shield_hit",
	vce_grunt_long = "wwise/events/minions/play_enemy_chaos_ogryn_bulwark_a__grunt_long_vce",
	run_foley = "wwise/events/minions/play_shared_foley_chaos_ogryn_elites_medium_run"
}

table.add_missing(sounds, ChaosOgrynCommonSounds)

return sounds
