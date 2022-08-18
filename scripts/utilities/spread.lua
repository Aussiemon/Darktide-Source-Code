local WeaponMovementState = require("scripts/extension_systems/weapon/utilities/weapon_movement_state")
local Spread = {}
local _spread_values = nil

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
		fassert(movement_state_settings.immediate_spread[spread_type], "Immediate spread type [%s] does not exist!", spread_type)

		local spread_type_settings = movement_state_settings.immediate_spread[spread_type]
		local spread_settings = spread_type_settings[math.min(num_shots or 1, spread_type_settings.num_spreads)]
		local added_pitch = spread_settings.pitch
		local added_yaw = spread_settings.yaw

		return current_immediate_pitch + added_pitch, current_immediate_yaw + added_yaw
	else
		return current_immediate_pitch, current_immediate_yaw
	end
end

return Spread
