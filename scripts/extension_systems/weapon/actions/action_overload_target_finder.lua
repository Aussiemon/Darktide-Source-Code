require("scripts/extension_systems/weapon/actions/action_target_finder")

local ActionModules = require("scripts/extension_systems/weapon/actions/modules/action_modules")
local ActionOverloadTargetFinder = class("ActionOverloadTargetFinder", "ActionTargetFinder")

ActionOverloadTargetFinder.init = function (self, action_context, action_params, action_settings)
	ActionOverloadTargetFinder.super.init(self, action_context, action_params, action_settings)

	local player_unit = self._player_unit
	local overload_module_class_name = action_settings.overload_module_class_name
	self._overload_module = ActionModules[overload_module_class_name]:new(player_unit, action_settings, self._inventory_slot_component)
end

ActionOverloadTargetFinder.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionOverloadTargetFinder.super.start(self, action_settings, t, time_scale, action_start_params)
	self._overload_module:start(t)
end

ActionOverloadTargetFinder.fixed_update = function (self, dt, t, time_in_action)
	ActionOverloadTargetFinder.super.fixed_update(self, dt, t, time_in_action)
	self._overload_module:fixed_update(dt, t)
end

ActionOverloadTargetFinder.finish = function (self, reason, data, t, time_in_action)
	ActionOverloadTargetFinder.super.finish(self, reason, data, t, time_in_action)
	self._overload_module:finish(reason, data, t)
end

return ActionOverloadTargetFinder
