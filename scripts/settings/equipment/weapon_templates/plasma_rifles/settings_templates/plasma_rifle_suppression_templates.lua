-- chunkname: @scripts/settings/equipment/weapon_templates/plasma_rifles/settings_templates/plasma_rifle_suppression_templates.lua

local suppression_templates = {}
local overrides = {}

table.make_unique(suppression_templates)
table.make_unique(overrides)

suppression_templates.plasmarifle_p1_m1_suppression_bfg = {
	still = {
		decay_time = 0.25,
		delay = 1,
		immediate_spread = {
			{
				pitch = 0.5,
				yaw = 0.5,
			},
		},
	},
	moving = {
		inherits = {
			"plasmarifle_p1_m1_suppression_bfg",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"plasmarifle_p1_m1_suppression_bfg",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"plasmarifle_p1_m1_suppression_bfg",
			"still",
		},
	},
}
suppression_templates.plasmarifle_p1_m1_suppression_demolitions = {
	still = {
		decay_time = 0.25,
		delay = 1,
		immediate_spread = {
			{
				pitch = 0.15,
				yaw = 0.15,
			},
		},
	},
	moving = {
		inherits = {
			"plasmarifle_p1_m1_suppression_demolitions",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"plasmarifle_p1_m1_suppression_demolitions",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"plasmarifle_p1_m1_suppression_demolitions",
			"still",
		},
	},
}

return {
	base_templates = suppression_templates,
	overrides = overrides,
}
