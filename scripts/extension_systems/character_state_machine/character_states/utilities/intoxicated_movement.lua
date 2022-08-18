local HALF_PI = math.pi * 0.5
local _start_stagger = nil
local IntoxicatedMovement = {
	update = function (intoxicated_movement_component, character_state_random_component, intoxication_level, dt, t, move_direction, move_speed)
		if t < intoxicated_movement_component.stagger_cooldown then
			return move_direction, move_speed
		end

		local seed = character_state_random_component.seed
		local in_stagger = intoxicated_movement_component.in_stagger

		if not in_stagger then
			in_stagger, seed = _start_stagger(move_direction, intoxicated_movement_component, intoxication_level, t, move_speed, seed)
		end

		if in_stagger then
			local stagger_start_t = intoxicated_movement_component.stagger_start_t
			local stagger_end_t = intoxicated_movement_component.stagger_end_t
			local stagger_duration = stagger_end_t - stagger_start_t
			local time_in_stagger = t - stagger_start_t
			local percentage = time_in_stagger / stagger_duration
			local stagger_direction = intoxicated_movement_component.stagger_direction
			local modified_direction = Vector3.lerp(move_direction, stagger_direction, percentage)
			move_direction = move_direction + modified_direction

			if Vector3.length_squared(move_direction) > 1 then
				move_direction = Vector3.normalize(move_direction)
			end

			if percentage < 0.5 then
				move_speed = math.lerp(move_speed, move_speed * 0.5, math.sin(percentage * 2 * HALF_PI))
			else
				move_speed = math.lerp(move_speed * 0.5, move_speed, math.sin(percentage * 2 * HALF_PI))
			end

			local last_frame_of_stagger = stagger_end_t < t + dt

			if last_frame_of_stagger then
				local random_value = nil
				seed, random_value = math.next_random(seed)
				local cooldown = t + random_value * 1 / intoxication_level
				intoxicated_movement_component.in_stagger = false
				intoxicated_movement_component.stagger_cooldown = cooldown
			end
		end

		character_state_random_component.seed = seed

		return move_direction, move_speed
	end,
	initialize_component = function (intoxicated_movement_component)
		intoxicated_movement_component.in_stagger = false
		intoxicated_movement_component.stagger_cooldown = 0
		intoxicated_movement_component.stagger_start_t = 0
		intoxicated_movement_component.stagger_end_t = 0
		intoxicated_movement_component.stagger_direction = Vector3.zero()
	end
}

function _start_stagger(movement_direction, intoxicated_movement_component, intoxication_level, t, move_speed, seed)
	local random_value_1 = nil
	seed, random_value_1 = math.next_random(seed)
	local moving = move_speed > 0
	local no_stagger_chance = 0.9 / intoxication_level
	local do_stagger = moving and no_stagger_chance < random_value_1

	if do_stagger then
		local velocity_direction = Vector3.normalize(movement_direction)
		local perpendicular_velocity_direction = Vector3.cross(velocity_direction, Vector3.up())
		local random_value_2, random_value_3, random_value_4 = nil
		seed, random_value_2 = math.next_random(seed)
		seed, random_value_3 = math.next_random(seed)
		seed, random_value_4 = math.next_random(seed)
		local duration = random_value_2 * 1.5 + random_value_3 * 0.5
		local direction = math.sin(t * HALF_PI) * math.sign(random_value_4 * 2 - 1) * perpendicular_velocity_direction
		intoxicated_movement_component.in_stagger = true
		intoxicated_movement_component.stagger_start_t = t
		intoxicated_movement_component.stagger_end_t = t + duration
		intoxicated_movement_component.stagger_direction = direction
	end

	return do_stagger, seed
end

return IntoxicatedMovement
