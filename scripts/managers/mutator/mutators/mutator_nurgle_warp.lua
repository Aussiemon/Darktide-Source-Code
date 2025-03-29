-- chunkname: @scripts/managers/mutator/mutators/mutator_nurgle_warp.lua

require("scripts/managers/mutator/mutators/mutator_base")

local MainPathQueries = require("scripts/utilities/main_path_queries")
local NavQueries = require("scripts/utilities/nav_queries")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local SpawnPointQueries = require("scripts/managers/main_path/utilities/spawn_point_queries")
local aggro_states = PerceptionSettings.aggro_states
local MutatorNurgleWarp = class("MutatorNurgleWarp", "MutatorBase")
local MINION_QUEUE_RING_BUFFER_SIZE = 256
local MINION_QUEUE_PARAMETERS = table.enum("breed_name", "position", "rotation", "optional_aggro_state", "optional_target_unit", "buff_to_add")

MutatorNurgleWarp.init = function (self, is_server, network_event_delegate, mutator_template, nav_world)
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._is_active = true
	self._buffs = {}
	self._template = mutator_template
	self._template_compositions = self._template.compositions

	local spawn_queue = Script.new_array(MINION_QUEUE_RING_BUFFER_SIZE)

	for i = 1, MINION_QUEUE_RING_BUFFER_SIZE do
		spawn_queue[i] = Script.new_array(#MINION_QUEUE_PARAMETERS)
	end

	self._spawn_queue = spawn_queue
	self._spawn_queue_read_index = 1
	self._spawn_queue_write_index = 1
	self._spawn_queue_size = 0
	self._nav_world = nav_world

	local world = Managers.world:world("level_world")

	self._world = world

	local physics_world = World.physics_world(world)

	self._physics_world = physics_world
end

local MIN_DISTANCE_FROM_PLAYERS = 1
local DEFAULT_MAIN_PATH_OFFSET = 10

MutatorNurgleWarp._try_find_occluded_position = function (self, nav_world, physics_world, side, target_side, occluded_spawn_range, try_find_on_main_path, optional_main_path_offset, optional_disallowed_positions)
	local target_side_id = target_side.side_id
	local main_path_manager = Managers.state.main_path
	local nav_spawn_points = main_path_manager:nav_spawn_points()
	local target_unit, travel_distance, path_position = main_path_manager:ahead_unit(target_side_id)

	if not target_unit then
		return false, nil, nil, nil
	end

	local wanted_position

	if try_find_on_main_path then
		local main_path_offset = optional_main_path_offset or DEFAULT_MAIN_PATH_OFFSET

		if type(main_path_offset) == "table" then
			main_path_offset = math.random_range(optional_main_path_offset[1], optional_main_path_offset[2])
		end

		local main_path_distance = math.max(travel_distance + main_path_offset, 0)

		wanted_position = MainPathQueries.position_from_distance(main_path_distance)
	else
		wanted_position = path_position
	end

	local only_search_forward = true
	local random_occluded_position = SpawnPointQueries.get_random_occluded_position(nav_world, nav_spawn_points, wanted_position, side, occluded_spawn_range, 1, MIN_DISTANCE_FROM_PLAYERS, nil, nil, only_search_forward, optional_disallowed_positions)

	if not random_occluded_position then
		return false, nil, nil, nil
	end

	local to_target = wanted_position - random_occluded_position
	local target_direction = Vector3.normalize(to_target)

	return true, random_occluded_position, target_direction, target_unit
end

local TEMP_FLOOD_FILL_POSITONS = {}

MutatorNurgleWarp.spawn_group = function (self, composition, unit)
	local nav_world = self._nav_world
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side_from_name("villains")
	local enemy_side = side_system:get_side_from_name("heroes")
	local physics_world = self._physics_world
	local success, random_occluded_position, target_direction = self:_try_find_occluded_position(nav_world, physics_world, side, enemy_side, 3, true, nil, nil)

	if success then
		local spawn_rotation = Quaternion.look(Vector3(target_direction.x, target_direction.y, 0))
		local num_to_spawn = #composition
		local below, above = 2, 2
		local num_positions = GwNavQueries.flood_fill_from_position(nav_world, random_occluded_position, above, below, num_to_spawn, TEMP_FLOOD_FILL_POSITONS)

		for i = 1, num_positions do
			local spawn_position = TEMP_FLOOD_FILL_POSITONS[i]

			self:add_split_spawn(spawn_position, spawn_rotation, composition[i], nil, unit)
		end

		table.clear_array(TEMP_FLOOD_FILL_POSITONS, num_positions)
	end
end

MutatorNurgleWarp.spawn_random_from_template = function (self, optional_target_unit)
	local template_compositions = self._template_compositions
	local index = math.random(1, #template_compositions)
	local random_composition = template_compositions[index]

	self:spawn_group(random_composition, optional_target_unit)
end

MutatorNurgleWarp.update = function (self, dt, t)
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
		local side_id = 2
		local minion_spawn_manager = Managers.state.minion_spawn
		local param_table = minion_spawn_manager:request_param_table()

		param_table.optional_aggro_state = aggro_states.aggroed

		if ALIVE[target_unit] then
			param_table.optional_target_unit = target_unit
		end

		minion_spawn_manager:spawn_minion(breed_name, position_on_navmesh, rotation, side_id, param_table)
	end

	self._spawn_queue_read_index = read_index % MINION_QUEUE_RING_BUFFER_SIZE + 1
	self._spawn_queue_size = self._spawn_queue_size - 1
end

MutatorNurgleWarp.add_split_spawn = function (self, position, rotation, breed_name, buff_to_add, target_unit)
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

return MutatorNurgleWarp
