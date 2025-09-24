-- chunkname: @scripts/settings/equipment/weapon_templates/bolt_pistols/settings_templates/boltpistol_suppression_templates.lua

local suppression_templates = {}
local overrides = {}

table.make_unique(suppression_templates)
table.make_unique(overrides)

suppression_templates.boltpistol_p1_m1_suppression_assault = {
	still = {
		decay_time = 0.6,
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
					lerp_basic = 3,
					lerp_perfect = 2,
				},
				yaw = {
					lerp_basic = 3,
					lerp_perfect = 2,
				},
			},
		},
	},
	moving = {
		inherits = {
			"boltpistol_p1_m1_suppression_assault",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"boltpistol_p1_m1_suppression_assault",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"boltpistol_p1_m1_suppression_assault",
			"still",
		},
	},
}
suppression_templates.boltpistol_p1_m1_suppression_killshot = {
	still = {
		decay_time = 0.6,
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
					lerp_basic = 2,
					lerp_perfect = 1.5,
				},
				yaw = {
					lerp_basic = 2,
					lerp_perfect = 1.5,
				},
			},
			{
				pitch = {
					lerp_basic = 3,
					lerp_perfect = 2.5,
				},
				yaw = {
					lerp_basic = 3,
					lerp_perfect = 2.5,
				},
			},
			{
				pitch = {
					lerp_basic = 4,
					lerp_perfect = 3.5,
				},
				yaw = {
					lerp_basic = 4,
					lerp_perfect = 3.5,
				},
			},
		},
	},
	moving = {
		inherits = {
			"boltpistol_p1_m1_suppression_killshot",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"boltpistol_p1_m1_suppression_killshot",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"boltpistol_p1_m1_suppression_killshot",
			"still",
		},
	},
}

return {
	base_templates = suppression_templates,
	overrides = overrides,
}
