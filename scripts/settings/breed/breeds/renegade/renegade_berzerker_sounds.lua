local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sounds = {
	vce_melee_attack_anim_attack_01 = "wwise/events/minions/play_enemy_cultist_berzerker__melee_attack_anim_attack_01_vce",
	vce_death = "wwise/events/minions/play_enemy_cultist_berzerker__death_vce",
	vce_breathing_running = "wwise/events/minions/play_enemy_cultist_berzerker__breathing_running_vce",
	stop_vce = "wwise/events/minions/stop_all_enemy_cultist_berzerker_vce",
	swing_large = "wwise/events/weapon/play_minion_swing_2h_sword_elite",
	foley_drastic_long = "wwise/events/minions/play_shared_foley_traitor_guard_medium_drastic_long",
	vce_melee_attack_final_vce = "wwise/events/minions/play_enemy_cultist_berzerker__melee_attack_final_vce",
	swing = "wwise/events/weapon/play_minion_swing_1h_sword_elite",
	vce_melee_attack_short = "wwise/events/minions/play_enemy_cultist_berzerker__melee_attack_short_vce",
	footstep_land = "wwise/events/minions/play_minion_footsteps_boots_heavy_land",
	ground_impact = "wwise/events/minions/play_enemy_foley_body_impact_medium_ground",
	foley_drastic_short = "wwise/events/minions/play_shared_foley_traitor_guard_medium_drastic_short",
	vce_hurt = "wwise/events/minions/play_enemy_cultist_berzerker__hurt_vce",
	vce_melee_attack_anim_combo_attack_01 = "wwise/events/minions/play_enemy_cultist_berzerker_a__melee_attack_anim_combo_01_vce",
	vce_melee_attack_normal = "wwise/events/minions/play_enemy_cultist_berzerker__melee_attack_normal_vce",
	footstep = "wwise/events/minions/play_minion_footsteps_boots_heavy",
	run_foley = "wwise/events/minions/play_shared_foley_elite_run"
}

table.add_missing(sounds, RenegadeCommonSounds)

return sounds
