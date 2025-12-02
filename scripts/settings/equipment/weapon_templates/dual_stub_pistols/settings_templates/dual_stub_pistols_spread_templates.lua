-- chunkname: @scripts/settings/equipment/weapon_templates/dual_stub_pistols/settings_templates/dual_stub_pistols_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.dual_stub_pistols_hip = {
	still = {
		max_spread = {
			pitch = 2.8,
			yaw = 2.8,
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				pitch = 0.65,
				yaw = 0.65,
			},
			idle = {
				pitch = 2.75,
				yaw = 2.75,
			},
		},
		continuous_spread = {
			min_pitch = 2.2,
			min_yaw = 2.2,
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = {
				{
					pitch = 1.5,
					yaw = 1.5,
				},
				{
					pitch = 1.35,
					yaw = 1.25,
				},
				{
					pitch = 1.65,
					yaw = 1.25,
				},
				{
					pitch = 1.5,
					yaw = 1.3,
				},
				{
					pitch = 1.475,
					yaw = 1.275,
				},
				{
					pitch = 1.55,
					yaw = 1.25,
				},
				{
					pitch = 1.425,
					yaw = 1.225,
				},
				{
					pitch = 1.5,
					yaw = 1.2,
				},
			},
		},
	},
	moving = {
		inherits = {
			"dual_stub_pistols_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 2.35,
			min_yaw = 2.35,
		},
	},
	crouch_still = {
		inherits = {
			"dual_stub_pistols_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.35,
			min_yaw = 1.35,
		},
	},
	crouch_moving = {
		inherits = {
			"dual_stub_pistols_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.85,
			min_yaw = 1.85,
		},
	},
}
spread_templates.dual_stub_pistols_braced = {
	still = {
		max_spread = {
			pitch = 2.5,
			yaw = 2.5,
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				pitch = 1.2,
				yaw = 1.2,
			},
			idle = {
				pitch = 3.05,
				yaw = 3.05,
			},
		},
		continuous_spread = {
			min_pitch = 1.3,
			min_yaw = 1.3,
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			damage_hit = {
				{
					pitch = 0.3,
					yaw = 0.3,
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
			"dual_stub_pistols_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.4,
			min_yaw = 1.4,
		},
	},
	crouch_still = {
		inherits = {
			"dual_stub_pistols_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.15,
			min_yaw = 1.15,
		},
	},
	crouch_moving = {
		inherits = {
			"dual_stub_pistols_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.25,
			min_yaw = 1.25,
		},
	},
}
spread_templates.dual_stub_pistols_spin = {
	still = {
		max_spread = {
			pitch = 1.5,
			yaw = 1.5,
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				pitch = 1.2,
				yaw = 1.2,
			},
			idle = {
				pitch = 2.75,
				yaw = 2.75,
			},
		},
		continuous_spread = {
			min_pitch = 0.1,
			min_yaw = 0.1,
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			damage_hit = {
				{
					pitch = 0.3,
					yaw = 0.3,
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
			"dual_stub_pistols_spin",
			"still",
		},
		continuous_spread = {
			min_pitch = 0.1,
			min_yaw = 0.1,
		},
	},
	crouch_still = {
		inherits = {
			"dual_stub_pistols_spin",
			"still",
		},
		continuous_spread = {
			min_pitch = 0.1,
			min_yaw = 0.1,
		},
	},
	crouch_moving = {
		inherits = {
			"dual_stub_pistols_spin",
			"still",
		},
		continuous_spread = {
			min_pitch = 0.1,
			min_yaw = 0.1,
		},
	},
}

return {
	base_templates = spread_templates,
	overrides = overrides,
}
