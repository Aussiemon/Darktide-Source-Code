-- chunkname: @scripts/settings/breed/breeds/chaos/chaos_ogryn_gunner_sounds.lua

local ChaosOgrynCommonSounds = require("scripts/settings/breed/breeds/chaos/chaos_ogryn_common_sounds")
local sound_data = {
	events = {
		foley_drastic = "wwise/events/minions/play_chaos_ogryn_heavy_gunner_foley_drastic_short",
		foley_movement_long = "wwise/events/minions/play_shared_foley_chaos_ogryn_elites_medium_movement_long",
		stop_vce = "wwise/events/minions/stop_all_enemy_chaos_ogryn_heavy_gunner",
		vce_death = "wwise/events/minions/play_enemy_chaos_ogryn_heavy_gunner__death_vce",
		vce_death_long = "wwise/events/minions/play_enemy_chaos_ogryn_heavy_gunner__death_long_vce",
		vce_grunt = "wwise/events/minions/play_enemy_chaos_ogryn_heavy_gunner__hurt_vce",
		vce_hurt = "wwise/events/minions/play_enemy_chaos_ogryn_heavy_gunner__hurt_vce",
		vce_short_attack = "wwise/events/minions/play_enemy_chaos_ogryn_heavy_gunner__melee_attack_vce",
	},
	use_proximity_culling = {},
}

table.add_missing(sound_data.events, ChaosOgrynCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, ChaosOgrynCommonSounds.use_proximity_culling)

return sound_data
