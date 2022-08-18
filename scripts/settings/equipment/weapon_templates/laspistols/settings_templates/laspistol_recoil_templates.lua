local RecoilTemplate = require("scripts/utilities/recoil_template")
local AIM_ASSIST_MULTIPLIER_FUNCTIONS = RecoilTemplate.AIM_ASSIST_MULTIPLIER_FUNCTIONS
local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

recoil_templates.default_laspistol_assault = {
	still = {
		new_influence_percent = 0.16,
		rise_duration = 0.1,
		decay_grace = 0.05,
		rise = {
			0.35,
			0.3,
			0.4,
			0.5
		},
		decay = {
			shooting = 0.5,
			idle = 2
		},
		offset_range = {
			{
				pitch = {
					0.005,
					0.005
				},
				yaw = {
					-0.02,
					0.02
				}
			}
		},
		offset_limit = {
			yaw = 1,
			pitch = 1
		}
	},
	moving = {
		new_influence_percent = 0.15,
		inherits = {
			"default_laspistol_assault",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.15,
		inherits = {
			"default_laspistol_assault",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.15,
		inherits = {
			"default_laspistol_assault",
			"still"
		}
	}
}
recoil_templates.default_laspistol_killshot = {
	still = {
		camera_recoil_percentage = 0,
		decay_grace = 0.05,
		new_influence_percent = 0.35,
		rise_duration = 0.05,
		rise = {
			{
				lerp_perfect = 0.07,
				lerp_basic = 0.25
			},
			{
				lerp_perfect = 0.06,
				lerp_basic = 0.15
			},
			{
				lerp_perfect = 0.04,
				lerp_basic = 0.1
			},
			{
				lerp_perfect = 0.03,
				lerp_basic = 0.05
			},
			{
				lerp_perfect = 0.01,
				lerp_basic = 0.04
			}
		},
		decay = {
			shooting = {
				lerp_perfect = 0.9,
				lerp_basic = 0.25
			},
			idle = {
				lerp_perfect = 1,
				lerp_basic = 0.8
			}
		},
		offset_range = {
			{
				pitch = {
					0.015,
					0.0175
				},
				yaw = {
					-0.02,
					0.02
				}
			}
		},
		offset_limit = {
			yaw = 2,
			pitch = 2
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		},
		visual_recoil_settings = {
			intensity = 3,
			lerp_scalar = 1
		}
	},
	moving = {
		new_influence_percent = 0.5,
		inherits = {
			"default_laspistol_killshot",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.26,
		inherits = {
			"default_laspistol_killshot",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.25,
		inherits = {
			"default_laspistol_killshot",
			"still"
		}
	}
}

return {
	base_templates = recoil_templates,
	overrides = overrides
}
