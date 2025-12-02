-- chunkname: @scripts/settings/equipment/weapon_templates/dual_autopistols/settings_templates/dual_autopistol_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_dual_autopistol_assault = {
	still = {
		max_spread = {
			pitch = 4,
			yaw = 4,
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				pitch = 1,
				yaw = 1,
			},
			idle = {
				pitch = 11.15,
				yaw = 11.15,
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
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = {
				{
					pitch = 0.2,
					yaw = 0.2,
				},
				{
					pitch = 0.35,
					yaw = 0.35,
				},
				{
					pitch = 0.25,
					yaw = 0.25,
				},
				{
					pitch = 0.25,
					yaw = 0.25,
				},
				{
					pitch = 0.375,
					yaw = 0.375,
				},
				{
					pitch = 0.15,
					yaw = 0.15,
				},
				{
					pitch = 0.425,
					yaw = 0.425,
				},
				{
					pitch = 0.3,
					yaw = 0.3,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_dual_autopistol_assault",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.45,
			min_yaw = 1.45,
		},
	},
	crouch_still = {
		inherits = {
			"default_dual_autopistol_assault",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.3,
			min_yaw = 1.3,
		},
	},
	crouch_moving = {
		inherits = {
			"default_dual_autopistol_assault",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.4,
			min_yaw = 1.4,
		},
	},
}
spread_templates.default_dual_autopistol_spraynpray = {
	still = {
		max_spread = {
			pitch = 3,
			yaw = 3,
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				pitch = 1.1,
				yaw = 1.1,
			},
			idle = {
				pitch = 11.15,
				yaw = 11.15,
			},
		},
		continuous_spread = {
			min_pitch = 1,
			min_yaw = 1,
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
					pitch = 0.2,
					yaw = 0.2,
				},
				{
					pitch = 0.35,
					yaw = 0.35,
				},
				{
					pitch = 0.25,
					yaw = 0.25,
				},
				{
					pitch = 0.25,
					yaw = 0.25,
				},
				{
					pitch = 0.375,
					yaw = 0.375,
				},
				{
					pitch = 0.15,
					yaw = 0.15,
				},
				{
					pitch = 0.425,
					yaw = 0.425,
				},
				{
					pitch = 0.3,
					yaw = 0.3,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_dual_autopistol_spraynpray",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.2,
			min_yaw = 1.2,
		},
	},
	crouch_still = {
		inherits = {
			"default_dual_autopistol_spraynpray",
			"still",
		},
		continuous_spread = {
			min_pitch = 1,
			min_yaw = 1,
		},
	},
	crouch_moving = {
		inherits = {
			"default_dual_autopistol_spraynpray",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.1,
			min_yaw = 1.1,
		},
	},
}

return {
	base_templates = spread_templates,
	overrides = overrides,
}
