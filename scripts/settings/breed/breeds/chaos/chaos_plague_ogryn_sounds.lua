﻿-- chunkname: @scripts/settings/breed/breeds/chaos/chaos_plague_ogryn_sounds.lua

local sound_data = {
	events = {
		foley = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_movement_foley",
		foley_belly = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_belly_bounce",
		footstep = "wwise/events/minions/play_footstep_boots_heavy_plague_ogryn",
		ground_impact = "wwise/events/minions/play_enemy_foley_body_impact_large_ground",
		sfx_enemy_vce_run_noise = "wwise/events/minions/play_enemy_plague_ogryn_vce_run_noise",
		sfx_footstep_land = "wwise/events/minions/play_plague_ogryn_footsteps_land",
		sfx_footstep_slide = "wwise/events/minions/play_plague_ogryn_footstep_slide",
	},
	use_proximity_culling = {
		footstep = false,
		sfx_enemy_vce_run_noise = false,
		sfx_footstep_land = false,
	},
}

return sound_data
