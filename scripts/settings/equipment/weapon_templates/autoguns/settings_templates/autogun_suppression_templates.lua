-- chunkname: @scripts/settings/equipment/weapon_templates/autoguns/settings_templates/autogun_suppression_templates.lua

local suppression_templates = {}
local overrides = {}

table.make_unique(suppression_templates)
table.make_unique(overrides)

suppression_templates.default_autogun_assault = {
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
			"default_autogun_assault",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"default_autogun_assault",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"default_autogun_assault",
			"still",
		},
	},
}
suppression_templates.fullauto_autogun_killshot = {
	still = {
		decay_time = 0.6,
		delay = 0.2,
		immediate_sway = {
			{
				pitch = {
					lerp_basic = 8,
					lerp_perfect = 4,
				},
				yaw = {
					lerp_basic = 8,
					lerp_perfect = 4,
				},
			},
		},
	},
	moving = {
		inherits = {
			"fullauto_autogun_killshot",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"fullauto_autogun_killshot",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"fullauto_autogun_killshot",
			"still",
		},
	},
}

return {
	base_templates = suppression_templates,
	overrides = overrides,
}
