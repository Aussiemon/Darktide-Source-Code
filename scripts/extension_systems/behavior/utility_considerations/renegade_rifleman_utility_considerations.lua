local considerations = {
	renegade_rifleman_bayonet_charge = {
		distance_to_slot = {
			component_field = "slot_distance",
			blackboard_component = "slot",
			max_value = 8,
			spline = {
				0,
				0,
				0.475,
				0,
				0.51001,
				1,
				1,
				1
			}
		}
	},
	renegade_rifleman_bayonet_attack = {
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
		has_line_of_sight = {
			component_field = "has_line_of_sight",
			blackboard_component = "perception",
			is_condition = true
		},
		has_slot = {
			component_field = "has_slot",
			blackboard_component = "slot",
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
	}
}

return considerations
