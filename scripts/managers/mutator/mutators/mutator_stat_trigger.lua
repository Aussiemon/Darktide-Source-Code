-- chunkname: @scripts/managers/mutator/mutators/mutator_stat_trigger.lua

require("scripts/managers/mutator/mutators/mutator_base")

local MutatorStatTrigger = class("MutatorStatTrigger", "MutatorBase")

MutatorStatTrigger.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)
	MutatorStatTrigger.super.init(self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)

	self._stats = self._template.stats
end

MutatorStatTrigger.activate = function (self)
	MutatorStatTrigger.super.activate(self)

	if not self._is_server then
		return
	end

	local stat_names_per_key = {
		TEAM = {},
	}

	for stat_name, stat_data in pairs(self._stats) do
		if not stat_names_per_key[stat_data.key] then
			stat_names_per_key[stat_data.key] = {}
		end

		table.insert(stat_names_per_key[stat_data.key], stat_name)
	end

	self._stat_listener_ids = {}

	local callback_fn = callback(self, "_cb_on_stat_change")

	for key, stat_names in pairs(stat_names_per_key) do
		table.insert(self._stat_listener_ids, Managers.stats:add_listener(key, stat_names, callback_fn))
	end
end

MutatorStatTrigger.deactivate = function (self)
	if not self._is_active then
		return
	end

	MutatorStatTrigger.super.deactivate(self)

	for stat_name, stat_data in pairs(self._stats) do
		if stat_data.listener_id then
			Managers.stats:remove_listener(stat_data.listener_id)
		end
	end
end

MutatorStatTrigger._cb_on_stat_change = function (self, listener_id, stat_name, stat_delta, caused_by_player)
	local stat_data = self._stats[stat_name]

	if not stat_data then
		return
	end

	for i = 1, #stat_data.triggers do
		stat_data.triggers[i]:on_stat_change(self, stat_delta, caused_by_player)
	end
end

return MutatorStatTrigger
