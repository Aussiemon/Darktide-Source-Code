-- chunkname: @scripts/extension_systems/weapon/actions/action_timed_trigger.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local TimedTriggerActionTemplates = require("scripts/settings/action/timed_trigger_action_templates")
local ActionTimedTrigger = class("ActionTimedTrigger", "ActionWeaponBase")

ActionTimedTrigger.init = function (self, action_context, action_params, action_settings)
	ActionTimedTrigger.super.init(self, action_context, action_params, action_settings)

	self._active_timed_templates = {}
end

ActionTimedTrigger.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionTimedTrigger.super.start(self, action_settings, t, time_scale, action_start_params)
	table.clear(self._active_timed_templates)

	local timed_templates = action_settings.timed_templates

	if timed_templates then
		for i = 1, #timed_templates do
			local action_data = timed_templates[i]
			local template_name = action_data.timed_trigger_template_name

			self._active_timed_templates[i] = {
				template_name = template_name,
				action_trigger_time = action_data.trigger_time or nil,
			}
		end

		table.append(self._active_timed_templates, timed_templates)
	end

	local anim_event = action_settings.anim_event
	local anim_event_3p = action_settings.anim_event_3p

	if anim_event then
		self:trigger_anim_event(anim_event, anim_event_3p)
	end
end

ActionTimedTrigger.fixed_update = function (self, dt, t, time_in_action)
	ActionTimedTrigger.super.fixed_update(self, dt, t, time_in_action)
	self:_update_timed_templates(time_in_action)
end

ActionTimedTrigger._update_timed_templates = function (self, time_in_action)
	local timed_template_datas = self._active_timed_templates
	local i = 1
	local num_active_timed_templates = #timed_template_datas

	while i < num_active_timed_templates do
		local timed_template_data = timed_template_datas[i]
		local timed_template = TimedTriggerActionTemplates[timed_template_data.template_name]
		local trigger_time = timed_template_data.action_trigger_time or timed_template.trigger_time

		if trigger_time < time_in_action then
			timed_template.trigger_function(self._is_server)

			if timed_template.execution_type == "trigger" then
				table.remove(timed_template_datas, i)

				i = i - 1
				num_active_timed_templates = num_active_timed_templates - 1
			end
		end

		i = i + 1
	end
end

ActionTimedTrigger.finish = function (self, reason, data, t, time_in_action)
	ActionTimedTrigger.super.finish(self, reason, data, t, time_in_action)

	local action_settings = self._action_settings
	local inventory_slot_component = self._inventory_slot_component

	if action_settings.remove_item_from_inventory then
		inventory_slot_component.unequip_slot = true
	else
		inventory_slot_component.unwield_slot = true
	end
end

return ActionTimedTrigger
