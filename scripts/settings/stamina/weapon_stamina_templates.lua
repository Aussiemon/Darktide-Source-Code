local weapon_stamina_templates = {
	default = {
		stamina_modifier = 4,
		sprint_cost_per_second = {
			lerp_perfect = 0.5,
			lerp_basic = 1.5
		},
		block_cost_default = {
			lerp_perfect = 0.5,
			lerp_basic = 1.5
		},
		push_cost = {
			lerp_perfect = 1,
			lerp_basic = 3
		}
	},
	smiter = {
		stamina_modifier = 3,
		sprint_cost_per_second = {
			lerp_perfect = 0.5,
			lerp_basic = 1.5
		},
		block_cost_default = {
			lerp_perfect = 0.5,
			lerp_basic = 1.5
		},
		push_cost = {
			lerp_perfect = 1,
			lerp_basic = 3
		}
	},
	linesman = {
		stamina_modifier = 4,
		sprint_cost_per_second = {
			lerp_perfect = 0.5,
			lerp_basic = 1.5
		},
		block_cost_default = {
			lerp_perfect = 0.5,
			lerp_basic = 1.5
		},
		push_cost = {
			lerp_perfect = 1,
			lerp_basic = 3
		}
	},
	tank = {
		stamina_modifier = 6,
		sprint_cost_per_second = {
			lerp_perfect = 1,
			lerp_basic = 2
		},
		block_cost_default = {
			lerp_perfect = 0.5,
			lerp_basic = 1
		},
		push_cost = {
			lerp_perfect = 0.75,
			lerp_basic = 2.25
		}
	},
	ninjafencer = {
		stamina_modifier = 1,
		sprint_cost_per_second = {
			lerp_perfect = 0.5,
			lerp_basic = 1
		},
		block_cost_default = {
			lerp_perfect = 0.5,
			lerp_basic = 1.5
		},
		push_cost = {
			lerp_perfect = 0.75,
			lerp_basic = 1.25
		}
	},
	luggable = {
		stamina_modifier = 2,
		sprint_cost_per_second = {
			lerp_perfect = 2,
			lerp_basic = 2
		},
		block_cost_default = {
			lerp_perfect = 1,
			lerp_basic = 2
		},
		push_cost = {
			lerp_perfect = 0.5,
			lerp_basic = 1.5
		}
	},
	lasrifle = {
		stamina_modifier = 2,
		sprint_cost_per_second = {
			lerp_perfect = 1.5,
			lerp_basic = 2
		},
		block_cost_default = {
			lerp_perfect = 1,
			lerp_basic = 2
		},
		push_cost = {
			lerp_perfect = 0.5,
			lerp_basic = 1
		}
	},
	thunderhammer_2h_p1_m1 = {
		stamina_modifier = 2,
		sprint_cost_per_second = {
			lerp_perfect = 1.5,
			lerp_basic = 2
		},
		block_cost_default = {
			lerp_perfect = 1,
			lerp_basic = 2
		},
		push_cost = {
			lerp_perfect = 0.5,
			lerp_basic = 2
		}
	},
	forcesword_p1_m1 = {
		block_break_disorientation_type = "heavy",
		stamina_modifier = 2,
		sprint_cost_per_second = {
			lerp_perfect = 0.5,
			lerp_basic = 1.5
		},
		block_cost_default = {
			lerp_perfect = 2,
			lerp_basic = 3
		},
		block_cost_ranged = {
			lerp_perfect = 0.5,
			lerp_basic = 1
		},
		push_cost = {
			lerp_perfect = 0.5,
			lerp_basic = 1.5
		}
	}
}

return settings("WeaponStaminaTemplates", weapon_stamina_templates)
