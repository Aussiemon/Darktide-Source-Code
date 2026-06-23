-- chunkname: @scripts/settings/equipment/weapon_templates/phosphor_pistol/settings_templates/phosphor_pistol_recoil_templates.lua

local RecoilTemplate = require("scripts/utilities/recoil_template")
local AIM_ASSIST_MULTIPLIER_FUNCTIONS = RecoilTemplate.AIM_ASSIST_MULTIPLIER_FUNCTIONS
local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

local multi_2 = 1

recoil_templates.phosphor_pistol_p1_m1_recoil_hip = {
	still = {
		camera_recoil_percentage = 0.65,
		decay_grace = 0.15,
		new_influence_percent = 0.6,
		rise_duration = 0.05,
		rise = {
			1.1,
		},
		decay = {
			idle = 2,
			shooting = 1,
		},
		offset_range = {
			{
				pitch = {
					0.145,
					0.165,
				},
				yaw = {
					-0.05,
					0,
				},
			},
		},
		offset_limit = {
			pitch = 2,
			yaw = 2,
		},
		visual_recoil_settings = {
			intensity = 5,
			lerp_scalar = 1,
		},
	},
	moving = {
		new_influence_percent = 0.7,
		inherits = {
			"phosphor_pistol_p1_m1_recoil_hip",
			"still",
		},
	},
	crouch_still = {
		new_influence_percent = 0.5,
		inherits = {
			"phosphor_pistol_p1_m1_recoil_hip",
			"still",
		},
	},
	crouch_moving = {
		new_influence_percent = 0.7,
		inherits = {
			"phosphor_pistol_p1_m1_recoil_hip",
			"still",
		},
	},
}
recoil_templates.phosphor_pistol_p1_m1_recoil_ads = {
	still = {
		camera_recoil_percentage = 0.65,
		decay_grace = 0.15,
		new_influence_percent = 0.6,
		rise_duration = 0.05,
		rise = {
			0.75,
		},
		decay = {
			idle = 2,
			shooting = 1,
		},
		offset_range = {
			{
				pitch = {
					0.145,
					0.165,
				},
				yaw = {
					-0.05,
					0,
				},
			},
		},
		offset_limit = {
			pitch = 2,
			yaw = 2,
		},
		visual_recoil_settings = {
			intensity = 5,
			lerp_scalar = 1,
		},
	},
	moving = {
		new_influence_percent = 0.6,
		inherits = {
			"phosphor_pistol_p1_m1_recoil_ads",
			"still",
		},
	},
	crouch_still = {
		new_influence_percent = 0.55,
		inherits = {
			"phosphor_pistol_p1_m1_recoil_ads",
			"still",
		},
	},
	crouch_moving = {
		new_influence_percent = 0.6,
		inherits = {
			"phosphor_pistol_p1_m1_recoil_ads",
			"still",
		},
	},
}

return {
	base_templates = recoil_templates,
	overrides = overrides,
}
