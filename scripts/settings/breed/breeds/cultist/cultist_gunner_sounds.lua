-- chunkname: @scripts/settings/breed/breeds/cultist/cultist_gunner_sounds.lua

local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sound_data = {
	events = {
		footstep = "wwise/events/minions/play_minion_footsteps_wrapped_feet_specials",
		footstep_land = "wwise/events/minions/play_minion_footsteps_barefoot_land",
		run_foley = "wwise/events/minions/play_shared_minion_cloth_leather_run_foley",
		stop_vce = "wwise/events/minions/stop_all_enemy_cultist_gunner_vce",
		swing = "wwise/events/weapon/play_minion_swing_1h_sword",
		vce_breathing_running = "wwise/events/minions/play_enemy_cultist_gunner__breathing_running_vce",
		vce_death = "wwise/events/minions/play_enemy_cultist_gunner__death_quick_vce",
		vce_death_gassed = "wwise/events/minions/play_enemy_cultist_gunner__death_quick_vce",
		vce_death_long = "wwise/events/minions/play_enemy_cultist_gunner__death_quick_vce",
		vce_grunt = "wwise/events/minions/play_enemy_cultist_gunner__stagger_vce",
		vce_hurt = "wwise/events/minions/play_enemy_cultist_gunner__hurt_vce",
	},
	use_proximity_culling = {
		footstep = false,
		footstep_land = false,
		stop_vce = false,
		vce_death = false,
		vce_death_long = false,
		vce_hurt = false,
	},
}

table.add_missing(sound_data.events, RenegadeCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, RenegadeCommonSounds.use_proximity_culling)

return sound_data
