local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local TrueFlightTemplates = require("scripts/settings/projectile/true_flight_templates")
local locomotion_states = ProjectileLocomotionSettings.states
local grenade_projectile_locomotion_templates = {
	grenade = {
		throw_parameters = {
			throw = {
				offset_right = 0,
				aim_max_iterations = 40,
				aim_time_step_multiplier = 3,
				aim_max_number_of_bounces = 2,
				speed_initial = 15,
				inherit_owner_velocity_percentage = 1,
				speed_charge_duration = 0.5,
				offset_forward = 1,
				rotation_charge_duration = 0,
				speed_maximal = 30,
				locomotion_state = locomotion_states.manual_physics,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				initial_angular_velocity = Vector3Box(0, 0, 1),
				randomized_angular_velocity = {
					x = math.pi * 2.2,
					y = math.pi * 1.1,
					z = math.pi * 2.2
				}
			},
			underhand_throw = {
				offset_right = 0,
				inherit_owner_velocity_percentage = 1,
				aim_max_number_of_bounces = 2,
				aim_time_step_multiplier = 3,
				speed_initial = 8,
				aim_max_iterations = 40,
				speed_charge_duration = 0.5,
				offset_forward = 1,
				offset_up = -0.3,
				rotation_charge_duration = 0,
				speed_maximal = 8,
				locomotion_state = locomotion_states.manual_physics,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				initial_angular_velocity = Vector3Box(0, 0, 1),
				randomized_angular_velocity = {
					x = math.pi * 2.2,
					y = math.pi * 1.1,
					z = math.pi * 2.2
				}
			},
			quick_throw = {
				offset_right = -0.2,
				inherit_owner_velocity_percentage = 1,
				aim_max_number_of_bounces = 2,
				aim_time_step_multiplier = 3,
				speed_initial = 30,
				aim_max_iterations = 40,
				speed_charge_duration = 0.5,
				offset_forward = 0,
				offset_up = 0.3,
				rotation_charge_duration = 0,
				speed_maximal = 30,
				locomotion_state = locomotion_states.manual_physics,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				initial_angular_velocity = Vector3Box(0, 0, 1),
				randomized_angular_velocity = {
					x = math.pi * 2.2,
					y = math.pi * 1.1,
					z = math.pi * 2.2
				}
			},
			drop = {
				speed = 1,
				inherit_owner_velocity_percentage = 1,
				locomotion_state = locomotion_states.engine_physics
			}
		},
		integrator_parameters = {
			gravity = 12.5,
			radius = 0.07,
			coefficient_of_restitution = 0.2,
			drag_coefficient = 0.2,
			collision_filter = "filter_player_character_shooting_projectile",
			use_actor_mass_radius = false,
			air_density = 0.7,
			collision_types = "both",
			max_hit_count = 10,
			mass = 0.8
		},
		vfx = {
			trajectory = {
				material_name = "content/fx/materials/master/trajectory"
			}
		}
	},
	krak_grenade = {
		throw_parameters = {
			throw = {
				offset_right = 0,
				inherit_owner_velocity_percentage = 1,
				aim_max_number_of_bounces = 2,
				aim_time_step_multiplier = 3,
				speed_initial = 15,
				aim_max_iterations = 40,
				speed_charge_duration = 0.5,
				offset_forward = 1,
				offset_up = 0,
				rotation_charge_duration = 0,
				speed_maximal = 30,
				locomotion_state = locomotion_states.true_flight,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				initial_angular_velocity = Vector3Box(0, 0, 1),
				randomized_angular_velocity = {
					x = math.pi * 2.2,
					y = math.pi * 1.1,
					z = math.pi * 2.2
				}
			},
			underhand_throw = {
				offset_right = 0,
				inherit_owner_velocity_percentage = 1,
				aim_max_number_of_bounces = 2,
				aim_time_step_multiplier = 3,
				speed_initial = 8,
				aim_max_iterations = 40,
				speed_charge_duration = 0.5,
				offset_forward = 1,
				offset_up = -0.3,
				rotation_charge_duration = 0,
				speed_maximal = 8,
				locomotion_state = locomotion_states.manual_physics,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				initial_angular_velocity = Vector3Box(0, 0, 1),
				randomized_angular_velocity = {
					x = math.pi * 2.2,
					y = math.pi * 1.1,
					z = math.pi * 2.2
				}
			},
			quick_throw = {
				offset_right = -0.2,
				inherit_owner_velocity_percentage = 1,
				aim_max_number_of_bounces = 2,
				aim_time_step_multiplier = 3,
				speed_initial = 30,
				aim_max_iterations = 40,
				speed_charge_duration = 0.5,
				offset_forward = 0,
				offset_up = 0.3,
				rotation_charge_duration = 0,
				speed_maximal = 30,
				locomotion_state = locomotion_states.true_flight,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				initial_angular_velocity = Vector3Box(0, 0, 1),
				randomized_angular_velocity = {
					x = math.pi * 2.2,
					y = math.pi * 1.1,
					z = math.pi * 2.2
				}
			},
			drop = {
				speed = 1,
				inherit_owner_velocity_percentage = 1,
				locomotion_state = locomotion_states.engine_physics
			}
		},
		integrator_parameters = {
			gravity = 12.5,
			radius = 0.07,
			coefficient_of_restitution = 0.2,
			drag_coefficient = 0.2,
			collision_filter = "filter_player_character_shooting_projectile",
			use_actor_mass_radius = false,
			air_density = 0.7,
			collision_types = "both",
			max_hit_count = 10,
			mass = 0.8,
			true_flight_template = TrueFlightTemplates.krak_grenade
		},
		vfx = {
			trajectory = {
				material_name = "content/fx/materials/master/trajectory"
			}
		}
	},
	ogryn_grenade_box = {
		throw_parameters = {
			throw = {
				offset_right = 0,
				aim_max_iterations = 40,
				aim_time_step_multiplier = 3,
				aim_max_number_of_bounces = 1,
				speed_initial = 30,
				inherit_owner_velocity_percentage = 1,
				speed_charge_duration = 0.7,
				offset_forward = 1,
				rotation_charge_duration = 0,
				speed_maximal = 60,
				locomotion_state = locomotion_states.manual_physics,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				initial_angular_velocity = Vector3Box(math.pi * 4.4, math.pi * 2.2, math.pi * 4.4),
				randomized_angular_velocity = {
					x = math.pi * 4.4,
					y = math.pi * 2.2,
					z = math.pi * 4.4
				}
			},
			underhand_throw = {
				offset_right = 0,
				inherit_owner_velocity_percentage = 1,
				aim_max_number_of_bounces = 1,
				aim_time_step_multiplier = 3,
				speed_initial = 25,
				aim_max_iterations = 40,
				speed_charge_duration = 0.3,
				offset_forward = 1,
				offset_up = -0.3,
				rotation_charge_duration = 0,
				speed_maximal = 50,
				locomotion_state = locomotion_states.manual_physics,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				initial_angular_velocity = Vector3Box(math.pi * 4.4, math.pi * 2.2, math.pi * 4.4),
				randomized_angular_velocity = {
					x = math.pi * 4.4,
					y = math.pi * 2.2,
					z = math.pi * 4.4
				}
			},
			quick_throw = {
				offset_right = -0.2,
				inherit_owner_velocity_percentage = 1,
				aim_max_number_of_bounces = 1,
				aim_time_step_multiplier = 3,
				speed_initial = 25,
				aim_max_iterations = 40,
				speed_charge_duration = 0.9,
				offset_forward = 0,
				offset_up = 0.3,
				rotation_charge_duration = 0,
				speed_maximal = 50,
				locomotion_state = locomotion_states.manual_physics,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				initial_angular_velocity = Vector3Box(math.pi * 4.4, math.pi * 2.2, math.pi * 4.4),
				randomized_angular_velocity = {
					x = math.pi * 4.4,
					y = math.pi * 2.2,
					z = math.pi * 4.4
				}
			},
			drop = {
				speed = 1,
				inherit_owner_velocity_percentage = 1,
				locomotion_state = locomotion_states.engine_physics
			}
		},
		integrator_parameters = {
			gravity = 10.5,
			radius = 0.07,
			coefficient_of_restitution = 0.05,
			drag_coefficient = 0.2,
			use_generous_bouncing = true,
			hit_zone_priority = "shield",
			collision_filter = "filter_player_character_shooting_projectile",
			use_actor_mass_radius = false,
			air_density = 0.7,
			collision_types = "both",
			max_hit_count = 10,
			mass = 24
		},
		vfx = {
			trajectory = {
				material_name = "content/fx/materials/master/trajectory"
			}
		}
	},
	ogryn_friendly_rock = {
		throw_parameters = {
			throw = {
				offset_right = 0,
				aim_max_iterations = 40,
				aim_time_step_multiplier = 3,
				aim_max_number_of_bounces = 1,
				speed_initial = 30,
				inherit_owner_velocity_percentage = 1,
				speed_charge_duration = 0.7,
				offset_forward = 1,
				rotation_charge_duration = 0,
				speed_maximal = 60,
				locomotion_state = locomotion_states.manual_physics,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				initial_angular_velocity = Vector3Box(math.pi * 4.4, math.pi * 2.2, math.pi * 4.4),
				randomized_angular_velocity = {
					x = math.pi * 4.4,
					y = math.pi * 2.2,
					z = math.pi * 4.4
				}
			},
			underhand_throw = {
				offset_right = 0,
				inherit_owner_velocity_percentage = 1,
				aim_max_number_of_bounces = 1,
				aim_time_step_multiplier = 3,
				speed_initial = 25,
				aim_max_iterations = 40,
				speed_charge_duration = 0.3,
				offset_forward = 1,
				offset_up = -0.3,
				rotation_charge_duration = 0,
				speed_maximal = 50,
				locomotion_state = locomotion_states.manual_physics,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				initial_angular_velocity = Vector3Box(math.pi * 4.4, math.pi * 2.2, math.pi * 4.4),
				randomized_angular_velocity = {
					x = math.pi * 4.4,
					y = math.pi * 2.2,
					z = math.pi * 4.4
				}
			},
			quick_throw = {
				offset_right = -0.2,
				inherit_owner_velocity_percentage = 1,
				aim_max_number_of_bounces = 1,
				aim_time_step_multiplier = 3,
				speed_initial = 25,
				aim_max_iterations = 40,
				speed_charge_duration = 0.9,
				offset_forward = 0,
				offset_up = 0.3,
				rotation_charge_duration = 0,
				speed_maximal = 50,
				locomotion_state = locomotion_states.manual_physics,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				initial_angular_velocity = Vector3Box(math.pi * 4.4, math.pi * 2.2, math.pi * 4.4),
				randomized_angular_velocity = {
					x = math.pi * 4.4,
					y = math.pi * 2.2,
					z = math.pi * 4.4
				}
			},
			drop = {
				speed = 1,
				inherit_owner_velocity_percentage = 1,
				locomotion_state = locomotion_states.engine_physics
			}
		},
		integrator_parameters = {
			gravity = 10.5,
			radius = 0.15,
			coefficient_of_restitution = 0.05,
			drag_coefficient = 0.2,
			use_generous_bouncing = true,
			hit_zone_priority = "shield",
			collision_filter = "filter_player_character_shooting_projectile",
			use_actor_mass_radius = false,
			air_density = 0.7,
			collision_types = "both",
			max_hit_count = 10,
			mass = 24
		},
		vfx = {
			trajectory = {
				material_name = "content/fx/materials/master/trajectory"
			}
		}
	},
	ogryn_frag_grenade = {
		throw_parameters = {
			throw = {
				offset_right = 0,
				aim_max_iterations = 40,
				aim_time_step_multiplier = 3,
				aim_max_number_of_bounces = 2,
				speed_initial = 30,
				inherit_owner_velocity_percentage = 1,
				speed_charge_duration = 0.5,
				offset_forward = 1,
				rotation_charge_duration = 0,
				speed_maximal = 32,
				locomotion_state = locomotion_states.manual_physics,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				initial_angular_velocity = Vector3Box(0, 0, 1),
				randomized_angular_velocity = {
					x = math.pi * 2.2,
					y = math.pi * 1.1,
					z = math.pi * 2.2
				}
			},
			underhand_throw = {
				offset_right = 0,
				inherit_owner_velocity_percentage = 1,
				aim_max_number_of_bounces = 2,
				aim_time_step_multiplier = 3,
				speed_initial = 9.5,
				aim_max_iterations = 40,
				speed_charge_duration = 0.4,
				offset_forward = 1,
				offset_up = -0.3,
				rotation_charge_duration = 0,
				speed_maximal = 10,
				locomotion_state = locomotion_states.manual_physics,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				initial_angular_velocity = Vector3Box(0, 0, 1),
				randomized_angular_velocity = {
					x = math.pi * 2.2,
					y = math.pi * 1.1,
					z = math.pi * 2.2
				}
			},
			quick_throw = {
				offset_right = -0.2,
				inherit_owner_velocity_percentage = 1,
				aim_max_number_of_bounces = 2,
				aim_time_step_multiplier = 3,
				speed_initial = 18,
				aim_max_iterations = 40,
				speed_charge_duration = 0.5,
				offset_forward = 0,
				offset_up = 0.3,
				rotation_charge_duration = 0,
				speed_maximal = 22,
				locomotion_state = locomotion_states.manual_physics,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				initial_angular_velocity = Vector3Box(0, 0, 1),
				randomized_angular_velocity = {
					x = math.pi * 2.2,
					y = math.pi * 1.1,
					z = math.pi * 2.2
				}
			},
			drop = {
				speed = 1,
				inherit_owner_velocity_percentage = 1,
				locomotion_state = locomotion_states.engine_physics
			}
		},
		integrator_parameters = {
			gravity = 12.5,
			radius = 0.07,
			coefficient_of_restitution = 0.2,
			drag_coefficient = 0.3,
			collision_filter = "filter_player_character_shooting_projectile",
			use_actor_mass_radius = false,
			air_density = 0.9,
			collision_types = "both",
			max_hit_count = 10,
			mass = 0.9
		},
		vfx = {
			trajectory = {
				material_name = "content/fx/materials/master/trajectory"
			}
		}
	},
	zealot_throwing_knife_projectile = {
		throw_parameters = {
			spawn = {
				locomotion_state = locomotion_states.manual_physics
			}
		},
		shoot_parameters = {
			initial_speed = 75,
			spawn_offset = Vector3Box(0, 0.7, 0),
			rotation = Vector3Box(-90, 0, 0),
			yaw_offset = {
				max = 1,
				min = 0.5
			},
			pitch_offset = {
				max = 0.8,
				min = 0.25
			}
		},
		integrator_parameters = {
			coefficient_of_restitution = 0,
			radius = 0.37,
			gravity = 17.5,
			drag_coefficient = 0.2,
			collision_filter = "filter_player_character_shooting_projectile",
			statics_raycast = true,
			use_actor_mass_radius = false,
			air_density = 0.7,
			collision_types = "both",
			mass = 0.8
		}
	},
	psyker_throwing_knife_projectile = {
		throw_parameters = {
			spawn = {
				locomotion_state = locomotion_states.true_flight
			}
		},
		shoot_parameters = {
			initial_speed = 20,
			spawn_offset = Vector3Box(0.1, 0.4, 0.12),
			rotation = Vector3Box(-90, 0, 0),
			has_target_yaw_offset = {
				max = 10,
				min = -10
			},
			has_target_pitch_offset = {
				max = 8,
				min = -3
			},
			pitch_offset = {
				max = 5,
				min = -5
			},
			yaw_offset = {
				max = 3,
				min = -3
			}
		},
		integrator_parameters = {
			statics_raycast = true,
			use_actor_mass_radius = false,
			radius = 0.1,
			coefficient_of_restitution = 1,
			collision_types = "both",
			collision_filter = "filter_player_character_shooting_magic_projectile",
			mass = 0.8,
			true_flight_template = TrueFlightTemplates.throwing_knives
		}
	},
	psyker_throwing_knife_projectile_aimed = {
		throw_parameters = {
			spawn = {
				locomotion_state = locomotion_states.true_flight
			}
		},
		shoot_parameters = {
			initial_speed = 40,
			spawn_offset = Vector3Box(0.1, 0.4, 0.12),
			rotation = Vector3Box(-90, 0, 0),
			has_target_yaw_offset = {
				max = 1,
				min = 0.5
			},
			has_target_pitch_offset = {
				max = 0.8,
				min = 0.25
			},
			pitch_offset = {
				max = 0,
				min = 0
			}
		},
		integrator_parameters = {
			statics_raycast = true,
			use_actor_mass_radius = false,
			radius = 0.1,
			coefficient_of_restitution = 1,
			collision_types = "both",
			collision_filter = "filter_player_character_shooting_magic_projectile",
			mass = 0.8,
			true_flight_template = TrueFlightTemplates.throwing_knives_aimed
		}
	}
}

return grenade_projectile_locomotion_templates
