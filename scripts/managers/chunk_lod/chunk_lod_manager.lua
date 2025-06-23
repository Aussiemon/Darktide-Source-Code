-- chunkname: @scripts/managers/chunk_lod/chunk_lod_manager.lua

local ChunkLodUnits = require("scripts/managers/chunk_lod/chunk_lod_units")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local ChunkLodManager = class("ChunkLodManager")

ChunkLodManager.init = function (self, world, mission, local_player)
	self._local_player = local_player
	self._level_unit = nil
	self._world = world
	self._raycast_interval = 2
	self._raycast_timer = 0
	self._raycast_lengths = {
		free_flight = 10,
		first_person = 10
	}
	self._current_level_name = nil
	self._show_all = false
	self._active = true
	self._safe_raycast_cb = callback(self, "_async_raycast_result_cb")
	self._raycast_object = Managers.state.game_mode:create_safe_raycast_object("all", "types", "statics", "collision_filter", "filter_player_mover")
	self._chunk_units = {}
end

ChunkLodManager.player = function (self)
	return self._local_player
end

ChunkLodManager.set_level_unit = function (self, unit)
	local level = Unit.level(unit)
	local mission_level = Managers.state.mission:mission_level()

	if level and level ~= mission_level then
		self._level_unit = unit

		return true
	end

	return false
end

ChunkLodManager.clear_level_unit = function (self, unit)
	if unit == self._level_unit then
		self._level_unit = nil

		return true
	end

	return false
end

ChunkLodManager.register_unit = function (self, unit, callback_function)
	local world = Unit.world(unit)

	if world ~= self._world then
		return false
	end

	local level = Unit.level(unit)

	self._chunk_units[level] = self._chunk_units[level] or ChunkLodUnits:new(level)

	self._chunk_units[level]:register_unit(unit, callback_function)

	return true
end

ChunkLodManager.unregister_unit = function (self, unit)
	local level = Unit.level(unit)

	self._chunk_units[level]:unregister_unit(unit)
end

ChunkLodManager.update = function (self, dt, t)
	if not self._local_player or not self._active then
		return
	end

	local cinematic_manager = Managers.state.cinematic
	local cinematic_camera, is_testify_camera = cinematic_manager:active_camera()
	local is_in_cutscene = cinematic_camera ~= nil and not is_testify_camera

	if t > self._raycast_timer or not self._current_level_name or is_in_cutscene then
		self:_do_level_check(false, t)
	end
end

ChunkLodManager.current_chunk_name = function (self)
	return self._current_level_name
end

ChunkLodManager._try_update_level = function (self, hit_unit, force_show_all, is_using_cinematic_levels)
	local level = Unit.level(hit_unit)

	if level == nil then
		return
	end

	local level_name = Level.name(level)
	local show_all = is_using_cinematic_levels or force_show_all

	if self._current_level_name ~= level_name or self._show_all ~= show_all then
		self:_update_level_lods(level, show_all)

		self._current_level_name = level_name
		self._show_all = show_all
	end
end

ChunkLodManager.reset_timer = function (self)
	self._raycast_timer = Managers.time:time("main")
end

ChunkLodManager._do_level_check = function (self, force_show_all, t)
	local cinematic_manager = Managers.state.cinematic
	local cinematic_camera, is_testify_camera = cinematic_manager:active_camera()
	local is_using_cinematic_levels = cinematic_manager:is_using_cinematic_levels()

	self._raycast_timer = t + self._raycast_interval

	if not is_using_cinematic_levels and cinematic_camera ~= nil and not is_testify_camera then
		self:_try_update_level(cinematic_camera, force_show_all, is_using_cinematic_levels)
	elseif self._level_unit then
		self:_try_update_level(self._level_unit, force_show_all, is_using_cinematic_levels)
	else
		self:_detect_level_unit(force_show_all, is_using_cinematic_levels)
	end
end

ChunkLodManager._detect_level_unit = function (self, force_show_all, is_using_cinematic_levels)
	local from_position, _, length = self:_get_raycast_parameters()

	if not from_position then
		return
	end

	Managers.state.game_mode:add_safe_raycast(self._raycast_object, from_position, Vector3.down(), length, self._safe_raycast_cb, force_show_all, is_using_cinematic_levels)
end

local INDEX_ACTOR = 4

ChunkLodManager._async_raycast_result_cb = function (self, id, data, hits, num_hits)
	if num_hits <= 0 then
		return
	end

	local mission_manager = Managers.state.mission
	local mission_level = mission_manager:mission_level()
	local force_show_all = data[1]
	local is_using_cinematic_levels = data[2]

	for i = 1, num_hits do
		local result = hits[i]
		local actor = result[INDEX_ACTOR]
		local hit_unit = Actor.unit(actor)
		local level = Unit.level(hit_unit)

		if level and level ~= mission_level then
			return self:_try_update_level(hit_unit, force_show_all, is_using_cinematic_levels)
		end
	end
end

ChunkLodManager._get_raycast_parameters = function (self)
	local use_free_flight_camera_as_raycast_position
	local free_flight_manager = Managers.free_flight
	local is_in_free_flight = free_flight_manager and free_flight_manager:is_in_free_flight() and use_free_flight_camera_as_raycast_position

	if not is_in_free_flight then
		local player = self._local_player
		local viewport_name = player.viewport_name
		local camera_manager = Managers.state.camera

		if camera_manager:has_camera(viewport_name) then
			local position = camera_manager:camera_position(viewport_name)
			local rotation = camera_manager:camera_rotation(viewport_name)
			local raycast_length = self._raycast_lengths.first_person

			return position, rotation, raycast_length
		end
	else
		local free_flight_position, free_flight_rotation = free_flight_manager:camera_position_rotation("global")
		local position = free_flight_position
		local rotation = free_flight_rotation
		local raycast_length = self._raycast_lengths.free_flight

		return position, rotation, raycast_length
	end
end

ChunkLodManager._get_neighbours = function (self, level, ...)
	local i = 1
	local neighbours = {}

	while Level.has_data(level, ..., i) do
		local neighbour_data = {}
		local neighbour_level_name = Level.get_data(level, ..., i, "level")
		local neighbour_lod_state = Level.get_data(level, ..., i, "state")

		neighbour_data.level_name = neighbour_level_name
		neighbour_data.lod_state = neighbour_lod_state
		neighbours[#neighbours + 1] = neighbour_data
		i = i + 1
	end

	return neighbours
end

ChunkLodManager._set_show_chunk_units = function (self, level, show_units)
	local chunk_lod_units = self._chunk_units[level]

	if chunk_lod_units then
		chunk_lod_units:set_visibility_state(show_units)
	end
end

ChunkLodManager._update_level_lods = function (self, level, show_all)
	local world = self._world
	local neighbours = self:_get_neighbours(level, "neighbour_states")
	local level_set_lod_level_type = Level.set_lod_level_type

	level_set_lod_level_type(level, LodLevelType.SHOW_LEVEL)
	Level.trigger_event(level, "set_lod_level_type_show_level")
	self:_set_show_chunk_units(level, true)

	if #neighbours > 0 then
		for _, neighbour in ipairs(neighbours) do
			local lod_state = neighbour.lod_state
			local neighbour_level_name = neighbour.level_name

			if Application.can_get_resource("level", neighbour_level_name) then
				local neighbour_level = ScriptWorld.level(world, neighbour_level_name .. ".level")
				local show_units = lod_state == "Full" or show_all

				if show_units then
					level_set_lod_level_type(neighbour_level, LodLevelType.SHOW_LEVEL)
					Level.trigger_event(neighbour_level, "set_lod_level_type_show_level")
				else
					if lod_state == "Proxy" then
						level_set_lod_level_type(neighbour_level, LodLevelType.SHOW_LOD_UNIT)
						Level.trigger_event(neighbour_level, "set_lod_level_type_show_lod_unit")
					end

					if lod_state == "None" then
						level_set_lod_level_type(neighbour_level, LodLevelType.HIDE)
						Level.trigger_event(neighbour_level, "set_lod_level_type_hide")
					end
				end

				self:_set_show_chunk_units(neighbour_level, show_units)
			end
		end
	end
end

ChunkLodManager.enable = function (self)
	self._active = true

	self:_do_level_check(true, 0)
end

ChunkLodManager.disable = function (self)
	self._active = false
	self._current_level_name = nil

	self:_do_level_check(false, 0)
end

return ChunkLodManager
