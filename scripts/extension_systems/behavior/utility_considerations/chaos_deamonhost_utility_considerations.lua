-- chunkname: @scripts/extension_systems/behavior/utility_considerations/chaos_deamonhost_utility_considerations.lua

local considerations = {
	warp_sweep = {
		distance_to_target = {
			blackboard_component = "perception",
			component_field = "target_distance",
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
	daemonhost_melee = {
		distance_to_target = {
			blackboard_component = "perception",
			component_field = "target_distance",
			max_value = 5,
			spline = {
				0,
				1,
				0.5,
				1,
				0.9,
				0,
				1,
				0,
			},
		},
		distance_to_target_z = {
			blackboard_component = "perception",
			component_field = "target_distance_z",
			max_value = 8,
			spline = {
				0,
				1,
				0.5,
				0,
				1,
				0,
			},
		},
	},
	chaos_daemonhost_combo_attack = {
		distance_to_target = {
			blackboard_component = "perception",
			component_field = "target_distance",
			max_value = 5,
			spline = {
				0,
				1,
				0.5,
				1,
				0.9,
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
		has_slot = {
			blackboard_component = "slot",
			component_field = "has_slot",
			is_condition = true,
		},
		last_done_time = {
			component_field = "last_done_time",
			max_value = 5,
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
	chaos_daemonhost_warp_grab = {
		distance_to_target = {
			blackboard_component = "perception",
			component_field = "target_distance",
			max_value = 100,
			spline = {
				0,
				1,
				0.5,
				1,
				0.900001,
				0.25,
				1,
				0.2,
			},
		},
	},
	chaos_daemonhost_warp_teleport = {
		distance_to_target = {
			blackboard_component = "perception",
			component_field = "target_distance",
			max_value = 10,
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
		last_done_time = {
			component_field = "last_done_time",
			max_value = 8,
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
