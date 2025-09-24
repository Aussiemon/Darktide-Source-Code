-- chunkname: @scripts/settings/equipment/weapon_templates/force_staffs/settings_templates/force_staff_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_force_staff_killshot = {
	charge_scale = {
		max_pitch = 0.25,
		max_yaw = 0.25,
	},
	still = {
		max_spread = {
			pitch = 4,
			yaw = 4,
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				pitch = 0.1,
				yaw = 0.1,
			},
			idle = {
				pitch = 4,
				yaw = 4,
			},
		},
		continuous_spread = {
			min_pitch = 1,
			min_yaw = 1,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.1,
			first_shot_random_ratio = 0.2,
			min_ratio = 0.1,
			random_ratio = 0.2,
		},
		immediate_spread = {
			num_shots_clear_time = 0.8,
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
			},
		},
	},
	moving = {
		inherits = {
			"default_force_staff_killshot",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"default_force_staff_killshot",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"default_force_staff_killshot",
			"still",
		},
	},
}

return {
	base_templates = spread_templates,
	overrides = overrides,
}
