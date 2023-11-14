local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local locomotion_states = ProjectileLocomotionSettings.states
local weapon_projectile_locomotion_templates = {
	force_staff_ball = {
		trajectory_parameters = {
			spawn = {
				locomotion_state = locomotion_states.manual_physics
			}
		},
		shoot_parameters = {
			initial_speed = 60,
			spawn_offset = Vector3Box(0, 0, 0),
			pitch_offset = {
				max = 0,
				min = 0
			}
		},
		integrator_parameters = {
			gravity = 0,
			radius = 0.125,
			coefficient_of_restitution = 0.125,
			drag_coefficient = 0,
			collision_filter = "filter_player_character_shooting_magic_projectile",
			statics_raycast = true,
			use_actor_mass_radius = false,
			air_density = 0,
			collision_types = "both",
			max_hit_count = 100,
			mass = 0.8
		},
		vfx = {}
	},
	force_staff_ball_heavy = {
		trajectory_parameters = {
			spawn = {
				locomotion_state = locomotion_states.manual_physics
			}
		},
		shoot_parameters = {
			initial_speed = 60,
			spawn_offset = Vector3Box(0, 0, 0),
			pitch_offset = {
				max = 0,
				min = 0
			}
		},
		integrator_parameters = {
			gravity = 0,
			radius = 0.3,
			coefficient_of_restitution = 0.125,
			drag_coefficient = 0,
			collision_filter = "filter_player_character_shooting_magic_projectile",
			statics_raycast = true,
			use_actor_mass_radius = false,
			air_density = 0,
			collision_types = "both",
			max_hit_count = 100,
			mass = 0.8
		},
		vfx = {}
	},
	ogryn_gauntlet_grenade = {
		trajectory_parameters = {
			shoot = {
				offset_right = 0,
				inherit_owner_velocity_percentage = 1,
				aim_max_number_of_bounces = 2,
				aim_time_step_multiplier = 3,
				speed_initial = 75,
				aim_max_iterations = 40,
				speed_charge_duration = 0,
				offset_forward = 1.5,
				offset_up = 0,
				rotation_charge_duration = 0,
				speed_maximal = 75,
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
		trajectory_parameters = {
			shoot = {
				offset_right = 0,
				inherit_owner_velocity_percentage = 1,
				aim_max_number_of_bounces = 2,
				aim_time_step_multiplier = 3,
				speed_initial = 95,
				aim_max_iterations = 40,
				speed_charge_duration = 0,
				offset_forward = 1.5,
				offset_up = 0,
				rotation_charge_duration = 0,
				speed_maximal = 95,
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
		trajectory_parameters = {
			shoot = {
				offset_right = 0,
				inherit_owner_velocity_percentage = 1,
				aim_max_number_of_bounces = 2,
				aim_time_step_multiplier = 3,
				speed_initial = 105,
				aim_max_iterations = 40,
				speed_charge_duration = 0,
				offset_forward = 1.5,
				offset_up = 0,
				rotation_charge_duration = 0,
				speed_maximal = 105,
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
	}
}

return weapon_projectile_locomotion_templates
