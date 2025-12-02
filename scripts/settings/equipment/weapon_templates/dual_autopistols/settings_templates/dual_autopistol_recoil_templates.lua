-- chunkname: @scripts/settings/equipment/weapon_templates/dual_autopistols/settings_templates/dual_autopistol_recoil_templates.lua

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
			1,
		},
	},
	{
		5,
		{
			0.7,
			0.7,
		},
	},
	{
		8,
		{
			0.5,
			0.5,
		},
	},
	{
		30,
		{
			0.3,
			0.3,
		},
	},
}
local spray_n_pray_scale = {
	{
		1,
		{
			2.7,
			1.7,
		},
	},
	{
		5,
		{
			0.25,
			0.25,
		},
	},
	{
		8,
		{
			0.5,
			0.5,
		},
	},
	{
		15,
		{
			1,
			1,
		},
	},
	{
		30,
		{
			0.5,
			0.612,
		},
	},
}
local spray_n_pray_random_scale = {
	{
		1,
		{
			0.05,
			0.05,
		},
	},
	{
		5,
		{
			0.25,
			0.25,
		},
	},
	{
		15,
		{
			1,
			1,
		},
	},
	{
		30,
		{
			0.75,
			0.75,
		},
	},
}
local assault_random_scale = {
	{
		1,
		{
			0.05,
			0.05,
		},
	},
	{
		5,
		{
			0.25,
			0.25,
		},
	},
	{
		30,
		{
			1,
			1,
		},
	},
}
local num_shot = 30
local pitch_base = 0.005
local yaw_base = 0.0075
local lerp_distance = 0.98
local spray_n_pray_offset_range = generate_offset_range(num_shot, pitch_base, yaw_base, lerp_distance, create_scale(spray_n_pray_scale))
local spray_n_pray_random_range = generate_offset_range(30, 0.015, 0.02, 0.8, create_scale(spray_n_pray_random_scale))
local assault_offset_range = generate_offset_range(30, 0.04, 0, 0.25, create_scale(assault_scale))
local assault_random_range = generate_offset_range(30, 0.015, 0.03, 0.25, create_scale(assault_random_scale))

recoil_templates.default_dual_autopistol_assault = {
	still = {
		camera_recoil_percentage = 0.8,
		decay_grace = 0.1,
		new_influence_percent = 0.5,
		rise_duration = 0.03,
		rise = {
			0.27,
			0.16,
			0.23,
			0.155,
			0.13,
			0.15,
			0.14,
			0.135,
		},
		decay = {
			idle = 2.5,
			shooting = 2,
		},
		offset = assault_offset_range,
		offset_random_range = assault_random_range,
		offset_limit = {
			pitch = 0.75,
			yaw = 0.75,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
		visual_recoil_settings = {
			intensity = 6,
			lerp_scalar = 0.4,
			yaw_intensity = 3,
		},
	},
	moving = {
		new_influence_percent = 1,
		inherits = {
			"default_dual_autopistol_assault",
			"still",
		},
	},
	crouch_still = {
		new_influence_percent = 0.55,
		inherits = {
			"default_dual_autopistol_assault",
			"still",
		},
	},
	crouch_moving = {
		new_influence_percent = 0.75,
		inherits = {
			"default_dual_autopistol_assault",
			"still",
		},
	},
}
recoil_templates.default_dual_autopistol_spraynpray = {
	still = {
		camera_recoil_percentage = 0.8,
		decay_grace = 0.1,
		new_influence_percent = 0.5,
		rise_duration = 0.035,
		rise = {
			0.32,
			0.21,
			0.22,
			0.175,
			0.19,
			0.175,
			0.15,
			0.13,
		},
		decay = {
			idle = 2.4,
			shooting = 2.25,
		},
		offset = assault_offset_range,
		offset_random_range = assault_random_range,
		offset_limit = {
			pitch = 0.75,
			yaw = 0.75,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
		visual_recoil_settings = {
			intensity = 5,
			lerp_scalar = 0.4,
			yaw_intensity = 2.5,
		},
	},
	moving = {
		new_influence_percent = 1,
		inherits = {
			"default_dual_autopistol_assault",
			"still",
		},
	},
	crouch_still = {
		new_influence_percent = 0.55,
		inherits = {
			"default_dual_autopistol_assault",
			"still",
		},
	},
	crouch_moving = {
		new_influence_percent = 0.75,
		inherits = {
			"default_dual_autopistol_assault",
			"still",
		},
	},
}

return {
	base_templates = recoil_templates,
	overrides = overrides,
}
