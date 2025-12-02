-- chunkname: @scripts/settings/equipment/weapon_templates/needlepistols/settings_templates/needlepistol_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_needlepistol = {
	still = {
		max_spread = {
			pitch = 4,
			yaw = 4,
		},
		decay = {
			from_shooting_grace_time = 0.05,
			shooting = {
				pitch = 0.75,
				yaw = 0.75,
			},
			idle = {
				pitch = 2.5,
				yaw = 2.5,
			},
		},
		continuous_spread = {
			min_pitch = 2.65,
			min_yaw = 2.65,
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			suppression_hit = nil,
			damage_hit = {
				{
					pitch = 1.15,
					yaw = 1.15,
				},
			},
			shooting = {
				{
					pitch = 0.15,
					yaw = 0.15,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_needlepistol",
			"still",
		},
		continuous_spread = {
			min_pitch = 2.85,
			min_yaw = 2.85,
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = 0.5,
				yaw = 0.5,
			},
			idle = {
				pitch = 2,
				yaw = 2,
			},
		},
	},
	crouch_still = {
		inherits = {
			"default_needlepistol",
			"still",
		},
		continuous_spread = {
			min_pitch = 0.75,
			min_yaw = 0.75,
		},
	},
	crouch_moving = {
		inherits = {
			"default_needlepistol",
			"still",
		},
		continuous_spread = {
			min_pitch = 0.75,
			min_yaw = 0.75,
		},
	},
}
spread_templates.default_needlepistol_ads = {
	still = {
		max_spread = {
			pitch = 4,
			yaw = 4,
		},
		decay = {
			from_shooting_grace_time = 0.05,
			shooting = {
				pitch = 0.75,
				yaw = 0.75,
			},
			idle = {
				pitch = 4.5,
				yaw = 4.5,
			},
		},
		continuous_spread = {
			min_pitch = 0.45,
			min_yaw = 0.45,
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			suppression_hit = nil,
			damage_hit = {
				{
					pitch = 1.15,
					yaw = 1.15,
				},
			},
			shooting = {
				{
					pitch = 0.15,
					yaw = 0.15,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_needlepistol",
			"still",
		},
		continuous_spread = {
			min_pitch = 0.55,
			min_yaw = 0.55,
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = 0.5,
				yaw = 0.5,
			},
			idle = {
				pitch = 2,
				yaw = 2,
			},
		},
	},
	crouch_still = {
		inherits = {
			"default_needlepistol",
			"still",
		},
		continuous_spread = {
			min_pitch = 0.75,
			min_yaw = 0.75,
		},
	},
	crouch_moving = {
		inherits = {
			"default_needlepistol",
			"still",
		},
		continuous_spread = {
			min_pitch = 0.75,
			min_yaw = 0.75,
		},
	},
}

return {
	base_templates = spread_templates,
	overrides = overrides,
}
