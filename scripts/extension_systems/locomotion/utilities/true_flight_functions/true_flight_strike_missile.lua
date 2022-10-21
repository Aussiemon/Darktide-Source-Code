local true_flight_strike_missile = {}

local function _lerp_modifier_func_default(integration_data, distance, height_over_target)
	return distance < 5 and 1 or 5 / distance
end

local function _lerp_modifier_func(true_flight_template)
	local template_func = true_flight_template and true_flight_template.lerp_modifier_func

	return template_func or _lerp_modifier_func_default
end

true_flight_strike_missile.update_towards_strike_missile_target = function (target_position, integration_data, dt, t)
	local position = integration_data.position
	local velocity = integration_data.velocity
	local current_direction = Vector3.normalize(velocity)
	local speed = Vector3.length(velocity)
	local true_flight_template = integration_data.true_flight_template
	local speed_multiplier = true_flight_template.speed_multiplier
	local required_velocity = target_position - position
	local dist_to_target = Vector3.length(required_velocity)
	local wanted_direction = Vector3.normalize(required_velocity)
	local dot_threshold = true_flight_template.dot_threshold

	if integration_data.missile_triggered then
		if integration_data.missile_striking then
			local speed_mod = true_flight_template.triggered_speed_mult
			local new_velocity = current_direction * speed * speed_multiplier
			integration_data.velocity = new_velocity
			local new_position = position + new_velocity * speed_mod * dt

			return new_position
		else
			if integration_data.missile_lingering < t then
				integration_data.missile_striking = true
			end

			local speed_mod = 0.1
			local new_position = position + current_direction * speed * speed_multiplier * speed_mod * dt

			return new_position
		end
	elseif dot_threshold < Vector3.dot(current_direction, wanted_direction) or integration_data.on_target_time > 2 then
		integration_data.missile_triggered = true
		integration_data.missile_lingering = t + true_flight_template.lingering_duration
	end

	local current_rotation = Quaternion.look(current_direction)
	local wanted_rotation = Quaternion.look(wanted_direction)
	speed = (speed - 5 * dt) * speed_multiplier
	speed = math.max(speed, 0.1)
	local lerp_func = _lerp_modifier_func(true_flight_template)
	local lerp_modifier = lerp_func(integration_data, dist_to_target)
	local lerp_value = math.min(dt * lerp_modifier * 100, 0.75)
	local new_rotation = Quaternion.lerp(current_rotation, wanted_rotation, lerp_value)
	local new_direction = Quaternion.forward(new_rotation)
	local new_velocity = new_direction * speed
	local new_position = position + new_velocity * dt
	integration_data.velocity = new_velocity

	return new_position
end

return true_flight_strike_missile
