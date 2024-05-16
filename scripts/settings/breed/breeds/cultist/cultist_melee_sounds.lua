-- chunkname: @scripts/settings/breed/breeds/cultist/cultist_melee_sounds.lua

local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sound_data = {
	events = {
		foley_drastic_long = "wwise/events/minions/play_shared_foley_chaos_cultist_light_drastic_long",
		foley_drastic_short = "wwise/events/minions/play_shared_foley_chaos_cultist_light_drastic_short",
		footstep = "wwise/events/minions/play_minion_footsteps_wrapped_feet",
		footstep_land = "wwise/events/minions/play_minion_footsteps_barefoot_land",
		run_foley = "wwise/events/minions/play_shared_foley_chaos_cultist_light_run",
		stop_vce = "wwise/events/minions/stop_all_cultist_melee_fighter_vce",
		swing = "wwise/events/weapon/play_minion_swing_1h_sword",
		swing_foley = "wwise/events/minions/play_shared_foley_chaos_cultist_light_drastic_short",
		vce_breathing_running = "wwise/events/minions/play_enemy_cultist_melee_fighter__breathing_running_vce",
		vce_death = "wwise/events/minions/play_enemy_cultist_melee_fighter__death_quick_vce",
		vce_death_burning = "wwise/events/minions/play_enemy_cultist_melee_fighter__death_long_vce",
		vce_death_gassed = "wwise/events/minions/play_enemy_cultist_melee_fighter__death_long_gassed_vce",
		vce_death_long = "wwise/events/minions/play_enemy_cultist_melee_fighter__death_long_vce",
		vce_grunt = "wwise/events/minions/play_enemy_cultist_melee_fighter__grunt_vce",
		vce_hurt = "wwise/events/minions/play_enemy_cultist_melee_fighter__hurt_vce",
		vce_melee_attack_charged = "wwise/events/minions/play_enemy_cultist_melee_fighter__melee_attack_charged_vce",
		vce_melee_attack_short = "wwise/events/minions/play_enemy_cultist_melee_fighter__melee_attack_vce",
		vce_passive_idle_aggro = "wwise/events/minions/play_enemy_cultist_melee_fighter_idle_aggro_vce",
		vce_passive_idle_cough = "wwise/events/minions/play_enemy_cultist_melee_fighter__idle_cough_vce",
		vce_passive_idle_itchy = "wwise/events/minions/play_enemy_cultist_melee_fighter__idle_itchy_vce",
	},
	use_proximity_culling = {
		stop_vce = false,
		vce_melee_attack_charged = false,
		vce_melee_attack_short = false,
	},
}

table.add_missing(sound_data.events, RenegadeCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, RenegadeCommonSounds.use_proximity_culling)

return sound_data
