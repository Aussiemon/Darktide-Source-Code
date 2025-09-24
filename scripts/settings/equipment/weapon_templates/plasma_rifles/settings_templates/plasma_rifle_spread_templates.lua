-- chunkname: @scripts/settings/equipment/weapon_templates/plasma_rifles/settings_templates/plasma_rifle_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_plasma_rifle_bfg = {
	charge_scale = {
		max_pitch = 0.1,
		max_yaw = 0.1,
	},
	still = {
		max_spread = {
			pitch = 20,
			yaw = 20,
		},
		decay = {
			from_shooting_grace_time = 0.5,
			shooting = {
				pitch = 0.2,
				yaw = 0.2,
			},
			idle = {
				pitch = 0.75,
				yaw = 0.75,
			},
			charging = {
				pitch = 2.75,
				yaw = 2.75,
			},
		},
		continuous_spread = {
			min_pitch = 1.5,
			min_yaw = 1.5,
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			damage_hit = {
				{
					pitch = 8,
					yaw = 8,
				},
			},
			shooting = {
				{
					pitch = 2.5,
					yaw = 2.5,
				},
				{
					pitch = 3,
					yaw = 3,
				},
				{
					pitch = 4,
					yaw = 4,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_plasma_rifle_bfg",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"default_plasma_rifle_bfg",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"default_plasma_rifle_bfg",
			"still",
		},
	},
}
spread_templates.default_plasma_rifle_demolitions = {
	charge_scale = {
		max_pitch = 0.25,
		max_yaw = 0.25,
	},
	still = {
		max_spread = {
			pitch = 20,
			yaw = 20,
		},
		decay = {
			from_shooting_grace_time = 0.2,
			shooting = {
				pitch = 0.5,
				yaw = 0.5,
			},
			idle = {
				pitch = 1,
				yaw = 1,
			},
		},
		continuous_spread = {
			min_pitch = 2.5,
			min_yaw = 2.5,
		},
		immediate_spread = {
			num_shots_clear_time = 0.35,
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
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
			"default_plasma_rifle_demolitions",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"default_plasma_rifle_demolitions",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"default_plasma_rifle_demolitions",
			"still",
		},
	},
}

return {
	base_templates = spread_templates,
	overrides = overrides,
}
