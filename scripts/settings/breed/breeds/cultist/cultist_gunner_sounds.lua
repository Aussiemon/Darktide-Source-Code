local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sounds = {
	footstep_land = "wwise/events/minions/play_minion_footsteps_barefoot_land",
	vce_death = "wwise/events/minions/play_enemy_cultist_gunner__death_quick_vce",
	vce_breathing_running = "wwise/events/minions/play_enemy_cultist_gunner__breathing_running_vce",
	stop_vce = "wwise/events/minions/stop_all_enemy_cultist_gunner_vce",
	vce_death_long = "wwise/events/minions/play_enemy_cultist_gunner__death_quick_vce",
	vce_hurt = "wwise/events/minions/play_enemy_cultist_gunner__hurt_vce",
	vce_grunt = "wwise/events/minions/play_enemy_cultist_gunner__stagger_vce",
	vce_death_gassed = "wwise/events/minions/play_enemy_cultist_gunner__death_quick_vce",
	swing = "wwise/events/weapon/play_minion_swing_1h_sword",
	footstep = "wwise/events/minions/play_minion_footsteps_wrapped_feet",
	run_foley = "wwise/events/minions/play_shared_minion_cloth_leather_run_foley"
}

table.add_missing(sounds, RenegadeCommonSounds)

return sounds
