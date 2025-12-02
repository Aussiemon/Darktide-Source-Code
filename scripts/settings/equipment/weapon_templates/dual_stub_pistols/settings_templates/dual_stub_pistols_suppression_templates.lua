-- chunkname: @scripts/settings/equipment/weapon_templates/dual_stub_pistols/settings_templates/dual_stub_pistols_suppression_templates.lua

local suppression_templates = {}
local overrides = {}

table.make_unique(suppression_templates)
table.make_unique(overrides)

suppression_templates.dual_stub_pistols = {
	still = {
		decay_time = 0.25,
		delay = 1,
		immediate_spread = {
			{
				pitch = {
					lerp_basic = 6,
					lerp_perfect = 3,
				},
				yaw = {
					lerp_basic = 6,
					lerp_perfect = 3,
				},
			},
			{
				pitch = {
					lerp_basic = 5.5,
					lerp_perfect = 2.5,
				},
				yaw = {
					lerp_basic = 5.5,
					lerp_perfect = 2.5,
				},
			},
			{
				pitch = {
					lerp_basic = 5,
					lerp_perfect = 2,
				},
				yaw = {
					lerp_basic = 5,
					lerp_perfect = 2,
				},
			},
			{
				pitch = {
					lerp_basic = 4.5,
					lerp_perfect = 1.5,
				},
				yaw = {
					lerp_basic = 4.5,
					lerp_perfect = 1.5,
				},
			},
			{
				pitch = {
					lerp_basic = 4,
					lerp_perfect = 1,
				},
				yaw = {
					lerp_basic = 4,
					lerp_perfect = 1,
				},
			},
		},
	},
	moving = {
		inherits = {
			"dual_stub_pistols",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"dual_stub_pistols",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"dual_stub_pistols",
			"still",
		},
	},
}

return {
	base_templates = suppression_templates,
	overrides = overrides,
}
