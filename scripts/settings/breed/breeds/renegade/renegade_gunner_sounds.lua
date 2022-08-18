local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sounds = {
	footstep_land = "wwise/events/minions/play_footstep_boots_land_medium_enemy",
	footstep = "wwise/events/minions/play_footstep_boots_medium_enemy",
	swing = "wwise/events/weapon/play_minion_swing_1h_sword",
	run_foley = "wwise/events/minions/play_enemy_guard_shocktrooper_movement_foley"
}

table.add_missing(sounds, RenegadeCommonSounds)

return sounds
