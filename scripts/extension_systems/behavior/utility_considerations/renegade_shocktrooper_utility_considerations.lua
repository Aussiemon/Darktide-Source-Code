-- chunkname: @scripts/extension_systems/behavior/utility_considerations/renegade_shocktrooper_utility_considerations.lua

local considerations = {
	renegade_shocktrooper_step_shoot = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 22,
			spline = {
				0,
				1,
				0.5,
				1,
				0.900001,
				0.25,
				1,
				0
			}
		},
		has_line_of_sight = {
			component_field = "has_line_of_sight",
			blackboard_component = "perception",
			is_condition = true
		},
		last_time = {
			time_diff = true,
			max_value = 5,
			component_field = "last_time",
			spline = {
				0,
				0,
				0.5,
				0,
				0.5001,
				1,
				1,
				1
			}
		}
	},
	renegade_shocktrooper_shoot = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 40,
			spline = {
				0,
				0,
				0.5,
				1,
				0.900001,
				0.25,
				1,
				0
			}
		},
		has_line_of_sight = {
			component_field = "has_line_of_sight",
			blackboard_component = "perception",
			is_condition = true
		}
	},
	renegade_shocktrooper_frag_grenade = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 20,
			spline = {
				0,
				0,
				0.35,
				0,
				0.351,
				1,
				1,
				0
			}
		},
		has_line_of_sight = {
			component_field = "has_line_of_sight",
			blackboard_component = "perception",
			is_condition = true
		},
		last_done_time = {
			time_diff = true,
			max_value = 30,
			component_field = "last_done_time",
			spline = {
				0,
				0,
				0.5,
				0,
				0.5001,
				1,
				1,
				1
			}
		}
	}
}

return considerations
