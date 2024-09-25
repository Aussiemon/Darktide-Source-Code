﻿-- chunkname: @scripts/components/minion_multi_teleporter.lua

local MinionMultiTeleporterQueries = require("scripts/components/utilities/minion_multi_teleporter_queries")
local SharedNav = require("scripts/components/utilities/shared_nav")
local MinionMultiTeleporter = component("MinionMultiTeleporter")

MinionMultiTeleporter.init = function (self, unit, is_server, nav_world)
	if not is_server then
		return false
	end

	local teleporter_units = MinionMultiTeleporter._teleporter_units

	if teleporter_units == nil then
		teleporter_units = {}
		MinionMultiTeleporter._teleporter_units = teleporter_units
	end

	teleporter_units[unit] = self

	local unit_id, smart_object_id_lookup = Unit.id_string(unit), {}

	self._unit_id = unit_id
	self._nav_world = nav_world
	self._smart_object_id_lookup = smart_object_id_lookup

	local nav_graph_extension = ScriptUnit.fetch_component_extension(unit, "nav_graph_system")

	if nav_graph_extension then
		self.is_valid = self:_setup_smart_objects(unit, unit_id, nav_world, nav_graph_extension, smart_object_id_lookup, teleporter_units)
		self._nav_graph_extension = nav_graph_extension
	else
		self.is_valid = false
	end
end

local ENABLED_ON_SPAWN, EMPTY = true, {}

MinionMultiTeleporter._setup_smart_objects = function (self, unit, unit_id, nav_world, nav_graph_extension, smart_object_id_lookup, teleporter_units)
	local smart_objects, new_smart_object_id_lookup = MinionMultiTeleporterQueries.generate_smart_objects(unit, nav_world, teleporter_units)

	if smart_objects == nil then
		nav_graph_extension:setup_from_component(self, unit, ENABLED_ON_SPAWN, nil, EMPTY)

		return false
	end

	table.merge(smart_object_id_lookup, new_smart_object_id_lookup)
	nav_graph_extension:setup_from_component(self, unit, ENABLED_ON_SPAWN, nil, smart_objects)

	for teleporter_unit, teleporter_component in pairs(teleporter_units) do
		if teleporter_unit ~= unit and teleporter_component.is_valid then
			teleporter_component:add_smart_object(unit, unit_id)
		end
	end

	return true
end

MinionMultiTeleporter.destroy = function (self, unit)
	if not self.is_server then
		return
	end

	local teleporter_units = MinionMultiTeleporter._teleporter_units

	if self.is_valid then
		for teleporter_unit, teleporter_component in pairs(teleporter_units) do
			if teleporter_unit ~= unit and teleporter_component.is_valid then
				teleporter_component:remove_smart_object(unit)
			end
		end
	end

	teleporter_units[unit] = nil
end

MinionMultiTeleporter.enable = function (self, unit)
	return
end

MinionMultiTeleporter.disable = function (self, unit)
	return
end

MinionMultiTeleporter.teleporter_units = function (self)
	return MinionMultiTeleporter._teleporter_units
end

MinionMultiTeleporter.add_smart_object = function (self, destination_unit, destination_unit_id)
	local unit_id = self._unit_id
	local smart_object_id_lookup = self._smart_object_id_lookup
	local existing_smart_object_id = smart_object_id_lookup[destination_unit]
	local smart_object, smart_object_id = MinionMultiTeleporterQueries.generate_smart_object(self.unit, self._nav_world, destination_unit)

	self._nav_graph_extension:add_smart_object(smart_object, smart_object_id)

	smart_object_id_lookup[destination_unit] = smart_object_id
end

MinionMultiTeleporter.remove_smart_object = function (self, destination_unit)
	local smart_object_id_lookup = self._smart_object_id_lookup
	local smart_object_id = smart_object_id_lookup[destination_unit]

	self._nav_graph_extension:remove_smart_object(smart_object_id)

	smart_object_id_lookup[destination_unit] = nil
end

MinionMultiTeleporter.enable_smart_object = function (self, destination_unit)
	local smart_object_id = self._smart_object_id_lookup[destination_unit]

	self._nav_graph_extension:add_nav_graph_to_database(smart_object_id)
end

MinionMultiTeleporter.disable_smart_object = function (self, destination_unit)
	local smart_object_id = self._smart_object_id_lookup[destination_unit]

	self._nav_graph_extension:remove_nav_graph_from_database(smart_object_id)
end

MinionMultiTeleporter.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return false
	end

	local teleporter_units = MinionMultiTeleporter._teleporter_units

	if teleporter_units == nil then
		teleporter_units = {}
		MinionMultiTeleporter._teleporter_units = teleporter_units
	end

	teleporter_units[unit] = self

	local world = Application.main_world()
	local line_object = World.create_line_object(world)

	self._world, self._line_object = world, line_object
	self._drawer = DebugDrawer(line_object, "retained")

	if MinionMultiTeleporter._nav_info == nil then
		MinionMultiTeleporter._nav_info = SharedNav.create_nav_info()
	end

	self._my_nav_gen_guid = nil
	self._is_selected = false
	self._debug_draw_enabled = false

	local update_enabled = true

	return update_enabled
end

MinionMultiTeleporter.editor_validate = function (self, unit)
	return true, ""
end

MinionMultiTeleporter.editor_destroy = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local teleporter_units = MinionMultiTeleporter._teleporter_units

	teleporter_units[unit] = nil

	local world, line_object = self._world, self._line_object

	LineObject.reset(line_object)
	LineObject.dispatch(world, line_object)
	World.destroy_line_object(world, line_object)
end

MinionMultiTeleporter.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return false
	end

	local with_traverse_logic = false
	local nav_gen_guid = SharedNav.check_new_navmesh_generated(MinionMultiTeleporter._nav_info, self._my_nav_gen_guid, with_traverse_logic)

	if nav_gen_guid then
		self._my_nav_gen_guid = nav_gen_guid

		if self._is_selected then
			self:_editor_debug_draw(unit)
		end
	end

	return true
end

local AVAILABLE_DESTINATION_TELEPORTERS, GAP_PERCENTAGE, SUBDIVISIONS = {}, 20, 50

MinionMultiTeleporter._editor_debug_draw = function (self, unit)
	local drawer = self._drawer

	drawer:reset()

	local active_mission_level_id = LevelEditor:get_active_mission_level()
	local nav_world = MinionMultiTeleporter._nav_info.nav_world_from_level_id[active_mission_level_id]

	if nav_world and self._debug_draw_enabled then
		table.clear(AVAILABLE_DESTINATION_TELEPORTERS)

		local teleporter_units = MinionMultiTeleporter._teleporter_units

		for teleporter_unit, teleporter_component in pairs(teleporter_units) do
			local level_object_id = Unit.get_data(teleporter_unit, "LevelEditor", "object_id")
			local in_active_mission_table = LevelEditor:is_level_object_in_active_mission_table(level_object_id)

			if in_active_mission_table then
				AVAILABLE_DESTINATION_TELEPORTERS[teleporter_unit] = teleporter_component
			end
		end

		local self_toggleable, line_object = self:get_data(unit, "toggleable"), self._line_object
		local smart_objects, smart_object_id_lookup = MinionMultiTeleporterQueries.generate_smart_objects(unit, nav_world, AVAILABLE_DESTINATION_TELEPORTERS)

		if smart_objects then
			for i = 1, #smart_objects do
				local smart_object = smart_objects[i]
				local smart_object_id = smart_object:id()
				local entrance_position, exit_position = smart_object:get_entrance_exit_positions()
				local teleporter_unit = table.find(smart_object_id_lookup, smart_object_id)
				local teleporter_component = AVAILABLE_DESTINATION_TELEPORTERS[teleporter_unit]
				local toggleable = teleporter_component:get_data(teleporter_unit, "toggleable")

				if toggleable or self_toggleable then
					LineObject.add_segmented_line(line_object, Color.light_blue(), entrance_position, exit_position, GAP_PERCENTAGE, SUBDIVISIONS)
				else
					drawer:line(entrance_position, exit_position, Color.light_green())
				end
			end
		else
			local position = Unit.world_position(unit, 1)

			drawer:sphere(position, 0.25, Color.red())
			drawer:line(position, position + Vector3.up() * 15, Color.red())
		end
	end

	drawer:update(self._world)
end

MinionMultiTeleporter.editor_on_mission_changed = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	if self._is_selected then
		self:_editor_debug_draw(unit)
	end
end

MinionMultiTeleporter.editor_selection_changed = function (self, unit, selected)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._is_selected = selected

	if selected then
		self:_editor_debug_draw(unit)
	else
		local drawer = self._drawer

		drawer:reset()
		drawer:update(self._world)
	end
end

MinionMultiTeleporter.editor_world_transform_modified = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	if self._is_selected then
		self:_editor_debug_draw(unit)
	end
end

MinionMultiTeleporter.editor_toggle_debug_draw = function (self, enable)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._debug_draw_enabled = enable

	if self._is_selected then
		self:_editor_debug_draw(self.unit)
	end
end

MinionMultiTeleporter.flow_enable = function (self)
	if not self.is_server then
		return
	end

	local unit = self.unit
	local toggleable = self:get_data(unit, "toggleable")

	self._nav_graph_extension:add_nav_graphs_to_database()

	local teleporter_units = MinionMultiTeleporter._teleporter_units

	for teleporter_unit, teleporter_component in pairs(teleporter_units) do
		if teleporter_unit ~= unit and teleporter_component.is_valid then
			teleporter_component:enable_smart_object(unit)
		end
	end
end

MinionMultiTeleporter.flow_disable = function (self)
	if not self.is_server then
		return
	end

	local unit = self.unit
	local toggleable = self:get_data(unit, "toggleable")

	self._nav_graph_extension:remove_nav_graphs_from_database()

	local teleporter_units = MinionMultiTeleporter._teleporter_units

	for teleporter_unit, teleporter_component in pairs(teleporter_units) do
		if teleporter_unit ~= unit and teleporter_component.is_valid then
			teleporter_component:disable_smart_object(unit)
		end
	end
end

MinionMultiTeleporter.component_data = {
	toggleable = {
		ui_name = "Toggleable",
		ui_type = "check_box",
		value = false,
	},
	inputs = {
		flow_enable = {
			accessibility = "public",
			type = "event",
		},
		flow_disable = {
			accessibility = "public",
			type = "event",
		},
	},
	extensions = {
		"NavGraphExtension",
	},
}

return MinionMultiTeleporter
