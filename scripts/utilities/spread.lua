local WeaponMovementState = require("scripts/extension_systems/weapon/utilities/weapon_movement_state")
local Spread = {}
local _spread_values = nil
local PI_2 = math.pi * 2

Spread.add_immediate_spread = function (t, spread_template, spread_control_component, movement_state_component, spread_type, optional_num_hits)
	if not spread_template then
		return
	end

	local weapon_movement_state = WeaponMovementState.translate_movement_state_component(movement_state_component)
	local movement_state_settings = spread_template[weapon_movement_state]
	local new_immediate_pitch, new_immediate_yaw = _spread_values(movement_state_settings, spread_control_component, spread_type, optional_num_hits)
	spread_control_component.immediate_pitch = new_immediate_pitch
	spread_control_component.immediate_yaw = new_immediate_yaw
end

Spread.add_immediate_spread_from_shooting = function (t, spread_template, spread_control_component, movement_state_component, shooting_status_component, spread_type)
	if not spread_template then
		return
	end

	local weapon_movement_state = WeaponMovementState.translate_movement_state_component(movement_state_component)
	local movement_state_settings = spread_template[weapon_movement_state]
	local num_shots = shooting_status_component.num_shots
	local new_immediate_pitch, new_immediate_yaw = _spread_values(movement_state_settings, spread_control_component, spread_type, num_shots)
	spread_control_component.immediate_pitch = new_immediate_pitch
	spread_control_component.immediate_yaw = new_immediate_yaw
end

function _spread_values(movement_state_settings, spread_control_component, spread_type, num_shots)
	local current_immediate_pitch = spread_control_component.immediate_pitch
	local current_immediate_yaw = spread_control_component.immediate_yaw

	if movement_state_settings.immediate_spread[spread_type] then
		local spread_type_settings = movement_state_settings.immediate_spread[spread_type]
		local num_spreads = spread_type_settings.num_spreads
		local spread_index = math.min(num_shots or 1, num_spreads)
		local spread_settings = spread_type_settings[spread_index]
		local added_pitch = spread_settings.pitch
		local added_yaw = spread_settings.yaw

		return current_immediate_pitch + added_pitch, current_immediate_yaw + added_yaw
	else
		return current_immediate_pitch, current_immediate_yaw
	end
end

local function _combine_spread_rotations(roll, pitch, current_rotation)
	local roll_rotation = Quaternion(Vector3.forward(), roll)
	local pitch_rotation = Quaternion(Vector3.right(), pitch)
	local combined_rotation = Quaternion.multiply(current_rotation, roll_rotation)
	combined_rotation = Quaternion.multiply(combined_rotation, pitch_rotation)

	return combined_rotation
end

local function _max_pitch_rotation(roll_rotation, pitch, yaw)
	local x = yaw * math.cos(roll_rotation)
	local y = pitch * math.sin(roll_rotation)
	local length = Vector3.length(Vector3(x, y, 0))

	if length == 0 then
		return 0
	end

	local max_pitch_rotation = pitch * yaw / length

	return math.degrees_to_radians(max_pitch_rotation)
end

Spread.target_style_spread = function (current_rotation, num_shots_fired, num_shots_in_attack, num_spread_circles, bullseye, spread_pitch, spread_yaw, scatter_range, no_random, roll_offset, seed)
	if bullseye and num_shots_fired == 1 then
		return current_rotation, seed
	end

	local random_value = nil
	local current_shot = bullseye and num_shots_fired - 1 or num_shots_fired
	local max_shots = bullseye and num_shots_in_attack - 1 or num_shots_in_attack
	local shot_roll_current_angle = num_spread_circles * current_shot / max_shots
	local shot_roll_spread_modifier = num_spread_circles / max_shots
	seed, random_value = math.next_random(seed)
	local random_roll = nil

	if scatter_range then
		random_roll = 1 - scatter_range + scatter_range * random_value * 2
	elseif no_random then
		random_roll = 1
	else
		random_roll = 0.9 + 0.2 * random_value
	end

	local roll = (roll_offset or 0) + random_roll * shot_roll_spread_modifier * 2 + shot_roll_current_angle - shot_roll_spread_modifier
	local rolled_rotation = roll * PI_2
	local max_pitch_rotation = _max_pitch_rotation(rolled_rotation, spread_pitch, spread_yaw)
	local shots_per_layer = max_shots / num_spread_circles
	local current_layer_of_shot = math.ceil(current_shot / shots_per_layer)
	seed, random_value = math.next_random(seed)
	local random_pitch_scale = math.sqrt(0.25 + 0.5 * random_value)

	if no_random then
		random_pitch_scale = 1
	end

	local pitch_rotation = random_pitch_scale * max_pitch_rotation * current_layer_of_shot / num_spread_circles
	local final_rotation = _combine_spread_rotations(rolled_rotation, pitch_rotation, current_rotation)

	return final_rotation, seed
end

Spread.uniform_circle = function (rotation, spread_angle, seed)
	spread_angle = math.degrees_to_radians(spread_angle)
	local random_value_1, random_value_2, random_value_3 = nil
	seed, random_value_1 = math.next_random(seed)
	seed, random_value_2 = math.next_random(seed)
	seed, random_value_3 = math.next_random(seed)
	local k = PI_2 * random_value_1
	local u = random_value_2 + random_value_3
	local r = u > 1 and 2 - u or u
	local pitch = math.cos(k) * r * spread_angle
	local yaw = math.sin(k) * r * spread_angle
	local spread = Quaternion.from_yaw_pitch_roll(yaw, pitch, 0)
	local spread_rotation = Quaternion.multiply(rotation, spread)

	return spread_rotation, seed
end

return Spread
