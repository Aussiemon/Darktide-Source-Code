-- chunkname: @scripts/extension_systems/weapon/utilities/weapon_movement_state.lua

local WeaponMovementStateSettings = require("scripts/settings/equipment/weapon_movement_state_settings")
local WEAPON_MOVEMENT_STATES = WeaponMovementStateSettings.weapon_movement_states
local EPSILON_SQUARED_MOVEMENT_SPEED = WeaponMovementStateSettings.epsilon_squared_movement_speed
local WeaponMovementState = {}

WeaponMovementState.translate_movement_state_component = function (movement_state_component, locomotion_component, inair_state_component)
	local is_crouching = movement_state_component.is_crouching
	local on_ground = inair_state_component.on_ground
	local velocity_current = locomotion_component.velocity_current

	if not on_ground then
		return WEAPON_MOVEMENT_STATES.moving
	end

	local moving = Vector3.length_squared(velocity_current) > EPSILON_SQUARED_MOVEMENT_SPEED

	if moving then
		return is_crouching and WEAPON_MOVEMENT_STATES.crouch_moving or WEAPON_MOVEMENT_STATES.moving
	end

	return is_crouching and WEAPON_MOVEMENT_STATES.crouch_still or WEAPON_MOVEMENT_STATES.still
end

return WeaponMovementState
