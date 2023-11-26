-- chunkname: @scripts/extension_systems/behavior/utility_considerations/renegade_sniper_utility_considerations.lua

local considerations = {
	sniper_shoot = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 50,
			spline = {
				0,
				0,
				0.1,
				0,
				0.751,
				1,
				0.900001,
				1,
				1,
				1
			}
		},
		has_good_last_los_position = {
			component_field = "has_good_last_los_position",
			blackboard_component = "perception",
			is_condition = true
		}
	},
	sniper_move_to_cover = {
		distance_to_cover = {
			component_field = "distance_to_cover",
			blackboard_component = "cover",
			max_value = 5,
			spline = {
				0,
				0,
				0.3,
				0,
				0.751,
				1,
				1,
				1
			}
		},
		has_cover = {
			component_field = "has_cover",
			blackboard_component = "cover",
			is_condition = true
		}
	},
	sniper_move_to_combat_vector = {
		distance_to_combat_vector = {
			component_field = "distance",
			blackboard_component = "combat_vector",
			max_value = 5,
			spline = {
				0,
				0,
				0.5,
				0,
				0.75,
				1,
				1,
				1
			}
		},
		has_combat_vector_position = {
			component_field = "has_position",
			blackboard_component = "combat_vector",
			is_condition = true
		},
		dont_have_cover = {
			component_field = "has_cover",
			blackboard_component = "cover",
			invert = true,
			is_condition = true
		}
	},
	sniper_movement = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 50,
			spline = {
				0,
				0.1,
				0.5,
				0.5,
				0.751,
				1,
				0.900001,
				1,
				1,
				1
			}
		}
	}
}

return considerations
