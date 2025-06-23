-- chunkname: @scripts/settings/equipment/weapon_templates/plasma_rifles/settings_templates/plasma_rifle_recoil_templates.lua

local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

recoil_templates.default_plasma_rifle_bfg = {
	still = {
		new_influence_percent = 0.25,
		camera_recoil_percentage = 0.5,
		rise_duration = 0.05,
		rise = {
			1
		},
		decay = {
			shooting = 0.1,
			idle = 1.5
		},
		offset_range = {
			{
				pitch = {
					0.25,
					0.3
				},
				yaw = {
					-0.025,
					0.025
				}
			}
		},
		offset_limit = {
			yaw = 0.175,
			pitch = 0.175
		},
		visual_recoil_settings = {
			intensity = 5,
			lerp_scalar = 0.2
		}
	},
	moving = {
		inherits = {
			"default_plasma_rifle_bfg",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_plasma_rifle_bfg",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_plasma_rifle_bfg",
			"still"
		}
	}
}
recoil_templates.default_plasma_rifle_demolitions = {
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
			"default_plasma_rifle_demolitions",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_plasma_rifle_demolitions",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_plasma_rifle_demolitions",
			"still"
		}
	}
}

return {
	base_templates = recoil_templates,
	overrides = overrides
}
