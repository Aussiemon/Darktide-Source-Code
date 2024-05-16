-- chunkname: @scripts/settings/projectile_locomotion/templates/minion_grenade_projectile_locomotion_templates.lua

local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local locomotion_states = ProjectileLocomotionSettings.states
local minion_projectile_locomotion_templates = {
	minion_grenade = {
		trajectory_parameters = {
			throw = {
				aim_max_iterations = 150,
				inherit_owner_velocity_percentage = 1,
				offset_forward = 1,
				offset_right = 0,
				place_distance = 2,
				rotation_charge_duration = 0,
				speed_charge_duration = 0,
				speed_initial = 20,
				speed_maximal = 20,
				locomotion_state = locomotion_states.manual_physics,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				randomized_angular_velocity = {
					x = math.pi / 10,
					y = math.pi,
					z = math.pi / 2,
				},
			},
			drop = {
				inherit_owner_velocity_percentage = 1,
				speed = 1,
				locomotion_state = locomotion_states.manual_physics,
				randomized_angular_velocity = {
					x = math.pi / 10,
					y = math.pi,
					z = math.pi / 2,
				},
			},
		},
		integrator_parameters = {
			air_density = 0,
			coefficient_of_restitution = 0,
			collision_filter = "filter_minion_throwing",
			collision_types = "both",
			drag_coefficient = 0,
			gravity = 12.5,
			mass = 0.8,
			max_hit_count = 1,
			radius = 0.025,
			use_actor_mass_radius = false,
		},
	},
	minion_grenade_cultist_grenadier = {
		trajectory_parameters = {
			throw = {
				aim_max_iterations = 150,
				inherit_owner_velocity_percentage = 1,
				offset_forward = 1,
				offset_right = 0,
				place_distance = 2,
				rotation_charge_duration = 0,
				speed_charge_duration = 0,
				speed_initial = 25,
				speed_maximal = 25,
				locomotion_state = locomotion_states.manual_physics,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				randomized_angular_velocity = {
					x = math.pi / 10,
					y = math.pi,
					z = math.pi / 2,
				},
			},
			drop = {
				inherit_owner_velocity_percentage = 1,
				speed = 1,
				locomotion_state = locomotion_states.manual_physics,
				randomized_angular_velocity = {
					x = math.pi / 10,
					y = math.pi,
					z = math.pi / 2,
				},
			},
		},
		integrator_parameters = {
			air_density = 0,
			coefficient_of_restitution = 0.55,
			collision_filter = "filter_minion_throwing",
			collision_types = "both",
			drag_coefficient = 0,
			gravity = 14.5,
			mass = 0.8,
			max_hit_count = 1,
			radius = 0.035,
			use_actor_mass_radius = false,
		},
	},
	minion_grenade_twin = {
		trajectory_parameters = {
			throw = {
				aim_max_iterations = 150,
				inherit_owner_velocity_percentage = 1,
				offset_forward = 1,
				offset_right = 0,
				place_distance = 2,
				rotation_charge_duration = 0,
				speed_charge_duration = 0,
				speed_initial = 18,
				speed_maximal = 28,
				locomotion_state = locomotion_states.manual_physics,
				rotation_offset_initial = Vector3Box(0, 0, 0),
				rotation_offset_maximal = Vector3Box(0, 0, 0),
				randomized_angular_velocity = {
					x = math.pi / 10,
					y = math.pi,
					z = math.pi / 2,
				},
			},
			drop = {
				inherit_owner_velocity_percentage = 1,
				speed = 1,
				locomotion_state = locomotion_states.manual_physics,
				randomized_angular_velocity = {
					x = math.pi / 10,
					y = math.pi,
					z = math.pi / 2,
				},
			},
		},
		integrator_parameters = {
			air_density = 0,
			coefficient_of_restitution = 0,
			collision_filter = "filter_minion_throwing",
			collision_types = "both",
			drag_coefficient = 0,
			gravity = 14.5,
			mass = 0.8,
			max_hit_count = 1,
			radius = 0.025,
			use_actor_mass_radius = false,
		},
	},
}

return minion_projectile_locomotion_templates
