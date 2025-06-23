-- chunkname: @scripts/extension_systems/behavior/utility_considerations/renegade_grenadier_utility_considerations.lua

local considerations = {
	grenadier_quick_throw = {
		has_line_of_sight = {
			component_field = "has_line_of_sight",
			blackboard_component = "perception",
			is_condition = true
		},
		last_done_time = {
			time_diff = true,
			max_value = 10,
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
	},
	grenadier_multi_quick_throw = {
		has_line_of_sight = {
			component_field = "has_line_of_sight",
			blackboard_component = "perception",
			is_condition = true
		},
		last_done_time = {
			time_diff = true,
			max_value = 20,
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
