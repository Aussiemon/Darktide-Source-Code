-- chunkname: @scripts/extension_systems/locomotion/utilities/true_flight_functions/true_flight_smite.lua

local ProjectileLocomotion = require("scripts/extension_systems/locomotion/utilities/projectile_locomotion")
local TrueFlightSmite = {}

local function _lerp_modifier_func_default(integration_data, distance)
	return distance < 2 and 1 or 2 / distance
end

local function _lerp_modifier_func(true_flight_template)
	local template_func = true_flight_template and true_flight_template.lerp_modifier_func

	return template_func or _lerp_modifier_func_default
end

TrueFlightSmite.smite_update_towards_position = function (target_position, physics_world, integration_data, dt, t, optional_validate_impact_func, optional_on_impact_func)
	local true_flight_template = integration_data.true_flight_template
	local time_without_bounce = integration_data.time_without_bounce
	local position = integration_data.position
	local velocity = integration_data.velocity
	local current_direction = Vector3.normalize(velocity)
	local current_rotation = Quaternion.look(current_direction)
	local speed = Vector3.length(velocity)
	local to_target = target_position - position
	local to_target_distance = Vector3.length(to_target)
	local wanted_direction = Vector3.normalize(to_target)
	local wanted_rotation = Quaternion.look(wanted_direction)
	local current_offset = math.abs(1 - Vector3.dot(current_direction, wanted_direction))
	local is_aligned_offset = true_flight_template.is_aligned_offset
	local current_is_aligned = current_offset < is_aligned_offset
	local lerp_modifier

	if current_is_aligned then
		local lerp_modifier_func = _lerp_modifier_func(true_flight_template)
		local lerp_modifier_1 = lerp_modifier_func(integration_data, to_target_distance)

		lerp_modifier = lerp_modifier_1 * lerp_modifier_1 * math.min(time_without_bounce * 0.5, 0.5)
	else
		local lerp_modifier_1 = math.min(time_without_bounce, 0.5)

		lerp_modifier = lerp_modifier_1 * lerp_modifier_1
	end

	local lerp_value = math.min(dt * lerp_modifier * 100, 1)
	local new_rotation = Quaternion.lerp(current_rotation, wanted_rotation, lerp_value)
	local new_direction = Quaternion.forward(new_rotation)
	local new_off = math.abs(1 - Vector3.dot(new_direction, wanted_direction))
	local is_aligned = new_off < is_aligned_offset
	local acceleration = is_aligned and true_flight_template.on_target_acceleration or 0
	local new_speed = speed + acceleration * dt
	local min_adjustment_speed = true_flight_template.min_adjustment_speed

	if min_adjustment_speed and not is_aligned then
		local diff = math.abs(Vector3.angle(new_direction, current_direction) / (math.pi * 2))

		new_speed = math.lerp(new_speed, min_adjustment_speed, (dt + diff) * 12)
	end

	local travel_distance = (speed + new_speed) * dt * 0.5
	local new_position = position + new_direction * travel_distance
	local new_velocity = new_direction * new_speed
	local collision_filter = integration_data.collision_filter
	local have_target = integration_data.target_unit ~= nil
	local have_target_collision_filter_override = true_flight_template.have_target_collision_filter_override

	if have_target and have_target_collision_filter_override then
		collision_filter = have_target_collision_filter_override
	end

	local skip_statics = integration_data.number_of_bounces >= 2
	local hit_units_this_frame

	new_position, new_velocity, hit_units_this_frame = ProjectileLocomotion.impact_detection_and_resolution(integration_data, new_position, new_velocity, physics_world, collision_filter, dt, false, skip_statics)

	for hit_unit, _ in pairs(hit_units_this_frame) do
		if integration_data.target_unit == hit_unit then
			integration_data.target_unit = nil
		end
	end

	integration_data.velocity = new_velocity
	new_rotation = Quaternion.look(velocity)

	return new_position, new_rotation
end

return TrueFlightSmite
