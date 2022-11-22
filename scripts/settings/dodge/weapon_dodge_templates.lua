local weapon_dodge_templates = {
	default = {
		consecutive_dodges_reset = 0.15,
		distance_scale = {
			lerp_perfect = 1.1,
			lerp_basic = 0.9
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.25,
			lerp_basic = 0.5
		},
		diminishing_return_start = {
			lerp_perfect = 6,
			lerp_basic = 2
		},
		diminishing_return_limit = {
			lerp_perfect = 4,
			lerp_basic = 2
		},
		speed_modifier = {
			lerp_perfect = 1,
			lerp_basic = 1
		}
	},
	smiter = {
		consecutive_dodges_reset = 0.15,
		distance_scale = {
			lerp_perfect = 0.95,
			lerp_basic = 0.75
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.3,
			lerp_basic = 0.6
		},
		diminishing_return_start = {
			lerp_perfect = 4,
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
	psyker = {
		distance_scale = {
			lerp_perfect = 1.1,
			lerp_basic = 0.8
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.3,
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
		consecutive_dodges_reset = 0.15,
		distance_scale = {
			lerp_perfect = 0.85,
			lerp_basic = 0.7
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.25,
			lerp_basic = 0.5
		},
		diminishing_return_start = {
			lerp_perfect = 4,
			lerp_basic = 2
		},
		diminishing_return_limit = {
			lerp_perfect = 2,
			lerp_basic = 2
		},
		speed_modifier = {
			lerp_perfect = 1.075,
			lerp_basic = 1.05
		}
	},
	ogryn = {
		distance_scale = {
			lerp_perfect = 1,
			lerp_basic = 0.8
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.2,
			lerp_basic = 0.4
		},
		diminishing_return_start = {
			lerp_perfect = 4,
			lerp_basic = 2
		},
		diminishing_return_limit = {
			lerp_perfect = 4,
			lerp_basic = 2
		},
		speed_modifier = {
			lerp_perfect = 0.9,
			lerp_basic = 0.9
		}
	},
	support = {
		consecutive_dodges_reset = 0.15,
		distance_scale = {
			lerp_perfect = 0.95,
			lerp_basic = 0.75
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.2,
			lerp_basic = 0.4
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
			lerp_perfect = 1.2,
			lerp_basic = 1.1
		}
	},
	plasma_rifle = {
		speed_modifier = 1.2,
		consecutive_dodges_reset = 0.15,
		distance_scale = {
			lerp_perfect = 0.75,
			lerp_basic = 0.65
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.25,
			lerp_basic = 0.5
		},
		diminishing_return_start = {
			lerp_perfect = 2,
			lerp_basic = 2
		},
		diminishing_return_limit = {
			lerp_perfect = 2,
			lerp_basic = 2
		}
	},
	killshot = {
		consecutive_dodges_reset = 0.15,
		distance_scale = {
			lerp_perfect = 0.85,
			lerp_basic = 0.65
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.2,
			lerp_basic = 0.4
		},
		diminishing_return_start = {
			lerp_perfect = 4,
			lerp_basic = 2
		},
		diminishing_return_limit = {
			lerp_perfect = 4,
			lerp_basic = 2
		},
		speed_modifier = {
			lerp_perfect = 1.15,
			lerp_basic = 1.1
		}
	},
	assault_killshot = {
		distance_scale = {
			lerp_perfect = 0.9,
			lerp_basic = 0.7
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.3,
			lerp_basic = 0.6
		},
		diminishing_return_start = {
			lerp_perfect = 4,
			lerp_basic = 2
		},
		diminishing_return_limit = {
			lerp_perfect = 4,
			lerp_basic = 2
		},
		speed_modifier = {
			lerp_perfect = 1,
			lerp_basic = 1
		}
	},
	assault = {
		distance_scale = {
			lerp_perfect = 1,
			lerp_basic = 0.85
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.3,
			lerp_basic = 0.6
		},
		diminishing_return_start = {
			lerp_perfect = 4,
			lerp_basic = 2
		},
		diminishing_return_limit = {
			lerp_perfect = 4,
			lerp_basic = 2
		},
		speed_modifier = {
			lerp_perfect = 1.2,
			lerp_basic = 1
		}
	},
	ninja_knife = {
		consecutive_dodges_reset = 0.15,
		distance_scale = {
			lerp_perfect = 1.1,
			lerp_basic = 0.9
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.2,
			lerp_basic = 0.3
		},
		diminishing_return_start = {
			lerp_perfect = 6,
			lerp_basic = 3
		},
		diminishing_return_limit = {
			lerp_perfect = 4,
			lerp_basic = 2
		},
		speed_modifier = {
			lerp_perfect = 1.15,
			lerp_basic = 1.15
		}
	},
	ninjafencer = {
		consecutive_dodges_reset = 0.15,
		distance_scale = {
			lerp_perfect = 1.05,
			lerp_basic = 0.9
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.2,
			lerp_basic = 0.3
		},
		diminishing_return_start = {
			lerp_perfect = 5,
			lerp_basic = 3
		},
		diminishing_return_limit = {
			lerp_perfect = 4,
			lerp_basic = 2
		},
		speed_modifier = {
			lerp_perfect = 1.15,
			lerp_basic = 1.15
		}
	},
	luggable = {
		speed_modifier = 1,
		diminishing_return_distance_modifier = 0.4,
		diminishing_return_start = 2,
		consecutive_dodges_reset = 0.5,
		diminishing_return_limit = 2,
		distance_scale = {
			lerp_perfect = 0.6,
			lerp_basic = 0.5
		}
	}
}

return settings("WeaponDodgeTemplates", weapon_dodge_templates)
