-- chunkname: @scripts/settings/equipment/weapon_templates/autopistols/settings_templates/autopistol_recoil_templates.lua

local RecoilTemplate = require("scripts/utilities/recoil_template")
local generate_offset_range = RecoilTemplate.generate_offset_range
local create_scale = RecoilTemplate.create_scale
local AIM_ASSIST_MULTIPLIER_FUNCTIONS = RecoilTemplate.AIM_ASSIST_MULTIPLIER_FUNCTIONS
local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

local assault_scale = {
	{
		1,
		{
			1,
			1
		}
	},
	{
		5,
		{
			0.7,
			0.7
		}
	},
	{
		8,
		{
			0.5,
			0.5
		}
	},
	{
		30,
		{
			0.3,
			0.3
		}
	}
}
local spray_n_pray_scale = {
	{
		1,
		{
			2.7,
			1.7
		}
	},
	{
		5,
		{
			0.25,
			0.25
		}
	},
	{
		8,
		{
			0.5,
			0.5
		}
	},
	{
		15,
		{
			1,
			1
		}
	},
	{
		30,
		{
			0.5,
			0.612
		}
	}
}
local spray_n_pray_random_scale = {
	{
		1,
		{
			0.05,
			0.05
		}
	},
	{
		5,
		{
			0.25,
			0.25
		}
	},
	{
		15,
		{
			1,
			1
		}
	},
	{
		30,
		{
			0.75,
			0.75
		}
	}
}
local assault_random_scale = {
	{
		1,
		{
			0.05,
			0.05
		}
	},
	{
		5,
		{
			0.25,
			0.25
		}
	},
	{
		30,
		{
			1,
			1
		}
	}
}
local num_shot = 30
local pitch_base = 0.005
local yaw_base = 0.0075
local lerp_distance = 0.98
local spray_n_pray_offset_range = generate_offset_range(num_shot, pitch_base, yaw_base, lerp_distance, create_scale(spray_n_pray_scale))
local spray_n_pray_random_range = generate_offset_range(30, 0.015, 0.02, 0.8, create_scale(spray_n_pray_random_scale))
local assault_offset_range = generate_offset_range(30, 0.04, 0, 0.25, create_scale(assault_scale))
local assault_random_range = generate_offset_range(30, 0.015, 0.03, 0.25, create_scale(assault_random_scale))

recoil_templates.default_autopistol_assault = {
	still = {
		camera_recoil_percentage = 0.8,
		decay_grace = 0,
		new_influence_percent = 0.5,
		rise_duration = 0.05,
		rise = {
			0.4,
			0.25,
			0.15,
			0.075,
			0.1,
			0.075,
			0.05,
			0.025
		},
		decay = {
			shooting = 1.5,
			idle = 4
		},
		offset = assault_offset_range,
		offset_random_range = assault_random_range,
		offset_limit = {
			yaw = 0.75,
			pitch = 0.75
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		},
		visual_recoil_settings = {
			intensity = 7,
			lerp_scalar = 0.4,
			yaw_intensity = 3
		}
	},
	moving = {
		new_influence_percent = 0.55,
		inherits = {
			"default_autopistol_assault",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.25,
		inherits = {
			"default_autopistol_assault",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.4,
		inherits = {
			"default_autopistol_assault",
			"still"
		}
	}
}
recoil_templates.default_autopistol_spraynpray = {
	still = {
		camera_recoil_percentage = 0.8,
		decay_grace = 0.05,
		new_influence_percent = 0.5,
		rise_duration = 0.05,
		rise = {
			0.4,
			0.1,
			0.1,
			0.1,
			0.2
		},
		decay = {
			shooting = 4,
			idle = 2
		},
		offset = spray_n_pray_offset_range,
		offset_random_range = spray_n_pray_random_range,
		offset_limit = {
			yaw = 2,
			pitch = 0.75
		},
		visual_recoil_settings = {
			intensity = 7,
			lerp_scalar = 0.4,
			yaw_intensity = 3
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		}
	},
	moving = {
		new_influence_percent = 0.6,
		inherits = {
			"default_autopistol_spraynpray",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.3,
		inherits = {
			"default_autopistol_spraynpray",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.75,
		inherits = {
			"default_autopistol_spraynpray",
			"still"
		}
	}
}

return {
	base_templates = recoil_templates,
	overrides = overrides
}
