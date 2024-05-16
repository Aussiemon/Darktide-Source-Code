-- chunkname: @scripts/extension_systems/behavior/utility_considerations/renegade_sniper_utility_considerations.lua

local considerations = {
	sniper_shoot = {
		distance_to_target = {
			blackboard_component = "perception",
			component_field = "target_distance",
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
				1,
			},
		},
		has_good_last_los_position = {
			blackboard_component = "perception",
			component_field = "has_good_last_los_position",
			is_condition = true,
		},
	},
	sniper_move_to_cover = {
		distance_to_cover = {
			blackboard_component = "cover",
			component_field = "distance_to_cover",
			max_value = 5,
			spline = {
				0,
				0,
				0.3,
				0,
				0.751,
				1,
				1,
				1,
			},
		},
		has_cover = {
			blackboard_component = "cover",
			component_field = "has_cover",
			is_condition = true,
		},
	},
	sniper_move_to_combat_vector = {
		distance_to_combat_vector = {
			blackboard_component = "combat_vector",
			component_field = "distance",
			max_value = 5,
			spline = {
				0,
				0,
				0.5,
				0,
				0.75,
				1,
				1,
				1,
			},
		},
		has_combat_vector_position = {
			blackboard_component = "combat_vector",
			component_field = "has_position",
			is_condition = true,
		},
		dont_have_cover = {
			blackboard_component = "cover",
			component_field = "has_cover",
			invert = true,
			is_condition = true,
		},
	},
	sniper_movement = {
		distance_to_target = {
			blackboard_component = "perception",
			component_field = "target_distance",
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
				1,
			},
		},
	},
}

return considerations
