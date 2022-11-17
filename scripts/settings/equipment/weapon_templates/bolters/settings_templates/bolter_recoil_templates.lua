local RecoilTemplate = require("scripts/utilities/recoil_template")
local AIM_ASSIST_MULTIPLIER_FUNCTIONS = RecoilTemplate.AIM_ASSIST_MULTIPLIER_FUNCTIONS
local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

recoil_templates.default_bolter_spraynpray = {
	still = {
		camera_recoil_percentage = 0.5,
		decay_grace = 0.1,
		new_influence_percent = 0.5,
		rise_duration = 0.075,
		rise = {
			0.75,
			0.35,
			0.3
		},
		decay = {
			shooting = 0.25,
			idle = 2.75
		},
		offset = {
			{
				yaw = 0,
				pitch = 0.05
			},
			{
				yaw = 0,
				pitch = 0.035
			},
			{
				yaw = 0,
				pitch = 0.025
			},
			{
				yaw = 0,
				pitch = 0.015
			}
		},
		offset_random_range = {
			{
				yaw = 0.04,
				pitch = 0.025
			},
			{
				yaw = 0.05,
				pitch = 0.025
			},
			{
				yaw = 0.065,
				pitch = 0.025
			}
		},
		offset_limit = {
			yaw = 2,
			pitch = 2
		},
		visual_recoil_settings = {
			intensity = 1,
			lerp_scalar = 0.1
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		}
	},
	moving = {
		new_influence_percent = 0.5,
		inherits = {
			"default_bolter_spraynpray",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.5,
		inherits = {
			"default_bolter_spraynpray",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.5,
		inherits = {
			"default_bolter_spraynpray",
			"still"
		}
	}
}
recoil_templates.bolter_p1_m2_spraynpray = {
	still = {
		camera_recoil_percentage = 0.5,
		decay_grace = 0.14,
		new_influence_percent = 0.5,
		rise_duration = 0.04,
		rise = {
			3.75,
			1.35,
			1.3
		},
		decay = {
			shooting = 0.25,
			idle = 2.75
		},
		offset = {
			{
				yaw = 0,
				pitch = 0.09
			},
			{
				yaw = 0,
				pitch = 0.04
			},
			{
				yaw = 0,
				pitch = 0.03
			},
			{
				yaw = 0,
				pitch = 0.02
			}
		},
		offset_random_range = {
			{
				yaw = 0.04,
				pitch = 0.025
			},
			{
				yaw = 0.05,
				pitch = 0.025
			},
			{
				yaw = 0.065,
				pitch = 0.025
			}
		},
		offset_limit = {
			yaw = 2,
			pitch = 2
		},
		visual_recoil_settings = {
			intensity = 4,
			lerp_scalar = 0.5
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		}
	},
	moving = {
		new_influence_percent = 0.5,
		inherits = {
			"bolter_p1_m2_spraynpray",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.5,
		inherits = {
			"bolter_p1_m2_spraynpray",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.5,
		inherits = {
			"bolter_p1_m2_spraynpray",
			"still"
		}
	}
}
recoil_templates.bolter_p1_m3_spraynpray = {
	still = {
		camera_recoil_percentage = 0.5,
		decay_grace = 0.44,
		new_influence_percent = 0.5,
		rise_duration = 0.1,
		rise = {
			1.3
		},
		decay = {
			shooting = 0.05,
			idle = 2.75
		},
		offset = {
			{
				yaw = 0.004,
				pitch = 0.014
			}
		},
		offset_random_range = {
			{
				yaw = 0.04,
				pitch = 0.025
			},
			{
				yaw = 0.05,
				pitch = 0.025
			},
			{
				yaw = 0.065,
				pitch = 0.025
			}
		},
		offset_limit = {
			yaw = 2,
			pitch = 2
		},
		visual_recoil_settings = {
			intensity = 1,
			lerp_scalar = 0.1
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		}
	},
	moving = {
		new_influence_percent = 0.5,
		inherits = {
			"bolter_p1_m3_spraynpray",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.5,
		inherits = {
			"bolter_p1_m3_spraynpray",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.5,
		inherits = {
			"bolter_p1_m3_spraynpray",
			"still"
		}
	}
}
recoil_templates.default_bolter_killshot = {
	still = {
		camera_recoil_percentage = 0.2,
		new_influence_percent = 0.42,
		rise_duration = 0.07,
		rise = {
			0.75,
			0.65,
			0.5
		},
		decay = {
			shooting = 0.2,
			idle = 0.8
		},
		offset = {
			{
				yaw = 0,
				pitch = 0.075
			},
			{
				yaw = 0,
				pitch = 0.05
			},
			{
				yaw = 0,
				pitch = 0.035
			}
		},
		offset_random_range = {
			{
				yaw = 0.1,
				pitch = 0.025
			},
			{
				yaw = 0.1,
				pitch = 0.025
			},
			{
				yaw = 0.1,
				pitch = 0.025
			}
		},
		offset_limit = {
			yaw = 1,
			pitch = 1.25
		},
		visual_recoil_settings = {
			intensity = 5,
			lerp_scalar = 0.8,
			yaw_intensity = 7.5
		}
	},
	moving = {
		new_influence_percent = 1,
		inherits = {
			"default_bolter_killshot",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_bolter_killshot",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_bolter_killshot",
			"still"
		}
	}
}

return {
	base_templates = recoil_templates,
	overrides = overrides
}
