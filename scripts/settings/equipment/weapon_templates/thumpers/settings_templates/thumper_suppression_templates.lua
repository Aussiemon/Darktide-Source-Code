-- chunkname: @scripts/settings/equipment/weapon_templates/thumpers/settings_templates/thumper_suppression_templates.lua

local suppression_templates = {}
local overrides = {}

table.make_unique(suppression_templates)
table.make_unique(overrides)

suppression_templates.thumper_p1_m1_suppression_assault = {
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
			"thumper_p1_m1_suppression_assault",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"thumper_p1_m1_suppression_assault",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"thumper_p1_m1_suppression_assault",
			"still",
		},
	},
}

return {
	base_templates = suppression_templates,
	overrides = overrides,
}
