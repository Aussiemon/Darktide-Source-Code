-- chunkname: @scripts/settings/projectile/true_flight_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local TrueFlightDefaults = require("scripts/extension_systems/locomotion/utilities/true_flight_functions/true_flight_defaults")
local armor_types = ArmorSettings.types
local true_flight_templates = {}

true_flight_templates.krak_grenade = {
	broadphase_radius = 3,
	check_all_hit_zones = true,
	find_target_function = "krak_find_armored_target",
	forward_search_distance_to_find_target = 1,
	legitimate_target_function = "legitimate_always",
	on_target_acceleration = 50,
	skip_search_time = 0.1,
	slow_down_dot_product_threshold = 0.9,
	slow_down_factor = 0.2,
	speed_multiplier = 1,
	target_hit_zone = "torso",
	target_tracking_update_function = "krak_update_towards_position",
	time_between_raycasts = 0.1,
	trigger_time = 0.2,
	update_seeking_position_function = "krak_projectile_locomotion",
	target_armor_types = {
		[armor_types.super_armor] = true
	}
}
true_flight_templates.smite_light = {
	broadphase_radius = 2.5,
	find_target_function = "find_closest_highest_value_target",
	forward_search_distance_to_find_target = 0.5,
	have_target_collision_types_override = "dynamics",
	is_aligned_offset = 0.01,
	legitimate_target_function = "legitimate_dot_check",
	min_adjustment_speed = 15,
	on_target_acceleration = 200,
	target_hit_zone = "head",
	target_tracking_update_function = "smite_update_towards_position",
	time_between_raycasts = 0.1,
	lerp_modifier_func = function (integration_data, distance)
		return distance < 2 and 1 or 2 / distance
	end
}
true_flight_templates.smite_heavy = {
	broadphase_radius = 2.5,
	find_target_function = "find_closest_highest_value_target",
	forward_search_distance_to_find_target = 0.5,
	have_target_collision_types_override = "dynamics",
	is_aligned_offset = 0.01,
	legitimate_target_function = "legitimate_dot_check",
	min_adjustment_speed = 25,
	on_target_acceleration = 300,
	target_hit_zone = "head",
	target_tracking_update_function = "smite_update_towards_position",
	time_between_raycasts = 0.1,
	lerp_modifier_func = function (integration_data, distance)
		return distance < 1.5 and 1 or 1.5 / distance
	end
}
true_flight_templates.throwing_knives = {
	allowed_bounces = 5,
	broadphase_radius = 10,
	distance_to_owner_requirement = 100,
	find_target_function = "throwing_knives_find_highest_value_target",
	forward_search_distance_to_find_target = 0,
	impact_validate_function = "throwing_knives_impact_valid",
	is_aligned_offset = 0.25,
	legitimate_target_function = "legitimate_line_of_sight_from_player",
	min_adjustment_speed = 15,
	on_impact_function = "throwing_knives_on_impact",
	on_target_acceleration = 0,
	skip_search_time = 0.3,
	speed_multiplier = 1,
	target_hit_zone = "head",
	target_tracking_update_function = "smite_update_towards_position",
	time_between_raycasts = 0.1,
	true_flight_shard_impact_behaviour = true,
	update_seeking_position_function = "throwing_knives_locomotion",
	lerp_modifier_func = function (integration_data, distance)
		local d = 1.5

		return distance < d and 1 or d / distance
	end
}
true_flight_templates.throwing_knives_aimed = {
	allowed_bounces = 5,
	broadphase_radius = 10,
	distance_to_owner_requirement = 100,
	find_target_function = "throwing_knives_find_highest_value_target",
	forward_search_distance_to_find_target = 0,
	impact_validate_function = "throwing_knives_impact_valid",
	is_aligned_offset = 0.25,
	legitimate_target_function = "legitimate_always",
	min_adjustment_speed = 15,
	on_impact_function = "throwing_knives_on_impact",
	on_target_acceleration = 0,
	skip_search_time = 0,
	speed_multiplier = 1,
	target_hit_zone = "head",
	target_tracking_update_function = "smite_update_towards_position",
	time_between_raycasts = 0.1,
	true_flight_shard_impact_behaviour = true,
	update_seeking_position_function = "throwing_knives_locomotion",
	lerp_modifier_func = function (integration_data, distance)
		local d = 1.5

		return distance < d and 1 or d / distance
	end
}
true_flight_templates.wizard_ball = {
	allowed_bounces = 10,
	broadphase_radius = 10,
	distance_to_owner_requirement = 100,
	find_target_function = "throwing_knives_find_highest_value_target",
	forward_search_distance_to_find_target = 0,
	impact_validate_function = "throwing_knives_impact_valid",
	is_aligned_offset = 0.25,
	legitimate_target_function = "legitimate_always",
	min_adjustment_speed = 15,
	on_impact_function = "throwing_knives_on_impact",
	on_target_acceleration = 0,
	skip_search_time = 0,
	speed_multiplier = 1,
	target_hit_zone = "head",
	target_tracking_update_function = "smite_update_towards_position",
	time_between_raycasts = 0.1,
	true_flight_shard_impact_behaviour = true,
	lerp_modifier_func = function (integration_data, distance)
		local d = 1.5

		return distance < d and 1 or d / distance
	end
}
true_flight_templates.drone = {
	on_target_acceleration = 0,
	speed_multiplier = 1,
	target_tracking_update_function = "drone_update_towards_position",
	time_between_raycasts = 0.1,
	trigger_time = 0,
	update_seeking_position_function = "drone_projectile_locomotion",
	lerp_modifier_func = function (integration_data, distance)
		local d = 1.5

		return distance < d and 1 or d / distance
	end
}

local function _force_ball_sweep_hit_dot_validation_func(hit_unit, attacker_unit, first_person_component, true_flight_template)
	local is_player_facing_towards_projectile = true
	local min_dot = true_flight_template.register_sweep_minimum_dot

	if min_dot then
		local attacker_head_pos = TrueFlightDefaults.get_unit_position(attacker_unit, "head")
		local force_ball_pos = Unit.world_position(hit_unit, 1)
		local player_to_projectile = Vector3.normalize(force_ball_pos - attacker_head_pos)
		local player_forward = Vector3.normalize(Quaternion.forward(first_person_component.rotation))

		is_player_facing_towards_projectile = min_dot < Vector3.dot(player_forward, player_to_projectile)
	end

	return is_player_facing_towards_projectile
end

true_flight_templates.magic_missile = {
	find_target_function = "wizard_forceball_target_lost",
	highest_speed = 8.4,
	impact_validate_function = "wizard_force_ball_impact_valid",
	initial_deceleration_duration = 1,
	lowest_speed = 4.2,
	register_sweep_hits = true,
	register_sweep_minimum_dot = 0.4,
	target_hit_zone = "head",
	target_tracking_update_function = "wizard_force_ball_update_towards_position",
	sweep_hit_dot_validation_func = _force_ball_sweep_hit_dot_validation_func
}

return settings("TrueFlightTemplates", true_flight_templates)
