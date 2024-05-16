-- chunkname: @scripts/settings/equipment/weapon_templates/lasguns/settings_templates/lasgun_suppression_templates.lua

local suppression_templates = {}
local overrides = {}

table.make_unique(suppression_templates)
table.make_unique(overrides)

suppression_templates.default_lasgun_killshot = {
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
			"default_lasgun_killshot",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"default_lasgun_killshot",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"default_lasgun_killshot",
			"still",
		},
	},
}
suppression_templates.krieg_lasgun_killshot = {
	still = {
		decay_time = 0.6,
		delay = 0.2,
		immediate_sway = {
			{
				pitch = {
					lerp_basic = 0.1,
					lerp_perfect = 0.05,
				},
				yaw = {
					lerp_basic = 0.1,
					lerp_perfect = 0.05,
				},
			},
			{
				pitch = {
					lerp_basic = 0.2,
					lerp_perfect = 0.1,
				},
				yaw = {
					lerp_basic = 0.2,
					lerp_perfect = 0.1,
				},
			},
			{
				pitch = {
					lerp_basic = 0.3,
					lerp_perfect = 0.2,
				},
				yaw = {
					lerp_basic = 0.3,
					lerp_perfect = 0.2,
				},
			},
			{
				pitch = {
					lerp_basic = 0.4,
					lerp_perfect = 0.3,
				},
				yaw = {
					lerp_basic = 0.4,
					lerp_perfect = 0.3,
				},
			},
			{
				pitch = {
					lerp_basic = 0.5,
					lerp_perfect = 0.4,
				},
				yaw = {
					lerp_basic = 0.5,
					lerp_perfect = 0.4,
				},
			},
		},
	},
	moving = {
		inherits = {
			"krieg_lasgun_killshot",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"krieg_lasgun_killshot",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"krieg_lasgun_killshot",
			"still",
		},
	},
}
suppression_templates.hip_lasgun_killshot = {
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
			"hip_lasgun_killshot",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_killshot",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_killshot",
			"still",
		},
	},
}

return {
	base_templates = suppression_templates,
	overrides = overrides,
}
