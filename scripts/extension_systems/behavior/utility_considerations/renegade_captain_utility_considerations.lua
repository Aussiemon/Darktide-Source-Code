local considerations = {
	renegade_captain_charge = {
		is_available = {
			component_field = "charge",
			blackboard_component = "available_attacks",
			is_condition = true
		},
		last_weapon_switch = {
			time_diff = true,
			blackboard_component = "weapon_switch",
			component_field = "last_weapon_switch_t",
			max_value = 10,
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
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 10,
			spline = {
				0,
				0,
				0.4,
				0,
				0.7,
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
		last_time = {
			time_diff = true,
			max_value = 10,
			component_field = "last_time",
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
	renegade_captain_throw_fire_grenade = {
		is_available = {
			component_field = "fire_grenade",
			blackboard_component = "available_attacks",
			is_condition = true
		},
		last_weapon_switch = {
			time_diff = true,
			blackboard_component = "weapon_switch",
			component_field = "last_weapon_switch_t",
			max_value = 10,
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
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 12,
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
	renegade_captain_throw_frag_grenade = {
		is_available = {
			component_field = "frag_grenade",
			blackboard_component = "available_attacks",
			is_condition = true
		},
		last_weapon_switch = {
			time_diff = true,
			blackboard_component = "weapon_switch",
			component_field = "last_weapon_switch_t",
			max_value = 10,
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
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 12,
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
	renegade_captain_kick = {
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
	renegade_captain_punch = {
		is_available = {
			component_field = "punch",
			blackboard_component = "available_attacks",
			is_condition = true
		},
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
	renegade_captain_void_shield_explosion = {
		is_available = {
			component_field = "void_shield_explosion",
			blackboard_component = "available_attacks",
			is_condition = true
		},
		shield_toughness = {
			component_field = "toughness_percent",
			blackboard_component = "toughness",
			max_value = 1,
			spline = {
				0,
				0,
				0.01,
				1,
				0.5,
				0.5,
				0.5001,
				0,
				1,
				0
			}
		},
		nearby_units = {
			component_field = "num_units",
			blackboard_component = "nearby_units_broadphase",
			max_value = 4,
			spline = {
				0,
				0,
				0.25,
				0.25,
				0.5,
				0.5,
				0.75,
				0.75,
				1,
				1
			}
		},
		distance_to_target_z = {
			component_field = "target_distance_z",
			blackboard_component = "perception",
			max_value = 2.25,
			spline = {
				0,
				1,
				0.5,
				0,
				1,
				0
			}
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
	renegade_captain_hellgun_shoot = {
		is_available = {
			component_field = "hellgun_shoot",
			blackboard_component = "available_attacks",
			is_condition = true
		},
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
				1,
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
	renegade_captain_hellgun_spray_and_pray = {
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
				1,
				1,
				0
			}
		},
		has_line_of_sight = {
			component_field = "has_line_of_sight",
			blackboard_component = "perception",
			is_condition = true
		},
		last_time = {
			time_diff = true,
			max_value = 60,
			component_field = "last_time",
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
	renegade_captain_hellgun_sweep_shoot = {
		is_available = {
			component_field = "hellgun_sweep_shoot",
			blackboard_component = "available_attacks",
			is_condition = true
		},
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
				1,
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
	renegade_captain_hellgun_strafe_shoot = {
		is_available = {
			component_field = "hellgun_strafe_shoot",
			blackboard_component = "available_attacks",
			is_condition = true
		},
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
	renegade_captain_bolt_pistol_shoot = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 22,
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
	renegade_captain_shotgun_shoot = {
		is_available = {
			component_field = "shotgun_shoot",
			blackboard_component = "available_attacks",
			is_condition = true
		},
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 10,
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
	renegade_captain_shotgun_strafe_shoot = {
		is_available = {
			component_field = "shotgun_strafe_shoot",
			blackboard_component = "available_attacks",
			is_condition = true
		},
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
	renegade_captain_power_sword_moving_melee_attack = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 5.6,
			spline = {
				0,
				1,
				0.589,
				1,
				0.62002,
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
	renegade_captain_power_sword_melee_combo_attack = {
		is_available = {
			component_field = "power_sword_melee_combo_attack",
			blackboard_component = "available_attacks",
			is_condition = true
		},
		slot_distance = {
			component_field = "slot_distance",
			blackboard_component = "slot",
			max_value = 4,
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
	renegade_captain_power_sword_melee_sweep = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 6,
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
		has_line_of_sight = {
			component_field = "has_line_of_sight",
			blackboard_component = "perception",
			is_condition = true
		}
	},
	renegade_captain_powermaul_ground_slam_attack = {
		is_available = {
			component_field = "powermaul_ground_slam_attack",
			blackboard_component = "available_attacks",
			is_condition = true
		},
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 5.4,
			spline = {
				0,
				1,
				0.589,
				1,
				0.62002,
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
	renegade_captain_plasma_pistol_shoot = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 22,
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
	renegade_captain_plasma_pistol_shoot_volley = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 22,
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
		},
		last_time = {
			time_diff = true,
			max_value = 20,
			component_field = "last_time",
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
