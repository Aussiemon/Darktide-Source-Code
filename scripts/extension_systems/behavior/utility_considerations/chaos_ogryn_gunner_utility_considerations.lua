-- chunkname: @scripts/extension_systems/behavior/utility_considerations/chaos_ogryn_gunner_utility_considerations.lua

local considerations = {
	chaos_ogryn_gunner_melee = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 7,
			spline = {
				0,
				1,
				0.52,
				1,
				0.57002,
				0,
				1,
				0
			}
		},
		distance_to_target_z = {
			component_field = "target_distance_z",
			blackboard_component = "perception",
			max_value = 3.75,
			spline = {
				0,
				1,
				0.5,
				0,
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
	chaos_ogryn_gunner_shoot = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 7,
			spline = {
				0,
				0,
				0.52,
				0,
				0.57002,
				1,
				1,
				1
			}
		},
		has_line_of_sight = {
			component_field = "has_line_of_sight",
			blackboard_component = "perception",
			is_condition = true
		}
	}
}

return considerations
