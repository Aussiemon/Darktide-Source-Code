local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sounds = {
	foley_drastic_long = "wwise/events/minions/play_shared_foley_chaos_cultist_light_drastic_long",
	vce_death = "wwise/events/minions/play_enemy_cultist_flamer__death_quick_vce",
	run_foley = "wwise/events/minions/play_shared_foley_chaos_cultist_light_run",
	stop_vce = "wwise/events/minions/stop_all_enemy_cultist_flamer_vce",
	vce_death_long = "wwise/events/minions/play_enemy_cultist_flamer__death_quick_vce",
	footstep_land = "wwise/events/minions/play_minion_footsteps_barefoot_land",
	vce_hurt = "wwise/events/minions/play_enemy_cultist_flamer_hurt_vce",
	vce_grunt = "wwise/events/minions/play_enemy_cultist_flamer_grunt_vce",
	run_foley_special = "wwise/events/minions/play_enemy_cultist_flamer_foley_tank",
	vce_death_gassed = "wwise/events/minions/play_enemy_cultist_flamer__death_quick_vce",
	vce_breathing_running = "wwise/events/minions/play_enemy_cultist_flamer__breathing_running_vce",
	footstep_special = "wwise/events/minions/play_minion_footsteps_wrapped_feet_specials",
	foley_movement_short = "wwise/events/minions/play_shared_foley_chaos_cultist_light_drastic_short"
}

table.add_missing(sounds, RenegadeCommonSounds)

return sounds
