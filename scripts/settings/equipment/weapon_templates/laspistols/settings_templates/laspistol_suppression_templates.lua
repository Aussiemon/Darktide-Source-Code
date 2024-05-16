﻿-- chunkname: @scripts/settings/equipment/weapon_templates/laspistols/settings_templates/laspistol_suppression_templates.lua

local suppression_templates = {}
local overrides = {}

table.make_unique(suppression_templates)
table.make_unique(overrides)

suppression_templates.default_laspistol_killshot = {
	still = {
		decay_time = 0.6,
		delay = 0.2,
		immediate_sway = {
			{
				pitch = {
					lerp_basic = 0.2,
					lerp_perfect = 0.1,
				},
				yaw = {
					lerp_basic = 0.2,
					lerp_perfect = 0.1,
				},
			},
			{
				pitch = {
					lerp_basic = 0.3,
					lerp_perfect = 0.15,
				},
				yaw = {
					lerp_basic = 0.3,
					lerp_perfect = 0.15,
				},
			},
			{
				pitch = {
					lerp_basic = 0.4,
					lerp_perfect = 0.2,
				},
				yaw = {
					lerp_basic = 0.4,
					lerp_perfect = 0.2,
				},
			},
			{
				pitch = {
					lerp_basic = 0.5,
					lerp_perfect = 0.3,
				},
				yaw = {
					lerp_basic = 0.5,
					lerp_perfect = 0.3,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_laspistol_killshot",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"default_laspistol_killshot",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"default_laspistol_killshot",
			"still",
		},
	},
}
suppression_templates.hip_laspistol_killshot = {
	still = {
		decay_time = 0.6,
		delay = 0.2,
		immediate_spread = {
			{
				pitch = {
					lerp_basic = 0.2,
					lerp_perfect = 0.1,
				},
				yaw = {
					lerp_basic = 0.2,
					lerp_perfect = 0.1,
				},
			},
			{
				pitch = {
					lerp_basic = 0.3,
					lerp_perfect = 0.15,
				},
				yaw = {
					lerp_basic = 0.3,
					lerp_perfect = 0.15,
				},
			},
			{
				pitch = {
					lerp_basic = 0.4,
					lerp_perfect = 0.2,
				},
				yaw = {
					lerp_basic = 0.4,
					lerp_perfect = 0.2,
				},
			},
			{
				pitch = {
					lerp_basic = 0.5,
					lerp_perfect = 0.3,
				},
				yaw = {
					lerp_basic = 0.5,
					lerp_perfect = 0.3,
				},
			},
		},
	},
	moving = {
		inherits = {
			"hip_laspistol_killshot",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"hip_laspistol_killshot",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"hip_laspistol_killshot",
			"still",
		},
	},
}

return {
	base_templates = suppression_templates,
	overrides = overrides,
}
