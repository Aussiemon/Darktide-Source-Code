local ProjectileLocomotionUtility = require("scripts/extension_systems/locomotion/utilities/projectile_locomotion_utility")
local TrueFlightDefaults = require("scripts/extension_systems/locomotion/utilities/true_flight_functions/true_flight_defaults")
local TrueFlightFunctions = require("scripts/extension_systems/locomotion/utilities/true_flight_functions/true_flight_functions")
local TrueFlightProjectileLocomotion = {}
local _function_defaults = {
	target_tracking_update_func = TrueFlightFunctions.default_update_towards_position,
	update_seeking_position_function = TrueFlightFunctions.default_update_position_velocity,
	find_target_func = TrueFlightFunctions.find_closest_highest_value_target,
	legitimate_target_func = TrueFlightFunctions.legitimate_always,
	impact_validate = TrueFlightFunctions.hit_is_awlays_valid,
	on_impact = TrueFlightFunctions.on_hit_do_nothing,
	retry_target = TrueFlightFunctions.retry_if_no_target
}

local function _find_true_flight_function(true_flight_template, function_name)
	local template_value = true_flight_template[function_name]
	local template_type = type(template_value)

	if template_type == "string" then
		local func = TrueFlightFunctions[template_value]

		return func
	elseif template_type == "function" then
		return template_value
	end

	local default = _function_defaults[function_name]

	return default
end

local function _is_target_valid(target_unit)
	return HEALTH_ALIVE[target_unit]
end

local function _update_towards_position(target_position, physics_world, integration_data, dt, t, validate_impact_func, on_impact_func)
	local true_flight_template = integration_data.true_flight_template
	local update_seeking_position_function = _find_true_flight_function(true_flight_template, "target_tracking_update_func")
	local position, rotation = update_seeking_position_function(target_position, physics_world, integration_data, dt, t, validate_impact_func, on_impact_func)

	return position, rotation
end

local function _update_position_while_seeking_target(physics_world, integration_data, dt, t, validate_impact_func, on_impact_func)
	local true_flight_template = integration_data.true_flight_template
	local update_seeking_position_function = _find_true_flight_function(true_flight_template, "update_seeking_position_function")
	local position, rotation = update_seeking_position_function(physics_world, integration_data, dt, t, validate_impact_func, on_impact_func)

	return position, rotation
end

local function _find_new_target(integration_data, position, dt, t)
	local true_flight_template = integration_data.true_flight_template

	if not integration_data.raycast_timer or integration_data.raycast_timer < t then
		local time_between_raycasts = true_flight_template.time_between_raycasts or 0.1
		integration_data.raycast_timer = t + time_between_raycasts

		local function is_valid_and_legitimate_target_func(integration_data, unit, position)
			local legitimate_target_func = _find_true_flight_function(true_flight_template, "legitimate_target_func")
			local target_hit_zone = true_flight_template.target_hit_zone
			local target_position = TrueFlightDefaults.get_unit_position(unit, target_hit_zone)

			return _is_target_valid(unit) and legitimate_target_func(integration_data, unit, target_position, position)
		end

		local find_target_func = _find_true_flight_function(true_flight_template, "find_target_func")
		local target, target_hit_zone = find_target_func(integration_data, position, is_valid_and_legitimate_target_func)

		return target, target_hit_zone
	end
end

TrueFlightProjectileLocomotion.integrate = function (physics_world, integration_data, dt, t, is_server)
	if not integration_data.integrate then
		return
	end

	local previous_position = integration_data.position
	local target_unit = integration_data.target_unit
	local target_position = integration_data.target_position
	local true_flight_template = integration_data.true_flight_template
	local legitimate_target_func = _find_true_flight_function(true_flight_template, "legitimate_target_func")

	if target_unit then
		local target_hit_zone = integration_data.target_hit_zone

		if not target_hit_zone then
			target_hit_zone = true_flight_template.target_hit_zone
			integration_data.target_hit_zone = target_hit_zone
		end

		local is_target_valid = false

		if _is_target_valid(target_unit) then
			local check_position = TrueFlightDefaults.get_unit_position(target_unit, target_hit_zone)

			if legitimate_target_func(integration_data, target_unit, check_position, previous_position) then
				is_target_valid = true
			end
		end

		if not is_target_valid then
			integration_data.target_unit = nil
			target_unit = nil
		end
	end

	if target_position then
		local check_position = target_position

		if not legitimate_target_func(integration_data, nil, check_position, previous_position) then
			integration_data.target_position = nil
			target_position = nil
		end
	end

	integration_data.time_since_start = integration_data.time_since_start + dt

	if target_unit or target_position then
		integration_data.on_target_time = integration_data.on_target_time + dt
		integration_data.time_without_target = 0
	else
		integration_data.time_without_target = integration_data.time_without_target + dt
		integration_data.on_target_time = 0
	end

	local retry_target_func = _find_true_flight_function(integration_data.true_flight_template, "retry_target")
	local retry_target = retry_target_func(integration_data)
	local is_seeking = is_server and retry_target

	if is_seeking then
		local new_target, new_target_hit_zone = nil

		if is_seeking then
			new_target, new_target_hit_zone = _find_new_target(integration_data, integration_data.position, dt, t)
		end

		if new_target then
			target_unit = new_target
			integration_data.target_unit = new_target
			integration_data.target_hit_zone = new_target_hit_zone
		end
	end

	local validate_impact_func = _find_true_flight_function(true_flight_template, "impact_validate")
	local on_impact_func = _find_true_flight_function(true_flight_template, "on_impact")
	local actual_target_position, debug_info = nil

	if target_unit then
		local target_hit_zone = integration_data.target_hit_zone

		if not target_hit_zone then
			target_hit_zone = true_flight_template.target_hit_zone
			integration_data.target_hit_zone = target_hit_zone
		end

		actual_target_position, debug_info = TrueFlightDefaults.get_unit_position(target_unit, target_hit_zone)
	elseif target_position then
		actual_target_position = target_position
	end

	local new_position, new_rotation = nil

	if actual_target_position then
		new_position, new_rotation = _update_towards_position(actual_target_position, physics_world, integration_data, dt, t, validate_impact_func, on_impact_func)
	else
		new_position, new_rotation = _update_position_while_seeking_target(physics_world, integration_data, dt, t, validate_impact_func, on_impact_func)
	end

	if integration_data.bounced_this_frame then
		integration_data.time_without_bounce = 0
	else
		integration_data.time_without_bounce = integration_data.time_without_bounce + dt
	end

	ProjectileLocomotionUtility.check_suppression(physics_world, integration_data, previous_position, new_position, is_server, dt, t)

	integration_data.position = new_position
	integration_data.rotation = new_rotation
	integration_data.previous_position = previous_position
end

return TrueFlightProjectileLocomotion
