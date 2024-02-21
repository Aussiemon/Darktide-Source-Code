local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sound_data = {
	events = {
		vce_melee_attack_anim_attack_01 = "wwise/events/minions/play_enemy_cultist_berzerker__melee_attack_anim_attack_01_vce",
		vce_death = "wwise/events/minions/play_enemy_cultist_berzerker__death_vce",
		vce_melee_attack_anim_combo_attack_01 = "wwise/events/minions/play_enemy_cultist_berzerker_a__melee_attack_anim_combo_01_vce",
		stop_vce = "wwise/events/minions/stop_all_enemy_cultist_berzerker_vce",
		swing_large = "wwise/events/weapon/play_minion_swing_2h_sword_elite",
		vce_breathing_running = "wwise/events/minions/play_enemy_cultist_berzerker__breathing_running_vce",
		foley_drastic_long = "wwise/events/minions/play_shared_foley_chaos_cultist_light_drastic_long",
		vce_combat_idle = "wwise/events/minions/play_enemy_cultist_berzerker__combat_idle_vce",
		vce_melee_attack_short = "wwise/events/minions/play_enemy_cultist_berzerker__melee_attack_short_vce",
		swing = "wwise/events/weapon/play_minion_swing_1h_sword_elite",
		vce_melee_attack_final_vce = "wwise/events/minions/play_enemy_cultist_berzerker__melee_attack_final_vce",
		footstep_land = "wwise/events/minions/play_minion_footsteps_barefoot_land",
		foley_drastic_short = "wwise/events/minions/play_shared_foley_chaos_cultist_light_drastic_short",
		vce_hurt = "wwise/events/minions/play_enemy_cultist_berzerker__hurt_vce",
		vce_grunt = "wwise/events/minions/play_enemy_cultist_berzerker__grunt_vce",
		vce_melee_attack_normal = "wwise/events/minions/play_enemy_cultist_berzerker__melee_attack_normal_vce",
		footstep = "wwise/events/minions/play_minion_footsteps_wrapped_feet_specials",
		run_foley = "wwise/events/minions/play_shared_foley_chaos_cultist_light_run"
	},
	use_proximity_culling = {
		footstep_land = false,
		vce_melee_attack_final_vce = false,
		swing_large = false,
		stop_vce = false,
		vce_melee_attack_anim_attack_01 = false,
		vce_breathing_running = false,
		vce_combat_idle = false,
		vce_melee_attack_anim_combo_attack_01 = false,
		vce_melee_attack_normal = false,
		footstep = false,
		swing = false,
		vce_melee_attack_short = false
	}
}

table.add_missing(sound_data.events, RenegadeCommonSounds.events)
table.add_missing(sound_data.use_proximity_culling, RenegadeCommonSounds.use_proximity_culling)

return sound_data
