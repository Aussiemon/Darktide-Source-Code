require("scripts/extension_systems/weapon/actions/action_ability_base")

local ActionTargetAlly = class("ActionTargetAlly", "ActionAbilityBase")

ActionTargetAlly.init = function (self, action_context, action_params, action_setting)
	ActionTargetAlly.super.init(self, action_context, action_params, action_setting)

	self._input_extension = action_context.input_extension
	self._aim_ready_up_time = action_setting.aim_ready_up_time or 0
	self._last_unit = nil
	local unit_data_extension = self._unit_data_extension
	self._action_module_targeting_component = unit_data_extension:write_component("action_module_targeting")
end

ActionTargetAlly.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionTargetAlly.super.start(self, action_settings, t, time_scale, action_start_params)

	self._action_module_targeting_component.target_unit_1 = nil
	self._action_module_targeting_component.target_unit_2 = nil
	self._action_module_targeting_component.target_unit_3 = nil
end

ActionTargetAlly.fixed_update = function (self, dt, t, time_in_action)
	if self._unit_data_extension.is_resimulating then
		return
	end

	self:_find_target(time_in_action)
end

ActionTargetAlly._find_target = function (self, time_in_action)
	local smart_targeting_data = self._smart_targeting_extension:targeting_data()
	local target_unit = smart_targeting_data.unit
	self._action_module_targeting_component.target_unit_1 = target_unit
end

return ActionTargetAlly
