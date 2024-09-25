-- chunkname: @scripts/settings/breed/breeds/renegade/renegade_captain_sounds.lua

local sound_data = {
	events = {
		charge = "wwise/events/weapon/play_minion_captain_powersword_charge",
		foley_drastic_long = "wwise/events/minions/play_shared_foley_traitor_guard_medium_drastic_long",
		foley_drastic_short = "wwise/events/minions/play_minion_captain_drastic_short",
		foley_movement_short = "wwise/events/minions/play_minion_captain_foley_short",
		footstep = "wwise/events/minions/play_minion_captain_footsteps",
		footstep_land = "wwise/events/minions/play_minion_captain_footsteps_land",
		ground_impact = "wwise/events/minions/play_enemy_foley_body_impact_large_ground",
		run_foley = "wwise/events/minions/play_shared_foley_traitor_guard_medium_run",
		sprint_start = "wwise/events/minions/play_minion_captain_sprint_start",
		vce_breathing_running = "wwise/events/minions/play_minion_captain__breathing_running_vce",
		vce_combo_attack_single = "wwise/events/minions/play_minion_captain__combo_attack_single_vce",
		vce_death_quick = "wwise/events/minions/play_minion_captain__death_quick_vce",
		vce_force_field_overload = "wwise/events/minions/play_minion_captain__force_field_overload_vce",
		vce_grunt = "wwise/events/minions/play_minion_captain__grunt_vce",
		vce_hurt = "wwise/events/minions/play_minion_captain__hurt_vce",
		vce_kick = "wwise/events/minions/play_minion_captain__kick_vce",
		vce_melee_attack_charged = "wwise/events/minions/play_minion_captain__melee_attack_charged_vce",
		vce_melee_attack_charged_long = "wwise/events/minions/play_minion_captain__melee_attack_charged_long_vce",
		vce_melee_attack_short = "wwise/events/minions/play_minion_captain__melee_attack_short_vce",
		vce_mocking_laughter = "wwise/events/minions/play_minion_captain__mocking_laughter_vce",
		equip_melee = {
			slot_power_sword = "wwise/events/minions/play_minion_captain_equip_sword",
			slot_powermaul = "wwise/events/minions/play_minion_captain_equip_maul",
		},
		swing_heavy = {
			slot_power_sword = "wwise/events/weapon/play_minion_captain_swing_powered",
			slot_powermaul = "wwise/events/weapon/play_minion_captain_swing_powered",
		},
		swing = {
			slot_power_sword = "wwise/events/weapon/play_minion_captain_swing",
			slot_powermaul = "wwise/events/weapon/play_minion_captain_swing",
		},
		swing_start = {
			slot_power_sword = "wwise/events/minions/play_minion_captain_swing_light_charge",
			slot_powermaul = "wwise/events/minions/play_minion_captain_light_charge_start",
		},
	},
	use_proximity_culling = {
		charge = false,
		footstep = false,
		footstep_land = false,
		swing = false,
		swing_heavy = false,
		vce_breathing_running = false,
		vce_combo_attack_single = false,
		vce_death_quick = false,
		vce_force_field_overload = false,
		vce_grunt = false,
		vce_hurt = false,
		vce_kick = false,
		vce_melee_attack_charged = false,
		vce_melee_attack_charged_long = false,
		vce_melee_attack_short = false,
		vce_mocking_laughter = false,
	},
}

return sound_data
