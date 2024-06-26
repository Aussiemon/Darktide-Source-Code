﻿-- chunkname: @scripts/components/minion_spawner.lua

local Component = require("scripts/utilities/component")
local MinionSpawnerSpawnPosition = require("scripts/extension_systems/minion_spawner/utilities/minion_spawner_spawn_position")
local SharedNav = require("scripts/components/utilities/shared_nav")
local MinionSpawner = component("MinionSpawner")

MinionSpawner.init = function (self, unit, is_server)
	self._unit = unit
	self._is_server = is_server

	local spawner_extension = ScriptUnit.fetch_component_extension(unit, "minion_spawner_system")

	if spawner_extension then
		local spawner_groups, spawn_position_offset, exit_position_offset, anim_data, exclude_from_pacing, exclude_from_specials_pacing, spawn_type, exit_rotation_num_directions, exit_rotation_random_degree_range = self:_get_data(unit)

		self._anim_data = anim_data

		local tm = Unit.world_pose(unit, 1)
		local has_spawn_node = Unit.has_node(unit, "spawn_node")

		if has_spawn_node then
			local spawn_node = Unit.node(unit, "spawn_node")
			local spawn_node_position = Unit.world_position(unit, spawn_node)

			Matrix4x4.set_translation(tm, spawn_node_position)
		end

		local spawn_position = Matrix4x4.transform(tm, spawn_position_offset:unbox())
		local exit_position = Matrix4x4.transform(tm, exit_position_offset:unbox())

		spawner_extension:setup_from_component(spawner_groups, spawn_position, exit_position, exclude_from_pacing, exclude_from_specials_pacing, spawn_type, exit_rotation_num_directions, exit_rotation_random_degree_range)
	end
end

MinionSpawner._get_data = function (self, unit)
	local spawner_groups = self:get_data(unit, "spawner_groups")
	local spawn_position_offset = self:get_data(unit, "spawn_offset")
	local exit_position_offset = self:get_data(unit, "exit_offset")
	local anim_duration = self:get_data(unit, "duration")
	local anim_data

	if anim_duration ~= 0 then
		local anim_length = Unit.simple_animation_length(unit)
		local spawning_started_anim = {}

		spawning_started_anim.time_from = self:get_data(unit, "spawning_started_time_from") * anim_length
		spawning_started_anim.time_to = self:get_data(unit, "spawning_started_time_to") * anim_length
		spawning_started_anim.speed = (spawning_started_anim.time_to - spawning_started_anim.time_from) / anim_duration

		local spawning_done_anim = {}

		spawning_done_anim.time_from = self:get_data(unit, "spawning_done_time_from") * anim_length
		spawning_done_anim.time_to = self:get_data(unit, "spawning_done_time_to") * anim_length
		spawning_done_anim.speed = (spawning_done_anim.time_to - spawning_done_anim.time_from) / anim_duration
		anim_data = {
			spawning_started = spawning_started_anim,
			spawning_done = spawning_done_anim,
		}
	end

	local exclude_from_pacing = self:get_data(unit, "exclude_from_pacing")
	local exclude_from_specials_pacing = self:get_data(unit, "exclude_from_specials_pacing")
	local spawn_type = self:get_data(unit, "spawn_type")
	local exit_rotation_num_directions = self:get_data(unit, "exit_rotation_num_directions")
	local exit_rotation_random_degree_range = self:get_data(unit, "exit_rotation_random_degree_range")

	return spawner_groups, spawn_position_offset, exit_position_offset, anim_data, exclude_from_pacing, exclude_from_specials_pacing, spawn_type, exit_rotation_num_directions, exit_rotation_random_degree_range
end

MinionSpawner.destroy = function (self)
	return
end

MinionSpawner.enable = function (self, unit)
	return
end

MinionSpawner.disable = function (self, unit)
	return
end

MinionSpawner.events.minion_spawner_spawning_started = function (self)
	if self._is_server then
		Component.trigger_event_on_clients(self, "minion_spawner_spawning_started")
	end

	local anim_data = self._anim_data

	Unit.flow_event(self._unit, "lua_spawning_started")

	if anim_data then
		local data = anim_data.spawning_started

		Unit.play_simple_animation(self._unit, data.time_from, data.time_to, false, data.speed)
	end
end

MinionSpawner.events.minion_spawner_spawning_done = function (self)
	if self._is_server then
		Component.trigger_event_on_clients(self, "minion_spawner_spawning_done")
	end

	local anim_data = self._anim_data

	Unit.flow_event(self._unit, "lua_spawning_done")

	if anim_data then
		local data = anim_data.spawning_done

		Unit.play_simple_animation(self._unit, data.time_from, data.time_to, false, data.speed)
	end
end

MinionSpawner.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._unit = unit

	local world = Application.main_world()

	self._world = world
	self._line_object = World.create_line_object(world)
	self._drawer = DebugDrawer(self._line_object, "retained")

	local _, spawn_offset, exit_offset = self:_get_data(unit)

	self._spawn_offset = spawn_offset
	self._exit_offset = exit_offset

	if MinionSpawner._nav_info == nil then
		MinionSpawner._nav_info = SharedNav.create_nav_info()
	end

	self._my_nav_gen_guid = nil
	self._active_debug_draw = false
	self._should_debug_draw = false

	return true
end

MinionSpawner.editor_destroy = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local line_object = self._line_object
	local world = self._world

	LineObject.reset(line_object)
	LineObject.dispatch(world, line_object)
	World.destroy_line_object(world, line_object)

	self._line_object = nil
	self._world = nil
end

MinionSpawner.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return false
	end

	local with_traverse_logic = true
	local nav_gen_guid = SharedNav.check_new_navmesh_generated(MinionSpawner._nav_info, self._my_nav_gen_guid, with_traverse_logic)

	if nav_gen_guid then
		self._my_nav_gen_guid = nav_gen_guid

		self:_editor_debug_draw(unit)
	end

	local should_debug_draw = self._should_debug_draw

	if should_debug_draw ~= self._active_debug_draw and self._my_nav_gen_guid then
		self._active_debug_draw = should_debug_draw

		self:_editor_debug_draw(unit)
	end

	return true
end

MinionSpawner.editor_validate = function (self, unit)
	return true, ""
end

MinionSpawner._editor_debug_draw = function (self, unit)
	local drawer = self._drawer

	drawer:reset()

	if self._active_debug_draw then
		local nav_world = MinionSpawner._nav_info.nav_world
		local traverse_logic = MinionSpawner._nav_info.traverse_logic
		local spawn_offset = self._spawn_offset:unbox()
		local exit_offset = self._exit_offset:unbox()
		local tm = Unit.world_pose(unit, 1)
		local spawn_position = Matrix4x4.transform(tm, spawn_offset)
		local exit_position = Matrix4x4.transform(tm, exit_offset)
		local exit_position_on_nav_mesh = MinionSpawnerSpawnPosition.find_exit_position_on_nav_mesh(nav_world, spawn_position, exit_position, traverse_logic)

		drawer:sphere(spawn_position, 0.2, Color.white())

		if exit_position_on_nav_mesh then
			drawer:sphere(exit_position_on_nav_mesh, 0.2, Color.green())
			drawer:line(spawn_position, exit_position_on_nav_mesh, Color.green())
		else
			drawer:sphere(exit_position, 0.2, Color.red())
			drawer:line(spawn_position, exit_position, Color.red())
		end
	end

	drawer:update(self._world)
end

MinionSpawner.editor_world_transform_modified = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self:_editor_debug_draw(unit)
end

MinionSpawner.editor_toggle_debug_draw = function (self, enable)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._should_debug_draw = enable
end

MinionSpawner.debug_started_animation = function (self)
	Component.event(self._unit, "minion_spawner_spawning_started")
end

MinionSpawner.debug_done_animation = function (self)
	Component.event(self._unit, "minion_spawner_spawning_done")
end

MinionSpawner.component_data = {
	spawn_offset = {
		category = "Position Offset",
		step = 0.5,
		ui_name = "Spawn Position Offset",
		ui_type = "vector",
		value = Vector3Box(0, 0, 0),
	},
	exit_offset = {
		category = "Position Offset",
		step = 0.5,
		ui_name = "Exit Position Offset",
		ui_type = "vector",
		value = Vector3Box(0, 1, 0),
	},
	spawning_started_time_from = {
		category = "Spawning Started",
		decimals = 1,
		max = 1,
		min = 0,
		step = 0.1,
		ui_name = "Time From (Normalized)",
		ui_type = "number",
		value = 0,
	},
	spawning_started_time_to = {
		category = "Spawning Started",
		decimals = 1,
		max = 1,
		min = 0,
		step = 0.1,
		ui_name = "Time To (Normalized)",
		ui_type = "number",
		value = 1,
	},
	spawning_done_time_from = {
		category = "Spawning Done",
		decimals = 1,
		max = 1,
		min = 0,
		step = 0.1,
		ui_name = "Time From (Normalized)",
		ui_type = "number",
		value = 0,
	},
	spawning_done_time_to = {
		category = "Spawning Done",
		decimals = 1,
		max = 1,
		min = 0,
		step = 0.1,
		ui_name = "Time To (Normalized)",
		ui_type = "number",
		value = 1,
	},
	duration = {
		decimals = 1,
		min = 0,
		step = 0.1,
		ui_name = "Duration (0 if no animation)",
		ui_type = "number",
		value = 0,
	},
	spawner_groups = {
		category = "Spawner Groups",
		size = 0,
		ui_name = "Spawner Groups",
		ui_type = "text_box_array",
	},
	exclude_from_pacing = {
		ui_name = "Exclude From Pacing",
		ui_type = "check_box",
		value = false,
	},
	exclude_from_specials_pacing = {
		ui_name = "Exclude From Specials Pacing",
		ui_type = "check_box",
		value = false,
	},
	spawn_type = {
		ui_name = "Spawn Type(default, from_ground)",
		ui_type = "text_box",
		value = "default",
	},
	exit_rotation_random_degree_range = {
		ui_name = "Exit Rotation Degree Range",
		ui_type = "number",
		value = 0,
	},
	exit_rotation_num_directions = {
		ui_name = "Exit Rotation Num Directions",
		ui_type = "number",
		value = 0,
	},
	inputs = {
		debug_started_animation = {
			accessibility = "public",
			type = "event",
		},
		debug_done_animation = {
			accessibility = "public",
			type = "event",
		},
	},
	extensions = {
		"MinionSpawnerExtension",
	},
}

return MinionSpawner
