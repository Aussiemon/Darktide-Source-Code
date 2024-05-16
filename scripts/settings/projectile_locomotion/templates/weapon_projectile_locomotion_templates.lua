﻿-- chunkname: @scripts/settings/projectile_locomotion/templates/weapon_projectile_locomotion_templates.lua

local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local locomotion_states = ProjectileLocomotionSettings.states
local weapon_projectile_locomotion_templates = {
	force_staff_ball = {
		trajectory_parameters = {
			spawn = {
				locomotion_state = locomotion_states.manual_physics,
			},
		},
		shoot_parameters = {
			initial_speed = 60,
			spawn_offset = Vector3Box(0, 0, 0),
			pitch_offset = {
				max = 0,
				min = 0,
			},
		},
		integrator_parameters = {
			air_density = 0,
			coefficient_of_restitution = 0.125,
			collision_filter = "filter_player_character_shooting_magic_projectile",
			collision_types = "both",
			drag_coefficient = 0,
			gravity = 0,
			mass = 0.8,
			max_hit_count = 100,
			radius = 0.125,
			statics_raycast = true,
			use_actor_mass_radius = false,
		},
		vfx = {},
	},
	force_staff_ball_heavy = {
		trajectory_parameters = {
			spawn = {
				locomotion_state = locomotion_states.manual_physics,
			},
		},
		shoot_parameters = {
			initial_speed = 60,
			spawn_offset = Vector3Box(0, 0, 0),
			pitch_offset = {
				max = 0,
				min = 0,
			},
		},
		integrator_parameters = {
			air_density = 0,
			coefficient_of_restitution = 0.125,
			collision_filter = "filter_player_character_shooting_magic_projectile",
			collision_types = "both",
			drag_coefficient = 0,
			gravity = 0,
			mass = 0.8,
			max_hit_count = 100,
			radius = 0.3,
			statics_raycast = true,
			use_actor_mass_radius = false,
		},
		vfx = {},
	},
	ogryn_gauntlet_grenade = {
		trajectory_parameters = {
			shoot = {
				aim_max_iterations = 40,
				aim_max_number_of_bounces = 2,
				aim_time_step_multiplier = 3,
				inherit_owner_velocity_percentage = 1,
				offset_forward = 1.5,
				offset_right = 0,
				offset_up = 0,
				rotation_charge_duration = 0,
				speed_charge_duration = 0,
				speed_initial = 75,
				speed_maximal = 75,
				locomotion_state = locomotion_states.manual_physics,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				initial_angular_velocity = Vector3Box(0, 0, 1),
				randomized_angular_velocity = {
					x = math.pi * 2.2,
					y = math.pi * 1.1,
					z = math.pi * 2.2,
				},
			},
			drop = {
				inherit_owner_velocity_percentage = 1,
				speed = 1,
				locomotion_state = locomotion_states.engine_physics,
			},
		},
		integrator_parameters = {
			air_density = 0.7,
			coefficient_of_restitution = 0.12,
			collision_filter = "filter_player_character_shooting_projectile",
			collision_types = "both",
			drag_coefficient = 1,
			gravity = 10,
			mass = 0.8,
			max_hit_count = 10,
			radius = 0.125,
			rotate_towards_direction = true,
			use_actor_mass_radius = false,
		},
		vfx = {
			trajectory = {
				material_name = "content/fx/materials/master/trajectory",
			},
		},
	},
	ogryn_thumper_grenade = {
		trajectory_parameters = {
			shoot = {
				aim_max_iterations = 40,
				aim_max_number_of_bounces = 2,
				aim_time_step_multiplier = 3,
				inherit_owner_velocity_percentage = 1,
				offset_forward = 1.5,
				offset_right = 0,
				offset_up = 0,
				rotation_charge_duration = 0,
				speed_charge_duration = 0,
				speed_initial = 95,
				speed_maximal = 95,
				locomotion_state = locomotion_states.manual_physics,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				initial_angular_velocity = Vector3Box(0, 0, 1),
				randomized_angular_velocity = {
					x = math.pi * 2.2,
					y = math.pi * 1.1,
					z = math.pi * 2.2,
				},
			},
			drop = {
				inherit_owner_velocity_percentage = 1,
				speed = 1,
				locomotion_state = locomotion_states.engine_physics,
			},
		},
		integrator_parameters = {
			air_density = 2.7,
			coefficient_of_restitution = 0.125,
			collision_filter = "filter_player_character_shooting_projectile",
			collision_types = "both",
			drag_coefficient = 0.5,
			gravity = 15,
			mass = 0.8,
			max_hit_count = 10,
			radius = 0.125,
			rotate_towards_direction = true,
			use_actor_mass_radius = false,
			use_generous_bouncing = true,
		},
		vfx = {
			trajectory = {
				material_name = "content/fx/materials/master/trajectory",
			},
		},
	},
	ogryn_thumper_grenade_aimed = {
		trajectory_parameters = {
			shoot = {
				aim_max_iterations = 40,
				aim_max_number_of_bounces = 2,
				aim_time_step_multiplier = 3,
				inherit_owner_velocity_percentage = 1,
				offset_forward = 1.5,
				offset_right = 0,
				offset_up = 0,
				rotation_charge_duration = 0,
				speed_charge_duration = 0,
				speed_initial = 105,
				speed_maximal = 105,
				locomotion_state = locomotion_states.manual_physics,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				initial_angular_velocity = Vector3Box(0, 0, 1),
				randomized_angular_velocity = {
					x = math.pi * 2.2,
					y = math.pi * 1.1,
					z = math.pi * 2.2,
				},
			},
			drop = {
				inherit_owner_velocity_percentage = 1,
				speed = 1,
				locomotion_state = locomotion_states.engine_physics,
			},
		},
		integrator_parameters = {
			air_density = 2.7,
			coefficient_of_restitution = 0.125,
			collision_filter = "filter_player_character_shooting_projectile",
			collision_types = "both",
			drag_coefficient = 0.5,
			gravity = 15,
			mass = 0.8,
			max_hit_count = 10,
			radius = 0.125,
			rotate_towards_direction = true,
			use_actor_mass_radius = false,
			use_generous_bouncing = true,
		},
		vfx = {
			trajectory = {
				material_name = "content/fx/materials/master/trajectory",
			},
		},
	},
}

return weapon_projectile_locomotion_templates
