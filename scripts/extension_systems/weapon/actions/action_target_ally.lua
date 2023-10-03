require("scripts/extension_systems/weapon/actions/action_base")

local ActionTargetAlly = class("ActionTargetAlly", "ActionBase")

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

ActionTargetAlly.finish = function (self, reason, data, t, time_in_action)
	ActionTargetAlly.super.finish(self, reason, data, t, time_in_action)

	local action_setting = self._action_settings

	if action_setting.clear_on_hold_release and reason == "hold_input_released" then
		self._action_module_targeting_component.target_unit_1 = nil
	end
end

ActionTargetAlly._find_target = function (self, time_in_action)
	local action_setting = self._action_settings
	local smart_targeting_data = self._smart_targeting_extension:targeting_data()
	local target_unit = smart_targeting_data.unit
	local action_module_targeting_component = self._action_module_targeting_component
	local validate_target_func = action_setting.validate_target_func
	local is_valid_target = target_unit and target_unit ~= self._player_unit and (not validate_target_func or validate_target_func(target_unit))
	local old_target = action_module_targeting_component.target_unit_1
	local has_target_anim_event = action_setting.has_target_anim_event
	local no_target_anim_event = action_setting.no_target_anim_event

	if is_valid_target then
		action_module_targeting_component.target_unit_1 = target_unit

		if old_target == nil and has_target_anim_event then
			self:trigger_anim_event(has_target_anim_event)
		end
	else
		action_module_targeting_component.target_unit_1 = nil

		if old_target ~= nil and no_target_anim_event then
			self:trigger_anim_event(no_target_anim_event)
		end
	end
end

return ActionTargetAlly
