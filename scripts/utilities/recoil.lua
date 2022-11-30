local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeaponMovementState = require("scripts/extension_systems/weapon/utilities/weapon_movement_state")
local Recoil = {}
local _seeded_random_range, _dampen_target_to_max_angle = nil

Recoil.set_shooting = function (recoil_control_component, shooting)
	if shooting ~= recoil_control_component.shooting then
		recoil_control_component.shooting = shooting
	end
end

Recoil.first_person_offset = function (recoil_template, read_recoil_component, movement_state_component)
	local movement_state_settings = Recoil.recoil_movement_state_settings(recoil_template, movement_state_component)
	local first_person_offset_scalar = 1

	if movement_state_settings then
		first_person_offset_scalar = movement_state_settings.camera_recoil_percentage or 1
	end

	local pitch_offset = read_recoil_component.pitch_offset
	local yaw_offset = read_recoil_component.yaw_offset

	return pitch_offset * first_person_offset_scalar, yaw_offset * first_person_offset_scalar
end

Recoil.weapon_offset = function (recoil_template, read_recoil_component, movement_state_component)
	local movement_state_settings = Recoil.recoil_movement_state_settings(recoil_template, movement_state_component)
	local weapon_offset_scalar = 0

	if movement_state_settings then
		weapon_offset_scalar = 1 - (movement_state_settings.camera_recoil_percentage or 1)
	end

	local pitch_offset = read_recoil_component.pitch_offset
	local yaw_offset = read_recoil_component.yaw_offset

	return pitch_offset * weapon_offset_scalar, yaw_offset * weapon_offset_scalar
end

Recoil.recoil_movement_state_settings = function (recoil_template, movement_state_component)
	if not recoil_template then
		return
	end

	local weapon_movement_state = WeaponMovementState.translate_movement_state_component(movement_state_component)
	local movement_state_settings = recoil_template[weapon_movement_state]

	return movement_state_settings
end

local TEMP_PITCH_RANGE = Script.new_array(2)
local TEMP_YAW_RANGE = Script.new_array(2)

Recoil.add_recoil = function (t, recoil_template, read_recoil_component, recoil_control_component, movement_state_component, fp_rotation, unit)
	if not recoil_template then
		return
	end

	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local buff_keywords = BuffSettings.keywords
	local num_shots = recoil_control_component.num_shots + 1
	local seed = recoil_control_component.seed
	local weapon_movement_state = WeaponMovementState.translate_movement_state_component(movement_state_component)
	local random_pitch, random_yaw = nil
	local movement_state_settings = recoil_template[weapon_movement_state]
	local deterministic_recoil = buff_extension:has_keyword(buff_keywords.deterministic_recoil)
	local pitch_range, yaw_range = nil
	local offset_index = math.min(num_shots, movement_state_settings.num_offset_ranges)
	local offset_table = movement_state_settings.offset

	if offset_table then
		local offset = movement_state_settings.offset[offset_index]
		local offset_random_range = movement_state_settings.offset_random_range[offset_index]
		yaw_range = TEMP_YAW_RANGE
		pitch_range = TEMP_PITCH_RANGE
		local pitch_base = offset.pitch
		local pitch_mod = offset_random_range.pitch
		pitch_range[1] = pitch_base - pitch_mod
		pitch_range[2] = pitch_base + pitch_mod
		local yaw_base = offset.yaw
		local yaw_mod = offset_random_range.yaw
		yaw_range[1] = yaw_base - yaw_mod
		yaw_range[2] = yaw_base + yaw_mod
	else
		local offset_range = movement_state_settings.offset_range[offset_index]
		pitch_range = offset_range.pitch
		yaw_range = offset_range.yaw
	end

	if deterministic_recoil then
		random_pitch = math.lerp(pitch_range[1], pitch_range[2], 0.5)
		random_yaw = math.lerp(yaw_range[1], yaw_range[2], 0.5)
	else
		seed, random_pitch = _seeded_random_range(seed, pitch_range[1], pitch_range[2])
		seed, random_yaw = _seeded_random_range(seed, yaw_range[1], yaw_range[2])
	end

	if not recoil_control_component.recoiling then
		recoil_control_component.starting_rotation = fp_rotation
		recoil_control_component.recoiling = true
	end

	local current_pitch = read_recoil_component.pitch_offset
	local current_yaw = read_recoil_component.yaw_offset
	local offset_limit = movement_state_settings.offset_limit
	local pitch_limit = offset_limit.pitch
	local yaw_limit = offset_limit.yaw
	local base_target_pitch = current_pitch + _dampen_target_to_max_angle(current_pitch, random_pitch, pitch_limit)
	local base_target_yaw = current_yaw + _dampen_target_to_max_angle(current_yaw, random_yaw, yaw_limit)
	recoil_control_component.target_pitch = base_target_pitch
	recoil_control_component.target_yaw = base_target_yaw
	recoil_control_component.rise_end_time = t + movement_state_settings.rise_duration
	recoil_control_component.num_shots = num_shots
	recoil_control_component.seed = seed
end

function _seeded_random_range(seed, min, max)
	local new_seed, seeded_random = math.next_random(seed)
	local result = min + seeded_random * (max - min)

	return new_seed, result
end

function _dampen_target_to_max_angle(current_angle, added_angle, angle_limit)
	if angle_limit == 0 then
		return 0
	end

	local to_max = angle_limit - math.abs(current_angle)
	local damping = math.max(0.01, to_max / angle_limit)

	return added_angle * damping * damping
end

Recoil.aim_assist_multiplier = function (recoil_template, recoil_control_component, recoil_component, movement_state_component)
	if not recoil_template then
		return 1
	end

	local weapon_movement_state = WeaponMovementState.translate_movement_state_component(movement_state_component)
	local aim_assist_settings = recoil_template[weapon_movement_state].aim_assist

	if not aim_assist_settings then
		return 1
	end

	return aim_assist_settings:multiplier_function(recoil_control_component, recoil_component)
end

Recoil.apply_weapon_recoil_rotation = function (recoil_template, recoil_component, movement_state_component, current_rotation)
	local pitch_offset, yaw_offset = Recoil.weapon_offset(recoil_template, recoil_component, movement_state_component)
	local pitch_rotation = Quaternion(Vector3.right(), pitch_offset)
	local yaw_rotation = Quaternion(Vector3.up(), yaw_offset)
	local combined_offset = Quaternion.multiply(yaw_rotation, pitch_rotation)
	local combined_rotation = Quaternion.multiply(current_rotation, combined_offset)

	return combined_rotation
end

return Recoil
