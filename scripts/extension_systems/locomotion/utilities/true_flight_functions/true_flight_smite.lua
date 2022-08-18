local ture_flight_smite = {}

local function _lerp_modifier_func_default(integration_data, distance)
	return distance < 2 and 1 or 2 / distance
end

local function _lerp_modifier_func(true_flight_template)
	local template_func = true_flight_template and true_flight_template.lerp_modifier_func

	return template_func or _lerp_modifier_func_default
end

ture_flight_smite.smite_update_towards_position = function (target_position, physics_world, integration_data, dt, t)
	local true_flight_template = integration_data.true_flight_template
	local on_target_time = integration_data.on_target_time
	local position = integration_data.position:unbox()
	local velocity = integration_data.velocity:unbox()
	local current_direction = Vector3.normalize(velocity)
	local current_rotation = Quaternion.look(current_direction)
	local speed = Vector3.length(velocity)
	local to_target = target_position - position
	local to_target_distance = Vector3.length(to_target)
	local wanted_direction = Vector3.normalize(to_target)
	local wanted_rotation = Quaternion.look(wanted_direction)
	local _lerp_modifier_func = _lerp_modifier_func(true_flight_template)
	local lerp_modifier_1 = _lerp_modifier_func(integration_data, to_target_distance)
	local lerp_modifier = lerp_modifier_1 * lerp_modifier_1 * math.min(on_target_time, 0.25) / 0.25
	local lerp_value = math.min(dt * lerp_modifier * 100, 0.75)
	local new_rotation = Quaternion.lerp(current_rotation, wanted_rotation, lerp_value)
	local new_direction = Quaternion.forward(new_rotation)
	local new_off = math.abs(1 - Vector3.dot(new_direction, wanted_direction))
	local is_alligned_offset = true_flight_template.is_alligned_offset
	local is_aligned = new_off < is_alligned_offset
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

	integration_data.velocity:store(new_velocity)

	local new_rotation = Quaternion.look(velocity)

	return new_position, new_rotation
end

return ture_flight_smite
