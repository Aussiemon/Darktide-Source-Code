local ArmorSettings = require("scripts/settings/damage/armor_settings")
local armor_types = ArmorSettings.types
local true_flight_templates = {
	krak_grenade = {
		target_hit_zone = "torso",
		skip_search_time = 0.1,
		slow_down_dot_product_threshold = 0.9,
		target_tracking_update_func = "krak_update_towards_position",
		forward_search_distance_to_find_target = 1,
		update_seeking_position_function = "krak_projectile_locomotion",
		broadphase_radius = 3,
		check_all_hit_zones = true,
		speed_multiplier = 1,
		slow_down_factor = 0.2,
		trigger_time = 0.2,
		find_target_func = "krak_find_armored_target",
		on_target_acceleration = 50,
		time_between_raycasts = 0.1,
		legitimate_target_func = "legitimate_always",
		target_armor_types = {
			[armor_types.resistant] = true,
			[armor_types.armored] = true,
			[armor_types.super_armor] = true
		}
	},
	smite_light = {
		target_hit_zone = "head",
		broadphase_radius = 2.5,
		have_target_collision_types_override = "dynamics",
		min_adjustment_speed = 15,
		forward_search_distance_to_find_target = 0.5,
		legitimate_target_func = "legitimate_dot_check",
		target_tracking_update_func = "smite_update_towards_position",
		is_alligned_offset = 0.01,
		on_target_acceleration = 200,
		find_target_func = "find_closest_highest_value_target",
		time_between_raycasts = 0.1,
		lerp_modifier_func = function (integration_data, distance)
			return distance < 2 and 1 or 2 / distance
		end
	},
	smite_heavy = {
		target_hit_zone = "head",
		broadphase_radius = 2.5,
		have_target_collision_types_override = "dynamics",
		min_adjustment_speed = 25,
		forward_search_distance_to_find_target = 0.5,
		legitimate_target_func = "legitimate_dot_check",
		target_tracking_update_func = "smite_update_towards_position",
		is_alligned_offset = 0.01,
		on_target_acceleration = 300,
		find_target_func = "find_closest_highest_value_target",
		time_between_raycasts = 0.1,
		lerp_modifier_func = function (integration_data, distance)
			return distance < 1.5 and 1 or 1.5 / distance
		end
	},
	throwing_knives = {
		target_hit_zone = "head",
		on_target_acceleration = 0,
		speed_multiplier = 1,
		on_impact = "throwing_knives_on_impact",
		allowed_bounces = 0,
		legitimate_target_func = "legitimate_always",
		target_tracking_update_func = "smite_update_towards_position",
		find_target_func = "throwing_knifes_find_highest_value_target",
		is_alligned_offset = 0,
		time_between_raycasts = 0.1,
		impact_validate = "throwing_knives_impact_valid",
		distance_to_owner_requirement = 30,
		forward_search_distance_to_find_target = 0,
		update_seeking_position_function = "default_update_position_velocity",
		broadphase_radius = 0,
		min_adjustment_speed = 25,
		lerp_modifier_func = function (integration_data, distance)
			local d = 1.5

			return distance < d and 1 or d / distance
		end
	},
	throwing_knives_true_flight = {
		target_hit_zone = "head",
		on_target_acceleration = 0,
		speed_multiplier = 1,
		on_impact = "throwing_knives_on_impact",
		allowed_bounces = 20,
		legitimate_target_func = "legitimate_always",
		target_tracking_update_func = "smite_update_towards_position",
		find_target_func = "throwing_knifes_find_highest_value_target",
		is_alligned_offset = 0.01,
		time_between_raycasts = 0.1,
		impact_validate = "throwing_knives_impact_valid",
		distance_to_owner_requirement = 30,
		forward_search_distance_to_find_target = 0.25,
		update_seeking_position_function = "default_update_position_velocity",
		broadphase_radius = 10,
		min_adjustment_speed = 25,
		lerp_modifier_func = function (integration_data, distance)
			local d = 1.5

			return distance < d and 1 or d / distance
		end
	},
	magic_missile = {
		target_hit_zone = "head",
		broadphase_radius = 2.5,
		target_tracking_update_func = "default_update_towards_position",
		legitimate_target_func = "legitimate_dot_check",
		create_bot_threat = true,
		bot_threat_at_distance = 5,
		dot_threshold = 0.9999,
		lerp_squared_distance_threshold = 2000,
		speed_multiplier = 1,
		forward_search_distance_to_find_target = 0.5,
		find_target_func = "find_closest_highest_value_target",
		initial_target_hit_zone = "head",
		time_between_raycasts = 0.1,
		lerp_constant = 50
	}
}

return settings("TrueFlightTemplates", true_flight_templates)
