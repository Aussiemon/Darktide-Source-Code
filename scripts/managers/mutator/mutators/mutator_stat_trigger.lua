-- chunkname: @scripts/managers/mutator/mutators/mutator_stat_trigger.lua

require("scripts/managers/mutator/mutators/mutator_base")

local MutatorStatTrigger = class("MutatorStatTrigger", "MutatorBase")
local DEFAULT_GLOBAL_STAT_CATEGORY = "lw-mb"

MutatorStatTrigger.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)
	MutatorStatTrigger.super.init(self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)

	self._team_stats = {}

	self:_setup_trigger_instances(self._team_stats, self._template.team_stats)

	self._global_stats_state = {}
	self._global_stats = {}

	self:_setup_trigger_instances(self._global_stats, self._template.global_stats)

	self._stat_callback = callback(self, "_cb_on_team_stat_change")
end

MutatorStatTrigger._setup_trigger_instances = function (self, destination, template)
	if not template then
		return
	end

	for key, stat in pairs(template) do
		local instanced_stat = table.clone(stat)

		for i = 1, #instanced_stat.triggers do
			local trigger_template = instanced_stat.triggers[i]
			local class = require(trigger_template.class)

			instanced_stat.triggers[i] = class:new(trigger_template.template)
		end

		destination[key] = instanced_stat
	end
end

MutatorStatTrigger.activate = function (self)
	MutatorStatTrigger.super.activate(self)

	if not self._is_server then
		return
	end

	self:_register_team_stats()
	self:_register_global_stats()
end

MutatorStatTrigger.deactivate = function (self)
	if not self._is_active then
		return
	end

	MutatorStatTrigger.super.deactivate(self)

	if not self._is_server then
		return
	end

	self:_unregister_team_stats()
	self:_unregister_global_stats()
end

MutatorStatTrigger._register_team_stats = function (self)
	if not self._team_stats then
		return
	end

	self._team_stat_listener_ids = {}

	local team_stat_names = {}

	for stat_name, stat_data in pairs(self._team_stats) do
		table.insert(team_stat_names, stat_name)
	end

	self._stat_listener_ids = {}

	table.insert(self._stat_listener_ids, Managers.stats:add_listener("TEAM", team_stat_names, self._stat_callback))
end

MutatorStatTrigger._unregister_team_stats = function (self)
	if not self._team_stat_listener_ids then
		return
	end

	for i = 1, #self._team_stat_listener_ids do
		Managers.stats:remove_listener(self._team_stat_listener_ids[i])
	end

	self._team_stat_listener_ids = nil
end

MutatorStatTrigger._register_global_stats = function (self)
	if not self._global_stats then
		return
	end

	for stat_name, stat_data in pairs(self._global_stats) do
		local category = stat_data.category or DEFAULT_GLOBAL_STAT_CATEGORY
		local state_key = stat_name .. category
		local previous_value = Managers.data_service.global_stats:subscribe(self, "_cb_on_global_stat_update", category, stat_name)

		self._global_stats_state[state_key] = previous_value
	end
end

MutatorStatTrigger._unregister_global_stats = function (self)
	if not self._global_stats then
		return
	end

	for stat_name, stat_data in pairs(self._global_stats) do
		local category = stat_data.category or DEFAULT_GLOBAL_STAT_CATEGORY
		local state_key = stat_name .. category

		self._global_stats_state[state_key] = nil

		Managers.data_service.global_stats:unsubscribe(self, stat_data.category or DEFAULT_GLOBAL_STAT_CATEGORY, stat_name)
	end
end

MutatorStatTrigger._cb_on_global_stat_update = function (self, stat_name, new_value)
	local stat_data = self._global_stats[stat_name]

	if not stat_data then
		return
	end

	local state_key = stat_name .. (stat_data.category or DEFAULT_GLOBAL_STAT_CATEGORY)
	local previous_value = self._global_stats_state[state_key] or 0

	self._global_stats_state[state_key] = new_value

	for i = 1, #stat_data.triggers do
		stat_data.triggers[i]:on_stat_change(self, new_value - previous_value, nil)
	end
end

MutatorStatTrigger._cb_on_team_stat_change = function (self, listener_id, stat_name, stat_delta, caused_by_player)
	local stat_data = self._team_stats[stat_name]

	if not stat_data then
		return
	end

	for i = 1, #stat_data.triggers do
		stat_data.triggers[i]:on_stat_change(self, stat_delta, caused_by_player)
	end
end

return MutatorStatTrigger
