local considerations = {
	chaos_spawn_claw_attack = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 4.75,
			spline = {
				0,
				1,
				0.75,
				1,
				0.77002,
				0,
				1,
				0
			}
		},
		target_speed_away = {
			component_field = "target_speed_away",
			blackboard_component = "perception",
			max_value = 4,
			spline = {
				0,
				1,
				0.1,
				1,
				0.1001,
				0,
				1,
				0
			}
		},
		distance_to_target_z = {
			component_field = "target_distance_z",
			blackboard_component = "perception",
			max_value = 4.75,
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
	chaos_spawn_tentacle_attack = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 5.2,
			spline = {
				0,
				1,
				0.75,
				1,
				0.77002,
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
				0.4,
				0.933,
				1,
				0.9331,
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
		last_done_time = {
			time_diff = true,
			max_value = 20,
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
	chaos_spawn_grab_attack = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 5.2,
			spline = {
				0,
				1,
				0.75,
				1,
				0.77002,
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
				0.4,
				0.933,
				1,
				0.9331,
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
		last_done_time = {
			time_diff = true,
			max_value = 30,
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
	chaos_spawn_leap = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 8.2,
			spline = {
				0,
				0,
				0.75,
				0,
				0.77002,
				0,
				1,
				1
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
				0.4,
				0.933,
				1,
				0.9331,
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
	},
	chaos_spawn_combo_attack = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 6.2,
			spline = {
				0,
				1,
				0.75,
				1,
				0.77002,
				0,
				1,
				0
			}
		},
		distance_to_target_z = {
			component_field = "target_distance_z",
			blackboard_component = "perception",
			max_value = 4.75,
			spline = {
				0,
				1,
				0.75,
				1,
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
				0.4,
				0.25,
				0.65,
				0.933,
				1,
				0.9331,
				1,
				1,
				1
			}
		},
		last_done_time = {
			time_diff = true,
			max_value = 6,
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
