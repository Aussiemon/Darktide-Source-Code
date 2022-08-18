local weapon_stamina_templates = {
	default = {
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
	luggable = {
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
			lerp_basic = 1
		}
	},
	lasrifle = {
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
