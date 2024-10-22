﻿-- chunkname: @scripts/extension_systems/minion_spawner/minion_spawner_extension.lua

local Breeds = require("scripts/settings/breed/breeds")
local Component = require("scripts/utilities/component")
local MinionSpawnerQueue = require("scripts/extension_systems/minion_spawner/utilities/minion_spawner_queue")
local MinionSpawnerSpawnPosition = require("scripts/extension_systems/minion_spawner/utilities/minion_spawner_spawn_position")
local NavQueries = require("scripts/utilities/nav_queries")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local aggro_states = PerceptionSettings.aggro_states
local MinionSpawnerExtension = class("MinionSpawnerExtension")

MinionSpawnerExtension.UPDATE_DISABLED_BY_DEFAULT = true

local DEFAULT_SPAWN_DELAY = 0.25

MinionSpawnerExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._nav_world = extension_init_context.nav_world
	self._traverse_logic = extension_init_context.traverse_logic
	self._owner_system = extension_init_context.owner_system
	self._spawn_queue = MinionSpawnerQueue:new()
	self._next_spawn_time = nil
	self._is_setup = false
	self._spawned_minions_by_queue_id = {}
end

local NAV_MESH_ABOVE, NAV_MESH_BELOW = 1, 1

MinionSpawnerExtension.setup_from_component = function (self, spawner_groups, spawn_position, exit_position, exclude_from_pacing, exclude_from_specials_pacing, spawn_type, exit_rotation_num_directions, exit_rotation_random_degree_range)
	local unit, nav_world, traverse_logic = self._unit, self._nav_world, self._traverse_logic
	local exit_position_on_nav_mesh = MinionSpawnerSpawnPosition.find_exit_position_on_nav_mesh(nav_world, spawn_position, exit_position, traverse_logic)

	if not exit_position_on_nav_mesh then
		Log.warning("[MinionSpawnerExtension]", "Couldn't find any nav mesh at spawner exit position %s, on unit: %s", exit_position, Unit.id_string(unit))

		exit_position_on_nav_mesh = exit_position
	end

	self._spawner_groups = spawner_groups
	self._spawn_position = Vector3Box(spawn_position)

	local to_exit_on_navmesh = exit_position_on_nav_mesh - spawn_position
	local spawn_direction = Vector3.flat(Vector3.normalize(to_exit_on_navmesh))
	local spawn_rotation = Quaternion.look(spawn_direction, Vector3.up())

	self._spawn_rotation = QuaternionBox(spawn_rotation)
	self._exit_position = Vector3Box(exit_position_on_nav_mesh)

	if exit_rotation_random_degree_range and exit_rotation_num_directions and exit_rotation_random_degree_range > 0 and exit_rotation_num_directions > 0 then
		local degree_per_direction = exit_rotation_random_degree_range / exit_rotation_num_directions
		local current_degree = -exit_rotation_random_degree_range / 2
		local randomized_spawn_data = {}
		local unit_position
		local has_spawn_node = Unit.has_node(unit, "spawn_node")

		if has_spawn_node then
			local spawn_node = Unit.node(unit, "spawn_node")

			unit_position = Unit.world_position(unit, spawn_node)
		else
			unit_position = POSITION_LOOKUP[unit]
		end

		local flattened_unit_position = Vector3(unit_position.x, unit_position.y, spawn_position.z)
		local flattened_unit_to_spawn_position_length = Vector3.length(spawn_position - flattened_unit_position)
		local to_exit_on_navmesh_flat_length = Vector3.length(Vector3.flat(to_exit_on_navmesh))
		local spawn_horizontal_length = to_exit_on_navmesh_flat_length - flattened_unit_to_spawn_position_length

		for i = 1, exit_rotation_num_directions + 1 do
			local radians = math.degrees_to_radians(current_degree)
			local direction = Vector3(math.sin(radians), math.cos(radians), 0)
			local rotated_direction = Quaternion.rotate(spawn_rotation, direction)
			local wanted_direction = Vector3.normalize(0.5 * spawn_direction + rotated_direction)
			local exit_pos = unit_position + wanted_direction * to_exit_on_navmesh_flat_length

			exit_pos.z = exit_position_on_nav_mesh.z

			local exit_pos_on_nav_mesh = NavQueries.position_on_mesh(nav_world, exit_pos, NAV_MESH_ABOVE, NAV_MESH_BELOW, traverse_logic)

			if exit_pos_on_nav_mesh then
				local spawn_pos = flattened_unit_position + wanted_direction * flattened_unit_to_spawn_position_length
				local spawn_height = exit_pos_on_nav_mesh.z - spawn_pos.z
				local spawn_data = {
					rotation = QuaternionBox(Quaternion.look(wanted_direction)),
					position = Vector3Box(spawn_pos),
					height = spawn_height,
					horizontal_length = spawn_horizontal_length,
				}

				randomized_spawn_data[#randomized_spawn_data + 1] = spawn_data
			end

			current_degree = current_degree + degree_per_direction
		end

		table.shuffle(randomized_spawn_data)

		self._randomized_spawn_data = randomized_spawn_data
		self._randomized_index = 0
	end

	self._is_setup = true
	self._excluded_from_pacing = exclude_from_pacing
	self._exclude_from_specials_pacing = exclude_from_specials_pacing
	self._spawn_type = spawn_type
end

MinionSpawnerExtension.spawner_groups = function (self)
	return self._spawner_groups
end

MinionSpawnerExtension.exit_position_boxed = function (self)
	return self._exit_position
end

MinionSpawnerExtension.spawn_height = function (self, spawn_index)
	local spawn_data = self._randomized_spawn_data[spawn_index]
	local height = spawn_data.height

	return height
end

MinionSpawnerExtension.spawn_horizontal_length = function (self, spawn_index)
	local spawn_data = self._randomized_spawn_data[spawn_index]
	local horizontal_length = spawn_data.horizontal_length

	return horizontal_length
end

MinionSpawnerExtension.is_excluded_from_pacing = function (self)
	return self._excluded_from_pacing
end

MinionSpawnerExtension.is_excluded_from_specials_pacing = function (self)
	return self._exclude_from_specials_pacing
end

MinionSpawnerExtension.spawn_type = function (self)
	return self._spawn_type
end

MinionSpawnerExtension.position = function (self)
	local unit = self._unit
	local position = POSITION_LOOKUP[unit]

	return position
end

MinionSpawnerExtension.rotation = function (self)
	return self._spawn_rotation:unbox()
end

MinionSpawnerExtension.add_spawns = function (self, breed_list, spawn_side_id, optional_target_side_id, optional_spawn_delay, optional_mission_objective_id, optional_group_id, optional_attack_selection_template_name, optional_aggro_state, optional_max_health_modifier)
	local queue = self._spawn_queue
	local spawn_delay = optional_spawn_delay or DEFAULT_SPAWN_DELAY
	local spawn_data = {
		spawn_delay = spawn_delay,
		spawn_side_id = spawn_side_id,
		target_side_id = optional_target_side_id,
		mission_objective_id = optional_mission_objective_id,
		group_id = optional_group_id,
		attack_selection_template_name = optional_attack_selection_template_name,
		aggro_state = optional_aggro_state,
		max_health_modifier = optional_max_health_modifier,
	}
	local queue_id = queue:enqueue(breed_list, spawn_data)

	if not self._next_spawn_time then
		self._next_spawn_time = 0

		Component.event(self._unit, "minion_spawner_spawning_started")
		self._owner_system:enable_update_function(self.__class_name, "update", self._unit, self)
	end

	return queue_id
end

MinionSpawnerExtension.is_spawning = function (self)
	return self._next_spawn_time and true or false
end

MinionSpawnerExtension.spawned_minions_by_queue_id = function (self, queue_id)
	return self._spawned_minions_by_queue_id[queue_id]
end

MinionSpawnerExtension.update = function (self, unit, dt, t)
	if not self._is_setup then
		return
	end

	local next_spawn_time = self._next_spawn_time

	if next_spawn_time and next_spawn_time <= t then
		local breed_name, spawn_data, queue_id = self._spawn_queue:dequeue()

		if breed_name then
			local spawned_minion = self:_spawn(breed_name, spawn_data)
			local spawned_minions_by_queue_id = self._spawned_minions_by_queue_id
			local spawned_minions = spawned_minions_by_queue_id[queue_id]

			if spawned_minions then
				spawned_minions[#spawned_minions + 1] = spawned_minion
			else
				spawned_minions_by_queue_id[queue_id] = {
					spawned_minion,
				}
			end

			self._last_spawned_minion = spawned_minion
			self._next_spawn_time = t + spawn_data.spawn_delay
		else
			local should_wait_for_last_minion = false

			if ALIVE[self._last_spawned_minion] then
				local blackboard = BLACKBOARDS[self._last_spawned_minion]
				local spawn_component = blackboard and blackboard.spawn

				if spawn_component then
					local is_exiting_spawner = spawn_component.is_exiting_spawner

					if is_exiting_spawner then
						should_wait_for_last_minion = true
					end
				end
			end

			if not should_wait_for_last_minion then
				self._next_spawn_time = nil

				Component.event(self._unit, "minion_spawner_spawning_done")
				self._owner_system:disable_update_function(self.__class_name, "update", self._unit, self)
			end
		end
	end
end

MinionSpawnerExtension._spawn = function (self, breed_name, spawn_data)
	local breed = Breeds[breed_name]
	local unit, exit_position = self._unit, self._exit_position:unbox()
	local exit_position_valid = MinionSpawnerSpawnPosition.validate_exit_position(self._nav_world, exit_position, self._traverse_logic)

	if not exit_position_valid then
		Log.warning("[MinionSpawnerExtension]", "Spawning aborted for %q, couldn't find any traversable nav mesh at exit position %s, on unit: %s", breed_name, exit_position, Unit.id_string(unit))

		return nil
	end

	local spawn_position, spawn_rotation
	local randomized_spawn_data = self._randomized_spawn_data

	if randomized_spawn_data then
		self._randomized_index = self._randomized_index % #randomized_spawn_data + 1

		local current_randomized_spawn_data = randomized_spawn_data[self._randomized_index]

		spawn_position, spawn_rotation = current_randomized_spawn_data.position:unbox(), current_randomized_spawn_data.rotation:unbox()
	else
		spawn_position, spawn_rotation = self._spawn_position:unbox(), self._spawn_rotation:unbox()
	end

	local mission_objective_id = spawn_data.mission_objective_id
	local spawn_side_id = spawn_data.spawn_side_id
	local target_side_id = spawn_data.target_side_id
	local aggro_state = spawn_data.aggro_state or aggro_states.aggroed
	local target_unit

	if target_side_id and aggro_state == aggro_states.aggroed then
		local main_path_manager = Managers.state.main_path

		if main_path_manager:is_main_path_ready() then
			target_unit = main_path_manager:ahead_unit(target_side_id)
		end
	end

	local max_health_modifier, group_id, attack_selection_template_name = spawn_data.max_health_modifier, spawn_data.group_id, spawn_data.attack_selection_template_name
	local spawned_unit = Managers.state.minion_spawn:spawn_minion(breed_name, spawn_position, spawn_rotation, spawn_side_id, aggro_state, target_unit, unit, group_id, mission_objective_id, attack_selection_template_name, max_health_modifier, self._randomized_index)

	return spawned_unit
end

MinionSpawnerExtension.destroy = function (self)
	self._unit = nil
	self._nav_world = nil
	self._traverse_logic = nil
	self._spawn_queue = nil
	self._next_spawn_time = nil
end

return MinionSpawnerExtension
