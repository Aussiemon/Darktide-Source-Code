-- chunkname: @scripts/components/monster_spawner.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local ChaosDaemonhostSettings = require("scripts/settings/monster/chaos_daemonhost_settings")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local MonsterSettings = require("scripts/settings/monster/monster_settings")
local NavQueries = require("scripts/utilities/nav_queries")
local NavTagVolumeBox = require("scripts/extension_systems/navigation/utilities/nav_tag_volume_box")
local SharedNav = require("scripts/components/utilities/shared_nav")
local action_data = BreedActions.chaos_daemonhost
local MonsterSpawner = component("MonsterSpawner")

local function _calculate_positions(unit)
	local main_path_connection_node = Unit.node(unit, "main_path_connection")
	local position = Unit.local_position(unit, 1)
	local main_path_connection_position = Unit.world_position(unit, main_path_connection_node)
	local path_position, travel_distance = MainPathQueries.closest_position(main_path_connection_position)

	return position, main_path_connection_position, path_position, travel_distance
end

local NAV_TAG_LAYER_NAME = "monster_pacing_no_spawn_volume"
local NAV_TAG_LAYER_TYPE = "content/volume_types/nav_tag_volumes/no_spawn"

MonsterSpawner.init = function (self, unit, is_server, nav_world)
	local position, _, path_position, travel_distance = _calculate_positions(unit)
	local spawn_type = self:get_data(unit, "spawn_type")

	if is_server then
		local section = self:get_data(unit, "section")
		local success = Managers.state.pacing:add_monster_spawn_point(unit, position, path_position, travel_distance, section, spawn_type)

		if not success then
			self._no_nav_mesh_found = true
		end
	end

	local no_spawn_volume_half_extents = MonsterSettings.no_spawn_volume_half_extents[spawn_type]

	if no_spawn_volume_half_extents then
		local half_extents = no_spawn_volume_half_extents:unbox()
		local center_position = position + Vector3(0, 0, half_extents.z)
		local pose = Unit.world_pose(unit, 1)

		Matrix4x4.set_translation(pose, center_position)

		local volume_points, volume_altitude_min, volume_altitude_max = NavTagVolumeBox.create_from_pose(nav_world, pose, half_extents)

		Managers.state.nav_mesh:add_nav_tag_volume(volume_points, volume_altitude_min, volume_altitude_max, NAV_TAG_LAYER_NAME, true, NAV_TAG_LAYER_TYPE)
	end

	local run_update = false

	return run_update
end

MonsterSpawner.destroy = function (self)
	return
end

MonsterSpawner.enable = function (self, unit)
	return
end

MonsterSpawner.disable = function (self, unit)
	return
end

MonsterSpawner.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local world = Application.main_world()

	self._world = world

	local line_object = World.create_line_object(world)

	self._line_object = line_object
	self._drawer = DebugDrawer(line_object, "retained")
	self._gui = World.create_world_gui(world, Matrix4x4.identity(), 1, 1)
	self._debug_text_id = nil
	self._section_debug_text_id = nil

	if MonsterSpawner._nav_info == nil then
		MonsterSpawner._nav_info = SharedNav.create_nav_info()
	end

	self._my_nav_gen_guid = nil
	self._debug_draw_enabled = false
	self._selected = false

	local object_id = Unit.get_data(unit, "LevelEditor", "object_id")

	self._object_id = object_id
	self._in_active_mission_table = LevelEditor:is_level_object_in_active_mission_table(object_id)

	return true
end

MonsterSpawner.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if not Unit.has_node(unit, "main_path_connection") then
		error_message = error_message .. "\nmissing unit node 'main_path_connection'"
		success = false
	end

	return success, error_message
end

MonsterSpawner.editor_destroy = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local world, line_object = self._world, self._line_object

	LineObject.reset(line_object)
	LineObject.dispatch(world, line_object)
	World.destroy_line_object(world, line_object)

	if MonsterSpawner._nav_info ~= nil then
		SharedNav.destroy(MonsterSpawner._nav_info)
	end

	local gui = self._gui

	if self._debug_text_id then
		Gui.destroy_text_3d(gui, self._debug_text_id)
	end

	if self._section_debug_text_id then
		Gui.destroy_text_3d(gui, self._section_debug_text_id)
	end

	World.destroy_gui(world, gui)
end

MonsterSpawner.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local with_traverse_logic = false
	local nav_gen_guid = SharedNav.check_new_navmesh_generated(MonsterSpawner._nav_info, self._my_nav_gen_guid, with_traverse_logic)

	if nav_gen_guid then
		self:_refresh_debug_draw(unit)

		self._my_nav_gen_guid = nav_gen_guid
	end

	return true
end

MonsterSpawner.editor_on_mission_changed = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._in_active_mission_table = LevelEditor:is_level_object_in_active_mission_table(self._object_id)

	self:_refresh_debug_draw(unit)
end

MonsterSpawner.editor_world_transform_modified = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self:_refresh_debug_draw(unit)
end

MonsterSpawner.editor_property_changed = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self:_refresh_debug_draw(unit)
end

MonsterSpawner.editor_selection_changed = function (self, unit, selected)
	self._selected = selected

	self:_refresh_debug_draw(unit)
end

MonsterSpawner._refresh_debug_draw = function (self, unit)
	local gui = self._gui
	local debug_text_id = self._debug_text_id

	if debug_text_id then
		Gui.destroy_text_3d(gui, debug_text_id)

		self._debug_text_id = nil
	end

	local section_debug_text_id = self._section_debug_text_id

	if section_debug_text_id then
		Gui.destroy_text_3d(gui, section_debug_text_id)

		self._section_debug_text_id = nil
	end

	local drawer = self._drawer

	drawer:reset()

	if self._debug_draw_enabled and self._in_active_mission_table then
		local show_main_path_connection = self:get_data(unit, "show_main_path_connection")

		self:_editor_debug_draw(unit, show_main_path_connection)
	end

	drawer:update(self._world)
end

local FONT = "core/editor_slave/gui/arial"
local FONT_MATERIAL = "core/editor_slave/gui/arial"
local FONT_SIZE = 0.3
local SECTION_FONT_SIZE = 1
local section_colors = {
	{
		0,
		255,
		255,
	},
	{
		0,
		255,
		0,
	},
	{
		255,
		255,
		255,
	},
	{
		255,
		125,
		0,
	},
	{
		255,
		20,
		147,
	},
	{
		93,
		0,
		9,
	},
}

MonsterSpawner._editor_debug_draw = function (self, unit, show_main_path_connection)
	local drawer = self._drawer

	if show_main_path_connection then
		self:_debug_draw_main_path_connection(unit, drawer)
	end

	if self._selected then
		local spawn_type = self:get_data(unit, "spawn_type")

		if spawn_type == "witches" then
			self:_debug_draw_witch_spawner(unit, drawer)
		end
	end
end

MonsterSpawner._debug_draw_main_path_connection = function (self, unit, drawer)
	local gui = self._gui
	local debug_text_id, section_debug_text_id
	local is_main_path_registered = MainPathQueries.is_main_path_registered()
	local failed_color = Color.red()

	if is_main_path_registered then
		local active_mission_level_id = LevelEditor:get_active_mission_level()
		local nav_world = MonsterSpawner._nav_info.nav_world_from_level_id[active_mission_level_id]
		local position, main_path_connection_position, path_position, travel_distance = _calculate_positions(unit)

		if nav_world then
			local section = self:get_data(unit, "section")
			local modulo = section % #section_colors + 1
			local section_color_table = section_colors[modulo]
			local section_color = Color(255, section_color_table[1], section_color_table[2], section_color_table[3])
			local text_position = position + Vector3.up() * 4
			local tm = Matrix4x4.from_translation(text_position)

			section_debug_text_id = Gui.text_3d(gui, section, FONT_MATERIAL, SECTION_FONT_SIZE, FONT, tm, Vector3.zero(), 3, section_color)

			local above, below, horizontal = 1, 1, 1
			local position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, position, above, below, horizontal)

			if position_on_navmesh then
				drawer:sphere(position_on_navmesh, 0.15, section_color)
				drawer:sphere(path_position, 0.15, section_color)
				drawer:capsule(main_path_connection_position, main_path_connection_position + Vector3.up(), 0.2, section_color)
				drawer:line(path_position, main_path_connection_position, section_color)

				local spawn_distance = travel_distance - MonsterSettings.spawn_distance
				local spawn_trigger_position = MainPathQueries.position_from_distance(spawn_distance)
				local position_behind = MainPathQueries.position_from_distance(spawn_distance - 2)
				local position_ahead = MainPathQueries.position_from_distance(spawn_distance + 2)
				local direction = Vector3.normalize(position_ahead - position_behind)
				local rotation = Quaternion.look(direction)
				local height = 2.5
				local pose = Matrix4x4.from_quaternion_position(rotation, spawn_trigger_position + Vector3.up() * height)
				local half_extents = Vector3(2.5, 0.15, height)

				drawer:box(pose, half_extents, section_color)
				drawer:capsule(main_path_connection_position, spawn_trigger_position, 0.6, section_color)
			else
				drawer:sphere(position, 0.3, failed_color)
				drawer:capsule(main_path_connection_position, main_path_connection_position + Vector3.up(), 0.2, failed_color)
				drawer:sphere(path_position, 0.3, failed_color)
				drawer:line(path_position, main_path_connection_position, failed_color)

				local text = "Monster spawner must be on navmesh."
				local text_color = failed_color
				local error_text_position = position + Vector3.up() * 3
				local error_tm = Matrix4x4.from_translation(error_text_position)

				debug_text_id = Gui.text_3d(gui, text, FONT_MATERIAL, FONT_SIZE, FONT, error_tm, Vector3.zero(), 3, text_color)
			end
		else
			local text = "Found no navmesh, generate navmesh."
			local text_color = failed_color
			local text_position = position + Vector3.up() * 3
			local tm = Matrix4x4.from_translation(text_position)

			debug_text_id = Gui.text_3d(gui, text, FONT_MATERIAL, FONT_SIZE, FONT, tm, Vector3.zero(), 3, text_color)
		end
	else
		local text = "Failed showing main path connection, need to generate main path."
		local text_color = failed_color
		local text_position = Unit.local_position(unit, 1) + Vector3.up() * 3
		local tm = Matrix4x4.from_translation(text_position)

		debug_text_id = Gui.text_3d(self._gui, text, FONT_MATERIAL, FONT_SIZE, FONT, tm, Vector3.zero(), 3, text_color)
	end

	self._debug_text_id = debug_text_id
	self._section_debug_text_id = section_debug_text_id
end

MonsterSpawner._debug_draw_witch_spawner = function (self, unit, drawer)
	local position = Unit.world_position(unit, 1)
	local no_spawn_volume_half_extents = MonsterSettings.no_spawn_volume_half_extents.witches
	local half_extents = no_spawn_volume_half_extents:unbox()
	local center_position = position + Vector3(0, 0, half_extents.z)
	local pose = Unit.world_pose(unit, 1)

	Matrix4x4.set_translation(pose, center_position)
	drawer:box(pose, half_extents, Color.orange())

	local anger_distances = ChaosDaemonhostSettings.anger_distances.passive

	for _, v in pairs(anger_distances) do
		local distance = v.distance

		drawer:circle(position, distance, Vector3.up() * 1.15, Color.magenta())
	end

	local passive_data = action_data.passive
	local flashlight_range = passive_data.flashlight_settings.range

	drawer:circle(position, flashlight_range, Vector3.up() * 1.15, Color.yellow())

	local suppression_radius = 2.2

	drawer:sphere(position + Vector3.up(), suppression_radius, Color.orange())
end

MonsterSpawner.editor_toggle_debug_draw = function (self, enable)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._debug_draw_enabled = enable

	self:_refresh_debug_draw(self.unit)
end

MonsterSpawner.component_data = {
	section = {
		max = 20,
		min = 1,
		step = 1,
		ui_name = "Section Id",
		ui_type = "number",
		value = 1,
	},
	show_main_path_connection = {
		ui_name = "Show Main Path Connection",
		ui_type = "check_box",
		value = false,
	},
	spawn_type = {
		ui_name = "Spawn Type",
		ui_type = "combo_box",
		value = "monsters",
		options_keys = {
			"monsters",
			"witches",
		},
		options_values = {
			"monsters",
			"witches",
		},
	},
}

return MonsterSpawner
