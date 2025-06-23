-- chunkname: @scripts/settings/equipment/weapon_templates/grenadier_gauntlets/settings_templates/grenadier_gauntlet_recoil_templates.lua

local RecoilTemplate = require("scripts/utilities/recoil_template")
local AIM_ASSIST_MULTIPLIER_FUNCTIONS = RecoilTemplate.AIM_ASSIST_MULTIPLIER_FUNCTIONS
local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

recoil_templates.default_grenadier_gauntlet_demolitions = {
	still = {
		new_influence_percent = 0.35,
		rise_duration = 0.125,
		rise = {
			0.75,
			0.35,
			0.275
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
					-0.005,
					0.01
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
		new_influence_percent = 0.45,
		inherits = {
			"default_grenadier_gauntlet_demolitions",
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
		new_influence_percent = 0.4,
		inherits = {
			"default_grenadier_gauntlet_demolitions",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.45,
		inherits = {
			"default_grenadier_gauntlet_demolitions",
			"still"
		}
	}
}
recoil_templates.default_grenadier_gauntlet_bfg = {
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
			"default_grenadier_gauntlet_bfg",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_grenadier_gauntlet_bfg",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_grenadier_gauntlet_bfg",
			"still"
		}
	}
}

return {
	base_templates = recoil_templates,
	overrides = overrides
}
