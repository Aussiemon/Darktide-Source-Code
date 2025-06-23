-- chunkname: @scripts/extension_systems/behavior/utility_considerations/chaos_deamonhost_utility_considerations.lua

local considerations = {
	warp_sweep = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
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
	daemonhost_melee = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 5,
			spline = {
				0,
				1,
				0.5,
				1,
				0.9,
				0,
				1,
				0
			}
		},
		distance_to_target_z = {
			component_field = "target_distance_z",
			blackboard_component = "perception",
			max_value = 8,
			spline = {
				0,
				1,
				0.5,
				0,
				1,
				0
			}
		}
	},
	chaos_daemonhost_combo_attack = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 5,
			spline = {
				0,
				1,
				0.5,
				1,
				0.9,
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
		has_slot = {
			component_field = "has_slot",
			blackboard_component = "slot",
			is_condition = true
		},
		last_done_time = {
			time_diff = true,
			max_value = 5,
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
	chaos_daemonhost_warp_grab = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 100,
			spline = {
				0,
				1,
				0.5,
				1,
				0.900001,
				0.25,
				1,
				0.2
			}
		}
	},
	chaos_daemonhost_warp_teleport = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 10,
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
		},
		last_done_time = {
			time_diff = true,
			max_value = 8,
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
