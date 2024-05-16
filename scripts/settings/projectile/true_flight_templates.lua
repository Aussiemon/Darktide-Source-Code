-- chunkname: @scripts/settings/projectile/true_flight_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local armor_types = ArmorSettings.types
local true_flight_templates = {}

true_flight_templates.krak_grenade = {
	broadphase_radius = 3,
	check_all_hit_zones = true,
	find_target_func = "krak_find_armored_target",
	forward_search_distance_to_find_target = 1,
	legitimate_target_func = "legitimate_always",
	on_target_acceleration = 50,
	skip_search_time = 0.1,
	slow_down_dot_product_threshold = 0.9,
	slow_down_factor = 0.2,
	speed_multiplier = 1,
	target_hit_zone = "torso",
	target_tracking_update_func = "krak_update_towards_position",
	time_between_raycasts = 0.1,
	trigger_time = 0.2,
	update_seeking_position_function = "krak_projectile_locomotion",
	target_armor_types = {
		[armor_types.super_armor] = true,
	},
}
true_flight_templates.smite_light = {
	broadphase_radius = 2.5,
	find_target_func = "find_closest_highest_value_target",
	forward_search_distance_to_find_target = 0.5,
	have_target_collision_types_override = "dynamics",
	is_aligned_offset = 0.01,
	legitimate_target_func = "legitimate_dot_check",
	min_adjustment_speed = 15,
	on_target_acceleration = 200,
	target_hit_zone = "head",
	target_tracking_update_func = "smite_update_towards_position",
	time_between_raycasts = 0.1,
	lerp_modifier_func = function (integration_data, distance)
		return distance < 2 and 1 or 2 / distance
	end,
}
true_flight_templates.smite_heavy = {
	broadphase_radius = 2.5,
	find_target_func = "find_closest_highest_value_target",
	forward_search_distance_to_find_target = 0.5,
	have_target_collision_types_override = "dynamics",
	is_aligned_offset = 0.01,
	legitimate_target_func = "legitimate_dot_check",
	min_adjustment_speed = 25,
	on_target_acceleration = 300,
	target_hit_zone = "head",
	target_tracking_update_func = "smite_update_towards_position",
	time_between_raycasts = 0.1,
	lerp_modifier_func = function (integration_data, distance)
		return distance < 1.5 and 1 or 1.5 / distance
	end,
}
true_flight_templates.throwing_knives = {
	allowed_bounces = 5,
	broadphase_radius = 10,
	distance_to_owner_requirement = 100,
	find_target_func = "throwing_knives_find_highest_value_target",
	forward_search_distance_to_find_target = 0,
	impact_validate = "throwing_knives_impact_valid",
	is_aligned_offset = 0.25,
	legitimate_target_func = "legitimate_line_of_sight_from_player",
	min_adjustment_speed = 15,
	on_impact = "throwing_knives_on_impact",
	on_target_acceleration = 0,
	skip_search_time = 0.3,
	speed_multiplier = 1,
	target_hit_zone = "head",
	target_tracking_update_func = "smite_update_towards_position",
	time_between_raycasts = 0.1,
	true_flight_shard_impact_behaviour = true,
	update_seeking_position_function = "throwing_knives_locomotion",
	lerp_modifier_func = function (integration_data, distance)
		local d = 1.5

		return distance < d and 1 or d / distance
	end,
}
true_flight_templates.throwing_knives_aimed = {
	allowed_bounces = 5,
	broadphase_radius = 10,
	distance_to_owner_requirement = 100,
	find_target_func = "throwing_knives_find_highest_value_target",
	forward_search_distance_to_find_target = 0,
	impact_validate = "throwing_knives_impact_valid",
	is_aligned_offset = 0.25,
	legitimate_target_func = "legitimate_always",
	min_adjustment_speed = 15,
	on_impact = "throwing_knives_on_impact",
	on_target_acceleration = 0,
	skip_search_time = 0,
	speed_multiplier = 1,
	target_hit_zone = "head",
	target_tracking_update_func = "smite_update_towards_position",
	time_between_raycasts = 0.1,
	true_flight_shard_impact_behaviour = true,
	update_seeking_position_function = "throwing_knives_locomotion",
	lerp_modifier_func = function (integration_data, distance)
		local d = 1.5

		return distance < d and 1 or d / distance
	end,
}
true_flight_templates.magic_missile = {
	bot_threat_at_distance = 5,
	broadphase_radius = 2.5,
	create_bot_threat = true,
	dot_threshold = 0.9999,
	find_target_func = "find_closest_highest_value_target",
	forward_search_distance_to_find_target = 0.5,
	initial_target_hit_zone = "head",
	legitimate_target_func = "legitimate_dot_check",
	lerp_constant = 50,
	lerp_squared_distance_threshold = 2000,
	speed_multiplier = 1,
	target_hit_zone = "head",
	target_tracking_update_func = "default_update_towards_position",
	time_between_raycasts = 0.1,
}

return settings("TrueFlightTemplates", true_flight_templates)
