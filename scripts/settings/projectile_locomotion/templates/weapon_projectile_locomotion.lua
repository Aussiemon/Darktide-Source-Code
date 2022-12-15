local projectile_locomotion_templates = {
	force_staff_ball = {
		throw_parameters = {
			spawn = {
				locomotion_state = "manual_physics"
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
		throw_parameters = {
			spawn = {
				locomotion_state = "manual_physics"
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
			radius = 0.5,
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
	}
}

return projectile_locomotion_templates
