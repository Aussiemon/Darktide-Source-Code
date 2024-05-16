-- chunkname: @scripts/settings/equipment/weapon_templates/grenadier_gauntlets/settings_templates/grenadier_gauntlet_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_grenadier_gauntlet_demolitions = {
	still = {
		max_spread = {
			pitch = 6.5,
			yaw = 6.5,
		},
		decay = {
			from_shooting_grace_time = 0.25,
			shooting = {
				pitch = 0.25,
				yaw = 0.25,
			},
			idle = {
				pitch = 1.5,
				yaw = 1.5,
			},
		},
		continuous_spread = {
			min_pitch = 2.25,
			min_yaw = 2.25,
		},
		start_spread = {
			start_pitch = 4,
			start_yaw = 4,
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			suppression_hit = {
				{
					pitch = 0.5,
					yaw = 0.5,
				},
			},
			damage_hit = {
				{
					pitch = 1.5,
					yaw = 1.5,
				},
			},
			shooting = {
				{
					pitch = 2.5,
					yaw = 2.5,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_grenadier_gauntlet_demolitions",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"default_grenadier_gauntlet_demolitions",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"default_grenadier_gauntlet_demolitions",
			"still",
		},
	},
}
spread_templates.default_grenadier_gauntlet_bfg = {
	still = {
		max_spread = {
			pitch = 20,
			yaw = 20,
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = 0.25,
				yaw = 0.25,
			},
			idle = {
				pitch = 1,
				yaw = 1,
			},
		},
		continuous_spread = {
			min_pitch = 2,
			min_yaw = 2,
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			suppression_hit = {
				{
					pitch = 0.5,
					yaw = 0.5,
				},
			},
			damage_hit = {
				{
					pitch = 1.5,
					yaw = 1.5,
				},
			},
			shooting = {
				{
					pitch = 1,
					yaw = 1.25,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_grenadier_gauntlet_bfg",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"default_grenadier_gauntlet_bfg",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"default_grenadier_gauntlet_bfg",
			"still",
		},
	},
}

return {
	base_templates = spread_templates,
	overrides = overrides,
}
