-- chunkname: @scripts/extension_systems/behavior/utility_considerations/renegade_rifleman_utility_considerations.lua

local considerations = {
	renegade_rifleman_bayonet_charge = {
		distance_to_slot = {
			blackboard_component = "slot",
			component_field = "slot_distance",
			max_value = 8,
			spline = {
				0,
				0,
				0.475,
				0,
				0.51001,
				1,
				1,
				1,
			},
		},
	},
	renegade_rifleman_bayonet_attack = {
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
}

return considerations
