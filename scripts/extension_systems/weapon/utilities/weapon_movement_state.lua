local WeaponMovementStateSettings = require("scripts/settings/equipment/weapon_movement_state_settings")
local weapon_movement_states = WeaponMovementStateSettings.weapon_movement_states
local WeaponMovementState = {
	translate_movement_state_component = function (movement_state_component)
		local method = movement_state_component.method
		local is_crouching = movement_state_component.is_crouching

		if is_crouching then
			if method == "ladder_idle" or method == "idle" then
				return weapon_movement_states.crouch_still
			else
				return weapon_movement_states.crouch_moving
			end
		elseif method == "ladder_idle" or method == "idle" then
			return weapon_movement_states.still
		else
			return weapon_movement_states.moving
		end
	end
}

return WeaponMovementState
