local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local ProjectileLocomotionUtility = require("scripts/extension_systems/locomotion/utilities/projectile_locomotion_utility")
local TrueFlightDefaults = require("scripts/extension_systems/locomotion/utilities/true_flight_functions/true_flight_defaults")
local TrueFlightFunctions = require("scripts/extension_systems/locomotion/utilities/true_flight_functions/true_flight_functions")
local projectile_impact_results = ProjectileLocomotionSettings.impact_results
local TrueFlightProjectileLocomotion = {}
local _function_defaults = {
	target_tracking_update_func = TrueFlightFunctions.default_update_towards_position,
	update_seeking_position_function = TrueFlightFunctions.default_update_position_velocity,
	find_target_func = TrueFlightFunctions.find_closest_highest_value_target,
	legitimate_target_func = TrueFlightFunctions.legitimate_always,
	iompact_validate = TrueFlightFunctions.hit_is_awlays_valid,
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

local function _update_towards_position(target_position, physics_world, integration_data, dt, t)
	local true_flight_template = integration_data.true_flight_template
	local update_seeking_position_function = _find_true_flight_function(true_flight_template, "target_tracking_update_func")
	local position, rotation = update_seeking_position_function(target_position, physics_world, integration_data, dt, t)

	return position, rotation
end

local function _update_towards_target_position(physics_world, integration_data, dt, t)
	local target_position = integration_data.target_position
	local position, rotation = _update_towards_position(target_position, physics_world, integration_data, dt, t)

	return position, rotation
end

local function _update_towards_target_unit(physics_world, integration_data, dt, t)
	local target_unit = integration_data.target_unit
	local target_hit_zone = integration_data.target_hit_zone

	if not target_hit_zone then
		local true_flight_template = integration_data.true_flight_template
		target_hit_zone = true_flight_template.target_hit_zone
		integration_data.target_hit_zone = target_hit_zone
	end

	local target_position = TrueFlightDefaults.get_unit_position(target_unit, target_hit_zone)
	local position, rotation = _update_towards_position(target_position, physics_world, integration_data, dt, t)

	return position, rotation
end

local function _update_position_while_seeking_target(physics_world, integration_data, dt, t)
	local true_flight_template = integration_data.true_flight_template
	local update_seeking_position_function = _find_true_flight_function(true_flight_template, "update_seeking_position_function")
	local position, rotation = update_seeking_position_function(physics_world, integration_data, dt, t)

	return position, rotation
end

local function _find_new_target(integration_data, position, dt, t)
	local true_flight_template = integration_data.true_flight_template

	if not integration_data.raycast_timer or integration_data.raycast_timer < t then
		local time_between_raycasts = true_flight_template.time_between_raycasts or 0.1
		integration_data.raycast_timer = t + time_between_raycasts

		local function is_valid_and_legitimate_target_func(integration_data, unit, position)
			local legitimate_target_func = _find_true_flight_function(true_flight_template, "legitimate_target_func")
			local true_flight_template = integration_data.true_flight_template
			local target_hit_zone = true_flight_template.target_hit_zone
			local target_position = TrueFlightDefaults.get_unit_position(unit, target_hit_zone)

			return _is_target_valid(unit) and legitimate_target_func(integration_data, unit, target_position, position)
		end

		local find_target_func = _find_true_flight_function(true_flight_template, "find_target_func")
		local target, target_hit_zone = find_target_func(integration_data, position, is_valid_and_legitimate_target_func)

		return target, target_hit_zone
	end
end

local function _update_seeking_target(physics_world, integration_data, dt, t)
	local new_position, new_rotation = _update_position_while_seeking_target(physics_world, integration_data, dt, t)

	return new_position, new_rotation
end

local function _check_collisions(physics_world, integration_data, previus_position, new_position, is_server, dt, t)
	local true_flight_template = integration_data.true_flight_template
	local radius = integration_data.radius
	local collision_types = integration_data.collision_types
	local collision_filter = integration_data.collision_filter
	local have_target = integration_data.target_unit ~= nil
	local have_target_collision_types_override = true_flight_template.have_target_collision_types_override

	if have_target and have_target_collision_types_override then
		collision_types = have_target_collision_types_override
	end

	local have_target_collision_filter_override = true_flight_template.have_target_collision_filter_override

	if have_target and have_target_collision_filter_override then
		collision_filter = have_target_collision_filter_override
	end

	local travel_vector = new_position - previus_position
	local travel_direction = Vector3.normalize(travel_vector)
	local travel_distance = Vector3.length(travel_vector)
	local pre_pare_pos = Vector3.lerp(previus_position, new_position, 0.5)
	local pre_pare_raddius = 0.5 * travel_distance + radius

	PhysicsProximitySystem.prepare_for_overlap(physics_world, pre_pare_pos, pre_pare_raddius)

	local hits = PhysicsWorld.linear_sphere_sweep(physics_world, previus_position, new_position, radius, 1, "types", collision_types, "collision_filter", collision_filter)

	if not integration_data.has_hit and hits and #hits > 0 then
		local hit = hits[1]
		hit.hit_direction = travel_direction
		local hit_actor = hit.actor
		local hit_unit = Actor.unit(hit_actor)
		local hit_position = hit.position
		local validate_func = _find_true_flight_function(true_flight_template, "impact_validate")
		local is_valid_true_flight = not validate_func or validate_func(hit_unit, integration_data)
		local is_valid_collision = is_valid_true_flight and ProjectileLocomotionUtility.check_collision(hit_unit, hit_position, integration_data)

		if is_valid_collision then
			integration_data.hits = hits
			integration_data.has_hit = true
			local on_impact_func = _find_true_flight_function(true_flight_template, "on_impact")
			local force_delete = false

			if on_impact_func then
				new_position, force_delete = on_impact_func(hit_unit, hit, integration_data, new_position, is_server, dt, t)
			end

			if integration_data.damage_extension then
				local current_speed = Vector3.length(integration_data.velocity)
				local impact_result = integration_data.damage_extension:on_impact(hit.position, hit_actor, hit.hit_direction, hit.hit_normal, current_speed, force_delete)

				if impact_result == projectile_impact_results.removed then
					integration_data.integrate = false
				end
			end
		else
			integration_data.has_hit = false
			integration_data.hits = nil

			return new_position
		end

		return hit.position
	else
		integration_data.has_hit = false
		integration_data.hits = nil
	end

	return new_position
end

TrueFlightProjectileLocomotion.integrate = function (physics_world, integration_data, dt, t, is_server)
	if not integration_data.integrate then
		return
	end

	local previus_position = integration_data.position
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

			if legitimate_target_func(integration_data, target_unit, check_position, previus_position) then
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

		if not legitimate_target_func(integration_data, nil, check_position, previus_position) then
			integration_data.target_position = nil
			target_position = nil
		end
	end

	integration_data.time_since_start = integration_data.time_since_start + dt

	if target_unit or target_position then
		integration_data.on_target_time = integration_data.on_target_time + dt
	else
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

	local new_position, new_rotation = nil

	if target_unit then
		new_position, new_rotation = _update_towards_target_unit(physics_world, integration_data, dt, t)
	elseif target_position then
		new_position, new_rotation = _update_towards_target_position(physics_world, integration_data, dt, t)
	else
		new_position, new_rotation = _update_seeking_target(physics_world, integration_data, dt, t)
	end

	new_position = _check_collisions(physics_world, integration_data, previus_position, new_position, is_server, dt, t)

	ProjectileLocomotionUtility.check_suppression(physics_world, integration_data, previus_position, new_position, is_server, dt, t)

	integration_data.position = new_position
	integration_data.rotation = new_rotation
	integration_data.previous_position = previus_position
end

return TrueFlightProjectileLocomotion
