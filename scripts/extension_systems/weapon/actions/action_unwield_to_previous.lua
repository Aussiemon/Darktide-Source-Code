require("scripts/extension_systems/weapon/actions/action_unwield")

local ActionUnwieldToPrevious = class("ActionUnwieldToPrevious", "ActionUnwield")

ActionUnwieldToPrevious._next_slot = function (self)
	local action_settings = self._action_settings
	local inventory_component = self._inventory_component
	local unwield_to_weapon = action_settings.unwield_to_weapon

	if unwield_to_weapon then
		return inventory_component.previously_wielded_weapon_slot
	else
		return inventory_component.previously_wielded_slot
	end
end

return ActionUnwieldToPrevious
