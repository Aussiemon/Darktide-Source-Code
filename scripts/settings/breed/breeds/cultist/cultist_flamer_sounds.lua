-- chunkname: @scripts/settings/breed/breeds/cultist/cultist_flamer_sounds.lua

local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sound_data = {
	events = {
		foley_drastic_long = "wwise/events/minions/play_shared_foley_chaos_cultist_light_drastic_long",
		foley_movement_short = "wwise/events/minions/play_shared_foley_chaos_cultist_light_drastic_short",
		footstep = "wwise/events/minions/play_minion_footsteps_wrapped_feet_specials",
		footstep_land = "wwise/events/minions/play_minion_footsteps_barefoot_land",
		run_foley = "wwise/events/minions/play_shared_foley_chaos_cultist_light_run",
		run_foley_special = "wwise/events/minions/play_enemy_cultist_flamer_foley_tank",
		stop_vce = "wwise/events/minions/stop_all_enemy_cultist_flamer_vce",
		vce_breathing_running = "wwise/events/minions/play_enemy_cultist_flamer__breathing_running_vce",
		vce_death = "wwise/events/minions/play_enemy_cultist_flamer__death_quick_vce",
		vce_death_gassed = "wwise/events/minions/play_enemy_cultist_flamer__death_quick_vce",
		vce_death_long = "wwise/events/minions/play_enemy_cultist_flamer__death_quick_vce",
		vce_grunt = "wwise/events/minions/play_enemy_cultist_flamer_grunt_vce",
		vce_hurt = "wwise/events/minions/play_enemy_cultist_flamer_hurt_vce",
	},
	use_proximity_culling = {
		footstep = false,
		footstep_land = false,
		run_foley_special = false,
		stop_vce = false,
		vce_death = false,
		vce_death_long = false,
		vce_hurt = false,
	},
}

table.add_missing(sound_data.events, RenegadeCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, RenegadeCommonSounds.use_proximity_culling)

return sound_data
