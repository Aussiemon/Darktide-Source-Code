-- chunkname: @scripts/managers/mutator/mutators/mutator_purple_stimmed.lua

require("scripts/managers/mutator/mutators/mutator_base")

local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local NavQueries = require("scripts/utilities/nav_queries")
local aggro_states = PerceptionSettings.aggro_states
local MutatorPurpleStimmed = class("MutatorPurpleStimmed", "MutatorBase")
local MINION_QUEUE_RING_BUFFER_SIZE = 256
local MINION_QUEUE_PARAMETERS = table.enum("breed_name", "position", "rotation", "optional_aggro_state", "optional_target_unit", "buff_to_add")

MutatorPurpleStimmed.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)
	MutatorPurpleStimmed.super.init(self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)

	self._is_active = true

	local spawn_queue = Script.new_array(MINION_QUEUE_RING_BUFFER_SIZE)

	for i = 1, MINION_QUEUE_RING_BUFFER_SIZE do
		spawn_queue[i] = Script.new_array(#MINION_QUEUE_PARAMETERS)
	end

	self._spawn_queue = spawn_queue
	self._spawn_queue_read_index = 1
	self._spawn_queue_write_index = 1
	self._spawn_queue_size = 0
	self._nav_world = nav_world
end

MutatorPurpleStimmed.update = function (self, dt, t)
	if not self._is_server then
		return
	end

	local size = self._spawn_queue_size

	if size == 0 then
		return
	end

	local queue = self._spawn_queue
	local read_index = self._spawn_queue_read_index
	local queue_entry = queue[read_index]
	local nav_world = self._nav_world
	local position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, queue_entry[MINION_QUEUE_PARAMETERS.position]:unbox(), 1, 1, 1)

	if position_on_navmesh then
		local breed_name = queue_entry[MINION_QUEUE_PARAMETERS.breed_name]
		local rotation = queue_entry[MINION_QUEUE_PARAMETERS.rotation]:unbox()
		local target_unit = queue_entry[MINION_QUEUE_PARAMETERS.optional_target_unit]

		if ALIVE[target_unit] then
			local minion_spawn_manager = Managers.state.minion_spawn
			local param_table = minion_spawn_manager:request_param_table()

			param_table.optional_aggro_state = aggro_states.aggroed
			param_table.optional_target_unit = target_unit

			local spawned_unit = minion_spawn_manager:spawn_minion(breed_name, position_on_navmesh, rotation, 2, param_table)
			local buff_extension = ScriptUnit.extension(spawned_unit, "buff_system")

			if not buff_extension:has_keyword("stimmed") and queue_entry.buff_to_add then
				buff_extension:add_internally_controlled_buff("mutator_stimmed_minion_purple", t, "owner_unit", spawned_unit)
				buff_extension:_update_stat_buffs_and_keywords(t)
			end
		end
	end

	self._spawn_queue_read_index = read_index % MINION_QUEUE_RING_BUFFER_SIZE + 1
	self._spawn_queue_size = self._spawn_queue_size - 1
end

MutatorPurpleStimmed.add_split_spawn = function (self, position, rotation, breed_name, buff_to_add, target_unit)
	local queue = self._spawn_queue
	local write_index = self._spawn_queue_write_index
	local queue_entry = queue[write_index]

	queue_entry[MINION_QUEUE_PARAMETERS.breed_name] = breed_name
	queue_entry[MINION_QUEUE_PARAMETERS.position] = Vector3Box(position)
	queue_entry[MINION_QUEUE_PARAMETERS.rotation] = QuaternionBox(rotation)
	queue_entry[MINION_QUEUE_PARAMETERS.optional_target_unit] = target_unit
	queue_entry[MINION_QUEUE_PARAMETERS.buff_to_add] = buff_to_add
	self._spawn_queue_write_index = write_index % MINION_QUEUE_RING_BUFFER_SIZE + 1
	self._spawn_queue_size = self._spawn_queue_size + 1
end

return MutatorPurpleStimmed
