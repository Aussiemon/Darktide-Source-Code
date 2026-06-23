-- chunkname: @scripts/extension_systems/ability/actions/action_servo_skull_order_target_finder.lua

require("scripts/extension_systems/ability/actions/action_ability_target_finder")

local ActionServoSkullOrderTargetFinder = class("ActionServoSkullOrderTargetFinder", "ActionAbilityTargetFinder")
local GRENADE_ABILITY_SLOT = "slot_grenade_ability"

ActionServoSkullOrderTargetFinder.init = function (self, action_context, action_params, action_settings)
	ActionServoSkullOrderTargetFinder.super.init(self, action_context, action_params, action_settings)
end

ActionServoSkullOrderTargetFinder.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionServoSkullOrderTargetFinder.super.start(self, action_settings, t, time_scale, action_start_params)

	local wielded_slot = self._inventory_component.wielded_slot

	self._has_wielded_grenade_slot = wielded_slot == GRENADE_ABILITY_SLOT
end

ActionServoSkullOrderTargetFinder.fixed_update = function (self, dt, t, time_in_action)
	ActionServoSkullOrderTargetFinder.super.fixed_update(self, dt, t, time_in_action)

	local wielded_slot = self._inventory_component.wielded_slot

	if not self._has_wielded_grenade_slot and wielded_slot == GRENADE_ABILITY_SLOT then
		self._has_wielded_grenade_slot = true
	elseif self._has_wielded_grenade_slot and wielded_slot ~= "slot_grenade_ability" then
		return true
	end
end

ActionServoSkullOrderTargetFinder.finish = function (self, reason, data, t, time_in_action)
	ActionServoSkullOrderTargetFinder.super.finish(self, reason, data, t, time_in_action)
end

return ActionServoSkullOrderTargetFinder
