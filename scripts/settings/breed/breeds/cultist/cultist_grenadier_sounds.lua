local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sound_data = {
	events = {
		foley_drastic_long = "wwise/events/minions/play_shared_foley_chaos_cultist_light_drastic_long",
		vce_death = "wwise/events/minions/play_enemy_cultist_grenadier__death_quick_vce",
		run_foley_special = "wwise/events/minions/play_cultist_grenadier_run_foley",
		footstep_land = "wwise/events/minions/play_minion_footsteps_barefoot_land",
		vce_death_long = "wwise/events/minions/play_enemy_cultist_grenadier__death_long_vce",
		vce_kick = "wwise/events/minions/play_enemy_cultist_grenadier__grunt_vce",
		vce_hurt = "wwise/events/minions/play_enemy_cultist_grenadier__hurt_vce",
		vce_grunt = "wwise/events/minions/play_enemy_cultist_grenadier__grunt_vce",
		pull_sprint = "wwise/events/minions/play_cultist_grenadier_pull_sprint",
		vce_stop = "wwise/events/minions/stop_all_cultist_grenadier_vce",
		footstep = "wwise/events/minions/play_minion_footsteps_wrapped_feet_specials",
		run_foley = "wwise/events/minions/play_shared_minion_cloth_leather_run_foley"
	},
	use_proximity_culling = {
		pull_sprint = false,
		vce_death = false,
		vce_death_long = false,
		footstep = false,
		vce_hurt = false,
		run_foley_special = false
	}
}

table.add_missing(sound_data.events, RenegadeCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, RenegadeCommonSounds.use_proximity_culling)

return sound_data
