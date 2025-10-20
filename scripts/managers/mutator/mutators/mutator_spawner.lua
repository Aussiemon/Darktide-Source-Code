-- chunkname: @scripts/managers/mutator/mutators/mutator_spawner.lua

require("scripts/managers/mutator/mutators/mutator_base")

local NavQueries = require("scripts/utilities/nav_queries")
local LoadedDice = require("scripts/utilities/loaded_dice")
local MutatorMonsterSpawnerSettings = require("scripts/settings/mutator/mutator_monster_spawner_settings")
local MutatorSpawner = class("MutatorSpawner", "MutatorBase")
local spawn_types = table.enum("proximity", "default")
local TARGET_SIDE_ID = 1
local PLAYER_POSITIONS = {}
local vector3_distance = Vector3.distance
local NAV_MESH_ABOVE, NAV_MESH_BELOW = 5, 5

local function _walk_nodes_recursive(nodes, node_fun)
	for i = 1, #nodes do
		node_fun(nodes[i])

		local node_children = nodes[i]:children()

		if node_children then
			_walk_nodes_recursive(node_children, node_fun)
		end
	end
end

MutatorSpawner.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)
	MutatorSpawner.super.init(self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)

	self._uuid = math.uuid()
	self._is_active = true
	self._raycast_object = PhysicsWorld.make_raycast(self._physics_world, "closest", "types", "statics")

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

	mission_name = Managers.state.mission:mission_name()
	self._num_to_spawn = self._template_data.num_to_spawn or self._template_data.num_to_spawn_per_mission[mission_name]
end

MutatorSpawner.reset = function (self)
	if not self._is_server then
		return
	end

	local nodes = self._template.spawners

	for i = 1, #nodes do
		if nodes[i]:destroy() then
			nodes[i]:destroy()
		end
	end

	self._chance_initialized = nil
	self._init_spawn_called = nil
	self._spawn_points_done = nil

	self:_setup()
	self:on_spawn_points_generated()
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
		local asset_package = node:asset_package()

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

	self:_sort_dirty_spawn_locations()

	local trigger_distance = self._template_data.trigger_distance
	local spawn_locations = self._dirty_spawn_locations
	local nav_world = self._nav_world
	local num_spawn_locations = spawn_locations and #spawn_locations or 0

	for i = 1, num_spawn_locations do
		local dirty_spawn_data = spawn_locations[i]
		local nav_mesh_position = NavQueries.position_on_mesh_guaranteed(nav_world, dirty_spawn_data.position:unbox(), NAV_MESH_ABOVE, NAV_MESH_BELOW)

		if nav_mesh_position then
			local travel_distance = Managers.state.main_path:travel_distance_from_position(nav_mesh_position)
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
			local section = dirty_spawn_data.section
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

	if self._num_to_spawn > self._valid_spawn_points then
		Log.warning("[MutatorMonsterSpawner]", "Requested %s spawns but we only have %s possible spawn points. Clamped.", self._num_to_spawn, self._valid_spawn_points)

		self._num_to_spawn = self._valid_spawn_points
	end

	self:_calculate_probabillity(nil, nil)
	self:_add_location_spawns()
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
				local distance_sq = vector3_distance(spawn_position:unbox(), player_pos)

				if distance_sq <= proximity_trigger_distance then
					self:_trigger_runtime_spawn(location)
					table.remove(locations, i)

					break
				end
			end
		end

		table.clear(PLAYER_POSITIONS)
	end
end

MutatorSpawner._calculate_probabillity = function (self, optional_probabillity_reroll, remove_chance)
	if not self._chance_initialized then
		self._chance_initialized = true

		local weights = self._section_probabillity
		local num = 0
		local initial_chance = 1

		for i = 1, #weights do
			num = num + 1
		end

		initial_chance = initial_chance / num

		for ii = 1, #weights do
			weights[ii] = math.floor(initial_chance * 100) / 100
		end

		local prob, alias = LoadedDice.create(weights, false)

		self._section_probabillity = {
			probability = prob,
			alias = alias,
		}
	else
		local weights = self._section_probabillity
		local add_to_other_probabillites
		local current_value = weights.probability[optional_probabillity_reroll]

		current_value = current_value / 2

		if remove_chance then
			add_to_other_probabillites = current_value
			current_value = 0
		else
			add_to_other_probabillites = current_value / 2
		end

		for i = 1, #weights.probability do
			if i == optional_probabillity_reroll then
				weights.probability[i] = current_value
			elseif self._allowed_per_section[i] == 0 then
				add_to_other_probabillites = add_to_other_probabillites + add_to_other_probabillites
			else
				weights.probability[i] = weights.probability[i] + add_to_other_probabillites
			end
		end

		local prob, alias = LoadedDice.create(weights.probability, false)

		self._section_probabillity = {
			probability = prob,
			alias = alias,
		}
	end
end

MutatorSpawner._add_location_spawns = function (self)
	local locations = {}
	local spawn_point_sections = self._spawn_point_sections
	local num_to_spawn = self._num_to_spawn

	for i = 1, num_to_spawn do
		local weights = self._section_probabillity
		local temp_section_index = LoadedDice.roll(weights.probability, weights.alias)
		local section = spawn_point_sections[temp_section_index]
		local spawn_point_index = math.random(#section)
		local spawn_point = section[spawn_point_index]
		local travel_distance = spawn_point.spawn_travel_distance
		local position = spawn_point.position
		local rotation = spawn_point.rotation
		local level_size = spawn_point.level_size
		local section_index = temp_section_index
		local location = {
			travel_distance = travel_distance,
			position = position,
			section = section_index,
			rotation = rotation,
			level_size = level_size,
		}

		locations[#locations + 1] = location
		self._allowed_per_section[temp_section_index] = self._allowed_per_section[temp_section_index] - 1

		if self._allowed_per_section[temp_section_index] == 0 then
			self:_calculate_probabillity(temp_section_index, true)
		else
			self:_calculate_probabillity(temp_section_index, false)
		end

		table.swap_delete(section, spawn_point_index)
	end

	self._locations = locations
end

MutatorSpawner._trigger_runtime_spawn = function (self, location, ahead_target_unit)
	local spawn_position = location.position:unbox()
	local optional_spawn_rotation = location.rotation
	local optional_level_size = location.level_size
	local nodes = self._template.spawners

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
	local nodes = self._template.spawners

	for i = 1, #nodes do
		if nodes[i]:should_run_on_init() then
			nodes[i]:trigger_spawn(self._raycast_object, spawn_position, nil, optional_spawn_rotation, optional_level_size)
		end
	end
end

return MutatorSpawner
