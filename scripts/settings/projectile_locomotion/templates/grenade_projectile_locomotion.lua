local TrueFlightTemplates = require("scripts/settings/projectile/true_flight_templates")
local projectile_locomotion_templates = {
	grenade = {
		throw_parameters = {
			throw = {
				offset_right = 0,
				aim_max_iterations = 40,
				speed_inital = 15,
				aim_time_step_multiplier = 3,
				inherit_owner_velocity_percentage = 1,
				speed_charge_duration = 0.5,
				offset_forward = 1,
				locomotion_state = "manual_physics",
				aim_max_number_of_bounces = 2,
				rotation_charge_duration = 0,
				speed_maximal = 30,
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
				locomotion_state = "manual_physics",
				inherit_owner_velocity_percentage = 1,
				speed_inital = 8,
				aim_time_step_multiplier = 3,
				aim_max_iterations = 40,
				speed_charge_duration = 0.5,
				offset_forward = 1,
				aim_max_number_of_bounces = 2,
				offset_up = -0.3,
				rotation_charge_duration = 0,
				speed_maximal = 8,
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
				locomotion_state = "manual_physics",
				inherit_owner_velocity_percentage = 1,
				speed_inital = 30,
				aim_time_step_multiplier = 3,
				aim_max_iterations = 40,
				speed_charge_duration = 0.5,
				offset_forward = 0,
				aim_max_number_of_bounces = 2,
				offset_up = 0.3,
				rotation_charge_duration = 0,
				speed_maximal = 30,
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
				locomotion_state = "engine_physics",
				inherit_owner_velocity_percentage = 1
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
				locomotion_state = "true_flight",
				inherit_owner_velocity_percentage = 1,
				speed_inital = 15,
				aim_time_step_multiplier = 3,
				aim_max_iterations = 40,
				speed_charge_duration = 0.5,
				offset_forward = 1,
				aim_max_number_of_bounces = 2,
				offset_up = 0,
				rotation_charge_duration = 0,
				speed_maximal = 30,
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
				locomotion_state = "manual_physics",
				inherit_owner_velocity_percentage = 1,
				speed_inital = 8,
				aim_time_step_multiplier = 3,
				aim_max_iterations = 40,
				speed_charge_duration = 0.5,
				offset_forward = 1,
				aim_max_number_of_bounces = 2,
				offset_up = -0.3,
				rotation_charge_duration = 0,
				speed_maximal = 8,
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
				locomotion_state = "true_flight",
				inherit_owner_velocity_percentage = 1,
				speed_inital = 30,
				aim_time_step_multiplier = 3,
				aim_max_iterations = 40,
				speed_charge_duration = 0.5,
				offset_forward = 0,
				aim_max_number_of_bounces = 2,
				offset_up = 0.3,
				rotation_charge_duration = 0,
				speed_maximal = 30,
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
				locomotion_state = "engine_physics",
				inherit_owner_velocity_percentage = 1
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
	ogryn_gauntlet_grenade = {
		throw_parameters = {
			shoot = {
				offset_right = 0,
				locomotion_state = "manual_physics",
				inherit_owner_velocity_percentage = 1,
				speed_inital = 75,
				aim_time_step_multiplier = 3,
				aim_max_iterations = 40,
				speed_charge_duration = 0,
				offset_forward = 1.5,
				aim_max_number_of_bounces = 2,
				offset_up = 0,
				rotation_charge_duration = 0,
				speed_maximal = 75,
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
				locomotion_state = "engine_physics",
				inherit_owner_velocity_percentage = 1
			}
		},
		integrator_parameters = {
			gravity = 10,
			radius = 0.125,
			coefficient_of_restitution = 0.12,
			drag_coefficient = 1,
			rotate_towards_direction = true,
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
	ogryn_thumper_grenade = {
		throw_parameters = {
			shoot = {
				offset_right = 0,
				locomotion_state = "manual_physics",
				inherit_owner_velocity_percentage = 1,
				speed_inital = 95,
				aim_time_step_multiplier = 3,
				aim_max_iterations = 40,
				speed_charge_duration = 0,
				offset_forward = 1.5,
				aim_max_number_of_bounces = 2,
				offset_up = 0,
				rotation_charge_duration = 0,
				speed_maximal = 95,
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
				locomotion_state = "engine_physics",
				inherit_owner_velocity_percentage = 1
			}
		},
		integrator_parameters = {
			gravity = 15,
			radius = 0.125,
			coefficient_of_restitution = 0.125,
			drag_coefficient = 0.5,
			use_generous_bouncing = true,
			rotate_towards_direction = true,
			collision_filter = "filter_player_character_shooting_projectile",
			use_actor_mass_radius = false,
			air_density = 2.7,
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
	ogryn_thumper_grenade_aimed = {
		throw_parameters = {
			shoot = {
				offset_right = 0,
				locomotion_state = "manual_physics",
				inherit_owner_velocity_percentage = 1,
				speed_inital = 105,
				aim_time_step_multiplier = 3,
				aim_max_iterations = 40,
				speed_charge_duration = 0,
				offset_forward = 1.5,
				aim_max_number_of_bounces = 2,
				offset_up = 0,
				rotation_charge_duration = 0,
				speed_maximal = 105,
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
				locomotion_state = "engine_physics",
				inherit_owner_velocity_percentage = 1
			}
		},
		integrator_parameters = {
			gravity = 15,
			radius = 0.125,
			coefficient_of_restitution = 0.125,
			drag_coefficient = 0.5,
			use_generous_bouncing = true,
			rotate_towards_direction = true,
			collision_filter = "filter_player_character_shooting_projectile",
			use_actor_mass_radius = false,
			air_density = 2.7,
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
	ogryn_grenade_box = {
		throw_parameters = {
			throw = {
				offset_right = 0,
				aim_max_iterations = 40,
				speed_inital = 30,
				aim_time_step_multiplier = 3,
				inherit_owner_velocity_percentage = 1,
				speed_charge_duration = 0.7,
				offset_forward = 1,
				locomotion_state = "manual_physics",
				aim_max_number_of_bounces = 1,
				rotation_charge_duration = 0,
				speed_maximal = 60,
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
				locomotion_state = "manual_physics",
				inherit_owner_velocity_percentage = 1,
				speed_inital = 25,
				aim_time_step_multiplier = 3,
				aim_max_iterations = 40,
				speed_charge_duration = 0.3,
				offset_forward = 1,
				aim_max_number_of_bounces = 1,
				offset_up = -0.3,
				rotation_charge_duration = 0,
				speed_maximal = 50,
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
				locomotion_state = "manual_physics",
				inherit_owner_velocity_percentage = 1,
				speed_inital = 25,
				aim_time_step_multiplier = 3,
				aim_max_iterations = 40,
				speed_charge_duration = 0.9,
				offset_forward = 0,
				aim_max_number_of_bounces = 1,
				offset_up = 0.3,
				rotation_charge_duration = 0,
				speed_maximal = 50,
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
				locomotion_state = "engine_physics",
				inherit_owner_velocity_percentage = 1
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
	ogryn_frag_grenade = {
		throw_parameters = {
			throw = {
				offset_right = 0,
				aim_max_iterations = 40,
				speed_inital = 30,
				aim_time_step_multiplier = 3,
				inherit_owner_velocity_percentage = 1,
				speed_charge_duration = 0.5,
				offset_forward = 1,
				locomotion_state = "manual_physics",
				aim_max_number_of_bounces = 2,
				rotation_charge_duration = 0,
				speed_maximal = 32,
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
				locomotion_state = "manual_physics",
				inherit_owner_velocity_percentage = 1,
				speed_inital = 9.5,
				aim_time_step_multiplier = 3,
				aim_max_iterations = 40,
				speed_charge_duration = 0.4,
				offset_forward = 1,
				aim_max_number_of_bounces = 2,
				offset_up = -0.3,
				rotation_charge_duration = 0,
				speed_maximal = 10,
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
				locomotion_state = "manual_physics",
				inherit_owner_velocity_percentage = 1,
				speed_inital = 18,
				aim_time_step_multiplier = 3,
				aim_max_iterations = 40,
				speed_charge_duration = 0.5,
				offset_forward = 0,
				aim_max_number_of_bounces = 2,
				offset_up = 0.3,
				rotation_charge_duration = 0,
				speed_maximal = 22,
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
				locomotion_state = "engine_physics",
				inherit_owner_velocity_percentage = 1
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
	}
}

return projectile_locomotion_templates
