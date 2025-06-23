-- chunkname: @scripts/extension_systems/weapon/actions/action_overload_charge.lua

require("scripts/extension_systems/weapon/actions/action_charge")

local ActionModules = require("scripts/extension_systems/weapon/actions/modules/action_modules")
local ActionOverloadCharge = class("ActionOverloadCharge", "ActionCharge")

ActionOverloadCharge.init = function (self, action_context, action_params, action_settings)
	ActionOverloadCharge.super.init(self, action_context, action_params, action_settings)

	local overload_module_class_name = action_settings.overload_module_class_name

	self._overload_module = ActionModules[overload_module_class_name]:new(self._is_server, self._player_unit, action_settings, self._inventory_slot_component)
end

ActionOverloadCharge.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionOverloadCharge.super.start(self, action_settings, t, time_scale, action_start_params)
	self._overload_module:start(t)
end

ActionOverloadCharge.fixed_update = function (self, dt, t, time_in_action, frame)
	ActionOverloadCharge.super.fixed_update(self, dt, t, time_in_action, frame)
	self._overload_module:fixed_update(dt, t)
end

ActionOverloadCharge.finish = function (self, reason, data, t, time_in_action)
	ActionOverloadCharge.super.finish(self, reason, data, t, time_in_action)
	self._overload_module:finish(reason, data, t)
end

ActionOverloadCharge.running_action_state = function (self, t, time_in_action)
	if self._overload_module.running_action_state then
		return self._overload_module:running_action_state(t, time_in_action)
	end
end

return ActionOverloadCharge
