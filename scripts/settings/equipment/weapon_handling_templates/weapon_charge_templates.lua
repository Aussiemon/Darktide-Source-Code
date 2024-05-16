-- chunkname: @scripts/settings/equipment/weapon_handling_templates/weapon_charge_templates.lua

local weapon_charge_templates = {
	lasgun_p2_m1_charge_up = {
		charge_delay = 0,
		charge_on_action_start = true,
		limit_max_charge_to_ammo_clip = true,
		max_ammo_charge = 6,
		charge_duration = {
			lerp_basic = 0.8,
			lerp_perfect = 0.4,
		},
	},
	lasgun_p2_m2_charge_up = {
		charge_delay = 0,
		charge_on_action_start = true,
		limit_max_charge_to_ammo_clip = true,
		max_ammo_charge = 4,
		charge_duration = {
			lerp_basic = 0.65,
			lerp_perfect = 0.25,
		},
	},
	lasgun_p2_m3_charge_up = {
		charge_delay = 0,
		charge_on_action_start = true,
		limit_max_charge_to_ammo_clip = true,
		max_ammo_charge = 9,
		charge_duration = {
			lerp_basic = 1,
			lerp_perfect = 0.5,
		},
	},
	plasmagun_p1_m1_charge_direct = {
		charge_on_action_start = true,
		extra_overheat_percent = 0.025,
		fully_charged_charge_level = 0.525,
		limit_max_charge_to_ammo_clip = true,
		min_charge = 0.05,
		charge_duration = {
			lerp_basic = 1,
			lerp_perfect = 0.5,
		},
		overheat_percent = {
			lerp_basic = 0.09,
			lerp_perfect = 0.045,
		},
	},
	plasmagun_p1_m1_shoot = {
		use_charge = true,
		overheat_percent = {
			lerp_basic = 0.3,
			lerp_perfect = 0.15,
		},
	},
	plasmagun_p1_m1_shoot_charged = {
		limit_max_charge_to_ammo_clip = true,
		use_charge = true,
		overheat_percent = {
			lerp_basic = 0.4,
			lerp_perfect = 0.2,
		},
	},
	plasmagun_p1_m1_charge = {
		charge_on_action_start = true,
		charge_duration = {
			lerp_basic = 2,
			lerp_perfect = 1,
		},
		overheat_percent = {
			lerp_basic = 0.15,
			lerp_perfect = 0.1,
		},
		extra_overheat_percent = {
			lerp_basic = 0.02,
			lerp_perfect = 0.01,
		},
	},
	psyker_throwing_knives = {
		psyker_smite = true,
		warp_charge_percent = 0.1,
	},
	psyker_throwing_knives_homing = {
		psyker_smite = true,
		warp_charge_percent = 0.25,
	},
	psyker_overcharge_stance_hit = {
		warp_charge_percent = 0.02,
	},
	psyker_overcharge_stance_kill = {
		warp_charge_percent = 0.04,
	},
	psyker_overcharge_stance_passive = {
		use_charge = true,
		warp_charge_percent = 0.00075,
	},
	handgun_push_charge = {
		warp_charge_percent = 0.1,
	},
	psyker_smite_charge = {
		charge_duration = 3,
		charge_on_action_start = true,
		extra_warp_charge_percent = 0.09,
		psyker_smite = true,
		warp_charge_percent = 0.2,
	},
	psyker_smite_lock_target = {
		charge_duration = 3,
		extra_warp_charge_percent = 0.09,
		psyker_smite = true,
		warp_charge_percent = 0.3,
	},
	psyker_smite_use_power = {
		charge_duration = 0.5,
		extra_warp_charge_percent = 0.1,
		psyker_smite = true,
		warp_charge_percent = 0.25,
	},
	forcestaff_p1_m1_charge_aoe = {
		charge_on_action_start = true,
		charge_duration = {
			lerp_basic = 3,
			lerp_perfect = 0.5,
		},
		warp_charge_percent = {
			lerp_basic = 0.3,
			lerp_perfect = 0.15,
		},
		extra_warp_charge_percent = {
			lerp_basic = 0.06,
			lerp_perfect = 0.03,
		},
	},
	forcestaff_p1_m1_use_aoe = {
		use_charge = false,
		warp_charge_percent = {
			lerp_basic = 0.09,
			lerp_perfect = 0.03,
		},
	},
	forcestaff_p1_m1_projectile = {
		warp_charge_percent = {
			lerp_basic = 0.075,
			lerp_perfect = 0.025,
		},
	},
	forcestaff_p2_m1_charge = {
		charge_on_action_start = true,
		charge_duration = {
			lerp_basic = 2,
			lerp_perfect = 1.5,
		},
		warp_charge_percent = {
			lerp_basic = 0.25,
			lerp_perfect = 0.15,
		},
		extra_warp_charge_percent = {
			lerp_basic = 0.05,
			lerp_perfect = 0.03,
		},
	},
	forcestaff_p2_m1_flame_burst = {
		warp_charge_percent = {
			lerp_basic = 0.075,
			lerp_perfect = 0.025,
		},
	},
	forcestaff_p2_m1_flamer_gas = {
		warp_charge_percent = {
			lerp_basic = 0.02,
			lerp_perfect = 0.005,
		},
		charge_cost = {
			lerp_basic = 0.2,
			lerp_perfect = 0.4,
		},
	},
	forcestaff_p3_m1_projectile = {
		warp_charge_percent = {
			lerp_basic = 0.075,
			lerp_perfect = 0.025,
		},
	},
	forcestaff_p3_m1_charge = {
		charge_on_action_start = true,
		charge_duration = {
			lerp_basic = 1.4,
			lerp_perfect = 0.7,
		},
		warp_charge_percent = {
			lerp_basic = 0.2,
			lerp_perfect = 0.1,
		},
		extra_warp_charge_percent = {
			lerp_basic = 0.05,
			lerp_perfect = 0.03,
		},
	},
	forcestaff_p3_m1_chain_lightning = {
		chain_lightning = true,
		warp_charge_percent = {
			lerp_basic = 0.15,
			lerp_perfect = 0.075,
		},
	},
	forcestaff_p4_m1_projectile = {
		warp_charge_percent = {
			lerp_basic = 0.075,
			lerp_perfect = 0.025,
		},
	},
	forcestaff_p4_m1_charged_projectile = {
		warp_charge_percent = {
			lerp_basic = 0.12,
			lerp_perfect = 0.05,
		},
	},
	forcestaff_p4_m1_charge_projectile = {
		charge_on_action_start = true,
		charge_duration = {
			lerp_basic = 2,
			lerp_perfect = 1.5,
		},
		warp_charge_percent = {
			lerp_basic = 0.2,
			lerp_perfect = 0.1,
		},
		extra_warp_charge_percent = {
			lerp_basic = 0.05,
			lerp_perfect = 0.03,
		},
	},
	forcesword_p1_m1_weapon_special_hit = {
		warp_charge_percent = {
			lerp_basic = 0.5,
			lerp_perfect = 0,
		},
	},
	forcesword_p1_m1_charge_single_target = {
		charge_duration = 1,
		charge_on_action_start = true,
		extra_warp_charge_percent = 0.025,
		warp_charge_percent = 0.025,
	},
	forcesword_p1_m1_fling = {
		use_charge = true,
		warp_charge_percent = 0.04,
	},
	forcesword_p1_m1_push = {
		use_charge = true,
		warp_charge_percent = 0.08,
	},
	chain_lightning_ability_spread = {
		charge_duration = 0.1,
		charge_on_action_start = true,
		extra_warp_charge_percent = 0.18,
		warp_charge_percent = 0.0075,
	},
	chain_lightning_ability_activated = {
		charge_duration = 0.001,
		charge_on_action_start = true,
		extra_warp_charge_percent = 0.6,
		warp_charge_percent = 0.6,
	},
	chain_lightning_charge_heavy = {
		charge_duration = 0.8,
		charge_on_action_start = true,
		extra_warp_charge_percent = 0.01,
		warp_charge_percent = 0.05,
	},
	chain_lightning_attack_heavy = {
		charge_duration = 0.5,
		extra_warp_charge_percent = 0.01,
		start_warp_charge_percent = 0.05,
		warp_charge_percent = 0.12,
	},
}

return settings("WeaponChargeTemplates", weapon_charge_templates)
