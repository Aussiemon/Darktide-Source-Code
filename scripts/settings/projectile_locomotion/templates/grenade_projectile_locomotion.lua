local TrueFlightTemplates = require("scripts/settings/projectile/true_flight_templates")
local projectile_locomotion_templates = {
	grenade = {
		throw_parameters = {
			throw = {
				offset_right = 0,
				aim_max_iterations = 150,
				speed_inital = 15,
				offset_forward = 1,
				locomotion_state = "manual_physics",
				inherit_owner_velocity_percentage = 1,
				speed_charge_duration = 0.5,
				rotation_charge_duration = 0,
				speed_maximal = 30,
				rotation_offset_initial = Vector3Box(math.degrees_to_radians(0), math.degrees_to_radians(0), math.degrees_to_radians(0)),
				rotation_offset_maximal = Vector3Box(math.degrees_to_radians(0), math.degrees_to_radians(0), math.degrees_to_radians(0)),
				momentum = Vector3Box(0, 0, 1),
				randomized_momentum = {
					x = math.pi / 20,
					y = math.pi / 10,
					z = math.pi / 20
				}
			},
			underhand_throw = {
				offset_right = 0,
				aim_max_iterations = 150,
				speed_inital = 8,
				offset_forward = 1,
				locomotion_state = "manual_physics",
				inherit_owner_velocity_percentage = 1,
				speed_charge_duration = 0.5,
				offset_up = -0.3,
				rotation_charge_duration = 0,
				speed_maximal = 8,
				rotation_offset_initial = Vector3Box(math.degrees_to_radians(0), math.degrees_to_radians(0), math.degrees_to_radians(0)),
				rotation_offset_maximal = Vector3Box(math.degrees_to_radians(0), math.degrees_to_radians(0), math.degrees_to_radians(0)),
				momentum = Vector3Box(0, 0, 1),
				randomized_momentum = {
					x = math.pi / 20,
					y = math.pi / 10,
					z = math.pi / 20
				}
			},
			quick_throw = {
				offset_right = -0.2,
				aim_max_iterations = 150,
				speed_inital = 30,
				offset_forward = 0,
				locomotion_state = "manual_physics",
				inherit_owner_velocity_percentage = 1,
				speed_charge_duration = 0.5,
				offset_up = 0.3,
				rotation_charge_duration = 0,
				speed_maximal = 30,
				rotation_offset_initial = Vector3Box(math.degrees_to_radians(0), math.degrees_to_radians(0), math.degrees_to_radians(0)),
				rotation_offset_maximal = Vector3Box(math.degrees_to_radians(0), math.degrees_to_radians(0), math.degrees_to_radians(0)),
				momentum = Vector3Box(0, 0, 1),
				randomized_momentum = {
					x = math.pi / 20,
					y = math.pi / 10,
					z = math.pi / 20
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
			collision_filter = "filter_player_character_throwing",
			use_actor_mass_radius = false,
			air_density = 0.7,
			collision_types = "both",
			max_hit_count = 10,
			mass = 0.8
		},
		vfx = {
			trajectory = {
				particle_distance = 1,
				position_prefix = "pos_",
				max_position_indices = 30,
				effect_name = "content/fx/particles/abilities/trajectory_indicator"
			}
		}
	},
	krak_grenade = {
		throw_parameters = {
			throw = {
				offset_right = 0,
				aim_max_iterations = 150,
				speed_inital = 15,
				offset_forward = 1,
				locomotion_state = "true_flight",
				inherit_owner_velocity_percentage = 1,
				speed_charge_duration = 0.5,
				offset_up = 0,
				rotation_charge_duration = 0,
				speed_maximal = 30,
				rotation_offset_initial = Vector3Box(math.degrees_to_radians(0), math.degrees_to_radians(0), math.degrees_to_radians(0)),
				rotation_offset_maximal = Vector3Box(math.degrees_to_radians(0), math.degrees_to_radians(0), math.degrees_to_radians(0)),
				momentum = Vector3Box(0, 0, 1),
				randomized_momentum = {
					x = math.pi / 20,
					y = math.pi / 10,
					z = math.pi / 20
				}
			},
			underhand_throw = {
				offset_right = 0,
				aim_max_iterations = 150,
				speed_inital = 8,
				offset_forward = 1,
				locomotion_state = "manual_physics",
				inherit_owner_velocity_percentage = 1,
				speed_charge_duration = 0.5,
				offset_up = -0.3,
				rotation_charge_duration = 0,
				speed_maximal = 8,
				rotation_offset_initial = Vector3Box(math.degrees_to_radians(0), math.degrees_to_radians(0), math.degrees_to_radians(0)),
				rotation_offset_maximal = Vector3Box(math.degrees_to_radians(0), math.degrees_to_radians(0), math.degrees_to_radians(0)),
				momentum = Vector3Box(0, 0, 1),
				randomized_momentum = {
					x = math.pi / 20,
					y = math.pi / 10,
					z = math.pi / 20
				}
			},
			quick_throw = {
				offset_right = -0.2,
				aim_max_iterations = 150,
				speed_inital = 30,
				offset_forward = 0,
				locomotion_state = "true_flight",
				inherit_owner_velocity_percentage = 1,
				speed_charge_duration = 0.5,
				offset_up = 0.3,
				rotation_charge_duration = 0,
				speed_maximal = 30,
				rotation_offset_initial = Vector3Box(math.degrees_to_radians(0), math.degrees_to_radians(0), math.degrees_to_radians(0)),
				rotation_offset_maximal = Vector3Box(math.degrees_to_radians(0), math.degrees_to_radians(0), math.degrees_to_radians(0)),
				momentum = Vector3Box(0, 0, 1),
				randomized_momentum = {
					x = math.pi / 20,
					y = math.pi / 10,
					z = math.pi / 20
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
			collision_filter = "filter_player_character_throwing",
			use_actor_mass_radius = false,
			air_density = 0.7,
			collision_types = "both",
			max_hit_count = 10,
			mass = 0.8,
			true_flight_template = TrueFlightTemplates.krak_grenade
		},
		vfx = {
			trajectory = {
				particle_distance = 1,
				position_prefix = "pos_",
				max_position_indices = 30,
				effect_name = "content/fx/particles/abilities/trajectory_indicator"
			}
		}
	},
	ogryn_gauntlet_grenade = {
		throw_parameters = {
			shoot = {
				offset_right = 0,
				aim_max_iterations = 150,
				speed_inital = 75,
				offset_forward = 1.5,
				locomotion_state = "manual_physics",
				inherit_owner_velocity_percentage = 1,
				speed_charge_duration = 0,
				offset_up = 0,
				rotation_charge_duration = 0,
				speed_maximal = 75,
				rotation_offset_initial = Vector3Box(math.degrees_to_radians(0), math.degrees_to_radians(0), math.degrees_to_radians(0)),
				rotation_offset_maximal = Vector3Box(math.degrees_to_radians(0), math.degrees_to_radians(0), math.degrees_to_radians(0)),
				momentum = Vector3Box(0, 0, 1),
				randomized_momentum = {
					x = math.pi / 20,
					y = math.pi / 10,
					z = math.pi / 20
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
			collision_filter = "filter_player_character_throwing",
			use_actor_mass_radius = false,
			air_density = 0.7,
			collision_types = "both",
			max_hit_count = 10,
			mass = 0.8
		},
		vfx = {
			trajectory = {
				particle_distance = 1,
				position_prefix = "pos_",
				max_position_indices = 30,
				effect_name = "content/fx/particles/abilities/trajectory_indicator"
			}
		}
	},
	ogryn_thumper_grenade = {
		throw_parameters = {
			shoot = {
				offset_right = 0,
				aim_max_iterations = 150,
				speed_inital = 95,
				offset_forward = 1.5,
				locomotion_state = "manual_physics",
				inherit_owner_velocity_percentage = 1,
				speed_charge_duration = 0,
				offset_up = 0,
				rotation_charge_duration = 0,
				speed_maximal = 95,
				rotation_offset_initial = Vector3Box(math.degrees_to_radians(0), math.degrees_to_radians(0), math.degrees_to_radians(0)),
				rotation_offset_maximal = Vector3Box(math.degrees_to_radians(0), math.degrees_to_radians(0), math.degrees_to_radians(0)),
				momentum = Vector3Box(0, 0, 1),
				randomized_momentum = {
					x = math.pi / 20,
					y = math.pi / 10,
					z = math.pi / 20
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
			collision_filter = "filter_player_character_throwing",
			use_actor_mass_radius = false,
			air_density = 2.7,
			collision_types = "both",
			max_hit_count = 10,
			mass = 0.8
		},
		vfx = {
			trajectory = {
				particle_distance = 1,
				position_prefix = "pos_",
				max_position_indices = 30,
				effect_name = "content/fx/particles/abilities/trajectory_indicator"
			}
		}
	},
	ogryn_thumper_grenade_aimed = {
		throw_parameters = {
			shoot = {
				offset_right = 0,
				aim_max_iterations = 150,
				speed_inital = 105,
				offset_forward = 1.5,
				locomotion_state = "manual_physics",
				inherit_owner_velocity_percentage = 1,
				speed_charge_duration = 0,
				offset_up = 0,
				rotation_charge_duration = 0,
				speed_maximal = 105,
				rotation_offset_initial = Vector3Box(math.degrees_to_radians(0), math.degrees_to_radians(0), math.degrees_to_radians(0)),
				rotation_offset_maximal = Vector3Box(math.degrees_to_radians(0), math.degrees_to_radians(0), math.degrees_to_radians(0)),
				momentum = Vector3Box(0, 0, 1),
				randomized_momentum = {
					x = math.pi / 20,
					y = math.pi / 10,
					z = math.pi / 20
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
			collision_filter = "filter_player_character_throwing",
			use_actor_mass_radius = false,
			air_density = 2.7,
			collision_types = "both",
			max_hit_count = 10,
			mass = 0.8
		},
		vfx = {
			trajectory = {
				particle_distance = 1,
				position_prefix = "pos_",
				max_position_indices = 30,
				effect_name = "content/fx/particles/abilities/trajectory_indicator"
			}
		}
	}
}

return projectile_locomotion_templates
