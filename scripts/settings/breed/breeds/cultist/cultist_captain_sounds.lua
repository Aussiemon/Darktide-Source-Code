-- chunkname: @scripts/settings/breed/breeds/cultist/cultist_captain_sounds.lua

local sound_data = {
	events = {
		vce_combo_attack_single = "wwise/events/minions/play_cultist_captain__combo_attack_single_vce",
		run_foley = "wwise/events/minions/play_shared_foley_traitor_guard_medium_run",
		vce_melee_attack_charged_long = "wwise/events/minions/play_cultist_captain__melee_attack_charged_long_vce",
		foley_drastic_long = "wwise/events/minions/play_shared_foley_traitor_guard_medium_drastic_long",
		vce_melee_attack_charged = "wwise/events/minions/play_cultist_captain__melee_attack_charged_vce",
		foley_movement_short = "wwise/events/minions/play_minion_captain_foley_short",
		vce_charge_sprint = "wwise/events/minions/play_cultist_captain__melee_charge_sprint_vce",
		vce_kick = "wwise/events/minions/play_cultist_captain__kick_vce",
		charge = "wwise/events/weapon/play_minion_captain_powersword_charge",
		vce_melee_attack_short = "wwise/events/minions/play_cultist_captain__melee_attack_short_vce",
		footstep_land = "wwise/events/minions/play_cultist_captain_footsteps_land",
		ground_impact = "wwise/events/minions/play_enemy_foley_body_impact_large_ground",
		foley_drastic_short = "wwise/events/minions/play_foley_cultist_captain_drastic_short",
		vce_death_quick = "wwise/events/minions/play_cultist_captain__death_quick_vce",
		vce_hurt = "wwise/events/minions/play_cultist_captain__hurt_vce",
		vce_grunt = "wwise/events/minions/play_cultist_captain__grunt_vce",
		vce_force_field_overload = "wwise/events/minions/play_cultist_captain__force_field_overload_vce",
		sprint_start = "wwise/events/minions/play_minion_captain_sprint_start",
		footstep = "wwise/events/minions/play_minion_cultist_captain_footsteps",
		equip_melee = {
			slot_power_sword = "wwise/events/minions/play_minion_captain_equip_sword",
			slot_powermaul = "wwise/events/minions/play_minion_captain_equip_maul"
		},
		swing_heavy = {
			slot_power_sword = "wwise/events/weapon/play_minion_captain_swing_powered",
			slot_powermaul = "wwise/events/weapon/play_minion_captain_swing_powered"
		},
		swing = {
			slot_power_sword = "wwise/events/weapon/play_minion_captain_swing",
			slot_powermaul = "wwise/events/weapon/play_minion_captain_swing"
		},
		swing_start = {
			slot_power_sword = "wwise/events/minions/play_minion_captain_swing_light_charge",
			slot_powermaul = "wwise/events/minions/play_minion_captain_light_charge_start"
		}
	},
	use_proximity_culling = {
		vce_combo_attack_single = false,
		swing_heavy = false,
		vce_melee_attack_charged_long = false,
		vce_death_quick = false,
		vce_charge_sprint = false,
		vce_melee_attack_charged = false,
		vce_hurt = false,
		vce_grunt = false,
		vce_kick = false,
		vce_force_field_overload = false,
		charge = false,
		footstep_land = false,
		swing = false,
		footstep = false,
		vce_melee_attack_short = false
	}
}

return sound_data
