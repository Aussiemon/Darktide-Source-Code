-- chunkname: @scripts/settings/equipment/weapon_templates/bolters/settings_templates/bolter_recoil_templates.lua

local RecoilTemplate = require("scripts/utilities/recoil_template")
local AIM_ASSIST_MULTIPLIER_FUNCTIONS = RecoilTemplate.AIM_ASSIST_MULTIPLIER_FUNCTIONS
local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

recoil_templates.default_bolter_spraynpray = {
	still = {
		camera_recoil_percentage = 0.5,
		decay_grace = 0.1,
		new_influence_percent = 0.5,
		rise_duration = 0.075,
		rise = {
			0.75,
			0.35,
			0.3,
		},
		decay = {
			idle = 2.75,
			shooting = 0.25,
		},
		offset = {
			{
				pitch = 0.05,
				yaw = 0,
			},
			{
				pitch = 0.035,
				yaw = 0,
			},
			{
				pitch = 0.025,
				yaw = 0,
			},
			{
				pitch = 0.015,
				yaw = 0,
			},
		},
		offset_random_range = {
			{
				pitch = 0.025,
				yaw = 0.04,
			},
			{
				pitch = 0.025,
				yaw = 0.05,
			},
			{
				pitch = 0.025,
				yaw = 0.065,
			},
		},
		offset_limit = {
			pitch = 2,
			yaw = 2,
		},
		visual_recoil_settings = {
			intensity = 1,
			lerp_scalar = 0.1,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
	},
	moving = {
		new_influence_percent = 0.5,
		inherits = {
			"default_bolter_spraynpray",
			"still",
		},
	},
	crouch_still = {
		new_influence_percent = 0.5,
		inherits = {
			"default_bolter_spraynpray",
			"still",
		},
	},
	crouch_moving = {
		new_influence_percent = 0.5,
		inherits = {
			"default_bolter_spraynpray",
			"still",
		},
	},
}
recoil_templates.default_bolter_killshot = {
	still = {
		camera_recoil_percentage = 0.2,
		new_influence_percent = 0.42,
		rise_duration = 0.07,
		rise = {
			0.75,
			0.65,
			0.5,
		},
		decay = {
			idle = 0.8,
			shooting = 0.2,
		},
		offset = {
			{
				pitch = 0.075,
				yaw = 0,
			},
			{
				pitch = 0.05,
				yaw = 0,
			},
			{
				pitch = 0.035,
				yaw = 0,
			},
		},
		offset_random_range = {
			{
				pitch = 0.025,
				yaw = 0.1,
			},
			{
				pitch = 0.025,
				yaw = 0.1,
			},
			{
				pitch = 0.025,
				yaw = 0.1,
			},
		},
		offset_limit = {
			pitch = 1.25,
			yaw = 1,
		},
		visual_recoil_settings = {
			intensity = 5,
			lerp_scalar = 0.8,
			yaw_intensity = 7.5,
		},
	},
	moving = {
		new_influence_percent = 1,
		inherits = {
			"default_bolter_killshot",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"default_bolter_killshot",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"default_bolter_killshot",
			"still",
		},
	},
}

return {
	base_templates = recoil_templates,
	overrides = overrides,
}
