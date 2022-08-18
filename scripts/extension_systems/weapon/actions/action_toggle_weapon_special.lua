require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ActionUtility = require("scripts/extension_systems/weapon/actions/utilities/action_utility")
local ActionToggleWeaponSpecial = class("ActionToggleWeaponSpecial", "ActionWeaponBase")

ActionToggleWeaponSpecial.init = function (self, action_context, action_params, action_settings)
	ActionToggleWeaponSpecial.super.init(self, action_context, action_params, action_settings)
end

ActionToggleWeaponSpecial.start = function (self, action_settings, t, ...)
	ActionToggleWeaponSpecial.super.start(self, action_settings, t, ...)
end

ActionToggleWeaponSpecial.fixed_update = function (self, dt, t, time_in_action)
	local action_settings = self._action_settings
	local activation_time = action_settings.activation_time
	local should_toggle = ActionUtility.is_within_trigger_time(time_in_action, dt, activation_time)

	if should_toggle then
		local was_active = self._inventory_slot_component.special_active
		local is_active = not was_active

		self:_set_weapon_special(is_active, t)
	end
end

ActionToggleWeaponSpecial.finish = function (self, reason, data, t, time_in_action)
	ActionToggleWeaponSpecial.super.finish(self, reason, data, t, time_in_action)
end

return ActionToggleWeaponSpecial
