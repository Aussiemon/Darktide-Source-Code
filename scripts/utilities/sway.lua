-- chunkname: @scripts/utilities/sway.lua

local WeaponMovementState = require("scripts/extension_systems/weapon/utilities/weapon_movement_state")
local Sway = {}
local _sway_values

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

Sway.add_fixed_immediate_sway = function (sway_control_component, immediate_pitch, immediate_yaw)
	sway_control_component.immediate_pitch = immediate_pitch
	sway_control_component.immediate_yaw = immediate_yaw
end

Sway.apply_sway_rotation = function (sway_template, sway_component, movement_state_component, rotation)
	if not sway_template then
		return rotation
	end

	local yaw = sway_component.offset_x
	local pitch = sway_component.offset_y
	local sway_rotation = Quaternion.from_yaw_pitch_roll(yaw, pitch, 0)
	local combined_rotation = Quaternion.multiply(rotation, sway_rotation)

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
