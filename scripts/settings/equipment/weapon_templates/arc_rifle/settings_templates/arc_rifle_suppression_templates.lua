-- chunkname: @scripts/settings/equipment/weapon_templates/arc_rifle/settings_templates/arc_rifle_suppression_templates.lua

local suppression_templates = {}
local overrides = {}

table.make_unique(suppression_templates)
table.make_unique(overrides)

suppression_templates.arc_rifle_p1_m1_supression = {
	still = {
		decay_time = 0.25,
		delay = 1,
		immediate_spread = {
			{
				pitch = {
					lerp_basic = 3,
					lerp_perfect = 2,
				},
				yaw = {
					lerp_basic = 3,
					lerp_perfect = 2,
				},
			},
			{
				pitch = {
					lerp_basic = 3.5,
					lerp_perfect = 2.5,
				},
				yaw = {
					lerp_basic = 3.5,
					lerp_perfect = 2.5,
				},
			},
			{
				pitch = {
					lerp_basic = 3,
					lerp_perfect = 2,
				},
				yaw = {
					lerp_basic = 3,
					lerp_perfect = 2,
				},
			},
			{
				pitch = {
					lerp_basic = 2.5,
					lerp_perfect = 1.5,
				},
				yaw = {
					lerp_basic = 2.5,
					lerp_perfect = 1.5,
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
		},
	},
	moving = {
		inherits = {
			"arc_rifle_p1_m1_supression",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"arc_rifle_p1_m1_supression",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"arc_rifle_p1_m1_supression",
			"still",
		},
	},
}

return {
	base_templates = suppression_templates,
	overrides = overrides,
}
