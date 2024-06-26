-- chunkname: @scripts/extension_systems/behavior/utility_considerations/cultists_berzerker_utility_considerations.lua

local considerations = {
	cultist_berzerker_combo_attack = {
		slot_distance = {
			blackboard_component = "slot",
			component_field = "slot_distance",
			max_value = 4,
			spline = {
				0,
				0,
				0.5,
				1,
				0.75001,
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
	cultist_berzerker_leap_attack = {
		slot_distance = {
			blackboard_component = "slot",
			component_field = "slot_distance",
			max_value = 8,
			spline = {
				0,
				0,
				0.5,
				0,
				0.95,
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
