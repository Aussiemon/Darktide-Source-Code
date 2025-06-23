-- chunkname: @scripts/settings/equipment/weapon_templates/bolt_pistols/settings_templates/boltpistol_recoil_templates.lua

local RecoilTemplate = require("scripts/utilities/recoil_template")
local AIM_ASSIST_MULTIPLIER_FUNCTIONS = RecoilTemplate.AIM_ASSIST_MULTIPLIER_FUNCTIONS
local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

recoil_templates.default_boltpistol_hip = {
	still = {
		camera_recoil_percentage = 0.8,
		decay_grace = 0.42,
		new_influence_percent = 0.7,
		rise_duration = 0.495,
		rise = {
			3.75,
			3.6,
			4.7,
			3.5,
			2,
			2
		},
		decay = {
			shooting = 0.9,
			idle = 2.75
		},
		offset = {
			{
				yaw = 0,
				pitch = 0.09
			},
			{
				yaw = 0,
				pitch = 0.115
			},
			{
				yaw = 0,
				pitch = 0.145
			},
			{
				yaw = 0,
				pitch = 0.111
			},
			{
				yaw = 0,
				pitch = 0.07
			},
			{
				yaw = 0,
				pitch = 0.09
			},
			{
				yaw = 0,
				pitch = 0.14
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
			intensity = 0.8,
			lerp_scalar = 0.1
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		}
	},
	moving = {
		new_influence_percent = 0.6,
		inherits = {
			"default_boltpistol_hip",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.4,
		inherits = {
			"default_boltpistol_hip",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.55,
		inherits = {
			"default_boltpistol_hip",
			"still"
		}
	}
}
recoil_templates.default_boltpistol_ads = {
	still = {
		camera_recoil_percentage = 0.2,
		new_influence_percent = 0.27,
		rise_duration = 0.05,
		rise = {
			0.75,
			0.65,
			0.5
		},
		decay = {
			shooting = 0.2,
			idle = 0.4
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
			intensity = 3.8,
			lerp_scalar = 0.8,
			yaw_intensity = 2.3
		}
	},
	moving = {
		new_influence_percent = 0.4,
		inherits = {
			"default_boltpistol_ads",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_boltpistol_ads",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_boltpistol_ads",
			"still"
		}
	}
}

return {
	base_templates = recoil_templates,
	overrides = overrides
}
