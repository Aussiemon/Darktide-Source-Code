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
	}
}
local ninja_knife_distance = 2.9
local ninja_knife_time = 0.35
local ninja_knife_average_speed = ninja_knife_distance / ninja_knife_time
local ninja_knife_speed_curve = {
	{
		time_in_dodge = ninja_knife_time * 0,
		speed = ninja_knife_average_speed * 1.4
	},
	{
		time_in_dodge = ninja_knife_time * 0.2,
		speed = ninja_knife_average_speed * 1.4
	},
	{
		time_in_dodge = ninja_knife_time * 0.25,
		speed = ninja_knife_average_speed * 1.25
	},
	{
		time_in_dodge = ninja_knife_time * 0.4,
		speed = ninja_knife_average_speed * 1 * 0.9
	},
	{
		time_in_dodge = ninja_knife_time * 0.7,
		speed = ninja_knife_average_speed * 1 * 0.85
	},
	{
		speed = 4,
		time_in_dodge = ninja_knife_time * 0.85
	},
	{
		speed = 3.5,
		time_in_dodge = ninja_knife_time * 0.9
	},
	{
		speed = 3,
		time_in_dodge = ninja_knife_time * 1
	}
}
weapon_dodge_templates.ninja_knife = {
	consecutive_dodges_reset = 0.15,
	base_distance = 3,
	distance_scale = {
		lerp_perfect = 1.2,
		lerp_basic = 1
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
		lerp_perfect = 1,
		lerp_basic = 1
	},
	dodge_speed_at_times = ninja_knife_speed_curve
}
local ninjafencer_distance = 2.75
local ninjafencer_time = 0.35
local ninjafencer_average_speed = ninjafencer_distance / ninjafencer_time
local ninjafencer_speed_curve = {
	{
		time_in_dodge = ninjafencer_time * 0,
		speed = ninjafencer_average_speed * 1.5
	},
	{
		time_in_dodge = ninjafencer_time * 0.15,
		speed = ninjafencer_average_speed * 1.5
	},
	{
		time_in_dodge = ninjafencer_time * 0.2,
		speed = ninjafencer_average_speed * 1.25
	},
	{
		time_in_dodge = ninjafencer_time * 0.4,
		speed = ninjafencer_average_speed * 1
	},
	{
		time_in_dodge = ninjafencer_time * 0.7,
		speed = ninjafencer_average_speed * 1 * 0.9
	},
	{
		speed = 4,
		time_in_dodge = ninja_knife_time * 0.85
	},
	{
		speed = 3.5,
		time_in_dodge = ninja_knife_time * 0.9
	},
	{
		speed = 3,
		time_in_dodge = ninja_knife_time * 1
	}
}
weapon_dodge_templates.ninjafencer = {
	consecutive_dodges_reset = 0.15,
	base_distance = 2.75,
	distance_scale = {
		lerp_perfect = 1.15,
		lerp_basic = 0.95
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
		lerp_perfect = 1,
		lerp_basic = 1
	},
	dodge_speed_at_times = ninjafencer_speed_curve
}
weapon_dodge_templates.luggable = {
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

return settings("WeaponDodgeTemplates", weapon_dodge_templates)
