-- chunkname: @scripts/extension_systems/behavior/utility_considerations/renegade_shocktrooper_utility_considerations.lua

local considerations = {
	renegade_shocktrooper_step_shoot = {
		distance_to_target = {
			blackboard_component = "perception",
			component_field = "target_distance",
			max_value = 22,
			spline = {
				0,
				1,
				0.5,
				1,
				0.900001,
				0.25,
				1,
				0,
			},
		},
		has_line_of_sight = {
			blackboard_component = "perception",
			component_field = "has_line_of_sight",
			is_condition = true,
		},
		last_time = {
			component_field = "last_time",
			max_value = 5,
			time_diff = true,
			spline = {
				0,
				0,
				0.5,
				0,
				0.5001,
				1,
				1,
				1,
			},
		},
	},
	renegade_shocktrooper_shoot = {
		distance_to_target = {
			blackboard_component = "perception",
			component_field = "target_distance",
			max_value = 40,
			spline = {
				0,
				0,
				0.5,
				1,
				0.900001,
				0.25,
				1,
				0,
			},
		},
		has_line_of_sight = {
			blackboard_component = "perception",
			component_field = "has_line_of_sight",
			is_condition = true,
		},
	},
	renegade_shocktrooper_frag_grenade = {
		distance_to_target = {
			blackboard_component = "perception",
			component_field = "target_distance",
			max_value = 20,
			spline = {
				0,
				0,
				0.35,
				0,
				0.351,
				1,
				1,
				0,
			},
		},
		has_line_of_sight = {
			blackboard_component = "perception",
			component_field = "has_line_of_sight",
			is_condition = true,
		},
	},
}

return considerations
