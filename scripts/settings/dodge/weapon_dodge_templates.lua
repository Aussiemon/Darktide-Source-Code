local weapon_dodge_templates = {
	default = {
		distance_scale = {
			lerp_perfect = 1,
			lerp_basic = 0.7
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.2,
			lerp_basic = 0.4
		},
		diminishing_return_start = {
			lerp_perfect = 6,
			lerp_basic = 2
		},
		diminishing_return_limit = {
			lerp_perfect = 2,
			lerp_basic = 2
		},
		speed_modifier = {
			lerp_perfect = 1,
			lerp_basic = 0.9
		}
	},
	smiter = {
		distance_scale = {
			lerp_perfect = 0.9,
			lerp_basic = 0.6
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
			lerp_perfect = 0.9,
			lerp_basic = 0.8
		}
	},
	psyker = {
		distance_scale = {
			lerp_perfect = 1,
			lerp_basic = 0.7
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
		consecutive_dodges_reset = 0.25,
		distance_scale = {
			lerp_perfect = 0.75,
			lerp_basic = 0.7
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.4,
			lerp_basic = 0.6
		},
		diminishing_return_start = {
			lerp_perfect = 3,
			lerp_basic = 1
		},
		diminishing_return_limit = {
			lerp_perfect = 2,
			lerp_basic = 2
		},
		speed_modifier = {
			lerp_perfect = 1,
			lerp_basic = 0.9
		}
	},
	ogryn = {
		distance_scale = {
			lerp_perfect = 1,
			lerp_basic = 0.5
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.4,
			lerp_basic = 0.6
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
		distance_scale = {
			lerp_perfect = 0.8,
			lerp_basic = 0.6
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.2,
			lerp_basic = 0.4
		},
		diminishing_return_start = {
			lerp_perfect = 3,
			lerp_basic = 1
		},
		diminishing_return_limit = {
			lerp_perfect = 2,
			lerp_basic = 2
		},
		speed_modifier = {
			lerp_perfect = 1,
			lerp_basic = 0.9
		}
	},
	plasma_rifle = {
		speed_modifier = 1,
		consecutive_dodges_reset = 0.25,
		distance_scale = {
			lerp_perfect = 0.8,
			lerp_basic = 0.6
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.4,
			lerp_basic = 0.6
		},
		diminishing_return_start = {
			lerp_perfect = 2,
			lerp_basic = 2
		},
		diminishing_return_limit = {
			lerp_perfect = 1,
			lerp_basic = 1
		}
	},
	killshot = {
		consecutive_dodges_reset = 0.25,
		distance_scale = {
			lerp_perfect = 0.75,
			lerp_basic = 0.65
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.2,
			lerp_basic = 0.4
		},
		diminishing_return_start = {
			lerp_perfect = 3,
			lerp_basic = 1
		},
		diminishing_return_limit = {
			lerp_perfect = 3,
			lerp_basic = 1
		},
		speed_modifier = {
			lerp_perfect = 1,
			lerp_basic = 0.8
		}
	},
	assault_killshot = {
		consecutive_dodges_reset = 0.25,
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
			lerp_basic = 0.8
		}
	},
	assault = {
		consecutive_dodges_reset = 0.25,
		distance_scale = {
			lerp_perfect = 1.2,
			lerp_basic = 1
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
		distance_scale = {
			lerp_perfect = 1.3,
			lerp_basic = 1.1
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.3,
			lerp_basic = 0.6
		},
		diminishing_return_start = {
			lerp_perfect = 9,
			lerp_basic = 3
		},
		diminishing_return_limit = {
			lerp_perfect = 4,
			lerp_basic = 2
		},
		speed_modifier = {
			lerp_perfect = 1.3,
			lerp_basic = 1
		}
	},
	ninjafencer = {
		distance_scale = {
			lerp_perfect = 1.3,
			lerp_basic = 1.1
		},
		diminishing_return_distance_modifier = {
			lerp_perfect = 0.3,
			lerp_basic = 0.6
		},
		diminishing_return_start = {
			lerp_perfect = 7,
			lerp_basic = 3
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
	luggable = {
		consecutive_dodges_reset = 0.5,
		diminishing_return_distance_modifier = 0.6,
		diminishing_return_start = 1,
		speed_modifier = 1,
		diminishing_return_limit = 2,
		distance_scale = {
			lerp_perfect = 0.6,
			lerp_basic = 0.5
		}
	}
}

return settings("WeaponDodgeTemplates", weapon_dodge_templates)
