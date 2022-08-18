local ChaosOgrynCommonSounds = require("scripts/settings/breed/breeds/chaos/chaos_ogryn_common_sounds")
local sounds = {
	vce_short_attack = "wwise/events/minions/play_enemy_chaos_ogryn_heavy_gunner__melee_attack_vce",
	vce_death = "wwise/events/minions/play_enemy_chaos_ogryn_heavy_gunner__death_vce",
	foley_drastic = "wwise/events/minions/play_shared_foley_chaos_ogryn_elites_medium_drastic_short",
	stop_vce = "wwise/events/minions/stop_all_enemy_chaos_ogryn_heavy_gunner",
	vce_death_long = "wwise/events/minions/play_enemy_chaos_ogryn_heavy_gunner__death_long_vce",
	vce_hurt = "wwise/events/minions/play_enemy_chaos_ogryn_heavy_gunner__hurt_vce",
	vce_grunt = "wwise/events/minions/play_enemy_chaos_ogryn_heavy_gunner__hurt_vce",
	foley_movement_long = "wwise/events/minions/play_shared_foley_chaos_ogryn_elites_medium_movement_long",
	run_foley = "wwise/events/minions/play_shared_foley_chaos_ogryn_elites_medium_run"
}

table.add_missing(sounds, ChaosOgrynCommonSounds)

return sounds
