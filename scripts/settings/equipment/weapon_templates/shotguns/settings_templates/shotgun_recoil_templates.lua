local RecoilTemplate = require("scripts/utilities/recoil_template")
local recoil_templates = {}
local overrides = {}
local generate_offset_range = RecoilTemplate.generate_offset_range
local create_scale = RecoilTemplate.create_scale
local AIM_ASSIST_MULTIPLIER_FUNCTIONS = RecoilTemplate.AIM_ASSIST_MULTIPLIER_FUNCTIONS

table.make_unique(recoil_templates)
table.make_unique(overrides)

local assault_scale = {
	{
		1,
		{
			1,
			0.5
		}
	},
	{
		2,
		{
			0.85,
			1
		}
	},
	{
		3,
		{
			0.8,
			1
		}
	},
	{
		6,
		{
			0.3,
			1
		}
	}
}
local assault_random_scale = {
	{
		1,
		{
			1,
			1
		}
	},
	{
		3,
		{
			1,
			1
		}
	},
	{
		6,
		{
			0.5,
			1
		}
	}
}
local killshot_scale = {
	{
		1,
		{
			1,
			1
		}
	},
	{
		6,
		{
			1,
			1
		}
	}
}
local killshot_random_scale = {
	{
		1,
		{
			1,
			1
		}
	},
	{
		6,
		{
			1,
			1
		}
	}
}
local num_shot = 6
local lerp_distance = 0.3
local killshot_offset_range = generate_offset_range(num_shot, 0.15, -0.025, lerp_distance, create_scale(killshot_scale))
local killshot_random_range = generate_offset_range(num_shot, 0.025, 0.05, lerp_distance, create_scale(killshot_random_scale))
local assault_offset_range = generate_offset_range(num_shot, 0.15, 0, lerp_distance, create_scale(assault_scale))
local assault_random_range = generate_offset_range(num_shot, 0.05, 0.1, lerp_distance, create_scale(assault_random_scale))
local special_offset = generate_offset_range(num_shot, 0.75, -0.25, lerp_distance, create_scale(killshot_scale))
local special_random_offset = generate_offset_range(num_shot, 0.2, 0.25, lerp_distance, create_scale(killshot_scale))
recoil_templates.default_shotgun_assault = {
	still = {
		camera_recoil_percentage = 0.25,
		rise_duration = 0.05,
		rise = {
			{
				lerp_perfect = 0.15,
				lerp_basic = 0.8
			}
		},
		decay = {
			shooting = {
				lerp_perfect = 0.3,
				lerp_basic = 0.2
			},
			idle = {
				lerp_perfect = 1.25,
				lerp_basic = 0.75
			}
		},
		offset = assault_offset_range,
		offset_random_range = assault_random_range,
		offset_limit = {
			yaw = 2,
			pitch = 2
		},
		visual_recoil_settings = {
			intensity = 9,
			lerp_scalar = 1,
			yaw_intensity = 5.5
		},
		new_influence_percent = {
			lerp_perfect = 0.5,
			lerp_basic = 0.7
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		}
	},
	moving = {
		inherits = {
			"default_shotgun_assault",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.6,
			lerp_basic = 0.8
		}
	},
	crouch_still = {
		inherits = {
			"default_shotgun_assault",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.3,
			lerp_basic = 0.5
		}
	},
	crouch_moving = {
		inherits = {
			"default_shotgun_assault",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.35,
			lerp_basic = 0.55
		}
	}
}
recoil_templates.shotgun_special_recoil = {
	still = {
		camera_recoil_percentage = 0.25,
		rise_duration = 0.05,
		rise = {
			{
				lerp_perfect = 0.15,
				lerp_basic = 0.8
			}
		},
		decay = {
			shooting = {
				lerp_perfect = 0.2,
				lerp_basic = 0.1
			},
			idle = {
				lerp_perfect = 1,
				lerp_basic = 0.5
			}
		},
		offset = special_offset,
		offset_random_range = special_random_offset,
		offset_limit = {
			yaw = 2,
			pitch = 2
		},
		visual_recoil_settings = {
			intensity = 10,
			lerp_scalar = 1,
			yaw_intensity = 5.5
		},
		new_influence_percent = {
			lerp_perfect = 0.5,
			lerp_basic = 0.7
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		}
	},
	moving = {
		inherits = {
			"shotgun_special_recoil",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.6,
			lerp_basic = 0.8
		}
	},
	crouch_still = {
		inherits = {
			"shotgun_special_recoil",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.3,
			lerp_basic = 0.5
		}
	},
	crouch_moving = {
		inherits = {
			"shotgun_special_recoil",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.35,
			lerp_basic = 0.55
		}
	}
}
recoil_templates.default_shotgun_killshot = {
	still = {
		camera_recoil_percentage = 0.15,
		rise_duration = 0.05,
		rise = {
			{
				lerp_perfect = 0.3,
				lerp_basic = 0.7
			}
		},
		decay = {
			shooting = {
				lerp_perfect = 0.3,
				lerp_basic = 0.2
			},
			idle = {
				lerp_perfect = 1.5,
				lerp_basic = 1
			}
		},
		offset = killshot_offset_range,
		offset_random_range = killshot_random_range,
		offset_limit = {
			yaw = 5,
			pitch = 5
		},
		new_influence_percent = {
			lerp_perfect = 0.45,
			lerp_basic = 0.75
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		},
		visual_recoil_settings = {
			intensity = 4.75,
			lerp_scalar = 1,
			yaw_intensity = 5.5
		}
	},
	moving = {
		inherits = {
			"default_shotgun_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.7,
			lerp_basic = 0.9
		}
	},
	crouch_still = {
		inherits = {
			"default_shotgun_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.4,
			lerp_basic = 0.7
		}
	},
	crouch_moving = {
		inherits = {
			"default_shotgun_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.5,
			lerp_basic = 0.8
		}
	}
}

return {
	base_templates = recoil_templates,
	overrides = overrides
}
