-- chunkname: @scripts/settings/equipment/weapon_templates/grenadier_gauntlets/settings_templates/grenadier_gauntlet_suppression_templates.lua

local suppression_templates = {}
local overrides = {}

table.make_unique(suppression_templates)
table.make_unique(overrides)

suppression_templates.grenadier_gauntlet_p1_m1_suppression_demolitions = {
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
			"grenadier_gauntlet_p1_m1_suppression_demolitions",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"grenadier_gauntlet_p1_m1_suppression_demolitions",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"grenadier_gauntlet_p1_m1_suppression_demolitions",
			"still",
		},
	},
}

return {
	base_templates = suppression_templates,
	overrides = overrides,
}
