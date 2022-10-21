local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local locomotion_states = ProjectileLocomotionSettings.states
local projectile_locomotion_templates = {
	minion_grenade = {
		throw_parameters = {
			throw = {
				offset_right = 0,
				aim_max_iterations = 150,
				speed_inital = 20,
				place_distance = 2,
				inherit_owner_velocity_percentage = 1,
				speed_charge_duration = 0,
				offset_forward = 1,
				rotation_charge_duration = 0,
				speed_maximal = 20,
				locomotion_state = locomotion_states.manual_physics,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				randomized_angular_velocity = {
					x = math.pi / 10,
					y = math.pi,
					z = math.pi / 2
				}
			},
			drop = {
				speed = 1,
				inherit_owner_velocity_percentage = 1,
				locomotion_state = locomotion_states.manual_physics,
				randomized_angular_velocity = {
					x = math.pi / 10,
					y = math.pi,
					z = math.pi / 2
				}
			}
		},
		integrator_parameters = {
			gravity = 12.5,
			radius = 0.025,
			coefficient_of_restitution = 0,
			drag_coefficient = 0,
			collision_filter = "filter_minion_throwing",
			use_actor_mass_radius = false,
			air_density = 0,
			collision_types = "both",
			max_hit_count = 1,
			mass = 0.8
		}
	}
}

return projectile_locomotion_templates
