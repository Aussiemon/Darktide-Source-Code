-- chunkname: @scripts/settings/equipment/weapon_templates/autopistols/settings_templates/autopistol_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_autopistol_assault = {
	still = {
		max_spread = {
			pitch = 8,
			yaw = 8,
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				pitch = 1,
				yaw = 1,
			},
			idle = {
				pitch = 2.75,
				yaw = 2.75,
			},
		},
		continuous_spread = {
			min_pitch = 1.35,
			min_yaw = 1.35,
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			suppression_hit = {
				{
					pitch = 0.25,
					yaw = 0.25,
				},
			},
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = {
				{
					pitch = 0.5,
					yaw = 0.5,
				},
				{
					pitch = 0.15,
					yaw = 0.15,
				},
				{
					pitch = 0.25,
					yaw = 0.25,
				},
				{
					pitch = 0.3,
					yaw = 0.3,
				},
				{
					pitch = 0.275,
					yaw = 0.275,
				},
				{
					pitch = 0.25,
					yaw = 0.25,
				},
				{
					pitch = 0.225,
					yaw = 0.225,
				},
				{
					pitch = 0.2,
					yaw = 0.2,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_autopistol_assault",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.75,
			min_yaw = 1.75,
		},
	},
	crouch_still = {
		inherits = {
			"default_autopistol_assault",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.3,
			min_yaw = 1.3,
		},
	},
	crouch_moving = {
		inherits = {
			"default_autopistol_assault",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.6,
			min_yaw = 1.6,
		},
	},
}
spread_templates.autopistol_assault_p1m2 = {
	still = {
		max_spread = {
			pitch = 8,
			yaw = 8,
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				pitch = 1,
				yaw = 1,
			},
			idle = {
				pitch = 2.75,
				yaw = 2.75,
			},
		},
		continuous_spread = {
			min_pitch = 2.1,
			min_yaw = 2.35,
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			suppression_hit = {
				{
					pitch = 0.25,
					yaw = 0.25,
				},
			},
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = {
				{
					pitch = 0.5,
					yaw = 0.5,
				},
				{
					pitch = 0.15,
					yaw = 0.15,
				},
				{
					pitch = 0.25,
					yaw = 0.25,
				},
				{
					pitch = 0.3,
					yaw = 0.3,
				},
				{
					pitch = 0.275,
					yaw = 0.275,
				},
				{
					pitch = 0.25,
					yaw = 0.25,
				},
				{
					pitch = 0.225,
					yaw = 0.225,
				},
				{
					pitch = 0.2,
					yaw = 0.2,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_autopistol_assault",
			"still",
		},
		continuous_spread = {
			min_pitch = 2.35,
			min_yaw = 2.75,
		},
	},
	crouch_still = {
		inherits = {
			"default_autopistol_assault",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.4,
			min_yaw = 1.6,
		},
	},
	crouch_moving = {
		inherits = {
			"default_autopistol_assault",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.7,
			min_yaw = 1.9,
		},
	},
}

local pitch_spread = 0.6
local yaw_spread = pitch_spread * 1.75

spread_templates.default_autopistol_spraynpray = {
	still = {
		max_spread = {
			pitch = 3,
			yaw = 4,
		},
		decay = {
			from_shooting_grace_time = 0.025,
			shooting = {
				pitch = 1.15,
				yaw = 2.0124999999999997,
			},
			idle = {
				pitch = 2.5,
				yaw = 2.5,
			},
		},
		continuous_spread = {
			min_pitch = 1.25,
			min_yaw = 1.75,
		},
		immediate_spread = {
			num_shots_clear_time = 0.25,
			suppression_hit = {
				{
					pitch = 0.05,
					yaw = 0.05,
				},
			},
			damage_hit = {
				{
					pitch = 0.2,
					yaw = 0.2,
				},
			},
			shooting = {
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.125,
					yaw = yaw_spread * 0.125,
				},
				{
					pitch = pitch_spread * 0.15,
					yaw = yaw_spread * 0.15,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.225,
					yaw = yaw_spread * 0.225,
				},
				{
					pitch = pitch_spread * 0.25,
					yaw = yaw_spread * 0.25,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.15,
					yaw = yaw_spread * 0.15,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_autopistol_spraynpray",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.5,
			min_yaw = 2.1,
		},
	},
	crouch_still = {
		inherits = {
			"default_autopistol_spraynpray",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.125,
			min_yaw = 1.575,
		},
	},
	crouch_moving = {
		inherits = {
			"default_autopistol_spraynpray",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.375,
			min_yaw = 1.9250000000000003,
		},
	},
}

return {
	base_templates = spread_templates,
	overrides = overrides,
}
