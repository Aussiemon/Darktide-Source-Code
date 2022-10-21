local StatFlags = require("scripts/settings/stats/stat_flags")
local StatDefinition = class("StatDefinition")

StatDefinition.init = function (self, triggers, storage_component, optional_flags)
	self._triggers = triggers
	self._storage_component = storage_component
	self._triggered_by = {}

	for stat_id, _ in pairs(self._triggers) do
		self._triggered_by[#self._triggered_by + 1] = stat_id
	end

	self._flags = {}
	optional_flags = optional_flags or {}

	for i = 1, #optional_flags do
		local flag_name = optional_flags[i]
		self._flags[flag_name] = true
	end
end

StatDefinition._save_and_return = function (self, stat_table, trigger_time, new_value, ...)
	if not trigger_time then
		return
	end

	self:_set_value(stat_table, new_value, ...)

	return trigger_time, new_value, ...
end

StatDefinition.trigger = function (self, stat_table, trigger_id, trigger_value, ...)
	local trigger = self._triggers[trigger_id]
	local our_current_value = self:get_value(stat_table, trigger:get_parameters(trigger_value, ...))
	local trigger_time, our_new_value = trigger:activate(stat_table, our_current_value, trigger_value, ...)

	return self:_save_and_return(stat_table, trigger_time, our_new_value, trigger:get_parameters(trigger_value, ...))
end

StatDefinition.check_flag = function (self, flag_name)
	return self._flags[flag_name] ~= nil
end

StatDefinition.get_triggers = function (self)
	return self._triggered_by
end

StatDefinition.get_id = function (self)
	return self._storage_component:get_id()
end

StatDefinition.get_parameters = function (self)
	return self._storage_component:get_parameters()
end

StatDefinition.get_value = function (self, stat_table, ...)
	return self._storage_component:get_value(stat_table, ...)
end

StatDefinition.get_raw = function (self, stat_table)
	return self._storage_component:get_raw(stat_table)
end

StatDefinition._set_value = function (self, stat_table, value, ...)
	return self._storage_component:set_value(stat_table, value, ...)
end

return StatDefinition
