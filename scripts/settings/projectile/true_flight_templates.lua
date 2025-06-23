-- chunkname: @scripts/settings/projectile/true_flight_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local armor_types = ArmorSettings.types
local true_flight_templates = {}

true_flight_templates.krak_grenade = {
	legitimate_target_function = "legitimate_always",
	find_target_function = "krak_find_armored_target",
	slow_down_dot_product_threshold = 0.9,
	target_hit_zone = "torso",
	forward_search_distance_to_find_target = 1,
	update_seeking_position_function = "krak_projectile_locomotion",
	broadphase_radius = 3,
	check_all_hit_zones = true,
	speed_multiplier = 1,
	slow_down_factor = 0.2,
	trigger_time = 0.2,
	target_tracking_update_function = "krak_update_towards_position",
	on_target_acceleration = 50,
	time_between_raycasts = 0.1,
	skip_search_time = 0.1,
	target_armor_types = {
		[armor_types.super_armor] = true
	}
}
true_flight_templates.smite_light = {
	target_hit_zone = "head",
	find_target_function = "find_closest_highest_value_target",
	have_target_collision_types_override = "dynamics",
	legitimate_target_function = "legitimate_dot_check",
	forward_search_distance_to_find_target = 0.5,
	min_adjustment_speed = 15,
	broadphase_radius = 2.5,
	is_aligned_offset = 0.01,
	on_target_acceleration = 200,
	target_tracking_update_function = "smite_update_towards_position",
	time_between_raycasts = 0.1,
	lerp_modifier_func = function (integration_data, distance)
		return distance < 2 and 1 or 2 / distance
	end
}
true_flight_templates.smite_heavy = {
	target_hit_zone = "head",
	find_target_function = "find_closest_highest_value_target",
	have_target_collision_types_override = "dynamics",
	legitimate_target_function = "legitimate_dot_check",
	forward_search_distance_to_find_target = 0.5,
	min_adjustment_speed = 25,
	broadphase_radius = 2.5,
	is_aligned_offset = 0.01,
	on_target_acceleration = 300,
	target_tracking_update_function = "smite_update_towards_position",
	time_between_raycasts = 0.1,
	lerp_modifier_func = function (integration_data, distance)
		return distance < 1.5 and 1 or 1.5 / distance
	end
}
true_flight_templates.throwing_knives = {
	target_hit_zone = "head",
	find_target_function = "throwing_knives_find_highest_value_target",
	update_seeking_position_function = "throwing_knives_locomotion",
	allowed_bounces = 5,
	legitimate_target_function = "legitimate_line_of_sight_from_player",
	true_flight_shard_impact_behaviour = true,
	on_target_acceleration = 0,
	min_adjustment_speed = 15,
	speed_multiplier = 1,
	skip_search_time = 0.3,
	time_between_raycasts = 0.1,
	on_impact_function = "throwing_knives_on_impact",
	distance_to_owner_requirement = 100,
	forward_search_distance_to_find_target = 0,
	impact_validate_function = "throwing_knives_impact_valid",
	broadphase_radius = 10,
	is_aligned_offset = 0.25,
	target_tracking_update_function = "smite_update_towards_position",
	lerp_modifier_func = function (integration_data, distance)
		local d = 1.5

		return distance < d and 1 or d / distance
	end
}
true_flight_templates.throwing_knives_aimed = {
	target_hit_zone = "head",
	find_target_function = "throwing_knives_find_highest_value_target",
	update_seeking_position_function = "throwing_knives_locomotion",
	allowed_bounces = 5,
	legitimate_target_function = "legitimate_always",
	true_flight_shard_impact_behaviour = true,
	on_target_acceleration = 0,
	min_adjustment_speed = 15,
	speed_multiplier = 1,
	skip_search_time = 0,
	time_between_raycasts = 0.1,
	on_impact_function = "throwing_knives_on_impact",
	distance_to_owner_requirement = 100,
	forward_search_distance_to_find_target = 0,
	impact_validate_function = "throwing_knives_impact_valid",
	broadphase_radius = 10,
	is_aligned_offset = 0.25,
	target_tracking_update_function = "smite_update_towards_position",
	lerp_modifier_func = function (integration_data, distance)
		local d = 1.5

		return distance < d and 1 or d / distance
	end
}
true_flight_templates.drone = {
	speed_multiplier = 1,
	on_target_acceleration = 0,
	trigger_time = 0,
	target_tracking_update_function = "drone_update_towards_position",
	update_seeking_position_function = "drone_projectile_locomotion",
	time_between_raycasts = 0.1,
	lerp_modifier_func = function (integration_data, distance)
		local d = 1.5

		return distance < d and 1 or d / distance
	end
}
true_flight_templates.magic_missile = {
	legitimate_target_function = "legitimate_dot_check",
	find_target_function = "find_closest_highest_value_target",
	broadphase_radius = 2.5,
	forward_search_distance_to_find_target = 0.5,
	create_bot_threat = true,
	bot_threat_at_distance = 5,
	dot_threshold = 0.9999,
	lerp_squared_distance_threshold = 2000,
	speed_multiplier = 1,
	target_hit_zone = "head",
	target_tracking_update_function = "default_update_towards_position",
	initial_target_hit_zone = "head",
	time_between_raycasts = 0.1,
	lerp_constant = 50
}

return settings("TrueFlightTemplates", true_flight_templates)
