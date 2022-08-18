require("scripts/extension_systems/spline_follower/spline_follower_extension")

local Graph = require("scripts/utilities/graph")
local LevelEventSettings = require("scripts/settings/level_event/level_event_settings")
local SplineFollowerSystem = class("SplineFollowerSystem", "ExtensionSystemBase")
local RPCS = {
	"rpc_spline_follower_hot_join_sync",
	"rpc_spline_follower_system_seed_sync"
}

SplineFollowerSystem.init = function (self, context, system_init_data, ...)
	SplineFollowerSystem.super.init(self, context, system_init_data, ...)

	self._is_server = context.is_server
	self._splines_by_name = {}
	self._spline_path_indices_by_name = {}
	self._start_spline_indices = {}
	self._spline_connection_radius = LevelEventSettings.spline_follower.spline_connection_radius
	self._seed = (self._is_server and system_init_data.level_seed) or nil
	local network_event_delegate = context.network_event_delegate

	network_event_delegate:register_session_events(self, unpack(RPCS))

	self._network_event_delegate = network_event_delegate
	self._graph = Graph:new()
end

SplineFollowerSystem.on_gameplay_post_init = function (self, level)
	self:_setup_splines(level)

	if self._is_server then
		self:_setup_spline_paths()
	end
end

SplineFollowerSystem.destroy = function (self)
	self._network_event_delegate:unregister_events(unpack(RPCS))
end

SplineFollowerSystem.hot_join_sync = function (self, sender, channel)
	local seed = self._seed

	RPC.rpc_spline_follower_system_seed_sync(channel, seed)

	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		local is_level_unit, unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(unit)
		local current_spline_index = extension:current_spline_index()
		local is_moving = extension:is_moving()
		local objective_name = extension:objective_name()
		local objective_name_id = (objective_name and NetworkLookup.mission_objective_names[objective_name]) or 1

		RPC.rpc_spline_follower_hot_join_sync(channel, unit_id, is_level_unit, current_spline_index, is_moving, objective_name_id)
	end
end

SplineFollowerSystem.update = function (self, unit, dt, t)
	local unit_to_extension_map = self._unit_to_extension_map

	for spline_follower_unit, extension in pairs(unit_to_extension_map) do
		extension:update(spline_follower_unit, dt, t)
	end
end

SplineFollowerSystem._setup_splines = function (self, level)
	local spline_group_system = Managers.state.extension:system("spline_group_system")
	local spline_names_by_objective_name = spline_group_system:spline_names()

	for objective_name, spline_names in pairs(spline_names_by_objective_name) do
		local splines = self:_retrieve_splines_from_level(spline_names, level)
		self._splines_by_name[objective_name] = splines
	end
end

SplineFollowerSystem._retrieve_splines_from_level = function (self, spline_names, level)
	local splines = {}

	for i = 1, #spline_names, 1 do
		local spline_name = spline_names[i]
		local spline = Level.spline(level, spline_name)

		for n = 1, #spline, 1 do
			local boxed_spline = Vector3Box(spline[n])
			spline[n] = boxed_spline
		end

		splines[#splines + 1] = spline
	end

	return splines
end

local TEMP_KEYS = {}

SplineFollowerSystem._setup_spline_paths = function (self)
	local splines = self._splines_by_name
	local seed = self._seed
	local spline_path_indices_by_name = self._spline_path_indices_by_name

	for objective_name, spline in table.sorted(splines, TEMP_KEYS) do
		local graph, start_spline_indices = self:_setup_graph_with_connected_splines(spline)
		spline_path_indices_by_name[objective_name], seed = self:_new_random_spline_path_index(graph, start_spline_indices, seed)
	end

	self._spline_path_indices_by_name = spline_path_indices_by_name

	table.clear(TEMP_KEYS)
end

SplineFollowerSystem._setup_graph_with_connected_splines = function (self, splines)
	local graph = self._graph

	graph:clear_nodes()

	local start_spline_indices = self._start_spline_indices

	table.clear(start_spline_indices)

	for n = 1, #splines, 1 do
		local spline = splines[n]
		local spline_start_position = spline[1]:unbox()
		local spline_end_position = spline[#spline]:unbox()
		local has_any_start_position_connections = false

		graph:add_node(n)

		for i = 1, #splines, 1 do
			if i ~= n then
				local comparing_spline = splines[i]
				local comparing_spline_start_position = comparing_spline[1]:unbox()
				local comparing_spline_end_position = comparing_spline[#comparing_spline]:unbox()
				local start_position_conected = self:_fulfill_inside_of_radius_check(spline_start_position, comparing_spline_end_position)
				local end_position_conected = self:_fulfill_inside_of_radius_check(spline_end_position, comparing_spline_start_position)

				if start_position_conected then
					has_any_start_position_connections = true
				end

				if end_position_conected then
					graph:add_edge(n, i)
				end
			end
		end

		if not has_any_start_position_connections then
			start_spline_indices[#start_spline_indices + 1] = n
		end
	end

	return graph, start_spline_indices
end

SplineFollowerSystem._fulfill_inside_of_radius_check = function (self, position_one, position_two)
	local distance_squared = Vector3.distance_squared(position_one, position_two)

	if distance_squared < self._spline_connection_radius then
		return true
	end

	return false
end

SplineFollowerSystem._new_random_spline_path_index = function (self, graph, start_spline_indices, seed)
	local new_seed, spline_index = self:_next_random_spline_index(start_spline_indices, seed)
	local spline_path_indices = {
		spline_index
	}

	while graph:has_adjacency_nodes(spline_index) do
		local connected_splines = graph:get_adjacency_nodes(spline_index)
		new_seed, spline_index = self:_next_random_spline_index(connected_splines, new_seed)
		spline_path_indices[#spline_path_indices + 1] = spline_index
	end

	return spline_path_indices, new_seed
end

SplineFollowerSystem._next_random_spline_index = function (self, spline_indices, seed)
	local new_seed, rnd_num = math.next_random(seed, 1, #spline_indices)

	return new_seed, spline_indices[rnd_num]
end

SplineFollowerSystem.has_spline_path = function (self, name)
	return (self._spline_path_indices_by_name[name] and true) or false
end

SplineFollowerSystem.spline_path_start_position_and_rotation = function (self, name)
	local spline_path_indices = self._spline_path_indices_by_name[name]
	local splines = self._splines_by_name[name]
	local connected_spline = spline_path_indices[1]
	local spline = splines[connected_spline]
	local first_pos = spline[1]:unbox()
	local second_pos = spline[2]:unbox()
	local to_target = second_pos - first_pos
	local direction = Vector3.normalize(to_target)
	local rotation = Quaternion.look(direction)

	return first_pos, rotation
end

SplineFollowerSystem.spline_path_end_positions = function (self, name)
	local spline_path_indices = self._spline_path_indices_by_name[name]
	local splines = self._splines_by_name[name]
	local spline_path_end_positions = {}

	for i = 1, #spline_path_indices, 1 do
		local spline_path_index = spline_path_indices[i]
		local spline = splines[spline_path_index]
		spline_path_end_positions[#spline_path_end_positions + 1] = spline[#spline]:unbox()
	end

	return spline_path_end_positions
end

SplineFollowerSystem.has_connected_spline = function (self, name, spline_index)
	local spline_path_indices = self._spline_path_indices_by_name[name]

	if spline_index <= #spline_path_indices then
		return true
	end

	return false
end

SplineFollowerSystem.get_connected_spline = function (self, name, spline_index)
	local spline_path_indices = self._spline_path_indices_by_name[name]
	local splines = self._splines_by_name[name]

	if spline_index <= #spline_path_indices then
		local connected_spline = spline_path_indices[spline_index]
		local spline = splines[connected_spline]

		return spline
	end
end

SplineFollowerSystem.rpc_spline_follower_system_seed_sync = function (self, channel_id, seed)
	self._seed = seed

	self:_setup_spline_paths()
end

SplineFollowerSystem.rpc_spline_follower_hot_join_sync = function (self, channel_id, unit_id, is_level_unit, current_spline_index, is_moving, objective_name_id)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local unit_extension = self._unit_to_extension_map[unit]
	local objective_name = (is_moving and NetworkLookup.mission_objective_names[objective_name_id]) or ""

	unit_extension:hot_join_sync(current_spline_index, is_moving, objective_name)
end

return SplineFollowerSystem
