local HubMovementLocomotion = {}
local _physics_move = nil

HubMovementLocomotion.update_movement = function (unit, dt, velocity_current, velocity_wanted, current_position, calculate_fall_velocity, player_character_constants, movement_settings, movement_settings_override, hub_active_stopping)
	local shared_movement_settings = movement_settings.shared
	local move_state_movement_settings = movement_settings.current_move_state
	local current_z = velocity_current.z
	velocity_current.z = 0
	local velocity_current_dir = Vector3.normalize(velocity_current)
	local velocity_wanted_dir = Vector3.normalize(velocity_wanted)
	local current_to_wanted_angle = Vector3.flat_angle(velocity_current_dir, velocity_wanted_dir)
	local is_stopping = Vector3.length_squared(velocity_wanted) == 0
	local is_moving = Vector3.length_squared(velocity_current) > 0
	local acc = (hub_active_stopping and ((movement_settings_override and movement_settings_override.active_deceleration) or move_state_movement_settings.active_deceleration)) or (is_stopping and ((movement_settings_override and movement_settings_override.deceleration) or move_state_movement_settings.deceleration)) or (movement_settings_override and movement_settings_override.acceleration) or move_state_movement_settings.acceleration
	local new_velocity = nil
	local velocity_diff = Vector3.flat(velocity_wanted - velocity_current)

	if is_moving and not is_stopping and not hub_active_stopping then
		local speed_target = move_state_movement_settings.move_speed
		local current_speed = Vector3.length(Vector3.flat(velocity_current))
		local speed_step = acc * dt
		local speed_inc_step = math.clamp(speed_target - current_speed, -speed_step, speed_step)
		local new_speed = current_speed + speed_inc_step
		local current_turn_rate = move_state_movement_settings.allowed_turning_angle_rad
		local turn_step = current_turn_rate * math.min(new_speed, speed_target) * dt
		local turn_amount = math.clamp(current_to_wanted_angle, -turn_step, turn_step)
		local turn_quat = Quaternion.axis_angle(Vector3.up(), turn_amount)
		local new_travel_dir = Quaternion.rotate(turn_quat, velocity_current_dir)
		new_velocity = new_travel_dir * new_speed
		new_velocity.z = velocity_current.z
	else
		local speed_target = move_state_movement_settings.move_speed
		local new_speed = math.min(acc * dt, speed_target)
		new_velocity = velocity_current + Vector3.normalize(velocity_diff) * new_speed
	end

	local dot = is_moving and Vector3.dot(velocity_current, velocity_diff)
	local terminate_velocity = is_moving and dot < 0 and Vector3.length_squared(new_velocity) < shared_movement_settings.stop_move_speed_threshold_sq

	if terminate_velocity then
		new_velocity = Vector3.zero()
	end

	new_velocity.z = current_z - player_character_constants.hub_gravity * dt
	local final_position, final_velocity = _physics_move(unit, current_position, new_velocity, dt)
	local projected_velocity = Vector3.lerp(new_velocity, final_velocity, dt * shared_movement_settings.velocity_wall_slide_lerp_speed)
	projected_velocity.z = final_velocity.z

	return final_position, projected_velocity
end

local MOVEMENT_SETTINGS = {
	shared = {},
	current_move_state = {}
}

HubMovementLocomotion.fetch_movement_settings = function (unit, player_character_constants, hub_jog_character_state_component)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local breed_name = unit_data_extension:breed_name()
	local hub_movement = player_character_constants.hub_movement
	local movement_settings = hub_movement.movement_settings
	local breed_movement_settings = movement_settings[breed_name]
	local move_state = hub_jog_character_state_component.move_state
	local move_state_movement_settings = breed_movement_settings.move_states[move_state]
	MOVEMENT_SETTINGS.shared = breed_movement_settings.shared
	MOVEMENT_SETTINGS.current_move_state = move_state_movement_settings

	return MOVEMENT_SETTINGS
end

function _physics_move(unit, input_position, input_velocity, dt)
	local delta = input_velocity * dt
	local mover = Unit.mover(unit)

	Mover.move(mover, delta, dt)

	local final_position = Mover.position(mover)
	local final_velocity = (final_position - input_position) / dt

	return final_position, final_velocity
end

return HubMovementLocomotion
