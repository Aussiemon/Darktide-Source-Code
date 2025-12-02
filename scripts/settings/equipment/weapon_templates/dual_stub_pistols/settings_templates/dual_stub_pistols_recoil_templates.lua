-- chunkname: @scripts/settings/equipment/weapon_templates/dual_stub_pistols/settings_templates/dual_stub_pistols_recoil_templates.lua

local RecoilTemplate = require("scripts/utilities/recoil_template")
local AIM_ASSIST_MULTIPLIER_FUNCTIONS = RecoilTemplate.AIM_ASSIST_MULTIPLIER_FUNCTIONS
local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

recoil_templates.dual_stub_pistols_hip = {
	still = {
		camera_recoil_percentage = 0.2,
		decay_grace = 0.2,
		new_influence_percent = 1,
		rise_duration = 0.05,
		rise = {
			0.45,
			0.3,
			0.12,
			0.75,
			0.5,
			0.16,
		},
		decay = {
			idle = 2,
			shooting = 1.2,
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
			intensity = 12,
			lerp_scalar = 1,
			yaw_intensity = 8,
		},
	},
	moving = {
		new_influence_percent = 1,
		inherits = {
			"dual_stub_pistols_hip",
			"still",
		},
	},
	crouch_still = {
		new_influence_percent = 0.6,
		inherits = {
			"dual_stub_pistols_hip",
			"still",
		},
	},
	crouch_moving = {
		new_influence_percent = 0.8,
		inherits = {
			"dual_stub_pistols_hip",
			"still",
		},
	},
}
recoil_templates.dual_stub_pistols_braced = {
	still = {
		camera_recoil_percentage = 0.1,
		decay_grace = 0.15,
		new_influence_percent = 1,
		rise_duration = 0.015,
		rise = {
			0.21,
			0.22,
			0.14,
			0.25,
			0.3,
			0.25,
		},
		decay = {
			idle = 2,
			shooting = 1.4,
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
			pitch = 1.3,
			yaw = 1.3,
		},
		visual_recoil_settings = {
			intensity = 8,
			lerp_scalar = 1,
			yaw_intensity = 6,
		},
	},
	moving = {
		new_influence_percent = 1,
		inherits = {
			"dual_stub_pistols_hip",
			"still",
		},
	},
	crouch_still = {
		new_influence_percent = 0.6,
		inherits = {
			"dual_stub_pistols_hip",
			"still",
		},
	},
	crouch_moving = {
		new_influence_percent = 0.8,
		inherits = {
			"dual_stub_pistols_hip",
			"still",
		},
	},
}

return {
	base_templates = recoil_templates,
	overrides = overrides,
}
