-- chunkname: @scripts/settings/equipment/weapon_templates/force_staffs/settings_templates/force_staff_suppression_templates.lua

local suppression_templates = {}
local overrides = {}

table.make_unique(suppression_templates)
table.make_unique(overrides)

suppression_templates.force_staff_p1_m1_suppression_assault = {
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
			"force_staff_p1_m1_suppression_assault",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"force_staff_p1_m1_suppression_assault",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"force_staff_p1_m1_suppression_assault",
			"still",
		},
	},
}

return {
	base_templates = suppression_templates,
	overrides = overrides,
}
