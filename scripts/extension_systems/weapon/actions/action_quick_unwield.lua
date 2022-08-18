require("scripts/extension_systems/weapon/actions/action_unwield")

local ActionQuickUnwield = class("ActionQuickUnwield", "ActionUnwield")

ActionQuickUnwield._next_slot = function (self)
	local inventory_component = self._inventory_component
	local next_slot = inventory_component.quick_wield_slot

	return next_slot
end

return ActionQuickUnwield
