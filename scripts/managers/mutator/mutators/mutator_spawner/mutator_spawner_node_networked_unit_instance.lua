-- chunkname: @scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_networked_unit_instance.lua

require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node")

local MutatorSpawnerNodeNetworkedUnitInstance = class("MutatorSpawnerNodeNetworkedUnitInstance", "MutatorSpawnerNode")

MutatorSpawnerNodeNetworkedUnitInstance.init = function (self, template)
	MutatorSpawnerNodeNetworkedUnitInstance.super.init(self, template)

	self._initial_units = template.units
	self._current_units = table.clone(self._initial_units)
	self._randomize_rotation = template.randomize_rotation or false
	self._spawn_radius = template.spawn_radius or 5
	self._spawn_count = template.spawn_count or 1
	self._spawn_position_offset = template.spawn_position_offset or 0
	self._placement_method = template.placement_method
	self._use_slot_specific_units = template.use_slot_specific_units
	self._size_lookup = template.size_lookup
	self._spawned_units = {}
end

MutatorSpawnerNodeNetworkedUnitInstance._do_spawn = function (self, spawn_position, ahead_target_unit, optional_spawn_rotation, _, optional_slot_size)
	local unit_reference, _, idx

	if self._use_slot_specific_units and optional_slot_size then
		unit_reference, _, idx = math.random_array_entry(self._current_units[optional_slot_size])
	else
		local slot_size = self._size_lookup[math.random(1, #self._size_lookup)]

		unit_reference, _, idx = math.random_array_entry(self._current_units[slot_size])
	end

	local spawn_rotation = optional_spawn_rotation or self._randomize_rotation and Quaternion.axis_angle(Vector3.up(), math.random() * (math.pi * 2)) or Quaternion.identity()
	local unit_instance, game_object_id = Managers.state.unit_spawner:spawn_network_unit(unit_reference.unit_name, unit_reference.unit_template_name, spawn_position, spawn_rotation, nil, unit_reference.unit_settings)

	self._spawned_units[#self._spawned_units + 1] = {
		instance = unit_instance,
		game_object_id = game_object_id,
	}

	table.swap_delete(self._current_units, idx)

	if #self._current_units == 0 then
		self._current_units = table.clone(self._initial_units)
	end
end

MutatorSpawnerNodeNetworkedUnitInstance.destroy = function (self)
	for i = 1, #self._spawned_units do
		Managers.state.unit_spawner:mark_for_deletion(self._spawned_units[i].instance)
	end

	table.clear(self._spawned_units)
end

return MutatorSpawnerNodeNetworkedUnitInstance
