-- chunkname: @scripts/loading/expedition_spawner.lua

local Navigation = require("scripts/extension_systems/navigation/utilities/navigation")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local Expedition = require("scripts/utilities/expedition")
local AsyncExpeditionLevelSpawner = require("scripts/loading/async_expedition_level_spawner")
local ThemePackage = require("scripts/foundation/managers/package/utilities/theme_package")
local ScriptTheme = require("scripts/foundation/utilities/script_theme")
local BakeNavmesh = require("scripts/utilities/bake_navmesh")
local ASYNCHRONOUS_NAVMESH_GENERATION = DevParameters.expedition_async_nav_gen or true
local TEST_UNIT_FLOW_SPAWN_DELAY = ASYNCHRONOUS_NAVMESH_GENERATION

local function _log(...)
	Log.info("ExpeditionSpawner", ...)
end

local MAIN_PATH_STATE = table.enum("none", "spawn_point_generation", "occluded_points_generation", "exists")
local navtag_settings = {
	gameobject_id = 0,
	is_exclusive = false,
	layer_id = 0,
	smartobject_id = 0,
	user_data_id = 0,
	color = {
		201,
		255,
		94,
		0,
	},
}
local navgen_settings = {
	altitude_tolerance = 0.5,
	atomic_consume_units = true,
	cell_size = 3,
	consume_terrain = true,
	database_index = 0,
	entity_height = 1.6,
	entity_radius = 0.38,
	height_field_sampling = 1,
	min_navigable_surface = 0.5,
	output_type = 1,
	raster_precision = 0.1,
	sector_name = "world",
	slope_max = 60,
	step_max = 0.5,
	sector_id = math.uuid(),
}
local STATES = table.enum("none", "loading", "spawning", "post_spawn", "registering_levels", "done", "despawning_levels", "despawning_navigation")
local ExpeditionSpawner = class("ExpeditionSpawner")

ExpeditionSpawner.init = function (self, expedition_settings_template, section_structure)
	self._expedition_settings_template = expedition_settings_template
	self._expedition = section_structure
	self._state = STATES.none
	self._done = false
	self._spawn_main_path_state = MAIN_PATH_STATE.none
	self._main_path_level = nil
	self._level_spawn_queue = {}
	self._despawning_levels = {}
end

ExpeditionSpawner.expedition = function (self)
	return self._expedition
end

ExpeditionSpawner.settings_template = function (self)
	return self._expedition_settings_template
end

ExpeditionSpawner.assign_is_sever = function (self, is_server)
	self._is_server = is_server
end

ExpeditionSpawner.assign_world = function (self, world)
	self._world = world
end

ExpeditionSpawner.assign_nav_world = function (self, nav_world)
	self._nav_world = nav_world
end

ExpeditionSpawner.queue_levels_by_step = function (self, step_index)
	local expedition = self._expedition
	local section = expedition[step_index]
	local levels_data = section.levels_data

	for _, level_data in ipairs(levels_data) do
		self:add_level_to_queue(level_data)
	end
end

ExpeditionSpawner.spawn_queued_levels = function (self)
	self:_state_changed(STATES.spawning)
end

ExpeditionSpawner.add_level_to_queue = function (self, level_data)
	self._done = false
	self._level_spawn_queue[#self._level_spawn_queue + 1] = level_data
end

ExpeditionSpawner._start_spawn_level_at_location = function (self, level_name, position, rotation, included_object_sets, excluded_object_sets)
	local world = self._world
	local level_spawner = AsyncExpeditionLevelSpawner:new(world, level_name, position, rotation, DevParameters.expedition_time_sliced_max_dt_in_sec, included_object_sets, excluded_object_sets)

	return level_spawner
end

ExpeditionSpawner._get_level_unit_by_value_key = function (self, level, key, value)
	local level_units = Level.units(level)

	for i = 1, #level_units do
		local unit = level_units[i]

		if Unit.get_data(unit, key) == value then
			return unit
		end
	end
end

ExpeditionSpawner._get_level_unit_by_key = function (self, level, key)
	local level_units = Level.units(level)

	for i = 1, #level_units do
		local unit = level_units[i]

		if Unit.get_data(unit, key) ~= nil then
			return unit
		end
	end
end

ExpeditionSpawner.main_path_exists = function (self)
	return self._spawn_main_path_state == MAIN_PATH_STATE.exists
end

ExpeditionSpawner.loading = function (self)
	return self._state == STATES.loading
end

ExpeditionSpawner.spawning = function (self)
	return self._state == STATES.spawning
end

ExpeditionSpawner.done = function (self)
	return self._state == STATES.done
end

ExpeditionSpawner.despawning = function (self)
	return self._state == STATES.despawning_levels or self._state == STATES.despawning_navigation
end

ExpeditionSpawner.clear_done = function (self)
	self._done = false
end

ExpeditionSpawner._start_spawn_next_level = function (self, level_data)
	local world = self._world
	local level_name = level_data.level_name
	local position, rotation
	local template_type = level_data.template_type
	local template = Expedition.get_level_template_by_type(template_type)
	local position_and_rotation_function = template.position_and_rotation_function

	if position_and_rotation_function then
		position, rotation = position_and_rotation_function(level_data, world)
	end

	position = position or Vector3.zero()
	rotation = rotation or Quaternion.identity()

	local section = level_data.section
	local theme_tag = section.theme_tag

	if theme_tag and (level_data.is_location or level_data.is_safe_zone) then
		local theme_names = ThemePackage.level_resource_dependency_packages(level_name, theme_tag)

		if theme_names and #theme_names > 0 then
			level_data.theme_names = theme_names

			local reference_name = level_data.reference_name
			local themes = {}
			local themes_delayed_packages = level_data.themes_delayed_packages

			for _, theme_name in pairs(theme_names) do
				local theme = World.create_theme(world, theme_name)

				themes[#themes + 1] = theme

				local theme_delayed_package_id = Managers.package:load(theme_name, "ExpeditionSpawner_" .. reference_name .. "_" .. theme_name)

				themes_delayed_packages[theme_delayed_package_id] = theme_name
			end

			level_data.themes = themes
		end
	end

	local pre_spawn_function = template.pre_spawn_function

	if pre_spawn_function then
		pre_spawn_function(level_data, world)
	end

	local excluded_object_sets = level_data.excluded_object_sets
	local object_sets_to_hide = level_data.themes and ScriptTheme.object_sets_to_hide(level_data.themes)

	if object_sets_to_hide then
		for i = 1, #object_sets_to_hide do
			excluded_object_sets[#excluded_object_sets + 1] = object_sets_to_hide[i]
		end
	end

	local level_spawner = self:_start_spawn_level_at_location(level_name, position, rotation, nil, excluded_object_sets)

	level_data.level_spawner = level_spawner
	level_data.position = Vector3Box(position)
	level_data.rotation = QuaternionBox(rotation)
end

ExpeditionSpawner._complete_next_level_spawning = function (self, level_data, level, world)
	local reference_name = level_data.reference_name
	local section = level_data.section

	section[reference_name] = level
	level_data.level = level

	Level.set_data(level, "runtime_loaded_level", true)

	local template_type = level_data.template_type
	local template = Expedition.get_level_template_by_type(template_type)
	local on_spawned_function = template.on_spawned_function

	if on_spawned_function then
		on_spawned_function(level_data, world, self._expedition_settings_template)
	end

	if TEST_UNIT_FLOW_SPAWN_DELAY then
		local trigger_unit_spawned = false

		Level.finish_spawn_time_sliced(level, trigger_unit_spawned)
	end

	level_data.spawned = true
end

ExpeditionSpawner._register_level = function (self, level_data, wanted_level_id)
	local world = self._world
	local is_server = self._is_server
	local level = level_data.level
	local section = level_data.section
	local location_index = section.index
	local unit_spawner_manager = Managers.state.unit_spawner
	local level_units = Level.units(level, true)

	if is_server then
		local returned_id = unit_spawner_manager:register_dynamic_level_spawned_units_server(level, level_units)
	else
		unit_spawner_manager:register_dynamic_level_spawned_units_client(level, level_units, wanted_level_id)
	end

	if not TEST_UNIT_FLOW_SPAWN_DELAY then
		Level.finish_spawn_time_sliced(level)
	else
		Level.trigger_unit_spawned(level)
	end

	ScriptWorld.optimize_level_units(level)

	local position = level_data.position:unbox()
	local rotation = level_data.rotation:unbox()

	Managers.state.nav_mesh:add_nav_tag_volumes_for_level(level, position, rotation)

	local category_name
	local extension_manager = Managers.state.extension

	extension_manager:add_and_register_units(world, level_units, nil, category_name)

	if is_server then
		local destructible_system_unit_ids = {}

		for _, unit in ipairs(level_units) do
			local destructible_extension = ScriptUnit.has_extension(unit, "destructible_system")

			if destructible_extension then
				local _, level_unit_id = unit_spawner_manager:game_object_id_or_level_index(unit)

				destructible_system_unit_ids[#destructible_system_unit_ids + 1] = level_unit_id
			end
		end

		level_data.destructible_system_unit_ids = destructible_system_unit_ids
	end

	Level.set_flow_variable(level, "expedition_location_index", location_index)
	Level.trigger_level_spawned(level)
	Level.set_data(level, "server_level_id", wanted_level_id)

	local template_type = level_data.template_type
	local template = Expedition.get_level_template_by_type(template_type)
	local on_registered_function = template.on_registered_function

	if on_registered_function then
		on_registered_function(level_data, world)
	end

	level_data.wanted_level_id = nil
	level_data.level_id = wanted_level_id
end

ExpeditionSpawner._handle_next_level_spawning = function (self)
	local active_level_data_spawning = self._active_level_data_spawning

	if active_level_data_spawning then
		local level_spawner = active_level_data_spawning.level_spawner
		local done, world, level = level_spawner:update()

		if done then
			self:_complete_next_level_spawning(active_level_data_spawning, level, world)

			self._active_level_data_spawning = nil
		end
	else
		local next_queued_level_data = self:_get_next_level_in_queue()

		if next_queued_level_data then
			self._active_level_data_spawning = next_queued_level_data

			self:_start_spawn_next_level(next_queued_level_data)
		else
			return true
		end
	end

	return false
end

ExpeditionSpawner.main_path_exists = function (self)
	return self._spawn_main_path_state == MAIN_PATH_STATE.exists
end

ExpeditionSpawner.setup_main_path_for_level = function (self)
	local main_path_manager = Managers.state.main_path

	if self._spawn_main_path_state == MAIN_PATH_STATE.exists then
		self._spawn_main_path_state = MAIN_PATH_STATE.none

		main_path_manager:reset()
	end

	local use_nav_point_time_slice = true
	local main_path_resource_name = self._main_path_level .. "_main_path"

	if main_path_manager:setup_for_level(main_path_resource_name, use_nav_point_time_slice, self._main_path_level) and self._is_server then
		main_path_manager:generate_spawn_points()

		self._spawn_main_path_state = MAIN_PATH_STATE.spawn_point_generation
	end
end

ExpeditionSpawner._handle_main_path_setup = function (self)
	local path_state = self._spawn_main_path_state

	if path_state == MAIN_PATH_STATE.none or path_state == MAIN_PATH_STATE.exists then
		return false
	end

	local main_path_manager = Managers.state.main_path

	if path_state == MAIN_PATH_STATE.spawn_point_generation then
		if main_path_manager:update_time_slice_spawn_points() then
			self._spawn_main_path_state = MAIN_PATH_STATE.occluded_points_generation
		end
	elseif path_state == MAIN_PATH_STATE.occluded_points_generation and main_path_manager:update_time_slice_generate_occluded_points(DevParameters.expedition_time_sliced_max_dt_in_sec) then
		self._spawn_main_path_state = MAIN_PATH_STATE.exists
	end

	return true
end

ExpeditionSpawner._state_changed = function (self, new_state)
	local previous_state = self._server_level_state and self._server_level_state or "-"

	_log("[ExpeditionSpawner] - CHANING STATE: " .. new_state .. " - OLD STATE:" .. previous_state)

	self._state = new_state
end

ExpeditionSpawner.update = function (self, dt)
	do
		local main_path_not_setup = self:_handle_main_path_setup()

		if main_path_not_setup then
			return
		end
	end

	local state = self._state

	if state == STATES.spawning then
		local done = self:_handle_next_level_spawning()

		if done then
			self:post_levels_spawned_start()
		end
	elseif state == STATES.post_spawn then
		local done = self:is_post_levels_spawned_done()

		if done then
			self._navmesh_generation_job_id = nil
			self._done = true

			self:_state_changed(STATES.done)
		end
	elseif state == STATES.registering_levels then
		local extension_manager = Managers.state.extension
		local are_units_added_and_registered = extension_manager:update_time_slice_add_and_register_level_units()

		if are_units_added_and_registered then
			self:_state_changed(STATES.none)
		end
	elseif state == STATES.despawning_levels then
		local despawning_levels = self._despawning_levels
		local num_despawn_budget = DevParameters.expedition_num_levels_despawned_by_frame

		for level_data, section in pairs(despawning_levels) do
			if not self:_despawn_level(level_data) then
				num_despawn_budget = 0

				break
			end

			local reference_name = level_data.reference_name

			section[reference_name] = nil
			despawning_levels[level_data] = nil
			num_despawn_budget = num_despawn_budget - 1

			if num_despawn_budget <= 0 then
				break
			end
		end

		if num_despawn_budget > 0 then
			local main_path_manager = Managers.state.main_path

			self._spawn_main_path_state = MAIN_PATH_STATE.none

			main_path_manager:reset()

			local nav_data_created = self._nav_data_created

			if nav_data_created then
				GwNavData.remove_navdata(nav_data_created)

				self._nav_data_created = nil

				local flying_navigation_system = Managers.state.extension:system("flying_navigation_system")

				flying_navigation_system:remove_nav_data()
			end

			self:_state_changed(STATES.despawning_navigation)
		end
	elseif state == STATES.despawning_navigation then
		local done = self:_update_despawning_navigation(dt)

		if done then
			self:_state_changed(STATES.done)
		end
	end
end

ExpeditionSpawner._get_next_level_in_queue = function (self)
	if #self._level_spawn_queue == 0 then
		return nil
	end

	return table.remove(self._level_spawn_queue, 1)
end

ExpeditionSpawner.server_assign_register_spawned_levels = function (self, start_index)
	local is_server = self._is_server

	if not is_server then
		return
	end

	local expedition = self._expedition

	for _, section in ipairs(expedition) do
		local levels_data = section.levels_data

		for _, level_data in ipairs(levels_data) do
			if level_data.level and not level_data.level_id then
				local wanted_level_id = level_data.wanted_level_id

				if is_server and not wanted_level_id then
					start_index = start_index + 1
					level_data.wanted_level_id = start_index
				end
			end
		end
	end
end

ExpeditionSpawner.register_spawned_levels_sliced = function (self)
	local expedition = self._expedition
	local num_register_budget = DevParameters.expedition_num_levels_registered_by_frame

	for _, section in ipairs(expedition) do
		local levels_data = section.levels_data

		for _, level_data in ipairs(levels_data) do
			if level_data.level and not level_data.level_id then
				local wanted_level_id = level_data.wanted_level_id

				if wanted_level_id then
					self:_register_level(level_data, wanted_level_id)

					num_register_budget = num_register_budget - 1

					if num_register_budget <= 0 then
						goto label_1_0
					end
				end
			end
		end
	end

	::label_1_0::

	if num_register_budget > 0 then
		return true
	end
end

ExpeditionSpawner.has_spawned_levels = function (self)
	local expedition = self._expedition

	for _, section in ipairs(expedition) do
		local levels_data = section.levels_data

		for _, level_data in ipairs(levels_data) do
			if level_data.level and level_data.spawned then
				return true
			end
		end
	end

	return false
end

ExpeditionSpawner.register_spawned_level_by_expedition_level_id = function (self, expedition_level_id, wanted_level_id)
	local expedition = self._expedition

	for _, section in ipairs(expedition) do
		local levels_data = section.levels_data

		for _, level_data in ipairs(levels_data) do
			if level_data.expedition_level_id == expedition_level_id then
				if level_data.level_id ~= wanted_level_id then
					self:_register_level(level_data, wanted_level_id)
				end

				return
			end
		end
	end
end

ExpeditionSpawner._is_nav_generation_started = function (self)
	if self._navmesh_generation_job_id then
		return true
	end
end

ExpeditionSpawner._is_nav_generation_complete = function (self)
	if self._navmesh_generation_job_id then
		local world = self._world
		local nav_world = self._nav_world
		local done, navmesh = BakeNavmesh.is_navmesh_done(world, nav_world, self._navmesh_generation_job_id)

		if done then
			Managers.state.nav_mesh:set_async_paused(false)

			self._nav_data_created = navmesh

			return true
		end
	end

	return false
end

ExpeditionSpawner._create_levels_context = function (self)
	local levels = {}
	local expedition = self._expedition

	for _, section in ipairs(expedition) do
		local levels_data = section.levels_data

		for _, level_data in ipairs(levels_data) do
			if level_data.spawned then
				levels[#levels + 1] = {
					level_name = level_data.level_name,
					level = level_data.level,
					is_location = level_data.is_location,
					position = level_data.position,
				}
			end
		end
	end

	return levels
end

ExpeditionSpawner._generate_navdata = function (self)
	local nav_world = self._nav_world

	if nav_world then
		local bake_navmesh_context = {
			nav_world = nav_world,
			world = self._world,
			levels = self:_create_levels_context(),
		}
		local asynchronous = ASYNCHRONOUS_NAVMESH_GENERATION

		self._navmesh_generation_job_id = nil

		Managers.state.nav_mesh:set_async_paused(true)

		local nav_data, job_id = BakeNavmesh.run(navgen_settings, navtag_settings, bake_navmesh_context, asynchronous)

		self._nav_data_created = nav_data
		self._navmesh_generation_job_id = job_id
	end
end

ExpeditionSpawner._find_main_path_level = function (self)
	if self._nav_world and Managers.state.main_path then
		local expedition = self._expedition

		for _, section in ipairs(expedition) do
			local levels_data = section.levels_data

			for _, level_data in ipairs(levels_data) do
				if level_data.is_location and level_data.spawned then
					self._main_path_level = level_data.level_name

					break
				end
			end
		end
	end
end

ExpeditionSpawner.level_data_by_level_id = function (self, level_id)
	if self._nav_world and Managers.state.main_path then
		local expedition = self._expedition

		for _, section in ipairs(expedition) do
			local levels_data = section.levels_data

			for _, level_data in ipairs(levels_data) do
				local level = level_data.level

				if level and level_data.spawned then
					local server_level_id = Level.get_data(level, "server_level_id")

					if server_level_id == level_id then
						return level_data
					end
				end
			end
		end
	end
end

ExpeditionSpawner.apply_safe_zone_themes = function (self)
	self:_apply_safe_zone_themes_by_level_key("is_safe_zone")
end

ExpeditionSpawner.apply_location_themes = function (self)
	self:_apply_safe_zone_themes_by_level_key("is_location")
end

ExpeditionSpawner._apply_safe_zone_themes_by_level_key = function (self, key)
	local extension_manager = Managers.state.extension
	local shading_environment_system = extension_manager and extension_manager:system("shading_environment_system")
	local light_controller_system = extension_manager and extension_manager:system("light_controller_system")

	if shading_environment_system and light_controller_system then
		local expedition = self._expedition

		for _, section in ipairs(expedition) do
			local levels_data = section.levels_data

			for _, level_data in ipairs(levels_data) do
				if level_data[key] and level_data.spawned and not level_data.was_delayed_despawn then
					local themes = level_data.themes
					local force_reset = true

					shading_environment_system:on_theme_changed(themes, force_reset)
					light_controller_system:on_theme_changed(themes, force_reset)

					return
				end
			end
		end

		local force_reset = true

		shading_environment_system:on_theme_changed(nil, force_reset)
		light_controller_system:on_theme_changed(nil, force_reset)
	end
end

ExpeditionSpawner._apply_start_level_shading_environment = function (self)
	local expedition = self._expedition

	for _, section in ipairs(expedition) do
		local levels_data = section.levels_data

		for _, level_data in ipairs(levels_data) do
			if level_data.is_location then
				if level_data.level ~= nil then
					local world = self._world
					local levels = World.levels(world)
					local start_level = levels[1]
					local default_shading_environment = Level.get_data(level_data.level, "shading_environment")

					Level.set_data(start_level, "shading_environment", default_shading_environment)
				end

				break
			end
		end
	end
end

ExpeditionSpawner.start_level_loading = function (self)
	self:_state_changed(STATES.loading)
end

ExpeditionSpawner.post_levels_spawned_start = function (self)
	self:_state_changed(STATES.post_spawn)
	self:_find_main_path_level()
	self:_generate_navdata()
	self:_apply_start_level_shading_environment()
end

ExpeditionSpawner.generate_navdata = function (self)
	self:_generate_navdata()
end

ExpeditionSpawner.is_post_levels_spawned_done = function (self)
	local complete = true
	local is_nav_generation_started = self:_is_nav_generation_started()
	local is_nav_generation_complete

	if is_nav_generation_started then
		is_nav_generation_complete = self:_is_nav_generation_complete()

		if not is_nav_generation_complete then
			complete = false
		end

		if is_nav_generation_complete and not GwNavData.is_alive_in_database(self._nav_data_created) then
			complete = false
		end
	end

	if complete and Managers.state.nav_mesh then
		Managers.state.nav_mesh:_make_sparse_graph_dirty()
	end

	return complete
end

ExpeditionSpawner.start_despawning = function (self)
	self:_state_changed(STATES.despawning_levels)
	Managers.state.nav_mesh:_disconnect_sparse_graph()

	local despawning_levels = self._despawning_levels

	table.clear(despawning_levels)

	local expedition = self._expedition

	for _, section in ipairs(expedition) do
		local levels_data = section.levels_data

		for _, level_data in ipairs(levels_data) do
			if level_data.spawned then
				if level_data.delayed_despawn then
					level_data.delayed_despawn = false
					level_data.was_delayed_despawn = true
				else
					despawning_levels[level_data] = section
				end
			end
		end
	end
end

ExpeditionSpawner.despawn_levels_sync = function (self)
	local expedition = self._expedition

	for _, section in ipairs(expedition) do
		local levels_data = section.levels_data

		for i = #levels_data, 1, -1 do
			local level_data = levels_data[i]

			if level_data.spawned then
				repeat
					-- Nothing
				until self:_despawn_level(level_data)

				local reference_name = level_data.reference_name

				section[reference_name] = nil
			end
		end
	end
end

ExpeditionSpawner._despawn_level = function (self, level_data)
	local level = level_data.level

	if not level_data.despawning then
		level_data.despawning = true

		local storyteller = World.storyteller(self._world)

		Storyteller.stop_all_from_level(storyteller, level)
	end

	local num_to_despawn = DevParameters.expedition_despawn_units_per_frame
	local level_units = Level.units(level, true)
	local num_units = #level_units

	if num_to_despawn < num_units and Managers.state.unit_spawner then
		local unit_spawner = Managers.state.unit_spawner

		for i = 1, num_to_despawn do
			local unit = level_units[i]

			unit_spawner:mark_for_deletion(unit)
		end

		return false
	else
		local extension_manager = Managers.state.extension

		if extension_manager then
			extension_manager:unregister_units(level_units, #level_units)
		end
	end

	local world_markers = level_data.world_markers

	if world_markers then
		local event_manager = Managers.event

		for k = 1, #world_markers do
			local marker_id = world_markers[k]

			event_manager:trigger("remove_world_marker", marker_id)
		end

		table.clear(world_markers)

		local world_markers_by_unit = level_data.world_markers_by_unit

		if world_markers_by_unit then
			table.clear(world_markers_by_unit)
		end
	end

	local template_type = level_data.template_type
	local template = Expedition.get_level_template_by_type(template_type)
	local on_despawned_function = template.on_despawned_function

	if on_despawned_function then
		on_despawned_function(level_data, self._world)
	end

	local is_registered = level_data.level_id ~= nil

	if is_registered then
		local unit_spawner_manager = Managers.state.unit_spawner

		if unit_spawner_manager then
			unit_spawner_manager:unregister_spawned_level(level)
		end
	end

	local networked_flow_state_manager = Managers.state.networked_flow_state

	if networked_flow_state_manager then
		networked_flow_state_manager:unregister_level(level)
	end

	local network_story_manager = Managers.state.network_story

	if network_story_manager then
		network_story_manager:unregister_level(level)
	end

	local nav_mesh_manager = Managers.state.nav_mesh

	if nav_mesh_manager then
		nav_mesh_manager:remove_nav_tag_volumes_for_level(level)
	end

	if self._is_server then
		local destructible_system_unit_ids = level_data.destructible_system_unit_ids

		if destructible_system_unit_ids then
			local destructible_system = Managers.state.extension and Managers.state.extension:system("destructible_system")

			if destructible_system then
				destructible_system:clear_unit_ids_from_removed_level_list(destructible_system_unit_ids)
			end
		end
	end

	local themes = level_data.themes

	if themes then
		for x = 1, #themes do
			local theme = themes[x]

			World.destroy_theme(self._world, theme)
		end

		level_data.themes = nil
	end

	Level.trigger_level_shutdown(level)
	World.destroy_level(self._world, level)

	level_data.level = nil
	level_data.spawned = false
	level_data.was_spawned = true
	level_data.despawning = false

	return true
end

ExpeditionSpawner._update_despawning_navigation = function (self, dt)
	local nav_graph_system = Managers.state.extension:system("nav_graph_system")

	if nav_graph_system:are_nav_graphs_pending_removal() then
		return false
	end

	if Managers.state.nav_mesh:are_nav_volumes_being_added_or_removed() then
		return false
	end

	local nav_data_created = self._nav_data_created

	if nav_data_created then
		local result = GwNavData.is_alive_in_database(nav_data_created)

		if result then
			return false
		end

		GwNavData.destroy(nav_data_created)

		self._nav_data_created = nil
	end

	return true
end

ExpeditionSpawner.unload_despawned_levels = function (self, on_shutdown)
	local expedition = self._expedition

	for _, section in ipairs(expedition) do
		local levels_data = section.levels_data

		for i = #levels_data, 1, -1 do
			local level_data = levels_data[i]

			if on_shutdown or level_data.can_unload_themes_delayed_packages then
				local themes_delayed_packages = level_data.themes_delayed_packages

				if themes_delayed_packages then
					for id, package_name in pairs(themes_delayed_packages) do
						Managers.package:release(id)

						themes_delayed_packages[id] = nil
					end
				end

				level_data.can_unload_themes_delayed_packages = nil
			end

			local level_loader = level_data.level_loader

			if level_loader and level_loader:is_loading_done() and not level_data.spawned and level_data.was_spawned then
				level_loader:destroy()

				level_data.level_loader = nil
				level_data.can_unload_themes_delayed_packages = true
			end
		end
	end
end

ExpeditionSpawner.is_all_level_loading_done = function (self)
	local expedition = self._expedition

	for _, section in ipairs(expedition) do
		local levels_data = section.levels_data

		for _, level_data in ipairs(levels_data) do
			local level_loader = level_data.level_loader

			if level_loader and not level_loader:is_loading_done() then
				return false
			end
		end
	end

	return true
end

ExpeditionSpawner.destroy = function (self)
	local on_shutdown = true

	self:despawn_levels_sync()
	self:unload_despawned_levels(on_shutdown)

	if self._nav_data_created then
		Navigation.remove_nav_data(self._nav_data_created)

		self._nav_data_created = nil
	end
end

return ExpeditionSpawner
