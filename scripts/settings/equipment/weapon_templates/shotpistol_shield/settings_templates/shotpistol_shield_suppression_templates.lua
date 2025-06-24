-- chunkname: @scripts/settings/equipment/weapon_templates/shotpistol_shield/settings_templates/shotpistol_shield_suppression_templates.lua

local suppression_templates = {}
local overrides = {}

table.make_unique(suppression_templates)
table.make_unique(overrides)

suppression_templates.default_shotpistol_shield_ads = {
	still = {
		decay_time = 0.6,
		delay = 0.2,
		immediate_sway = {
			{
				pitch = {
					lerp_basic = 1.25,
					lerp_perfect = 0.75,
				},
				yaw = {
					lerp_basic = 1.25,
					lerp_perfect = 0.7,
				},
			},
			{
				pitch = {
					lerp_basic = 1.5,
					lerp_perfect = 0.4,
				},
				yaw = {
					lerp_basic = 1.5,
					lerp_perfect = 0.25,
				},
			},
			{
				pitch = {
					lerp_basic = 1.3,
					lerp_perfect = 0.2,
				},
				yaw = {
					lerp_basic = 1.2,
					lerp_perfect = 1.5,
				},
			},
			{
				pitch = {
					lerp_basic = 1.3,
					lerp_perfect = 0.2,
				},
				yaw = {
					lerp_basic = 1.3,
					lerp_perfect = 0.2,
				},
			},
			{
				pitch = {
					lerp_basic = 1.4,
					lerp_perfect = 0.3,
				},
				yaw = {
					lerp_basic = 1.4,
					lerp_perfect = 0.3,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_shotpistol_shield_ads",
			"still",
		},
		immediate_sway = {
			{
				pitch = {
					lerp_basic = 1.25,
					lerp_perfect = 0.75,
				},
				yaw = {
					lerp_basic = 1.25,
					lerp_perfect = 0.7,
				},
			},
			{
				pitch = {
					lerp_basic = 1.5,
					lerp_perfect = 0.4,
				},
				yaw = {
					lerp_basic = 1.5,
					lerp_perfect = 0.25,
				},
			},
			{
				pitch = {
					lerp_basic = 1.3,
					lerp_perfect = 0.2,
				},
				yaw = {
					lerp_basic = 1.2,
					lerp_perfect = 1.5,
				},
			},
			{
				pitch = {
					lerp_basic = 1.3,
					lerp_perfect = 0.2,
				},
				yaw = {
					lerp_basic = 1.3,
					lerp_perfect = 0.2,
				},
			},
			{
				pitch = {
					lerp_basic = 1.4,
					lerp_perfect = 0.3,
				},
				yaw = {
					lerp_basic = 1.4,
					lerp_perfect = 0.3,
				},
			},
		},
	},
	crouch_still = {
		inherits = {
			"default_shotpistol_shield_ads",
			"still",
		},
		immediate_sway = {
			{
				pitch = {
					lerp_basic = 1.25,
					lerp_perfect = 0.75,
				},
				yaw = {
					lerp_basic = 1.25,
					lerp_perfect = 0.7,
				},
			},
			{
				pitch = {
					lerp_basic = 1.5,
					lerp_perfect = 0.4,
				},
				yaw = {
					lerp_basic = 1.5,
					lerp_perfect = 0.25,
				},
			},
			{
				pitch = {
					lerp_basic = 1.3,
					lerp_perfect = 0.2,
				},
				yaw = {
					lerp_basic = 1.2,
					lerp_perfect = 1.5,
				},
			},
			{
				pitch = {
					lerp_basic = 1.3,
					lerp_perfect = 0.2,
				},
				yaw = {
					lerp_basic = 1.3,
					lerp_perfect = 0.2,
				},
			},
			{
				pitch = {
					lerp_basic = 1.4,
					lerp_perfect = 0.3,
				},
				yaw = {
					lerp_basic = 1.4,
					lerp_perfect = 0.3,
				},
			},
		},
	},
	crouch_moving = {
		inherits = {
			"default_shotpistol_shield_ads",
			"still",
		},
		immediate_sway = {
			{
				pitch = {
					lerp_basic = 1.25,
					lerp_perfect = 0.75,
				},
				yaw = {
					lerp_basic = 1.25,
					lerp_perfect = 0.7,
				},
			},
			{
				pitch = {
					lerp_basic = 1.5,
					lerp_perfect = 0.4,
				},
				yaw = {
					lerp_basic = 1.5,
					lerp_perfect = 0.25,
				},
			},
			{
				pitch = {
					lerp_basic = 1.3,
					lerp_perfect = 0.2,
				},
				yaw = {
					lerp_basic = 1.2,
					lerp_perfect = 1.5,
				},
			},
			{
				pitch = {
					lerp_basic = 1.3,
					lerp_perfect = 0.2,
				},
				yaw = {
					lerp_basic = 1.3,
					lerp_perfect = 0.2,
				},
			},
			{
				pitch = {
					lerp_basic = 1.4,
					lerp_perfect = 0.3,
				},
				yaw = {
					lerp_basic = 1.4,
					lerp_perfect = 0.3,
				},
			},
		},
	},
}

return {
	base_templates = suppression_templates,
	overrides = overrides,
}
