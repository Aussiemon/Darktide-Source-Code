-- chunkname: @scripts/extension_systems/behavior/utility_considerations/renegade_grenadier_utility_considerations.lua

local considerations = {
	grenadier_quick_throw = {
		has_line_of_sight = {
			blackboard_component = "perception",
			component_field = "has_line_of_sight",
			is_condition = true,
		},
		last_done_time = {
			component_field = "last_done_time",
			max_value = 10,
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
	grenadier_multi_quick_throw = {
		has_line_of_sight = {
			blackboard_component = "perception",
			component_field = "has_line_of_sight",
			is_condition = true,
		},
		last_done_time = {
			component_field = "last_done_time",
			max_value = 20,
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
}

return considerations
