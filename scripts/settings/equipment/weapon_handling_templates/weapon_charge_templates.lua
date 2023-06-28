local weapon_charge_templates = {
	lasgun_p2_m1_charge_up = {
		max_ammo_charge = 6,
		limit_max_charge_to_ammo_clip = true,
		charge_on_action_start = true,
		charge_delay = 0,
		charge_duration = {
			lerp_perfect = 0.4,
			lerp_basic = 0.8
		}
	},
	lasgun_p2_m2_charge_up = {
		max_ammo_charge = 4,
		limit_max_charge_to_ammo_clip = true,
		charge_on_action_start = true,
		charge_delay = 0,
		charge_duration = {
			lerp_perfect = 0.25,
			lerp_basic = 0.65
		}
	},
	lasgun_p2_m3_charge_up = {
		max_ammo_charge = 9,
		limit_max_charge_to_ammo_clip = true,
		charge_on_action_start = true,
		charge_delay = 0,
		charge_duration = {
			lerp_perfect = 0.5,
			lerp_basic = 1
		}
	},
	plasmagun_p1_m1_charge_direct = {
		fully_charged_charge_level = 0.5,
		extra_overheat_percent = 0.025,
		limit_max_charge_to_ammo_clip = true,
		charge_on_action_start = true,
		min_charge = 0.05,
		charge_duration = {
			lerp_perfect = 0.5,
			lerp_basic = 1
		},
		overheat_percent = {
			lerp_perfect = 0.045,
			lerp_basic = 0.09
		}
	},
	plasmagun_p1_m1_shoot = {
		use_charge = true,
		overheat_percent = {
			lerp_perfect = 0.15,
			lerp_basic = 0.3
		}
	},
	plasmagun_p1_m1_shoot_charged = {
		use_charge = true,
		limit_max_charge_to_ammo_clip = true,
		overheat_percent = {
			lerp_perfect = 0.2,
			lerp_basic = 0.4
		}
	},
	plasmagun_p1_m1_charge = {
		charge_on_action_start = true,
		charge_duration = {
			lerp_perfect = 1,
			lerp_basic = 2
		},
		overheat_percent = {
			lerp_perfect = 0.1,
			lerp_basic = 0.15
		},
		extra_overheat_percent = {
			lerp_perfect = 0.01,
			lerp_basic = 0.02
		}
	},
	handgun_push_charge = {
		warp_charge_percent = 0.1
	},
	psyker_smite_charge = {
		charge_duration = 3,
		psyker_smite = true,
		warp_charge_percent = 0.3,
		extra_warp_charge_percent = 0.09,
		charge_on_action_start = true
	},
	psyker_smite_lock_target = {
		charge_duration = 3,
		extra_warp_charge_percent = 0.09,
		psyker_smite = true,
		warp_charge_percent = 0.3
	},
	psyker_smite_use_power = {
		charge_duration = 0.5,
		extra_warp_charge_percent = 0.1,
		psyker_smite = true,
		warp_charge_percent = 0.25
	},
	forcestaff_p1_m1_charge_aoe = {
		charge_on_action_start = true,
		charge_duration = {
			lerp_perfect = 0.5,
			lerp_basic = 3
		},
		warp_charge_percent = {
			lerp_perfect = 0.15,
			lerp_basic = 0.3
		},
		extra_warp_charge_percent = {
			lerp_perfect = 0.03,
			lerp_basic = 0.06
		}
	},
	forcestaff_p1_m1_use_aoe = {
		use_charge = false,
		warp_charge_percent = {
			lerp_perfect = 0.03,
			lerp_basic = 0.09
		}
	},
	forcestaff_p1_m1_projectile = {
		warp_charge_percent = {
			lerp_perfect = 0.025,
			lerp_basic = 0.075
		}
	},
	forcestaff_p2_m1_charge = {
		charge_on_action_start = true,
		charge_duration = {
			lerp_perfect = 1.5,
			lerp_basic = 2
		},
		warp_charge_percent = {
			lerp_perfect = 0.15,
			lerp_basic = 0.25
		},
		extra_warp_charge_percent = {
			lerp_perfect = 0.03,
			lerp_basic = 0.05
		}
	},
	forcestaff_p2_m1_flame_burst = {
		warp_charge_percent = {
			lerp_perfect = 0.025,
			lerp_basic = 0.075
		}
	},
	forcestaff_p2_m1_flamer_gas = {
		warp_charge_percent = {
			lerp_perfect = 0.005,
			lerp_basic = 0.02
		},
		charge_cost = {
			lerp_perfect = 0.4,
			lerp_basic = 0.2
		}
	},
	forcestaff_p3_m1_projectile = {
		warp_charge_percent = {
			lerp_perfect = 0.025,
			lerp_basic = 0.075
		}
	},
	forcestaff_p3_m1_charge = {
		charge_on_action_start = true,
		charge_duration = {
			lerp_perfect = 1.5,
			lerp_basic = 3
		},
		warp_charge_percent = {
			lerp_perfect = 0.1,
			lerp_basic = 0.2
		},
		extra_warp_charge_percent = {
			lerp_perfect = 0.03,
			lerp_basic = 0.05
		}
	},
	forcestaff_p3_m1_chain_lightning = {
		chain_lightning = true,
		warp_charge_percent = {
			lerp_perfect = 0.1,
			lerp_basic = 0.2
		}
	},
	forcestaff_p4_m1_projectile = {
		warp_charge_percent = {
			lerp_perfect = 0.025,
			lerp_basic = 0.075
		}
	},
	forcestaff_p4_m1_charged_projectile = {
		warp_charge_percent = {
			lerp_perfect = 0.03,
			lerp_basic = 0.09
		}
	},
	forcestaff_p4_m1_charge_projectile = {
		charge_on_action_start = true,
		charge_duration = {
			lerp_perfect = 1.5,
			lerp_basic = 2
		},
		warp_charge_percent = {
			lerp_perfect = 0.1,
			lerp_basic = 0.2
		},
		extra_warp_charge_percent = {
			lerp_perfect = 0.03,
			lerp_basic = 0.05
		}
	},
	forcesword_p1_m1_weapon_special_hit = {
		warp_charge_percent = {
			lerp_perfect = 0,
			lerp_basic = 0.5
		}
	},
	forcesword_p1_m1_charge_single_target = {
		charge_duration = 1,
		charge_on_action_start = true,
		extra_warp_charge_percent = 0.025,
		warp_charge_percent = 0.025
	},
	forcesword_p1_m1_fling = {
		use_charge = true,
		warp_charge_percent = 0.04
	},
	forcesword_p1_m1_push = {
		use_charge = true,
		warp_charge_percent = 0.08
	}
}

return settings("WeaponChargeTemplates", weapon_charge_templates)
