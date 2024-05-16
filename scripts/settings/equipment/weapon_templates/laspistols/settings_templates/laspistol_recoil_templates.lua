-- chunkname: @scripts/settings/equipment/weapon_templates/laspistols/settings_templates/laspistol_recoil_templates.lua

local RecoilTemplate = require("scripts/utilities/recoil_template")
local AIM_ASSIST_MULTIPLIER_FUNCTIONS = RecoilTemplate.AIM_ASSIST_MULTIPLIER_FUNCTIONS
local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

recoil_templates.default_laspistol_assault = {
	still = {
		camera_recoil_percentage = 0.25,
		decay_grace = 0.125,
		rise_duration = 0.075,
		rise = {
			{
				lerp_basic = 0.75,
				lerp_perfect = 0.5,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.2,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.15,
			},
		},
		decay = {
			idle = 2.25,
			shooting = 0.75,
		},
		offset = {
			{
				pitch = {
					lerp_basic = 0.01,
					lerp_perfect = 0.005,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.01,
					lerp_perfect = 0.005,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
		},
		offset_random_range = {
			{
				pitch = {
					lerp_basic = 0.005,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.01,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.006,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.02,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.00625,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.03,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.0065,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.045,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.0065,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.055,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.0065,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.065,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.0065,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.075,
					lerp_perfect = 0,
				},
			},
		},
		offset_limit = {
			pitch = 0.25,
			yaw = 0.25,
		},
		visual_recoil_settings = {
			intensity = 3,
			lerp_scalar = 1,
			yaw_intensity = 10,
		},
		new_influence_percent = {
			lerp_basic = 0.02,
			lerp_perfect = 0.005,
		},
	},
	moving = {
		inherits = {
			"hip_lasgun_killshot",
			"still",
		},
		visual_recoil_settings = {
			intensity = 1,
			lerp_scalar = 1,
			yaw_intensity = 2,
		},
		new_influence_percent = {
			lerp_basic = 0.12,
			lerp_perfect = 0.06,
		},
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.1,
			lerp_perfect = 0.05,
		},
		visual_recoil_settings = {
			intensity = 1,
			lerp_scalar = 1,
			yaw_intensity = 2,
		},
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.125,
			lerp_perfect = 0.075,
		},
		visual_recoil_settings = {
			intensity = 1,
			lerp_scalar = 1,
			yaw_intensity = 2,
		},
	},
}

local multi = 0.3

recoil_templates.default_laspistol_killshot = {
	still = {
		camera_recoil_percentage = 0.15,
		decay_grace = 0.05,
		new_influence_percent = 0.1,
		rise_duration = 0.1,
		rise = {
			{
				lerp_basic = 0.75,
				lerp_perfect = 0.27,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.25,
			},
			{
				lerp_basic = 0.4,
				lerp_perfect = 0.23,
			},
			{
				lerp_basic = 0.3,
				lerp_perfect = 0.2,
			},
		},
		decay = {
			shooting = {
				lerp_basic = 0.5,
				lerp_perfect = 2,
			},
			idle = {
				lerp_basic = 1.8,
				lerp_perfect = 3,
			},
		},
		offset = {
			{
				pitch = {
					lerp_basic = 0.07 * multi,
					lerp_perfect = 0.075 * multi,
				},
				yaw = {
					lerp_basic = 0.03 * multi,
					lerp_perfect = 0.01 * multi,
				},
			},
			{
				pitch = {
					lerp_basic = 0.05 * multi,
					lerp_perfect = 0.05 * multi,
				},
				yaw = {
					lerp_basic = 0.03 * multi,
					lerp_perfect = 0.01 * multi,
				},
			},
			{
				pitch = {
					lerp_basic = 0.03 * multi,
					lerp_perfect = 0.015 * multi,
				},
				yaw = {
					lerp_basic = 0.03 * multi,
					lerp_perfect = 0.01 * multi,
				},
			},
			{
				pitch = {
					lerp_basic = 0.02 * multi,
					lerp_perfect = 0.01 * multi,
				},
				yaw = {
					lerp_basic = 0.02 * multi,
					lerp_perfect = 0.005 * multi,
				},
			},
			{
				pitch = {
					lerp_basic = 0.015 * multi,
					lerp_perfect = 0.01 * multi,
				},
				yaw = {
					lerp_basic = 0.01 * multi,
					lerp_perfect = 0 * multi,
				},
			},
			{
				pitch = {
					lerp_basic = 0.01 * multi,
					lerp_perfect = 0.0075 * multi,
				},
				yaw = {
					lerp_basic = 0.005 * multi,
					lerp_perfect = 0 * multi,
				},
			},
		},
		offset_random_range = {
			{
				pitch = {
					lerp_basic = 0.02,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.002,
					lerp_perfect = 0,
				},
			},
		},
		offset_limit = {
			pitch = 2,
			yaw = 2,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
		visual_recoil_settings = {
			intensity = 3.3,
			lerp_scalar = 0.8,
			yaw_intensity = 3.1,
		},
	},
	moving = {
		new_influence_percent = 0.1,
		inherits = {
			"default_laspistol_killshot",
			"still",
		},
	},
	crouch_still = {
		new_influence_percent = 0.05,
		inherits = {
			"default_laspistol_killshot",
			"still",
		},
	},
	crouch_moving = {
		new_influence_percent = 0.08,
		inherits = {
			"default_laspistol_killshot",
			"still",
		},
	},
}

local multi_2 = 1.7

recoil_templates.default_laspistol_bfg = {
	still = {
		camera_recoil_percentage = 0.2,
		decay_grace = 0.042,
		new_influence_percent = 0.3,
		rise_duration = 0.06,
		rise = {
			{
				lerp_basic = 1.5,
				lerp_perfect = 0.4,
			},
			{
				lerp_basic = 0.7,
				lerp_perfect = 0.25,
			},
			{
				lerp_basic = 0.6,
				lerp_perfect = 0.23,
			},
			{
				lerp_basic = 0.3,
				lerp_perfect = 0.2,
			},
		},
		decay = {
			shooting = {
				lerp_basic = 0.5,
				lerp_perfect = 3,
			},
			idle = {
				lerp_basic = 0.8,
				lerp_perfect = 3,
			},
		},
		offset = {
			{
				pitch = {
					lerp_basic = 0.07 * multi_2,
					lerp_perfect = 0.03 * multi_2,
				},
				yaw = {
					lerp_basic = 0.03 * multi_2,
					lerp_perfect = 0.01 * multi_2,
				},
			},
			{
				pitch = {
					lerp_basic = 0.05 * multi_2,
					lerp_perfect = 0.025 * multi_2,
				},
				yaw = {
					lerp_basic = 0.03 * multi_2,
					lerp_perfect = 0.01 * multi_2,
				},
			},
			{
				pitch = {
					lerp_basic = 0.03 * multi_2,
					lerp_perfect = 0.015 * multi_2,
				},
				yaw = {
					lerp_basic = 0.03 * multi_2,
					lerp_perfect = 0.01 * multi_2,
				},
			},
			{
				pitch = {
					lerp_basic = 0.02 * multi_2,
					lerp_perfect = 0.01 * multi_2,
				},
				yaw = {
					lerp_basic = 0.02 * multi_2,
					lerp_perfect = 0.005 * multi_2,
				},
			},
			{
				pitch = {
					lerp_basic = 0.015 * multi_2,
					lerp_perfect = 0.01 * multi_2,
				},
				yaw = {
					lerp_basic = 0.01 * multi_2,
					lerp_perfect = 0 * multi_2,
				},
			},
			{
				pitch = {
					lerp_basic = 0.01 * multi_2,
					lerp_perfect = 0.0075 * multi_2,
				},
				yaw = {
					lerp_basic = 0.005 * multi,
					lerp_perfect = 0 * multi,
				},
			},
		},
		offset_random_range = {
			{
				pitch = {
					lerp_basic = 0.02,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.02,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.025,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.025,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.03,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.03,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.035,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.035,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.04,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.04,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.03,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.03,
					lerp_perfect = 0,
				},
			},
		},
		offset_limit = {
			pitch = 2,
			yaw = 2,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
		visual_recoil_settings = {
			intensity = 4.3,
			lerp_scalar = 0.9,
			yaw_intensity = 4.1,
		},
	},
	moving = {
		new_influence_percent = 0.3,
		inherits = {
			"default_laspistol_bfg",
			"still",
		},
		visual_recoil_settings = {
			intensity = 5.3,
			lerp_scalar = 0.8,
			yaw_intensity = 3.1,
		},
	},
	crouch_still = {
		new_influence_percent = 0.35,
		inherits = {
			"default_laspistol_bfg",
			"still",
		},
	},
	crouch_moving = {
		new_influence_percent = 0.45,
		inherits = {
			"default_laspistol_bfg",
			"still",
		},
		visual_recoil_settings = {
			intensity = 4.3,
			lerp_scalar = 0.8,
			yaw_intensity = 4.1,
		},
	},
}
recoil_templates.ads_default_laspistol_bfg = {
	still = {
		camera_recoil_percentage = 0.2,
		decay_grace = 0.88,
		new_influence_percent = 0.2,
		rise_duration = 0.03,
		rise = {
			{
				lerp_basic = 1,
				lerp_perfect = 0.4,
			},
			{
				lerp_basic = 0.7,
				lerp_perfect = 0.25,
			},
			{
				lerp_basic = 0.6,
				lerp_perfect = 0.23,
			},
			{
				lerp_basic = 0.3,
				lerp_perfect = 0.2,
			},
		},
		decay = {
			shooting = {
				lerp_basic = 0.5,
				lerp_perfect = 3,
			},
			idle = {
				lerp_basic = 0.8,
				lerp_perfect = 3,
			},
		},
		offset = {
			{
				pitch = {
					lerp_basic = 0.07 * multi_2,
					lerp_perfect = 0.03 * multi_2,
				},
				yaw = {
					lerp_basic = 0.03 * multi_2,
					lerp_perfect = 0.01 * multi_2,
				},
			},
			{
				pitch = {
					lerp_basic = 0.05 * multi_2,
					lerp_perfect = 0.025 * multi_2,
				},
				yaw = {
					lerp_basic = 0.03 * multi_2,
					lerp_perfect = 0.01 * multi_2,
				},
			},
			{
				pitch = {
					lerp_basic = 0.03 * multi_2,
					lerp_perfect = 0.015 * multi_2,
				},
				yaw = {
					lerp_basic = 0.03 * multi_2,
					lerp_perfect = 0.01 * multi_2,
				},
			},
			{
				pitch = {
					lerp_basic = 0.02 * multi_2,
					lerp_perfect = 0.01 * multi_2,
				},
				yaw = {
					lerp_basic = 0.02 * multi_2,
					lerp_perfect = 0.005 * multi_2,
				},
			},
			{
				pitch = {
					lerp_basic = 0.015 * multi_2,
					lerp_perfect = 0.01 * multi_2,
				},
				yaw = {
					lerp_basic = 0.01 * multi_2,
					lerp_perfect = 0 * multi_2,
				},
			},
			{
				pitch = {
					lerp_basic = 0.01 * multi_2,
					lerp_perfect = 0.0075 * multi_2,
				},
				yaw = {
					lerp_basic = 0.005 * multi,
					lerp_perfect = 0 * multi,
				},
			},
		},
		offset_random_range = {
			{
				pitch = {
					lerp_basic = 0.02,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.02,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.025,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.025,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.03,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.03,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.035,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.035,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.04,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.04,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.03,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.03,
					lerp_perfect = 0,
				},
			},
		},
		offset_limit = {
			pitch = 2,
			yaw = 2,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
		visual_recoil_settings = {
			intensity = 5.3,
			lerp_scalar = 0.8,
			yaw_intensity = 4.1,
		},
	},
	moving = {
		new_influence_percent = 0.2,
		inherits = {
			"ads_default_laspistol_bfg",
			"still",
		},
		visual_recoil_settings = {
			intensity = 5.3,
			lerp_scalar = 0.8,
			yaw_intensity = 3.1,
		},
	},
	crouch_still = {
		new_influence_percent = 0.28,
		inherits = {
			"ads_default_laspistol_bfg",
			"still",
		},
	},
	crouch_moving = {
		new_influence_percent = 0.25,
		inherits = {
			"ads_default_laspistol_bfg",
			"still",
		},
		visual_recoil_settings = {
			intensity = 4.3,
			lerp_scalar = 0.8,
			yaw_intensity = 4.1,
		},
	},
}

return {
	base_templates = recoil_templates,
	overrides = overrides,
}
