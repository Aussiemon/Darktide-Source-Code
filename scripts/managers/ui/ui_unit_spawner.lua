-- chunkname: @scripts/managers/ui/ui_unit_spawner.lua

local GrowQueue = require("scripts/foundation/utilities/grow_queue")
local Unit_alive = Unit.alive
local UIUnitSpawner = class("UIUnitSpawner")
local DELETION_STATES = table.enum("default", "in_network_layers", "removing_units")

UIUnitSpawner.DELETION_STATES = DELETION_STATES

UIUnitSpawner.init = function (self, world)
	self._world = world
	self._deletion_queue = GrowQueue:new()
	self._num_deleted_units = 0
	self._deletion_state = DELETION_STATES.default
	self._temp_units_list = {}
end

UIUnitSpawner.destroy = function (self)
	self._unit_destroy_listeners = nil
end

UIUnitSpawner.remove_pending_units = function (self)
	local num_removed

	repeat
		num_removed = self:_remove_units_marked_for_deletion()
	until num_removed == 0
end

UIUnitSpawner.mark_for_deletion = function (self, unit)
	local deletion_state = self._deletion_state

	if deletion_state == DELETION_STATES.removing_units then
		Unit.flow_event(unit, "cleanup_before_destroy")

		self._num_deleted_units = self._num_deleted_units + 1
		self._temp_units_list[self._num_deleted_units] = unit
	else
		self._deletion_queue:push_back(unit)
	end
end

UIUnitSpawner._remove_units_marked_for_deletion = function (self)
	if self._deletion_queue:size() == 0 then
		return 0
	end

	local temp_deleted_units_list = self._temp_units_list

	self._num_deleted_units = 0

	self:_set_deletion_state(DELETION_STATES.removing_units)

	local unit = self._deletion_queue:pop_first()

	while unit do
		Unit.flow_event(unit, "cleanup_before_destroy")

		self._num_deleted_units = self._num_deleted_units + 1
		temp_deleted_units_list[self._num_deleted_units] = unit
		unit = self._deletion_queue:pop_first()
	end

	self:_set_deletion_state(DELETION_STATES.default)

	local world, num_deleted_units = self._world, self._num_deleted_units

	self:_world_delete_units(world, temp_deleted_units_list, num_deleted_units)

	return num_deleted_units
end

UIUnitSpawner._set_deletion_state = function (self, state)
	self._deletion_state = state
end

UIUnitSpawner.spawn_unit = function (self, unit_name, ...)
	local unit = World.spawn_unit_ex(self._world, unit_name, nil, ...)

	Unit.set_data(unit, "unit_name", unit_name)

	return unit
end

UIUnitSpawner._world_delete_units = function (self, world, units_list, num_units)
	for i = 1, num_units do
		local unit = units_list[i]
		local unit_is_alive = Unit_alive(unit)

		Unit.flow_event(unit, "unit_despawned")
		World.destroy_unit(world, unit)
	end
end

local TEMP_UNIT_TABLE = {}

UIUnitSpawner._world_delete_unit = function (self, world, unit)
	TEMP_UNIT_TABLE[1] = unit

	self:_world_delete_units(world, TEMP_UNIT_TABLE, 1)
end

return UIUnitSpawner
