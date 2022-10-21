local projectile_locomotion_templates = {
	luggable_battery = {
		throw_parameters = {
			throw = {
				offset_right = 0.3,
				aim_max_iterations = 40,
				speed_inital = 4,
				aim_time_step_multiplier = 3,
				aim_max_number_of_bounces = 1,
				place_distance = 2,
				inherit_owner_velocity_percentage = 1,
				speed_charge_duration = 1.5,
				offset_forward = 1,
				locomotion_state = "manual_physics",
				offset_up = 0.1,
				rotation_charge_duration = 1,
				speed_maximal = 6,
				rotation_offset_initial = Vector3Box(0, 0.53, 0),
				rotation_offset_maximal = Vector3Box(0, 0.53, 0),
				initial_angular_velocity = Vector3Box(1.22, 1.22, 0)
			},
			drop = {
				speed = 1,
				locomotion_state = "engine_physics",
				inherit_owner_velocity_percentage = 1
			}
		},
		integrator_parameters = {
			gravity = 9.82,
			radius = 5,
			coefficient_of_restitution = 0.25,
			drag_coefficient = 0.5,
			collision_filter = "filter_player_character_throwing",
			use_actor_mass_radius = true,
			air_density = 1.29,
			collision_types = "both",
			max_hit_count = 2,
			mass = 5
		},
		vfx = {
			trajectory = {
				material_name = "content/fx/materials/master/trajectory",
				radius = 0.025
			}
		}
	}
}

return projectile_locomotion_templates
