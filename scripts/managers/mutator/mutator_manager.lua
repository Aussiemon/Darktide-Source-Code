-- chunkname: @scripts/managers/mutator/mutator_manager.lua

local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local MutatorTemplates = require("scripts/settings/mutator/mutator_templates")
local MutatorManager = class("MutatorManager")

MutatorManager.init = function (self, is_server, nav_world, network_event_delegate, circumstance_name, level_seed)
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._mutators = {}
	self._nav_world = nav_world
	self._level_seed = level_seed

	self:_load_mutators(circumstance_name)

	if is_server then
		local event_manager = Managers.event

		event_manager:register(self, "player_unit_spawned", "_on_player_unit_spawned")
		event_manager:register(self, "player_unit_despawned", "_on_player_unit_despawned")
		event_manager:register(self, "minion_unit_spawned", "_on_minion_unit_spawned")
	end
end

MutatorManager._load_mutators = function (self, circumstance_name)
	local circumstance_template = CircumstanceTemplates[circumstance_name]
	local mutators_to_load = circumstance_template.mutators
	local is_server = self._is_server
	local network_event_delegate = self._network_event_delegate
	local mutators = self._mutators

	if mutators_to_load then
		for _, mutator_name in ipairs(mutators_to_load) do
			local mutator_template = MutatorTemplates[mutator_name]
			local mutator_class = require(mutator_template.class)

			mutators[mutator_name] = mutator_class:new(is_server, network_event_delegate, mutator_template, self._nav_world, self._level_seed)
		end
	end
end

MutatorManager.init = function (self, is_server, nav_world, network_event_delegate, circumstance_name, level_seed)
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._mutators = {}
	self._nav_world = nav_world
	self._level_seed = level_seed

	self:_load_mutators(circumstance_name)

	if is_server then
		local event_manager = Managers.event

		event_manager:register(self, "player_unit_spawned", "_on_player_unit_spawned")
		event_manager:register(self, "player_unit_despawned", "_on_player_unit_despawned")
		event_manager:register(self, "minion_unit_spawned", "_on_minion_unit_spawned")
	end
end

MutatorManager._load_mutators = function (self, circumstance_name)
	local havoc_data = Managers.state.difficulty:get_parsed_havoc_data()
	local mutators_to_load

	if havoc_data then
		local circumstances = havoc_data.circumstances

		for i = 1, #circumstances do
			local circumstance = circumstances[i]
			local circumstance_template = CircumstanceTemplates[circumstance]

			if mutators_to_load then
				table.append(mutators_to_load, circumstance_template.mutators)
			else
				mutators_to_load = table.clone(circumstance_template.mutators)
			end
		end
	else
		local circumstance_template = CircumstanceTemplates[circumstance_name]

		mutators_to_load = circumstance_template.mutators
	end

	local is_server = self._is_server
	local network_event_delegate = self._network_event_delegate
	local mutators = self._mutators

	if mutators_to_load then
		for _, mutator_name in ipairs(mutators_to_load) do
			local mutator_template = MutatorTemplates[mutator_name]
			local mutator_class = require(mutator_template.class)

			mutators[mutator_name] = mutator_class:new(is_server, network_event_delegate, mutator_template, self._nav_world, self._level_seed)
		end
	end
end

MutatorManager.destroy = function (self)
	if self._is_server then
		local event_manager = Managers.event

		event_manager:unregister(self, "minion_unit_spawned")
		event_manager:unregister(self, "player_unit_despawned")
		event_manager:unregister(self, "player_unit_spawned")
	end
end

MutatorManager.hot_join_sync = function (self, sender, channel)
	local mutators = self._mutators

	for _, mutator in pairs(mutators) do
		mutator:hot_join_sync(sender, channel)
	end
end

MutatorManager.on_gameplay_post_init = function (self, level, themes)
	local mutators = self._mutators

	for _, mutator in pairs(mutators) do
		mutator:on_gameplay_post_init(level, themes)
	end
end

MutatorManager.on_spawn_points_generated = function (self, level, themes)
	local mutators = self._mutators

	for _, mutator in pairs(mutators) do
		mutator:on_spawn_points_generated(level, themes)
	end
end

MutatorManager.update = function (self, dt, t)
	local mutators = self._mutators

	for _, mutator in pairs(mutators) do
		if mutator:is_active() then
			mutator:update(dt, t)
		end
	end
end

MutatorManager.activate_mutator = function (self, mutator_name)
	local mutator = self._mutators[mutator_name]

	mutator:activate()
end

MutatorManager.deactivate_mutator = function (self, mutator_name)
	local mutator = self._mutators[mutator_name]

	mutator:deactivate()
end

MutatorManager.mutator = function (self, mutator_name)
	return self._mutators[mutator_name]
end

MutatorManager._on_player_unit_spawned = function (self, player)
	local mutators = self._mutators

	for _, mutator in pairs(mutators) do
		mutator:_on_player_unit_spawned(player)
	end
end

MutatorManager._on_player_unit_despawned = function (self, player)
	local mutators = self._mutators

	for _, mutator in pairs(mutators) do
		mutator:_on_player_unit_despawned(player)
	end
end

MutatorManager._on_minion_unit_spawned = function (self, unit)
	local mutators = self._mutators

	for _, mutator in pairs(mutators) do
		mutator:_on_minion_unit_spawned(unit)
	end
end

return MutatorManager
