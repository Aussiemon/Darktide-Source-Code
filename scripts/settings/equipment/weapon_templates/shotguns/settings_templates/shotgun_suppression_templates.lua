-- chunkname: @scripts/settings/equipment/weapon_templates/shotguns/settings_templates/shotgun_suppression_templates.lua

local suppression_templates = {}
local overrides = {}

table.make_unique(suppression_templates)
table.make_unique(overrides)

suppression_templates.shotgun_p1_m1_suppression_assault = {
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
			"shotgun_p1_m1_suppression_assault",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"shotgun_p1_m1_suppression_assault",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"shotgun_p1_m1_suppression_assault",
			"still",
		},
	},
}
suppression_templates.shotgun_p1_m1_suppression_killshot = {
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
			"shotgun_p1_m1_suppression_killshot",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"shotgun_p1_m1_suppression_killshot",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"shotgun_p1_m1_suppression_killshot",
			"still",
		},
	},
}

return {
	base_templates = suppression_templates,
	overrides = overrides,
}
