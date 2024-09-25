-- chunkname: @scripts/components/nav_graph.lua

local NavGraphQueries = require("scripts/extension_systems/nav_graph/utilities/nav_graph_queries")
local SharedNav = require("scripts/components/utilities/shared_nav")
local NavGraph = component("NavGraph")

NavGraph.init = function (self, unit, is_server)
	if not is_server then
		return false
	end

	local nav_graph_extension = ScriptUnit.fetch_component_extension(unit, "nav_graph_system")

	if nav_graph_extension then
		self._nav_graph_extension = nav_graph_extension

		local enabled_on_spawn = self:get_data(unit, "enabled_on_spawn")
		local pregenerate_smart_objects = self:get_data(unit, "pregenerate_smart_objects")
		local simple_smart_objects = pregenerate_smart_objects and self:_fetch_smart_objects(unit)

		nav_graph_extension:setup_from_component(self, unit, enabled_on_spawn, simple_smart_objects)
	end
end

NavGraph._fetch_smart_objects = function (self, unit)
	local has_smart_object = true
	local smart_objects = {}
	local index = 1

	while has_smart_object do
		local smart_object = self:_fetch_smart_object(unit, index)

		index = index + 1

		if smart_object then
			smart_objects[#smart_objects + 1] = smart_object
		else
			has_smart_object = false
		end
	end

	return smart_objects
end

NavGraph._fetch_smart_object = function (self, unit, index)
	local layer_type = self:get_data(unit, "smart_objects", index, "layer_type")

	if layer_type == nil then
		return nil
	end

	local smart_object = {
		layer_type = layer_type,
		entrance_position = {
			self:get_data(unit, "smart_objects", index, "entrance_position", 1),
			self:get_data(unit, "smart_objects", index, "entrance_position", 2),
			(self:get_data(unit, "smart_objects", index, "entrance_position", 3)),
		},
		exit_position = {
			self:get_data(unit, "smart_objects", index, "exit_position", 1),
			self:get_data(unit, "smart_objects", index, "exit_position", 2),
			(self:get_data(unit, "smart_objects", index, "exit_position", 3)),
		},
		data = {
			is_bidirectional = self:get_data(unit, "smart_objects", index, "data", "is_bidirectional"),
			jump_flat_distance = self:get_data(unit, "smart_objects", index, "data", "jump_flat_distance"),
			ledge_type = self:get_data(unit, "smart_objects", index, "data", "ledge_type"),
			ledge_position = {
				self:get_data(unit, "smart_objects", index, "data", "ledge_position", 1),
				self:get_data(unit, "smart_objects", index, "data", "ledge_position", 2),
				(self:get_data(unit, "smart_objects", index, "data", "ledge_position", 3)),
			},
			ledge_position1 = {
				self:get_data(unit, "smart_objects", index, "data", "ledge_position1", 1),
				self:get_data(unit, "smart_objects", index, "data", "ledge_position1", 2),
				(self:get_data(unit, "smart_objects", index, "data", "ledge_position1", 3)),
			},
			ledge_position2 = {
				self:get_data(unit, "smart_objects", index, "data", "ledge_position2", 1),
				self:get_data(unit, "smart_objects", index, "data", "ledge_position2", 2),
				(self:get_data(unit, "smart_objects", index, "data", "ledge_position2", 3)),
			},
		},
	}

	return smart_object
end

NavGraph.destroy = function (self, unit)
	return
end

NavGraph.enable = function (self, unit)
	return
end

NavGraph.disable = function (self, unit)
	return
end

NavGraph.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local world = Application.main_world()

	self._world = world
	self._physics_world = World.physics_world(world)
	self._line_object = World.create_line_object(world)
	self._drawer = DebugDrawer(self._line_object, "retained")
	self._active_debug_draw = false
	self._debug_draw_enabled = false
	self._debug_data_smart_objects = {}
	self._calculation_items = {}

	if NavGraph._nav_info == nil then
		NavGraph._nav_info = SharedNav.create_nav_info()
	end

	self._my_nav_gen_guid = nil

	local object_id = Unit.get_data(unit, "LevelEditor", "object_id")

	self._object_id = object_id
	self._in_active_mission_table = LevelEditor:is_level_object_in_active_mission_table(object_id)

	return true
end

NavGraph.editor_validate = function (self, unit)
	return true, ""
end

NavGraph.editor_destroy = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local line_object, world = self._line_object, self._world

	LineObject.reset(line_object)
	LineObject.dispatch(world, line_object)
	World.destroy_line_object(world, line_object)
end

local MAX_DEBUG_DRAW_CAMERA_DISTANCE_SQ = 2500

NavGraph.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local should_debug_draw, refresh_needed = self._debug_draw_enabled, false

	if self._in_active_mission_table then
		local with_traverse_logic = false
		local nav_gen_guid = SharedNav.check_new_navmesh_generated(NavGraph._nav_info, self._my_nav_gen_guid, with_traverse_logic)

		if nav_gen_guid then
			self._my_nav_gen_guid = nav_gen_guid

			self:_generate_positions(unit)

			refresh_needed = self._active_debug_draw
		end

		if should_debug_draw then
			local camera_position, unit_position = LevelEditor:get_camera_location(), Unit.local_position(unit, 1)

			should_debug_draw = Vector3.distance_squared(camera_position, unit_position) < MAX_DEBUG_DRAW_CAMERA_DISTANCE_SQ
		end
	else
		should_debug_draw = false
	end

	if should_debug_draw ~= self._active_debug_draw or refresh_needed then
		self._active_debug_draw = should_debug_draw

		self:_editor_debug_draw(unit)
	end

	return true
end

NavGraph.editor_on_mission_changed = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._in_active_mission_table = LevelEditor:is_level_object_in_active_mission_table(self._object_id)
end

NavGraph.editor_world_transform_modified = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self:_generate_positions(unit)
	self:_editor_debug_draw(unit)
end

NavGraph.editor_toggle_debug_draw = function (self, enable)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._debug_draw_enabled = enable
end

NavGraph._editor_debug_draw = function (self, unit)
	local drawer = self._drawer

	drawer:reset()

	if self._active_debug_draw then
		local debug_data_smart_objects = self._debug_data_smart_objects

		for i = 1, #debug_data_smart_objects do
			local debug_data_smart_object = debug_data_smart_objects[i]
			local is_one_way = debug_data_smart_object.is_one_way
			local entrance_position = debug_data_smart_object.entrance_position:unbox()
			local exit_position = debug_data_smart_object.exit_position:unbox()

			NavGraphDebug.draw_nav_graph(drawer, unit, is_one_way, entrance_position, exit_position)
		end

		local calculation_items = self._calculation_items

		NavGraphDebug.draw_item_list(drawer, calculation_items)
	end

	drawer:update(self._world)
end

NavGraph._generate_positions = function (self, unit)
	local calculation_items, debug_data_smart_objects = self._calculation_items, self._debug_data_smart_objects

	table.clear_array(debug_data_smart_objects, #debug_data_smart_objects)
	table.clear_array(calculation_items, #calculation_items)

	local nav_world
	local pregenerate_smart_objects = self:get_data(unit, "pregenerate_smart_objects")

	if pregenerate_smart_objects then
		local _, level_id = LevelEditor:find_level_object(self._object_id)

		nav_world = NavGraph._nav_info.nav_world_from_level_id[level_id]
	else
		local active_mission_level_id = LevelEditor:get_active_mission_level()

		nav_world = NavGraph._nav_info.nav_world_from_level_id[active_mission_level_id]
	end

	if nav_world then
		local smart_objects, debug_draw_list = NavGraphQueries.generate_smart_objects(unit, nav_world, self._physics_world, self)

		table.merge_array(calculation_items, debug_draw_list)

		local is_one_way = self:get_data(unit, "is_one_way")

		for i = 1, #smart_objects do
			local smart_object = smart_objects[i]
			local entrance_position, exit_position = smart_object:get_entrance_exit_positions()
			local debug_data_smart_object = {
				entrance_position = Vector3Box(entrance_position),
				exit_position = Vector3Box(exit_position),
				is_one_way = is_one_way,
			}

			debug_data_smart_objects[i] = debug_data_smart_object
		end
	end
end

NavGraph.flow_nav_enable = function (self)
	if not self.is_server or not self._nav_graph_extension then
		return
	end

	self._nav_graph_extension:add_nav_graphs_to_database()
end

NavGraph.flow_nav_disable = function (self)
	if not self.is_server or not self._nav_graph_extension then
		return
	end

	self._nav_graph_extension:remove_nav_graphs_from_database()
end

NavGraph.component_data = {
	is_one_way = {
		ui_name = "Is One Way",
		ui_type = "check_box",
		value = false,
	},
	enabled_on_spawn = {
		ui_name = "Navigation Enabled on Spawn",
		ui_type = "check_box",
		value = true,
	},
	pregenerate_smart_objects = {
		ui_name = "Pregenerate Smart Objects",
		ui_type = "check_box",
		value = true,
	},
	layer_type = {
		ui_name = "Layer Type",
		ui_type = "combo_box",
		value = "auto_detect",
		options_keys = {
			"auto_detect",
			"teleporters",
			"monster_walls",
		},
		options_values = {
			"auto_detect",
			"teleporters",
			"monster_walls",
		},
	},
	smart_object_calculation_method = {
		ui_name = "Smart Object Calculation Method",
		ui_type = "combo_box",
		value = "use_node_pair",
		options_keys = {
			"use_node_pair",
			"use_offset_node",
			"calculate_from_node_pair",
			"calculate_from_node_list",
		},
		options_values = {
			"use_node_pair",
			"use_offset_node",
			"calculate_from_node_pair",
			"calculate_from_node_list",
		},
	},
	node_a_name = {
		category = "Node Pair",
		ui_name = "Node A Name",
		ui_type = "text_box",
		value = "",
	},
	node_b_name = {
		category = "Node Pair",
		ui_name = "Node B Name",
		ui_type = "text_box",
		value = "",
	},
	offset_node_name = {
		category = "Offset Node",
		ui_name = "Offset Node Name",
		ui_type = "text_box",
		value = "",
	},
	entrance_offset = {
		category = "Offset Node",
		ui_name = "Entrance Offset",
		ui_type = "vector",
		value = Vector3Box(0, 0, 0),
	},
	exit_offset = {
		category = "Offset Node",
		ui_name = "Exit Offset",
		ui_type = "vector",
		value = Vector3Box(0, 0, 0),
	},
	node_list = {
		category = "Node List",
		size = 0,
		ui_name = "Nodes",
		ui_type = "text_box_array",
	},
	inputs = {
		flow_nav_enable = {
			accessibility = "public",
			type = "event",
		},
		flow_nav_disable = {
			accessibility = "public",
			type = "event",
		},
	},
	extensions = {
		"NavGraphExtension",
	},
}

return NavGraph
