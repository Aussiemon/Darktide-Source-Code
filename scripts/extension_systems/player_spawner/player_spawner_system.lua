require("scripts/extension_systems/player_spawner/player_spawner_extension")

local MainPathQueries = require("scripts/utilities/main_path_queries")
local NavQueries = require("scripts/utilities/nav_queries")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
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

local progression_players = {}

PlayerSpawnerSystem._find_progression_spawn_point = function (self)
	table.clear(progression_players)

	local player_manager = Managers.player
	local players = player_manager:players()
	local bot_players = player_manager:players()

	for _, bot in pairs(bot_players) do
		self:_add_progression_player(bot)
	end

	for _, player in pairs(players) do
		self:_add_progression_player(player)
	end

	if #progression_players > 2 then
		local temp = progression_players[1]
		progression_players[1] = progression_players[2]
		progression_players[2] = temp
	end

	for i = 1, #progression_players do
		if not progression_players[i].disabled then
			local found, position, rotation, parent, side = self:_player_spawn_point(progression_players[i].unit)

			if found then
				return found, position, rotation, parent, side
			end
		end
	end

	for i = 1, #progression_players do
		if progression_players[i].disabled then
			local found, position, rotation, parent, side = self:_player_spawn_point(progression_players[i].unit)

			if found then
				return found, position, rotation, parent, side
			end
		end
	end

	Log.warning("PlayerSpawnerSystem", "[_find_progression_spawn_point] Failed to find progression point. %s players, %s bots with %s eligible units \n%s", #players, #bot_players, #progression_players, Script.callstack())

	for i = 1, #progression_players do
		local info = progression_players[i]

		Log.info("PlayerSpawnerSystem", "[_find_progression_spawn_point] eligible unit: %s, distance: %s, disabled: %s", info.unit, info.distance, info.disabled)
	end

	return false
end

PlayerSpawnerSystem._add_progression_player = function (self, player)
	local player_unit = player.player_unit

	if player_unit then
		local player_pos = Unit.world_position(player_unit, 1)
		local _, travel_distance = MainPathQueries.closest_position(player_pos)
		local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

		if unit_data_extension then
			local character_state_component = unit_data_extension:read_component("character_state")

			if not PlayerUnitStatus.is_dead_for_mission_failure(character_state_component) then
				local index = #progression_players

				for i = 1, #progression_players do
					if progression_players[i].distance < travel_distance then
						index = i

						break
					end
				end

				table.insert(progression_players, index, {
					unit = player_unit,
					distance = travel_distance,
					disabled = PlayerUnitStatus.requires_help(character_state_component)
				})
			end
		end
	end
end

PlayerSpawnerSystem._player_spawn_point = function (self, unit)
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local parent = locomotion_extension:get_parent_unit()
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	local from_position = navigation_extension:latest_position_on_nav_mesh()

	if from_position then
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local first_person_component = unit_data_extension:read_component("first_person")
		local position = from_position
		local furthest_back_unit_position = first_person_component.position
		local direction = Vector3.normalize(Vector3.flat(furthest_back_unit_position - position))
		local rotation = Quaternion.look(direction)

		return true, position, rotation, parent, PlayerSpawnerSystem.DEFAULT_SPAWN_SIDE
	elseif parent then
		return true, Unit.world_position(unit, 1), Unit.local_rotation(unit, 1), parent, PlayerSpawnerSystem.DEFAULT_SPAWN_SIDE
	end

	return false
end

return PlayerSpawnerSystem
