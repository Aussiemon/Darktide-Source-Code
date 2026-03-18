-- chunkname: @scripts/utilities/oscillation/movement_oscillation.lua

local MovementOscillation = {}

MovementOscillation.apply_Z_oscillation_movement = function (t, target_position, randomize_movement)
	local base = math.sin(t * randomize_movement.base_freq * 2 * math.pi + randomize_movement.phase) * randomize_movement.base_amp
	local noise = MovementOscillation._smooth_noise(t * randomize_movement.noise_freq, randomize_movement.seed) * randomize_movement.noise_amp
	local micro = math.sin(t * 1.2 + randomize_movement.seed) * 0.003
	local offset_z = base + noise + micro

	return Vector3(target_position.x, target_position.y, target_position.z + offset_z)
end

MovementOscillation.apply_XY_oscillation_movement = function (t, target_position, right_vector, randomize_movement)
	local base = math.sin(t * randomize_movement.base_freq * 2 * math.pi + randomize_movement.phase) * randomize_movement.base_amp
	local noise = MovementOscillation._smooth_noise(t * randomize_movement.noise_freq, randomize_movement.seed) * randomize_movement.noise_amp
	local micro = math.sin(t * 1.2 + randomize_movement.seed) * 0.003
	local offset_amount = base + noise + micro
	local offset = right_vector * offset_amount

	return target_position + offset
end

MovementOscillation._smooth_noise = function (t, seed)
	return math.sin(t * 1.7 + seed) * 0.5 + math.sin(t * 0.73 + seed * 2.1) * 0.5
end

return MovementOscillation
