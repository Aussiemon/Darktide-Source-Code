-- chunkname: @scripts/extension_systems/behavior/utility_considerations/chaos_poxwalker_utility_considerations.lua

local considerations = {
	chaos_poxwalker_moving_melee_attack = {
		slot_distance = {
			blackboard_component = "slot",
			component_field = "slot_distance",
			max_value = 4,
			spline = {
				0,
				0,
				0.1,
				0,
				0.1001,
				1,
				0.8,
				0,
				1,
				0,
			},
		},
		distance_to_target_z = {
			blackboard_component = "perception",
			component_field = "target_distance_z",
			max_value = 3.75,
			spline = {
				0,
				1,
				0.5,
				0,
				1,
				0,
			},
		},
		target_speed_away = {
			blackboard_component = "perception",
			component_field = "target_speed_away",
			max_value = 4,
			spline = {
				0,
				0.25,
				0.5,
				1,
				0.501,
				0,
				1,
				0,
			},
		},
		has_line_of_sight = {
			blackboard_component = "perception",
			component_field = "has_line_of_sight",
			is_condition = true,
		},
		has_slot = {
			blackboard_component = "slot",
			component_field = "has_slot",
			is_condition = true,
		},
	},
	chaos_poxwalker_running_melee_attack = {
		distance_to_slot = {
			blackboard_component = "slot",
			component_field = "slot_distance",
			max_value = 9,
			spline = {
				0,
				0,
				0.6,
				0,
				0.60001,
				1,
				1,
				0,
			},
		},
		target_speed_away = {
			blackboard_component = "perception",
			component_field = "target_speed_away",
			max_value = 4.7,
			spline = {
				0,
				0,
				0.1,
				0,
				0.3,
				0,
				0.301,
				1,
				0.75,
				1,
				1,
				0,
			},
		},
		distance_to_target_z = {
			blackboard_component = "perception",
			component_field = "target_distance_z",
			max_value = 3.75,
			spline = {
				0,
				1,
				0.5,
				0,
				1,
				0,
			},
		},
		has_line_of_sight = {
			blackboard_component = "perception",
			component_field = "has_line_of_sight",
			is_condition = true,
		},
		has_slot = {
			blackboard_component = "slot",
			component_field = "has_slot",
			is_condition = true,
		},
	},
}

return considerations
