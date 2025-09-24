-- chunkname: @scripts/settings/equipment/weapon_templates/flamers/settings_templates/flamer_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_flamer_assault = {
	charge_scale = {
		max_pitch = 0.25,
		max_yaw = 0.25,
	},
	still = {
		max_spread = {
			pitch = 1,
			yaw = 1,
		},
		decay = {
			from_shooting_grace_time = 1.1,
			shooting = {
				pitch = 1,
				yaw = 1,
			},
			idle = {
				pitch = 4,
				yaw = 4,
			},
		},
		continuous_spread = {
			min_pitch = 2.5,
			min_yaw = 2.5,
		},
		immediate_spread = {
			num_shots_clear_time = 0.7,
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = {
				{
					pitch = 0.25,
					yaw = 0.15,
				},
				{
					pitch = 0.1,
					yaw = 0.15,
				},
				{
					pitch = 0.15,
					yaw = 0.05,
				},
				{
					pitch = 0.25,
					yaw = 0.15,
				},
				{
					pitch = 0.15,
					yaw = 0.15,
				},
				{
					pitch = 0,
					yaw = 0.25,
				},
				{
					pitch = 0.2,
					yaw = 0.1,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_flamer_assault",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"default_flamer_assault",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"default_flamer_assault",
			"still",
		},
	},
}
spread_templates.default_flamer_demolitions = {
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
			"default_flamer_demolitions",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"default_flamer_demolitions",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"default_flamer_demolitions",
			"still",
		},
	},
}

return {
	base_templates = spread_templates,
	overrides = overrides,
}
