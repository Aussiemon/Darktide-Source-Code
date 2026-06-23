-- chunkname: @scripts/settings/equipment/weapon_templates/phosphor_pistol/settings_templates/phosphor_pistol_suppression_templates.lua

local suppression_templates = {}
local overrides = {}

table.make_unique(suppression_templates)
table.make_unique(overrides)

suppression_templates.phosphor_pistol_p1_m1_suppression_hip = {
	still = {
		decay_time = 0.5,
		delay = 0.2,
		immediate_spread = {
			{
				pitch = {
					lerp_basic = 1,
					lerp_perfect = 0.5,
				},
				yaw = {
					lerp_basic = 1,
					lerp_perfect = 0.5,
				},
			},
			{
				pitch = {
					lerp_basic = 2,
					lerp_perfect = 1,
				},
				yaw = {
					lerp_basic = 2,
					lerp_perfect = 1,
				},
			},
			{
				pitch = {
					lerp_basic = 2,
					lerp_perfect = 2,
				},
				yaw = {
					lerp_basic = 2,
					lerp_perfect = 2,
				},
			},
		},
	},
	moving = {
		inherits = {
			"phosphor_pistol_p1_m1_suppression_hip",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"phosphor_pistol_p1_m1_suppression_hip",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"phosphor_pistol_p1_m1_suppression_hip",
			"still",
		},
	},
}
suppression_templates.phosphor_pistol_p1_m1_suppression_ads = {
	still = {
		decay_time = 0.5,
		delay = 0.2,
		immediate_sway = {
			{
				pitch = {
					lerp_basic = 0.25,
					lerp_perfect = 0.1,
				},
				yaw = {
					lerp_basic = 0.25,
					lerp_perfect = 0.1,
				},
			},
			{
				pitch = {
					lerp_basic = 0.5,
					lerp_perfect = 0.25,
				},
				yaw = {
					lerp_basic = 0.5,
					lerp_perfect = 0.25,
				},
			},
			{
				pitch = {
					lerp_basic = 1,
					lerp_perfect = 1.5,
				},
				yaw = {
					lerp_basic = 1,
					lerp_perfect = 1,
				},
			},
		},
	},
	moving = {
		inherits = {
			"phosphor_pistol_p1_m1_suppression_ads",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"phosphor_pistol_p1_m1_suppression_ads",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"phosphor_pistol_p1_m1_suppression_ads",
			"still",
		},
	},
}

return {
	base_templates = suppression_templates,
	overrides = overrides,
}
