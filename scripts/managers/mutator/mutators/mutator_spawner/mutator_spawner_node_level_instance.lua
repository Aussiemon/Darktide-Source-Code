-- chunkname: @scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_level_instance.lua

require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node")

local MutatorSpawnerNodeLevelInstance = class("MutatorSpawnerNodeLevelInstance", "MutatorSpawnerNode")

MutatorSpawnerNodeLevelInstance.init = function (self, template)
	MutatorSpawnerNodeLevelInstance.super.init(self, template)

	self._initial_levels = template.levels
	self._current_levels = table.clone(self._initial_levels)
	self._randomize_rotation = template.randomize_rotation or false
	self._spawn_radius = template.spawn_radius or 5
	self._spawn_count = template.spawn_count or 1
	self._spawn_position_offset = template.spawn_position_offset or 0
	self._placement_method = template.placement_method
	self._use_slot_specific_levels = template.use_slot_specific_levels
	self._size_lookup = template.size_lookup
	self._spawned_instanced_levels = {}
end

MutatorSpawnerNodeLevelInstance._do_spawn = function (self, spawn_position, ahead_target_unit, optional_spawn_rotation, _, optional_slot_size)
	local level_reference, _, idx

	if self._use_slot_specific_levels and optional_slot_size then
		level_reference, _, idx = math.random_array_entry(self._current_levels[optional_slot_size])
	else
		local slot_size = self._size_lookup[math.random(1, #self._size_lookup)]

		level_reference, _, idx = math.random_array_entry(self._current_levels[slot_size])
	end

	local spawn_rotation = optional_spawn_rotation or self._randomize_rotation and Quaternion.axis_angle(Vector3.up(), math.random() * (math.pi * 2)) or Quaternion.identity()
	local level_instance_data = Managers.state.level_instance:spawn_level_instance(level_reference, spawn_position, spawn_rotation)

	self._spawned_instanced_levels[#self._spawned_instanced_levels + 1] = level_instance_data

	table.swap_delete(self._current_levels, idx)

	if #self._current_levels == 0 then
		self._current_levels = table.clone(self._initial_levels)
	end
end

MutatorSpawnerNodeLevelInstance.destroy = function (self)
	Managers.state.level_instance:cleanup()
end

return MutatorSpawnerNodeLevelInstance
