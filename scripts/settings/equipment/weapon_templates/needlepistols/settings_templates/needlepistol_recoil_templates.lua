-- chunkname: @scripts/settings/equipment/weapon_templates/needlepistols/settings_templates/needlepistol_recoil_templates.lua

local RecoilTemplate = require("scripts/utilities/recoil_template")
local AIM_ASSIST_MULTIPLIER_FUNCTIONS = RecoilTemplate.AIM_ASSIST_MULTIPLIER_FUNCTIONS
local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

recoil_templates.needlepistol_p1_m1_recoil_assault = {
	still = {
		camera_recoil_percentage = 0.2,
		decay_grace = 0.125,
		new_influence_percent = 1,
		rise_duration = 0.05,
		rise = {
			0.25,
			0.32,
			0.23,
			0.35,
			0.3,
			0.34,
		},
		decay = {
			idle = 2,
			shooting = 1.3,
		},
		offset_range = {
			{
				pitch = {
					0.0375,
					0.04375,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
		},
		offset_limit = {
			pitch = 2,
			yaw = 2,
		},
		visual_recoil_settings = {
			intensity = 1.5,
			lerp_scalar = 0.5,
			yaw_intensity = 1,
		},
	},
	moving = {
		new_influence_percent = 1,
		inherits = {
			"needlepistol_p1_m1_recoil_assault",
			"still",
		},
	},
	crouch_still = {
		new_influence_percent = 0.6,
		inherits = {
			"needlepistol_p1_m1_recoil_assault",
			"still",
		},
	},
	crouch_moving = {
		new_influence_percent = 0.8,
		inherits = {
			"needlepistol_p1_m1_recoil_assault",
			"still",
		},
	},
}
recoil_templates.needlepistol_p1_m1_recoil_killshot = {
	still = {
		camera_recoil_percentage = 0.2,
		decay_grace = 0.15,
		new_influence_percent = 1,
		rise_duration = 0.025,
		rise = {
			0.24,
			0.22,
			0.24,
			0.25,
			0.3,
			0.25,
		},
		decay = {
			idle = 2,
			shooting = 1.1,
		},
		offset_range = {
			{
				pitch = {
					0.0375,
					0.04375,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
		},
		offset_limit = {
			pitch = 2.1,
			yaw = 2.1,
		},
		visual_recoil_settings = {
			intensity = 1.9,
			lerp_scalar = 1,
			yaw_intensity = 1.3,
		},
	},
	moving = {
		new_influence_percent = 1.1,
		inherits = {
			"needlepistol_p1_m1_recoil_killshot",
			"still",
		},
	},
	crouch_still = {
		new_influence_percent = 0.6,
		inherits = {
			"needlepistol_p1_m1_recoil_killshot",
			"still",
		},
	},
	crouch_moving = {
		new_influence_percent = 0.8,
		inherits = {
			"needlepistol_p1_m1_recoil_killshot",
			"still",
		},
	},
}

return {
	base_templates = recoil_templates,
	overrides = overrides,
}
