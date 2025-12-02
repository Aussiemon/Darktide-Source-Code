-- chunkname: @scripts/settings/projectile_locomotion/templates/luggable_battery_projectile_locomotion_templates.lua

local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local locomotion_states = ProjectileLocomotionSettings.states
local luggable_projectile_locomotion_templates = {
	luggable_battery = {
		trajectory_parameters = {
			throw = {
				aim_max_iterations = 40,
				aim_max_number_of_bounces = 1,
				aim_time_step_multiplier = 3,
				inherit_owner_velocity_percentage = 1,
				offset_forward = 1,
				offset_right = 0.3,
				offset_up = 0.1,
				place_distance = 2,
				randomized_angular_velocity = nil,
				rotation_charge_duration = 1,
				speed_charge_duration = 1.5,
				speed_initial = 4,
				speed_maximal = 6,
				locomotion_state = locomotion_states.manual_physics,
				rotation_offset_initial = Vector3Box(0, 0.53, 0),
				rotation_offset_maximal = Vector3Box(0, 0.53, 0),
				initial_angular_velocity = Vector3Box(1.22, 1.22, 0),
			},
			drop = {
				inherit_owner_velocity_percentage = 1,
				speed = 1,
				locomotion_state = locomotion_states.engine_physics,
			},
		},
		integrator_parameters = {
			air_density = 1.29,
			coefficient_of_restitution = 0.25,
			collision_filter = "filter_player_character_throwing",
			collision_types = "both",
			drag_coefficient = 0.5,
			gravity = 9.82,
			mass = 5,
			max_hit_count = 2,
			radius = 5,
			use_actor_mass_radius = true,
		},
		vfx = {
			trajectory = {
				material_name = "content/fx/materials/master/trajectory",
				radius = 0.025,
			},
		},
	},
}

return luggable_projectile_locomotion_templates
