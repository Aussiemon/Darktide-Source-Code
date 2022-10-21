require("scripts/extension_systems/player_spawner/player_spawner_extension")

local MainPathQueries = require("scripts/utilities/main_path_queries")
local NavQueries = require("scripts/utilities/nav_queries")
local PlayerSpawnerSystem = class("PlayerSpawnerSystem", "ExtensionSystemBase")
PlayerSpawnerSystem.DEFAULT_SPAWN_IDENTIFIER = "default"
PlayerSpawnerSystem.DEFAULT_SPAWN_SIDE = "heroes"

PlayerSpawnerSystem.init = function (self, extension_init_context, system_init_data, ...)
	PlayerSpawnerSystem.super.init(self, extension_init_context, system_init_data, ...)

	if self._is_server then
		Managers.event:register(self, "in_safe_volume", "in_safe_volume")
	end

	self._spawn_points_by_identifier = {}
	self._next_spawn_point_index_by_identifier = {}
	self._in_safe_volume = true
end

PlayerSpawnerSystem.destroy = function (self)
	if self._is_server then
		Managers.event:unregister(self, "in_safe_volume")
	end
end

PlayerSpawnerSystem.in_safe_volume = function (self, in_volume)
	if not in_volume then
		self._in_safe_volume = false
	end
end

local function _sort_spawn_priority_func(a, b)
	local priority_a = a.spawn_priority
	local priority_b = b.spawn_priority

	return priority_a < priority_b
end

PlayerSpawnerSystem.add_spawn_point = function (self, unit, side, spawn_identifier, spawn_priority)
	local position = POSITION_LOOKUP[unit]
	local rotation = Unit.local_rotation(unit, 1)
	local spawn_point_data = {
		position = Vector3Box(position),
		rotation = QuaternionBox(rotation),
		spawn_priority = spawn_priority,
		side = side
	}
	local spawn_points = self._spawn_points_by_identifier[spawn_identifier]

	if spawn_points then
		spawn_points[#spawn_points + 1] = spawn_point_data

		table.sort(spawn_points, _sort_spawn_priority_func)
	else
		self._next_spawn_point_index_by_identifier[spawn_identifier] = 1
		self._spawn_points_by_identifier[spawn_identifier] = {
			spawn_point_data
		}
	end
end

PlayerSpawnerSystem.next_free_spawn_point = function (self, optional_spawn_identifier)
	local found, position, rotation, parent, side = nil

	if optional_spawn_identifier then
		found, position, rotation, side = self:_find_spawner_spawn_point(optional_spawn_identifier)
	end

	if not found and not self._in_safe_volume then
		found, position, rotation, parent, side = self:_find_progression_spawn_point()
	end

	if not found then
		local identifier = PlayerSpawnerSystem.DEFAULT_SPAWN_IDENTIFIER
		found, position, rotation, side = self:_find_spawner_spawn_point(identifier)
	end

	if not found then
		Log.warning("PlayerSpawnerSystem", "[next_free_spawn_point] No spawner found.\n%s", Script.callstack())

		position = Vector3.zero()
		rotation = Quaternion.identity()
		side = PlayerSpawnerSystem.DEFAULT_SPAWN_SIDE
	end

	return position, rotation, parent, side
end

PlayerSpawnerSystem._find_spawner_spawn_point = function (self, spawn_identifier)
	local spawn_points = self._spawn_points_by_identifier[spawn_identifier]

	if spawn_points == nil then
		return false
	end

	local next_spawn_point_index_by_identifier = self._next_spawn_point_index_by_identifier
	local spawn_point_index = next_spawn_point_index_by_identifier[spawn_identifier]
	local num_spawn_points = #spawn_points
	next_spawn_point_index_by_identifier[spawn_identifier] = spawn_point_index % num_spawn_points + 1
	local spawn_point = spawn_points[spawn_point_index]

	return true, spawn_point.position:unbox(), spawn_point.rotation:unbox(), spawn_point.side
end

PlayerSpawnerSystem._find_progression_spawn_point = function (self)
	local players = Managers.player:players()
	local lowest_travel_distance, furthest_back_unit = nil

	for _, player in pairs(players) do
		local player_unit = player.player_unit

		if player_unit then
			local player_pos = Unit.world_position(player_unit, 1)
			local _, travel_distance = MainPathQueries.closest_position(player_pos)

			if not lowest_travel_distance or travel_distance < lowest_travel_distance then
				lowest_travel_distance = travel_distance
				furthest_back_unit = player_unit
			end
		end
	end

	if furthest_back_unit then
		local locomotion_extension = ScriptUnit.extension(furthest_back_unit, "locomotion_system")
		local parent = locomotion_extension:get_parent_unit()
		local navigation_extension = ScriptUnit.extension(furthest_back_unit, "navigation_system")
		local from_position = navigation_extension:latest_position_on_nav_mesh()

		if from_position then
			local unit_data_extension = ScriptUnit.extension(furthest_back_unit, "unit_data_system")
			local first_person_component = unit_data_extension:read_component("first_person")
			local furthest_back_unit_rotation = first_person_component.rotation
			local query_direction = -Quaternion.forward(furthest_back_unit_rotation)
			local nav_world = navigation_extension:nav_world()
			local traverse_logic = navigation_extension:traverse_logic()
			local position = NavQueries.position_near_nav_position(from_position, query_direction, nav_world, traverse_logic)
			local furthest_back_unit_position = first_person_component.position
			local direction = Vector3.normalize(Vector3.flat(furthest_back_unit_position - position))
			local rotation = Quaternion.look(direction)

			return true, position, rotation, parent, PlayerSpawnerSystem.DEFAULT_SPAWN_SIDE
		elseif parent then
			return true, Unit.world_position(furthest_back_unit, 1), Unit.local_rotation(furthest_back_unit, 1), parent, PlayerSpawnerSystem.DEFAULT_SPAWN_SIDE
		end
	end

	return false
end

return PlayerSpawnerSystem
