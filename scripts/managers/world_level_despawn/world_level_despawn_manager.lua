local GameplayInitTimeSlice = require("scripts/game_states/game/utilities/gameplay_init_time_slice")
local WorldLevelDespawnManager = class("WorldLevelDespawnManager")
local Unit_alive = Unit.alive
local MAX_DT_IN_MSEC = 16
local STATES = table.enum("idle", "despawn_units", "despawn_themes", "despawn_level", "despawn_world")

WorldLevelDespawnManager.init = function (self)
	self._state = STATES.idle
end

WorldLevelDespawnManager.destroy = function (self)
	self:flush()
end

WorldLevelDespawnManager.despawn = function (self, world, world_name, level, level_name, themes, use_time_slice)
	if self._state ~= STATES.idle then
		Log.info("WorldLevelDespawnManager", "Already despawning, flushing old despawn")
		self:flush()
	end

	Log.info("WorldLevelDespawnManager", "despawing world:%s, level:%s", world_name, level_name)

	self._world = world
	self._world_name = world_name
	self._level = level
	self._themes = themes

	self:_init_timeslice_despawn_units(level)

	self._state = STATES.despawn_units
	self._start_time = Managers.time:time("main")

	if Managers.world:is_world_enabled(world_name) then
		Managers.world:enable_world(world_name, false)
	end
end

WorldLevelDespawnManager.flush = function (self)
	if self._state == STATES.idle then
		return
	end

	Log.info("WorldLevelDespawnManager", "flushing")

	local world = self._world
	local themes = self._themes
	local level = self._level
	local World_destroy_theme = World.destroy_theme
	local world_name = self._world_name

	if themes then
		for i = 1, #themes do
			World_destroy_theme(world, themes[i])
		end
	end

	if world and level then
		World.destroy_level(world, level)
		self:_check_orphaned_units()
	end

	if world_name then
		Managers.world:destroy_world(world_name)
	end

	self._state = STATES.idle
end

WorldLevelDespawnManager.update = function (self, dt, t)
	local state = self._state

	if state == STATES.despawn_units then
		local done = self:_update_time_slice_despawn_units()

		if done then
			self._state = STATES.despawn_themes
		end
	elseif state == STATES.despawn_themes then
		Log.info("WorldLevelDespawnManager", "despawning themes")

		local world = self._world
		local themes = self._themes
		local World_destroy_theme = World.destroy_theme

		for i = 1, #themes do
			World_destroy_theme(world, themes[i])
		end

		self._themes = nil
		self._state = STATES.despawn_level
	elseif state == STATES.despawn_level then
		Log.info("WorldLevelDespawnManager", "despawning level")

		local level = self._level
		local world = self._world

		World.destroy_level(world, level)
		self:_check_orphaned_units()

		self._level = nil
		self._world = nil
		self._state = STATES.despawn_world
	elseif state == STATES.despawn_world then
		Log.info("WorldLevelDespawnManager", "despawning world")

		local world_name = self._world_name

		Managers.world:destroy_world(world_name)

		self._world_name = nil
		self._state = STATES.idle
		local total_time = Managers.time:time("main") - self._start_time

		Log.info("WorldLevelDespawnManager", "total despawn time: %s", total_time)
	elseif state == STATES.idle then
		-- Nothing
	end
end

WorldLevelDespawnManager.despawning = function (self)
	return self._state ~= STATES.idle
end

WorldLevelDespawnManager._init_timeslice_despawn_units = function (self, level)
	Log.info("WorldLevelDespawnManager", "despawning units")

	local time_slice_unit_despawn_data = {
		last_index = 0,
		ready = false,
		parameters = {}
	}
	time_slice_unit_despawn_data.parameters.unit_list_to_despawn = Level.units(level, true)
	self._time_slice_unit_despawn_data = time_slice_unit_despawn_data
end

WorldLevelDespawnManager._update_time_slice_despawn_units = function (self)
	local init_data = self._time_slice_unit_despawn_data
	local last_index = init_data.last_index
	local units_to_despawn = init_data.parameters.unit_list_to_despawn
	local num_units = #units_to_despawn
	local performance_counter_handle, duration_ms = GameplayInitTimeSlice.pre_loop()

	for index = last_index + 1, num_units do
		local start_timer = GameplayInitTimeSlice.pre_process(performance_counter_handle, duration_ms, MAX_DT_IN_MSEC)

		if not start_timer then
			break
		end

		local unit = units_to_despawn[index]

		self:_delete_unit(unit)

		init_data.last_index = index
		duration_ms = GameplayInitTimeSlice.post_process(performance_counter_handle, start_timer, duration_ms)
	end

	if init_data.last_index == num_units then
		GameplayInitTimeSlice.set_finished(init_data)
	end

	return init_data.ready
end

WorldLevelDespawnManager._delete_unit = function (self, unit)
	Unit.flow_event(unit, "cleanup_before_destroy")

	local unit_is_alive = Unit_alive(unit)

	Unit.flow_event(unit, "unit_despawned")

	local unit_world = Unit.world(unit)

	World.destroy_unit(unit_world, unit)
end

WorldLevelDespawnManager._check_orphaned_units = function (self)
	local world = self._world
	local remaining_units = World.units(world)
	local num_remaining_units = #remaining_units

	for i = 1, num_remaining_units do
		local unit = remaining_units[i]

		Log.error("WorldLevelDespawnManager", "Unregistering orphaned unit %s.", unit)
		self:_delete_unit(unit)
	end
end

return WorldLevelDespawnManager
