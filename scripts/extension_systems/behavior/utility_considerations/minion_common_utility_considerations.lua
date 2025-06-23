-- chunkname: @scripts/extension_systems/behavior/utility_considerations/minion_common_utility_considerations.lua

local considerations = {
	melee_follow = {
		distance_to_slot = {
			component_field = "slot_distance",
			blackboard_component = "slot",
			max_value = 0.5,
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
	melee_attack = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 5,
			spline = {
				0,
				1,
				0.589,
				1,
				0.60002,
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
			max_value = 4.25,
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
	melee_attack_elite = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 5,
			spline = {
				0,
				1,
				0.629,
				1,
				0.63002,
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
			max_value = 4.25,
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
	running_phased_melee_attack = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 12,
			spline = {
				0,
				0,
				0.65,
				0,
				0.650001,
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
	far_ranged_follow = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 30,
			spline = {
				0,
				0,
				0.5,
				0,
				0.75,
				0.5,
				1,
				1
			}
		}
	},
	ranged_follow = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 30,
			spline = {
				0,
				0.01,
				0.1,
				0,
				0.5,
				0.75,
				1,
				1
			}
		}
	},
	ranged_follow_no_los = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 25,
			spline = {
				0,
				0.01,
				0.1,
				0,
				0.5,
				0.75,
				1,
				1
			}
		},
		dont_have_line_of_sight = {
			component_field = "has_line_of_sight",
			blackboard_component = "perception",
			invert = true,
			is_condition = true
		}
	},
	move_to_combat_vector = {
		distance_to_combat_vector = {
			component_field = "distance",
			blackboard_component = "combat_vector",
			max_value = 20,
			spline = {
				0,
				0,
				0.1,
				0,
				0.75,
				0.75,
				1,
				1
			}
		},
		has_combat_vector_position = {
			component_field = "has_position",
			blackboard_component = "combat_vector",
			is_condition = true
		},
		combat_vector_is_closer = {
			component_field = "combat_vector_is_closer",
			blackboard_component = "combat_vector",
			is_condition = true
		}
	},
	move_to_combat_vector_special = {
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
		}
	},
	escape_to_combat_vector = {
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
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 12,
			spline = {
				0,
				0,
				0.25,
				0,
				0.5,
				1,
				0.51,
				0,
				0.900001,
				0,
				1,
				0
			}
		},
		has_combat_vector_position = {
			component_field = "has_position",
			blackboard_component = "combat_vector",
			is_condition = true
		}
	},
	run_stop_and_shoot = {
		distance_to_combat_vector = {
			component_field = "distance",
			blackboard_component = "combat_vector",
			max_value = 10,
			spline = {
				0,
				0,
				0.5,
				0,
				0.50001,
				1,
				0.75,
				0,
				1,
				0
			}
		},
		has_combat_vector_position = {
			component_field = "has_position",
			blackboard_component = "combat_vector",
			is_condition = true
		},
		has_line_of_sight = {
			component_field = "has_line_of_sight",
			blackboard_component = "perception",
			is_condition = true
		}
	},
	strafe_shoot = {
		distance_to_combat_vector = {
			component_field = "distance",
			blackboard_component = "combat_vector",
			max_value = 2,
			spline = {
				0,
				0,
				0.5,
				0,
				0.50001,
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
		has_line_of_sight = {
			component_field = "has_line_of_sight",
			blackboard_component = "perception",
			is_condition = true
		}
	},
	assault_far = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 30,
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
		}
	},
	assault_close = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 30,
			spline = {
				0,
				0,
				0.5,
				1,
				0.8,
				1,
				1,
				0
			}
		}
	},
	far_combat_idle = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 30,
			spline = {
				0,
				0,
				0.2,
				0,
				0.5,
				1,
				1,
				1
			}
		},
		has_line_of_sight = {
			component_field = "has_line_of_sight",
			blackboard_component = "perception",
			is_condition = true
		}
	},
	close_combat_idle = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 30,
			spline = {
				0,
				1,
				0.1,
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
	melee_combat_idle = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 20,
			spline = {
				0,
				1,
				0.1,
				1,
				0.5,
				0,
				1,
				0
			}
		}
	},
	shoot_far = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 40,
			spline = {
				0,
				0,
				0.05,
				0,
				0.5,
				1,
				0.7500001,
				0.5,
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
	shoot_spray_n_pray_cultist = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 30,
			spline = {
				0,
				0,
				0.1,
				0,
				0.51,
				1,
				0.981,
				1,
				1,
				0.1
			}
		},
		has_line_of_sight = {
			component_field = "has_line_of_sight",
			blackboard_component = "perception",
			is_condition = true
		}
	},
	shoot_spray_n_pray = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 30,
			spline = {
				0,
				0,
				0.1,
				0,
				0.51,
				1,
				0.981,
				1,
				1,
				0.1
			}
		},
		has_line_of_sight = {
			component_field = "has_line_of_sight",
			blackboard_component = "perception",
			is_condition = true
		}
	},
	shoot_close = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 30,
			spline = {
				0,
				1,
				0.5,
				1,
				0.900001,
				0.25,
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
	move_to_cover_shoot = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 30,
			spline = {
				0,
				1,
				0.25,
				0.6,
				0.5,
				0.4,
				0.900001,
				0.2,
				1,
				0
			}
		},
		has_line_of_sight = {
			component_field = "has_line_of_sight",
			blackboard_component = "perception",
			is_condition = true
		},
		is_not_in_cover = {
			component_field = "is_in_cover",
			blackboard_component = "cover",
			invert = true,
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
		},
		is_not_suppressed = {
			component_field = "is_suppressed",
			blackboard_component = "suppression",
			invert = true,
			is_condition = true
		}
	},
	has_cover = {
		has_cover = {
			component_field = "has_cover",
			blackboard_component = "cover",
			is_condition = true
		}
	},
	shoot_suppressive = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 60,
			spline = {
				0,
				1,
				0.5,
				1,
				0.900001,
				0,
				1,
				0
			}
		}
	},
	ranged_elite_melee = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 6,
			spline = {
				0,
				1,
				0.52,
				1,
				0.57002,
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
		}
	},
	melee_attack_bayonet = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 5.8,
			spline = {
				0,
				1,
				0.589,
				1,
				0.60002,
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
			max_value = 4.25,
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
	has_line_of_sight = {
		has_line_of_sight = {
			component_field = "has_line_of_sight",
			blackboard_component = "perception",
			is_condition = true
		}
	},
	frag_grenade = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 20,
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
		has_good_last_los_position = {
			component_field = "has_good_last_los_position",
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
	sergeant_shout = {
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
	}
}

return considerations
