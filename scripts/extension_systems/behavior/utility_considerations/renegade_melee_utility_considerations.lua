-- chunkname: @scripts/extension_systems/behavior/utility_considerations/renegade_melee_utility_considerations.lua

local considerations = {
	renegade_melee_moving_melee_attack = {
		slot_distance = {
			component_field = "slot_distance",
			blackboard_component = "slot",
			max_value = 4,
			spline = {
				0,
				0,
				0.5,
				1,
				0.75001,
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
		target_speed_away = {
			component_field = "target_speed_away",
			blackboard_component = "perception",
			max_value = 4.5,
			spline = {
				0,
				0.1,
				0.2,
				0.15,
				0.25,
				0.2,
				0.75,
				1,
				0.7501,
				0,
				1,
				0
			}
		},
		has_line_of_sight = {
			component_field = "has_line_of_sight",
			blackboard_component = "perception",
			is_condition = true
		},
		has_slot = {
			component_field = "has_slot",
			blackboard_component = "slot",
			is_condition = true
		}
	},
	renegade_melee_running_melee_attack = {
		distance_to_slot = {
			component_field = "slot_distance",
			blackboard_component = "slot",
			max_value = 4.5,
			spline = {
				0,
				0.1,
				0.5,
				0.25,
				0.80001,
				1,
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
				0.5,
				1,
				0.25
			}
		},
		target_speed_away = {
			component_field = "target_speed_away",
			blackboard_component = "perception",
			max_value = 5,
			spline = {
				0,
				0.1,
				0.25,
				0.1,
				0.5,
				0.25,
				0.75,
				1,
				1,
				1
			}
		},
		has_line_of_sight = {
			component_field = "has_line_of_sight",
			blackboard_component = "perception",
			is_condition = true
		},
		has_slot = {
			component_field = "has_slot",
			blackboard_component = "slot",
			is_condition = true
		}
	}
}

return considerations
