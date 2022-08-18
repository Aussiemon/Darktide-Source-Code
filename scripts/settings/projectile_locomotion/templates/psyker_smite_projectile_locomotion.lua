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
			collision_filter = "filter_player_character_throwing",
			collision_types = "both",
			mass = 0.8,
			true_flight_template = TrueFlightTemplates.smite_light
		}
	},
	smite_projectile_heavy = {
		shoot_parameters = {
			initial_speed = 30,
			has_target_yaw_offset = {
				max = 15,
				min = 5
			},
			has_target_pitch_offset = {
				max = 15,
				min = 0
			}
		},
		integrator_parameters = {
			radius = 0.07,
			use_actor_mass_radius = false,
			collision_filter = "filter_player_character_throwing",
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
			collision_filter = "filter_player_character_throwing",
			collision_types = "both",
			mass = 0.8,
			true_flight_template = TrueFlightTemplates.throwing_knives_true_flight
		}
	}
}

return projectile_locomotion_templates
