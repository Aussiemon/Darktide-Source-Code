-- chunkname: @scripts/settings/equipment/weapon_templates/flamers/settings_templates/flamer_recoil_templates.lua

local RecoilTemplate = require("scripts/utilities/recoil_template")
local AIM_ASSIST_MULTIPLIER_FUNCTIONS = RecoilTemplate.AIM_ASSIST_MULTIPLIER_FUNCTIONS
local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

recoil_templates.default_flamer_demolitions = {
	still = {
		new_influence_percent = 0.75,
		rise_duration = 0.15,
		rise = {
			0.75
		},
		decay = {
			shooting = 0.5,
			idle = 1.5
		},
		offset_range = {
			{
				pitch = {
					0.25,
					0.3
				},
				yaw = {
					-0.1,
					0.1
				}
			}
		},
		offset_limit = {
			yaw = 3,
			pitch = 3
		}
	},
	moving = {
		inherits = {
			"default_flamer_demolitions",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_flamer_demolitions",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_flamer_demolitions",
			"still"
		}
	}
}
recoil_templates.default_flamer_assault = {
	still = {
		new_influence_percent = 0.1,
		rise_duration = 0.075,
		rise = {
			0.5,
			0.35,
			0.275,
			0.2,
			0.1
		},
		decay = {
			shooting = 1,
			idle = 1.75
		},
		offset_range = {
			{
				pitch = {
					0.1,
					0.125
				},
				yaw = {
					-0.02,
					0.02
				}
			},
			{
				pitch = {
					0.075,
					0.1
				},
				yaw = {
					-0.02,
					0.02
				}
			},
			{
				pitch = {
					0.05,
					0.075
				},
				yaw = {
					-0.03,
					0.03
				}
			},
			{
				pitch = {
					0.02,
					0.04
				},
				yaw = {
					-0.03,
					0.03
				}
			}
		},
		offset_limit = {
			yaw = 2,
			pitch = 2
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		}
	},
	moving = {
		new_influence_percent = 0.05,
		inherits = {
			"default_flamer_assault",
			"still"
		},
		rise = {
			0.5,
			0.35,
			0.275,
			0.2
		}
	},
	crouch_still = {
		new_influence_percent = 0.04,
		inherits = {
			"default_flamer_assault",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.08,
		inherits = {
			"default_flamer_assault",
			"still"
		}
	}
}

return {
	base_templates = recoil_templates,
	overrides = overrides
}
