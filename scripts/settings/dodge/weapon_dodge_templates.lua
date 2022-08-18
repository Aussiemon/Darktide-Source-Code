local weapon_dodge_templates = {
	default = {
		distance_scale = {
			lerp_perfect = 1,
			lerp_basic = 0.7
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 1,
			lerp_basic = 0.6
		},
		diminishing_return_start = {
			lerp_perfect = 2,
			lerp_basic = 2
		},
		diminishing_return_limit = {
			lerp_perfect = 1,
			lerp_basic = 1
		},
		speed_modifier = {
			lerp_perfect = 1,
			lerp_basic = 1
		}
	},
	psyker = {
		distance_scale = {
			lerp_perfect = 1,
			lerp_basic = 0.7
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 1,
			lerp_basic = 0.6
		},
		diminishing_return_start = {
			lerp_basic = math.huge,
			lerp_perfect = math.huge
		},
		diminishing_return_limit = {
			lerp_perfect = 100,
			lerp_basic = 100
		},
		speed_modifier = {
			lerp_perfect = 1,
			lerp_basic = 1
		}
	},
	default_ranged = {
		speed_modifier = 1,
		diminishing_return_distance_modifier = 0.5,
		diminishing_return_start = 1,
		diminishing_return_limit = 2,
		distance_scale = {
			lerp_perfect = 0.75,
			lerp_basic = 0.7
		}
	},
	ogryn = {
		distance_scale = {
			lerp_perfect = 1,
			lerp_basic = 0.5
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.7,
			lerp_basic = 0.5
		},
		diminishing_return_start = {
			lerp_perfect = 4,
			lerp_basic = 1
		},
		diminishing_return_limit = {
			lerp_perfect = 4,
			lerp_basic = 1
		},
		speed_modifier = {
			lerp_perfect = 1,
			lerp_basic = 0.9
		}
	},
	support = {
		speed_modifier = 1,
		diminishing_return_distance_modifier = 0.6,
		diminishing_return_start = 2,
		diminishing_return_limit = 1,
		distance_scale = {
			lerp_perfect = 0.8,
			lerp_basic = 0.6
		}
	},
	plasma_rifle = {
		speed_modifier = 1,
		diminishing_return_distance_modifier = 0.5,
		diminishing_return_start = 2,
		diminishing_return_limit = 1,
		distance_scale = {
			lerp_perfect = 0.8,
			lerp_basic = 0.6
		}
	},
	killshot = {
		distance_scale = {
			lerp_perfect = 0.65,
			lerp_basic = 0.65
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.1,
			lerp_basic = 0.25
		},
		diminishing_return_start = {
			lerp_perfect = 2,
			lerp_basic = 2
		},
		diminishing_return_limit = {
			lerp_perfect = 2,
			lerp_basic = 2
		},
		speed_modifier = {
			lerp_perfect = 1,
			lerp_basic = 1
		}
	},
	assault = {
		speed_modifier = 1,
		diminishing_return_distance_modifier = 0.5,
		diminishing_return_start = 2,
		diminishing_return_limit = 3,
		distance_scale = {
			lerp_perfect = 1.2,
			lerp_basic = 1
		}
	},
	ninja_m = {
		speed_modifier = 1,
		diminishing_return_distance_modifier = 0.6,
		diminishing_return_start = 3,
		diminishing_return_limit = 4,
		distance_scale = {
			lerp_perfect = 1.2,
			lerp_basic = 1
		}
	}
}

return settings("WeaponDodgeTemplates", weapon_dodge_templates)
