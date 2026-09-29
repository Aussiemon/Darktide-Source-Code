-- chunkname: @scripts/managers/mutator/mutators/mutator_spawner.lua

require("scripts/managers/mutator/mutators/mutator_base")

local Component = require("scripts/utilities/component")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local NavQueries = require("scripts/utilities/nav_queries")
local LoadedDice = require("scripts/utilities/loaded_dice")
local MutatorSpawner = class("MutatorSpawner", "MutatorBase")
local spawn_types = table.enum("proximity", "default")
local TARGET_SIDE_ID = 1
local PLAYER_POSITIONS = {}
local vector3_distance = Vector3.distance
local NAV_MESH_ABOVE, NAV_MESH_BELOW = 5, 5
local MAX_TRAVEL_DISTANCE_Z_DIFF = 4
local MAX_PROJECTION_HORIZONTAL_DISPLACEMENT = 2
local DEFAULT_MIN_LOCATION_SEPARATION = 30

local function _walk_nodes_recursive(nodes, node_func)
	for i = 1, #nodes do
		node_func(nodes[i])

		local node_children = nodes[i].template.spawners

		if node_children then
			_walk_nodes_recursive(node_children, node_func)
		end
	end
end

MutatorSpawner.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)
	MutatorSpawner.super.init(self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)

	self._uuid = math.uuid()
	self._is_active = true
	self._raycast_object = PhysicsWorld.make_raycast(self._physics_world, "closest", "types", "statics", "collision_filter", "filter_player_character_shooting_raycast_statics")

	if not self._is_server then
		return
	end

	self:_setup()
end

MutatorSpawner.add_spawn_point = function (self, unit, position, rotation, path_position, travel_distance, section, level_size)
	if not self._is_server then
		return
	end

	self._dirty_spawn_locations[#self._dirty_spawn_locations + 1] = {
		position = position,
		rotation = rotation,
		section = section,
		level_size = level_size,
	}
end

MutatorSpawner._sort_dirty_spawn_locations = function (self)
	local requested_size = self._template.size
	local sorted_positions = {}

	if requested_size then
		for i = 1, #self._dirty_spawn_locations do
			local dirty_spawn_point = self._dirty_spawn_locations[i]

			if not requested_size[dirty_spawn_point.level_size] or not dirty_spawn_point.level_size then
				self._dirty_spawn_locations[i] = nil
			end
		end

		for k, v in pairs(self._dirty_spawn_locations) do
			sorted_positions[#sorted_positions + 1] = v
		end

		self._dirty_spawn_locations = sorted_positions
	end
end

MutatorSpawner._setup = function (self)
	self._dirty_spawn_locations = self._template.spawn_locations()
	self._template_data = self._template
	self._spawn_point_sections = {}
	self._locations = {}
	self._valid_spawn_points = 0
	self._allowed_per_section = {}
	self._section_probabillity = {}
	self._spawn_type = self._template_data.spawn_type or "default"
	self._spawned_instanced_levels = {}

	local game_mode_manager = Managers.state.game_mode
	local game_mode = game_mode_manager:game_mode()
	local mission_name

	if game_mode:name() == "expedition" then
		mission_name = game_mode:get_current_level_name()
	else
		mission_name = Managers.state.mission:mission_name()
	end

	self._num_to_spawn = self._template_data.num_to_spawn or self._template_data.num_to_spawn_per_mission[mission_name]
	self._spawners = {}

	for i = 1, #self._template.spawners do
		local spawner_template = self._template.spawners[i]
		local class = require(spawner_template.class)

		table.insert(self._spawners, class:new(spawner_template.template))
	end
end

MutatorSpawner.reset = function (self)
	if not self._is_server then
		return
	end

	local nodes = self._spawners

	for i = 1, #nodes do
		if nodes[i].destroy then
			nodes[i]:destroy()
		end
	end

	self._spawners = nil
	self._chance_initialized = nil
	self._init_spawn_called = nil
	self._spawn_points_done = nil

	self:_setup()
	self:on_spawn_points_generated()
end

MutatorSpawner.deactivate = function (self)
	MutatorSpawner.super.deactivate(self)

	if not self._spawners then
		return
	end

	local nodes = self._spawners

	for i = 1, #nodes do
		if nodes[i].destroy then
			nodes[i]:destroy()
		end
	end
end

MutatorSpawner.on_gameplay_post_init = function (self, level, themes)
	if not self._is_server then
		return
	end

	self._allow_updating = true
end

MutatorSpawner.is_loading = function (self)
	return MutatorSpawner.super.is_loading(self) and self._init_spawn_called
end

MutatorSpawner._load_subnode_packages = function (self, package_scope)
	_walk_nodes_recursive(self._template.spawners, function (node)
		local asset_package = node.template and node.template.asset_package

		if asset_package then
			package_scope:add_package(asset_package)
		end
	end)
end

MutatorSpawner.on_spawn_points_generated = function (self, level, themes)
	if not self._spawn_points_done then
		self._spawn_points_done = true
	elseif self._spawn_points_done then
		return
	end

	local component_system = Managers.state.extension:system("component_system")
	local mutator_spawners = component_system:get_units_from_component_name("MutatorSpawner")

	if #mutator_spawners == 0 then
		Log.warning("MutatorSpawn", "No MutatorSpawner components found in the level.")
	end

	for i = 1, #mutator_spawners do
		local fog_unit = mutator_spawners[i]
		local components = Component.get_components_by_name(fog_unit, "MutatorSpawner")

		for ii = 1, #components do
			local component = components[ii]
			local component_data = component:get_position_data()

			self._dirty_spawn_locations[#self._dirty_spawn_locations + 1] = {
				position = component_data.position,
				rotation = component_data.rotation,
				section = component_data.section,
				level_size = component_data.level_size,
			}
		end
	end

	self:_sort_dirty_spawn_locations()

	local trigger_distance = self._template_data.trigger_distance
	local spawn_locations = self._dirty_spawn_locations
	local nav_world = self._nav_world
	local main_path_manager = Managers.state.main_path
	local main_path_segments = main_path_manager:main_path_segments()
	local total_path_distance = MainPathQueries.total_path_distance()
	local num_sections = 0
	local num_spawn_locations = spawn_locations and #spawn_locations or 0

	for i = 1, num_spawn_locations do
		num_sections = math.max(num_sections, spawn_locations[i].section or 0)
	end

	for i = 1, num_spawn_locations do
		local dirty_spawn_data = spawn_locations[i]
		local wanted_position = dirty_spawn_data.position:unbox()
		local nav_mesh_position = NavQueries.position_on_mesh_guaranteed(nav_world, wanted_position, NAV_MESH_ABOVE, NAV_MESH_BELOW)

		if nav_mesh_position then
			local flat_displacement = Vector3.distance(Vector3.flat(nav_mesh_position), Vector3.flat(wanted_position))

			if flat_displacement > MAX_PROJECTION_HORIZONTAL_DISPLACEMENT then
				nav_mesh_position = nil
			end
		end

		if nav_mesh_position then
			local travel_distance = MainPathQueries.closest_travel_distance_vertical_aware(main_path_segments, nav_mesh_position, MAX_TRAVEL_DISTANCE_Z_DIFF)

			travel_distance = travel_distance or main_path_manager:travel_distance_from_position(nav_mesh_position)

			local section = dirty_spawn_data.section

			if section and num_sections > 0 and total_path_distance and total_path_distance > 0 then
				local computed_section = math.clamp(math.ceil(travel_distance / total_path_distance * num_sections), 1, num_sections)
			end

			local wanted_distance = travel_distance - trigger_distance
			local rotation = dirty_spawn_data.rotation
			local level_size = dirty_spawn_data.level_size
			local spawn_point = {
				position = Vector3Box(nav_mesh_position),
				spawn_travel_distance = wanted_distance,
				spawn_point_travel_distance = travel_distance,
				rotation = rotation,
				level_size = level_size,
			}
			local spawn_point_sections = self._spawn_point_sections
			local spawn_point_section = spawn_point_sections[section]

			if spawn_point_section then
				spawn_point_section[#spawn_point_section + 1] = spawn_point
				self._allowed_per_section[section] = self._allowed_per_section[section] + 1
			else
				spawn_point_sections[section] = {
					spawn_point,
				}
				self._section_probabillity[section] = 0
				self._allowed_per_section[section] = 1
			end

			self._valid_spawn_points = self._valid_spawn_points + 1
		end
	end

	for section = 1, num_sections do
		if not self._spawn_point_sections[section] then
			self._spawn_point_sections[section] = {}
			self._section_probabillity[section] = 0
			self._allowed_per_section[section] = 0
		end
	end

	if self._num_to_spawn > self._valid_spawn_points then
		self._num_to_spawn = self._valid_spawn_points
	end

	self:_initialize_probability()
	self:_add_location_spawns()

	if self._template.allowed_sections then
		for i = #self._locations, 1, -1 do
			if not table.array_contains(self._template.allowed_sections, self._locations[i].section) then
				table.swap_delete(self._locations, i)
			end
		end
	end
end

MutatorSpawner.update = function (self, dt, t)
	if not self._is_server then
		return
	end

	if not self._init_spawn_called then
		if #self._locations > 0 and not MutatorSpawner.super.is_loading(self) then
			self:_trigger_on_init_spawns()
		end

		return
	end

	if not self._allow_updating then
		return
	end

	local spawn_type = self._spawn_type

	if spawn_type == spawn_types.default then
		local ahead_target_unit, ahead_travel_distance = Managers.state.main_path:ahead_unit(TARGET_SIDE_ID)

		if not ahead_target_unit then
			return
		end

		local locations = self._locations

		for i = #locations, 1, -1 do
			local location = locations[i]
			local spawn_travel_distance = location.travel_distance

			if spawn_travel_distance <= ahead_travel_distance then
				self:_trigger_runtime_spawn(location, ahead_target_unit)
				table.remove(locations, i)

				break
			end
		end
	end

	if spawn_type == spawn_types.proximity then
		local side_system = Managers.state.extension:system("side_system")
		local player_side = side_system:get_side(TARGET_SIDE_ID)
		local valid_player_positions = player_side.valid_player_units_positions

		for i = 1, #valid_player_positions do
			local player_position = valid_player_positions[i]

			PLAYER_POSITIONS[#PLAYER_POSITIONS + 1] = player_position
		end

		local proximity_trigger_distance = self._template_data.proximity_trigger_distance
		local locations = self._locations

		for i = #locations, 1, -1 do
			local location = locations[i]
			local spawn_position = location.position

			for ii = 1, #PLAYER_POSITIONS do
				local player_pos = PLAYER_POSITIONS[ii]
				local distance = vector3_distance(spawn_position:unbox(), player_pos)

				if distance <= proximity_trigger_distance then
					self:_trigger_runtime_spawn(location)
					table.remove(locations, i)

					break
				end
			end
		end

		table.clear(PLAYER_POSITIONS)
	end
end

MutatorSpawner._initialize_probability = function (self)
	if self._chance_initialized then
		return
	end

	self._chance_initialized = true

	local weights = self._section_probabillity
	local num_available = 0

	for i = 1, #weights do
		if self._allowed_per_section[i] > 0 then
			num_available = num_available + 1
		end
	end

	local initial_chance = num_available > 0 and 1 / num_available or 0

	for i = 1, #weights do
		if self._allowed_per_section[i] > 0 then
			weights[i] = math.floor(initial_chance * 100) / 100
		else
			weights[i] = 0
		end
	end

	if self._template.allowed_sections then
		local redistribute_to_sections = 0

		for i = 1, #weights do
			if not table.array_contains(self._template.allowed_sections, i) then
				weights[i] = 0
				redistribute_to_sections = redistribute_to_sections + self._allowed_per_section[i]
				self._allowed_per_section[i] = 0
			end
		end

		redistribute_to_sections = redistribute_to_sections / #self._template.allowed_sections

		for i = 1, #self._template.allowed_sections do
			local section_idx = self._template.allowed_sections[i]

			self._allowed_per_section[section_idx] = self._allowed_per_section[section_idx] + redistribute_to_sections

			if self._template.max_spawned_per_section then
				self._allowed_per_section[section_idx] = math.clamp(self._allowed_per_section[section_idx], 0, self._template.max_spawned_per_section)
			end

			self._allowed_per_section[section_idx] = math.clamp(self._allowed_per_section[section_idx], 0, #self._spawn_point_sections[section_idx])
		end
	end

	self._base_section_weights = weights

	local prob, alias = LoadedDice.create(weights, false)

	self._section_probabillity = {
		probability = prob,
		alias = alias,
	}
end

MutatorSpawner._calculate_probabillity = function (self, picked_section, remove_chance)
	local weights = self._base_section_weights
	local picked_weight = weights[picked_section]
	local removed_weight

	if remove_chance then
		removed_weight = picked_weight
		weights[picked_section] = 0
	else
		removed_weight = picked_weight / 2
		weights[picked_section] = picked_weight / 2
	end

	local num_receivers = 0

	for i = 1, #weights do
		if i ~= picked_section then
			if self._allowed_per_section[i] <= 0 then
				removed_weight = removed_weight + weights[i]
				weights[i] = 0
			else
				num_receivers = num_receivers + 1
			end
		end
	end

	if num_receivers > 0 then
		local share = removed_weight / num_receivers

		for i = 1, #weights do
			if i ~= picked_section and self._allowed_per_section[i] > 0 then
				weights[i] = weights[i] + share
			end
		end
	elseif weights[picked_section] <= 0 then
		return
	end

	self._base_section_weights = weights

	local prob, alias = LoadedDice.create(weights, false)

	self._section_probabillity = {
		probability = prob,
		alias = alias,
	}
end

MutatorSpawner._is_separated_from_locations = function (self, spawn_point, locations, min_separation)
	local position = spawn_point.position:unbox()

	for i = 1, #locations do
		local location_position = locations[i].position:unbox()

		if min_separation > Vector3.distance(position, location_position) then
			return false
		end
	end

	return true
end

MutatorSpawner._pick_spawn_point = function (self, locations, min_separation)
	local spawn_point_sections = self._spawn_point_sections
	local allowed_per_section = self._allowed_per_section
	local num_pick_attempts = 20

	for _ = 1, num_pick_attempts do
		local weights = self._section_probabillity
		local section_index = LoadedDice.roll(weights.probability, weights.alias)

		if section_index and allowed_per_section[section_index] and allowed_per_section[section_index] > 0 then
			local section = spawn_point_sections[section_index]
			local spawn_point_index = math.random(#section)
			local spawn_point = section[spawn_point_index]

			if not min_separation or self:_is_separated_from_locations(spawn_point, locations, min_separation) then
				return section_index, spawn_point_index, spawn_point
			end
		end
	end
end

MutatorSpawner._add_location_spawns = function (self)
	local locations = {}
	local spawn_point_sections = self._spawn_point_sections
	local num_to_spawn = self._num_to_spawn
	local min_separation = self._template.min_location_separation or DEFAULT_MIN_LOCATION_SEPARATION

	for i = 1, num_to_spawn do
		local section_index, spawn_point_index, spawn_point = self:_pick_spawn_point(locations, min_separation)

		if not section_index then
			section_index, spawn_point_index, spawn_point = self:_pick_spawn_point(locations, nil)
		end

		if not section_index then
			break
		end

		local location = {
			travel_distance = spawn_point.spawn_travel_distance,
			position = spawn_point.position,
			section = section_index,
			rotation = spawn_point.rotation,
			level_size = spawn_point.level_size,
		}

		locations[#locations + 1] = location

		local section = spawn_point_sections[section_index]

		self._allowed_per_section[section_index] = self._allowed_per_section[section_index] - 1

		table.swap_delete(section, spawn_point_index)
		self:_calculate_probabillity(section_index, self._allowed_per_section[section_index] <= 0)
	end

	self._locations = locations
end

MutatorSpawner._trigger_runtime_spawn = function (self, location, ahead_target_unit)
	local spawn_position = location.position:unbox()
	local optional_spawn_rotation = location.rotation
	local optional_level_size = location.level_size
	local nodes = self._spawners

	for i = 1, #nodes do
		if nodes[i]:is_runtime() then
			nodes[i]:trigger_spawn(self._raycast_object, spawn_position, ahead_target_unit, optional_spawn_rotation, optional_level_size)
		end
	end
end

MutatorSpawner._trigger_on_init_spawns = function (self)
	self._init_spawn_called = true

	local locations = self._locations

	for i = #locations, 1, -1 do
		local location = locations[i]

		self:_trigger_init_spawn(location)
	end
end

MutatorSpawner._trigger_init_spawn = function (self, location)
	local spawn_position = location.position:unbox()
	local optional_spawn_rotation = location.rotation
	local optional_level_size = location.level_size
	local nodes = self._spawners

	for i = 1, #nodes do
		if nodes[i]:should_run_on_init() then
			nodes[i]:trigger_spawn(self._raycast_object, spawn_position, nil, optional_spawn_rotation, optional_level_size)
		end
	end
end

return MutatorSpawner
