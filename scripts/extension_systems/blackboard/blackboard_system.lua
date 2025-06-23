-- chunkname: @scripts/extension_systems/blackboard/blackboard_system.lua

require("scripts/extension_systems/blackboard/blackboard_extension")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BlackboardSystem = class("BlackboardSystem", "ExtensionSystemBase")
local MAX_EXPECTED_AI_ENTITIES = 128
local BLACKBOARD_COMPONENT_UPDATE_SYSTEM_INDEX = 1
local BLACKBOARD_COMPONENT_UPDATE_FUNCTION_INDEX = 2
local BLACKBOARD_COMPONENT_UPDATE = {
	weapon_switch = {
		"behavior_system",
		"update_combat_range"
	},
	nearby_units_broadphase = {
		"behavior_system",
		"update_nearby_units_broadphase"
	},
	phase = {
		"behavior_system",
		"update_minion_phase"
	}
}

BlackboardSystem.init = function (self, ...)
	BlackboardSystem.super.init(self, ...)

	self._blackboard_updates = Script.new_array(MAX_EXPECTED_AI_ENTITIES)
	self._blackboard_prioritized_updates = Script.new_array(MAX_EXPECTED_AI_ENTITIES / 2)
	self._blackboard_update_index = 1
	self._blackboard_prioritized_update_index = 1
end

BlackboardSystem.register_extension_update = function (self, unit, extension_name, extension)
	BlackboardSystem.super.register_extension_update(self, unit, extension_name, extension)

	self._blackboard_updates[#self._blackboard_updates + 1] = unit
end

BlackboardSystem._cleanup_extension = function (self, unit)
	local blackboard_updates = self._blackboard_updates
	local num_blackboard_updates = #blackboard_updates

	for i = 1, num_blackboard_updates do
		if blackboard_updates[i] == unit then
			table.swap_delete(blackboard_updates, i)

			break
		end
	end

	local blackboard_prioritized_updates = self._blackboard_prioritized_updates
	local num_blackboard_prioritized_updates = #blackboard_prioritized_updates

	for i = 1, num_blackboard_prioritized_updates do
		if blackboard_prioritized_updates[i] == unit then
			table.swap_delete(blackboard_prioritized_updates, i)

			break
		end
	end
end

BlackboardSystem.on_remove_extension = function (self, unit, extension_name)
	self:_cleanup_extension(unit)

	BLACKBOARDS[unit] = nil

	BlackboardSystem.super.on_remove_extension(self, unit, extension_name)
end

BlackboardSystem.physics_async_update = function (self, context, dt, t, ...)
	self:_update_blackboards_prioritized(dt, t)
	self:_update_blackboards(dt, t)
end

local function _update_blackboard(unit, blackboard, dt, t)
	local component_config = Blackboard.component_config(blackboard)

	for component_name, data in pairs(BLACKBOARD_COMPONENT_UPDATE) do
		if component_config[component_name] then
			local system_name = data[BLACKBOARD_COMPONENT_UPDATE_SYSTEM_INDEX]
			local extension = ScriptUnit.extension(unit, system_name)
			local function_name = data[BLACKBOARD_COMPONENT_UPDATE_FUNCTION_INDEX]

			extension[function_name](extension, unit, blackboard, dt, t)
		end
	end
end

local MAX_BLACKBOARD_PRIORITIZED_UPDATES_PER_FRAME = 40

BlackboardSystem._update_blackboards_prioritized = function (self, dt, t)
	local blackboard_prioritized_updates = self._blackboard_prioritized_updates
	local num_blackboard_prioritized_updates = #blackboard_prioritized_updates
	local blackboards = BLACKBOARDS
	local max_updates_per_frame = MAX_BLACKBOARD_PRIORITIZED_UPDATES_PER_FRAME

	if num_blackboard_prioritized_updates < max_updates_per_frame then
		max_updates_per_frame = num_blackboard_prioritized_updates
	end

	local update_counter = 1
	local index = self._blackboard_prioritized_update_index

	while update_counter <= max_updates_per_frame do
		if num_blackboard_prioritized_updates < index then
			index = 1
		end

		local unit = blackboard_prioritized_updates[index]
		local blackboard = blackboards[unit]

		_update_blackboard(unit, blackboard, dt, t)

		index, update_counter = index + 1, update_counter + 1
	end

	self._blackboard_prioritized_update_index = index
end

local MAX_BLACKBOARD_UPDATES_PER_FRAME = 2

BlackboardSystem._update_blackboards = function (self, dt, t)
	local blackboard_updates = self._blackboard_updates
	local num_blackboard_updates = #blackboard_updates
	local blackboards = BLACKBOARDS
	local max_updates_per_frame = MAX_BLACKBOARD_UPDATES_PER_FRAME

	if num_blackboard_updates < max_updates_per_frame then
		max_updates_per_frame = num_blackboard_updates
	end

	local update_counter = 1
	local index = self._blackboard_update_index

	while update_counter <= max_updates_per_frame do
		if num_blackboard_updates < index then
			index = 1
		end

		local unit = blackboard_updates[index]
		local blackboard = blackboards[unit]

		_update_blackboard(unit, blackboard, dt, t)

		index, update_counter = index + 1, update_counter + 1
	end

	self._blackboard_update_index = index
end

BlackboardSystem.register_priority_update_unit = function (self, unit)
	local blackboard_prioritized_updates = self._blackboard_prioritized_updates
	local blackboard_updates = self._blackboard_updates
	local update_index = table.index_of(blackboard_updates, unit)

	table.swap_delete(blackboard_updates, update_index)

	blackboard_prioritized_updates[#blackboard_prioritized_updates + 1] = unit
end

BlackboardSystem.unregister_priority_update_unit = function (self, unit)
	local blackboard_prioritized_updates = self._blackboard_prioritized_updates
	local index = table.index_of(blackboard_prioritized_updates, unit)

	table.swap_delete(blackboard_prioritized_updates, index)

	local blackboard_updates = self._blackboard_updates

	blackboard_updates[#blackboard_updates + 1] = unit
end

return BlackboardSystem
