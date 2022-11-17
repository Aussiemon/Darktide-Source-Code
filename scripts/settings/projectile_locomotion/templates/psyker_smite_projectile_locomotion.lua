local TrueFlightTemplates = require("scripts/settings/projectile/true_flight_templates")
local projectile_locomotion_templates = {
	smite_projectile_light = {
		shoot_parameters = {
			initial_speed = 30,
			has_target_yaw_offset = {
				max = 30,
				min = 10
			},
			has_target_pitch_offset = {
				max = 30,
				min = 0
			}
		},
		integrator_parameters = {
			radius = 0.035,
			use_actor_mass_radius = false,
			collision_filter = "filter_player_character_shooting_projectile",
			collision_types = "both",
			mass = 0.8,
			true_flight_template = TrueFlightTemplates.smite_light
		}
	},
	smite_projectile_light_target = {
		shoot_parameters = {
			initial_speed = 30,
			has_target_yaw_offset = {
				max = 30,
				min = 10
			},
			has_target_pitch_offset = {
				max = 30,
				min = 0
			}
		},
		integrator_parameters = {
			radius = 0.035,
			use_actor_mass_radius = false,
			collision_filter = "filter_player_character_shooting_projectile",
			collision_types = "both",
			mass = 0.8,
			true_flight_template = TrueFlightTemplates.smite_heavy
		}
	},
	smite_projectile_heavy = {
		throw_parameters = {
			spawn = {
				locomotion_state = "manual_physics"
			}
		},
		shoot_parameters = {
			initial_speed = 60,
			spawn_offset = Vector3Box(0, 0.2, -0.14),
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
			collision_filter = "filter_player_character_shooting_projectile",
			use_actor_mass_radius = false,
			air_density = 0,
			collision_types = "both",
			max_hit_count = 100,
			mass = 0.8
		},
		vfx = {}
	},
	smite_projectile_heavy_target = {
		shoot_parameters = {
			initial_speed = 30,
			has_target_yaw_offset = {
				max = 0,
				min = 5
			},
			has_target_pitch_offset = {
				max = 0,
				min = 0
			},
			pitch_offset = {
				max = 0,
				min = 0
			}
		},
		integrator_parameters = {
			radius = 0.07,
			use_actor_mass_radius = false,
			collision_filter = "filter_player_character_shooting_projectile",
			collision_types = "both",
			mass = 0.8,
			true_flight_template = TrueFlightTemplates.smite_heavy
		}
	},
	throwing_knife_projectile_true_flight = {
		shoot_parameters = {
			initial_speed = 40,
			spawn_offset = Vector3Box(0, 0.7, 0),
			rotation = Vector3Box(-90, 0, 0),
			has_target_yaw_offset = {
				max = 1,
				min = 0.5
			},
			has_target_pitch_offset = {
				max = 0.8,
				min = 0.25
			}
		},
		integrator_parameters = {
			radius = 0.07,
			use_actor_mass_radius = false,
			collision_filter = "filter_player_character_shooting_projectile",
			collision_types = "both",
			mass = 0.8,
			true_flight_template = TrueFlightTemplates.throwing_knives_true_flight
		}
	}
}

return projectile_locomotion_templates
