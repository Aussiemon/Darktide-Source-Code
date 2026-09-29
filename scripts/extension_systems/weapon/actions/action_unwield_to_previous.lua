-- chunkname: @scripts/extension_systems/weapon/actions/action_unwield_to_previous.lua

require("scripts/extension_systems/weapon/actions/action_unwield")

local ActionUnwieldToPrevious = class("ActionUnwieldToPrevious", "ActionUnwield")

ActionUnwieldToPrevious._next_slot = function (self)
	local inventory_component = self._inventory_component

	return inventory_component.previously_wielded_weapon_slot
end

return ActionUnwieldToPrevious
