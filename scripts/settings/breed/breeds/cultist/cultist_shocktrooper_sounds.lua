local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sounds = {
	footstep_land = "wwise/events/minions/play_minion_footsteps_barefoot_land",
	vce_death = "wwise/events/minions/play_enemy_cultist_shocktrooper_a__death_quick",
	stop_vce = "wwise/events/minions/stop_all_enemy_cultist_shocktrooper_a_vce",
	vce_stagger = "wwise/events/minions/play_enemy_cultist_shocktrooper_a__stagger",
	vce_melee_attack = "wwise/events/minions/play_enemy_cultist_shocktrooper_a__melee_attack",
	vce_hurt = "wwise/events/minions/play_enemy_cultist_shocktrooper_a__hurt",
	swing = "wwise/events/weapon/play_minion_swing_1h_sword",
	footstep = "wwise/events/minions/play_minion_footsteps_wrapped_feet",
	run_foley = "wwise/events/minions/play_shared_minion_cloth_leather_run_foley"
}

table.add_missing(sounds, RenegadeCommonSounds)

return sounds
