local WeaponMovementState = require("scripts/extension_systems/weapon/utilities/weapon_movement_state")
local Sway = {}
local _sway_values = nil

Sway.add_immediate_sway = function (sway_template, sway_control_component, sway_component, movement_state_component, sway_type, optional_num_hits)
	if not sway_template then
		return
	end

	local weapon_movement_state = WeaponMovementState.translate_movement_state_component(movement_state_component)
	local movement_state_settings = sway_template[weapon_movement_state]
	local new_immediate_pitch, new_immediate_yaw = _sway_values(movement_state_settings, sway_control_component, sway_component, sway_type, optional_num_hits)
	sway_control_component.immediate_pitch = new_immediate_pitch
	sway_control_component.immediate_yaw = new_immediate_yaw
end

local degrees_to_radians = math.degrees_to_radians

Sway.apply_sway_rotation = function (sway_template, sway_component, movement_state_component, rotation)
	if not sway_template then
		return rotation
	end

	local weapon_movement_state = WeaponMovementState.translate_movement_state_component(movement_state_component)
	local sway_settings = sway_template[weapon_movement_state]
	local yaw_impact_mod = sway_settings.yaw_impact_mod or 1
	local offset_x = sway_component.offset_x
	local offset_y = sway_component.offset_y
	local max_sway = sway_settings.max_sway
	local max_pitch = degrees_to_radians(max_sway.pitch)
	local max_yaw = degrees_to_radians(max_sway.yaw)
	local x = offset_x * max_pitch
	local y = offset_y * max_yaw * yaw_impact_mod
	local offset = Vector3(x, y, 0)
	local roll = math.atan2(-x, y)
	local pitch = Vector3.length(offset) * sway_settings.sway_impact or 0
	local roll_rotation = Quaternion(Vector3.forward(), roll)
	local pitch_rotation = Quaternion(Vector3.right(), pitch)
	local combined_rotation = Quaternion.multiply(rotation, roll_rotation)
	combined_rotation = Quaternion.multiply(combined_rotation, pitch_rotation)

	return combined_rotation
end

Sway.movement_state_settings = function (sway_template, movement_state_component)
	if not sway_template then
		return nil
	end

	local weapon_movement_state = WeaponMovementState.translate_movement_state_component(movement_state_component)
	local movement_state_settings = sway_template[weapon_movement_state]

	return movement_state_settings
end

function _sway_values(movement_state_settings, sway_control_component, sway_component, sway_type, optional_num_hits)
	local current_immediate_pitch = sway_control_component.immediate_pitch
	local current_immediate_yaw = sway_control_component.immediate_yaw

	if movement_state_settings.immediate_sway[sway_type] then
		fassert(movement_state_settings.immediate_sway[sway_type], "Immediate sway type [%s] does not exist!", sway_type)

		local sway_type_settings = movement_state_settings.immediate_sway[sway_type]
		local sway_settings = sway_type_settings[math.min(optional_num_hits or 1, sway_type_settings.num_sway_values)]
		local added_pitch = sway_settings.pitch
		local added_yaw = sway_settings.yaw
		local wanted_pitch = current_immediate_pitch + added_pitch
		local wanted_yaw = current_immediate_yaw + added_yaw
		local cap = sway_settings.cap

		if cap then
			local projected_pitch = sway_component.pitch + wanted_pitch

			if added_pitch < projected_pitch then
				local overflow = projected_pitch - added_pitch
				local actual_added_pitch = math.max(added_pitch - overflow, 0)
				wanted_pitch = current_immediate_pitch + actual_added_pitch
			end

			local projected_yaw = sway_component.yaw + wanted_yaw

			if wanted_yaw < projected_yaw then
				local overflow = projected_yaw - added_yaw
				local actual_added_yaw = math.max(added_yaw - overflow, 0)
				wanted_yaw = current_immediate_yaw + actual_added_yaw
			end
		end

		return wanted_pitch, wanted_yaw
	else
		return current_immediate_pitch, current_immediate_yaw
	end
end

return Sway
