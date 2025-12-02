-- chunkname: @scripts/settings/equipment/weapon_templates/ripperguns/settings_templates/rippergun_suppression_templates.lua

local suppression_templates = {}
local overrides = {}

table.make_unique(suppression_templates)
table.make_unique(overrides)

suppression_templates.rippergun_p1_m1_suppression_assault = {
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
			"rippergun_p1_m1_suppression_assault",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"rippergun_p1_m1_suppression_assault",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"rippergun_p1_m1_suppression_assault",
			"still",
		},
	},
}
suppression_templates.rippergun_p1_m1_suppression_spraynpray = {
	still = {
		decay_time = 0.25,
		delay = 1,
		immediate_spread = {
			{
				pitch = 0.25,
				yaw = 0.25,
			},
		},
	},
	moving = {
		inherits = {
			"rippergun_p1_m1_suppression_spraynpray",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"rippergun_p1_m1_suppression_spraynpray",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"rippergun_p1_m1_suppression_spraynpray",
			"still",
		},
	},
}

return {
	base_templates = suppression_templates,
	overrides = overrides,
}
