local NavGraphQueries = require("scripts/extension_systems/nav_graph/utilities/nav_graph_queries")
local SmartObject = require("scripts/extension_systems/nav_graph/utilities/smart_object")
local NavGraphExtension = class("NavGraphExtension")

NavGraphExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._unit_id = Unit.id_string(unit)
	self._smart_objects = {}
	self._smart_object_id_to_component = {}
	self._smart_object_id_to_nav_graph = {}
	self._nav_graphs = {}
	self._nav_graph_added = {}
	self._enabled_on_spawn = nil
	self._has_navmesh = extension_init_context.has_navmesh
	self._is_server = extension_init_context.is_server
	self._nav_world = extension_init_context.nav_world
	self._nav_graph_system = Managers.state.extension:system("nav_graph_system")
	self._physics_world = extension_init_context.physics_world
end

NavGraphExtension.extensions_ready = function (self, world, unit)
	if not self._is_server then
		return
	end

	if self._has_navmesh then
		self:_create_nav_graphs()

		if self._enabled_on_spawn then
			self:add_nav_graphs_to_database()
		end
	end
end

local NAV_GRAPH_POINTS = {}
local SLOT_COUNT = 1
local OCCUPIED_COST = 2
local REGISTER_FOR_CROWD_DISPERSION = {
	teleporters = false
}

NavGraphExtension._create_nav_graphs = function (self)
	local nav_graphs = self._nav_graphs
	local nav_mesh_manager = Managers.state.nav_mesh
	local nav_world = self._nav_world
	local smart_objects = self._smart_objects
	local smart_object_id_to_nav_graph = self._smart_object_id_to_nav_graph
	local debug_color = Color.orange()

	for i = 1, #smart_objects do
		local smart_object = smart_objects[i]
		local smart_object_id = smart_object:id()
		local layer_type = smart_object:layer_type()
		local entrance_position, exit_position = smart_object:get_entrance_exit_positions()
		local is_bidirectional = smart_object:is_bidirectional()
		local layer_id = nav_mesh_manager:nav_tag_layer_id(layer_type)
		NAV_GRAPH_POINTS[1] = entrance_position
		NAV_GRAPH_POINTS[2] = exit_position
		local created, nav_graph = GwNavGraph.create(nav_world, is_bidirectional, NAV_GRAPH_POINTS, debug_color, layer_id, smart_object_id)

		if created then
			local register_for_crowd_dispersion = REGISTER_FOR_CROWD_DISPERSION[layer_type] == nil or REGISTER_FOR_CROWD_DISPERSION[layer_type]

			if register_for_crowd_dispersion then
				GwNavWorld.register_all_navgraphedges_for_crowd_dispersion(nav_world, nav_graph, SLOT_COUNT, OCCUPIED_COST)
			end

			nav_graphs[#nav_graphs + 1] = nav_graph
			smart_object_id_to_nav_graph[smart_object_id] = nav_graph
		end
	end
end

NavGraphExtension.destroy = function (self)
	local nav_graphs = self._nav_graphs

	for i = 1, #nav_graphs do
		local nav_graph = nav_graphs[i]

		GwNavGraph.destroy(nav_graph)
	end
end

local TEMP_SMART_OBJECT_IDS = {}

NavGraphExtension.setup_from_component = function (self, component, unit, enabled_on_spawn, optional_simple_smart_objects, optional_smart_objects)
	local component_guid = component.guid
	self._enabled_on_spawn = enabled_on_spawn
	local smart_objects = self._smart_objects
	local component_lookup = self._smart_object_id_to_component

	table.clear_array(TEMP_SMART_OBJECT_IDS, #TEMP_SMART_OBJECT_IDS)

	if optional_simple_smart_objects then
		for i = 1, #optional_simple_smart_objects do
			local simple_smart_object = optional_simple_smart_objects[i]
			local smart_object = SmartObject:new()

			smart_object:from_simple(simple_smart_object)

			smart_objects[#smart_objects + 1] = smart_object
			local smart_object_id = smart_object:id()
			component_lookup[smart_object_id] = component_guid
			TEMP_SMART_OBJECT_IDS[i] = smart_object_id
		end
	else
		local new_smart_objects = nil

		if optional_smart_objects then
			new_smart_objects = optional_smart_objects
		else
			new_smart_objects = NavGraphQueries.generate_smart_objects(unit, self._nav_world, self._physics_world, component)
		end

		for i = 1, #new_smart_objects do
			local smart_object = new_smart_objects[i]
			local smart_object_id = smart_object:id()
			smart_objects[#smart_objects + 1] = smart_object
			component_lookup[smart_object_id] = component_guid
			TEMP_SMART_OBJECT_IDS[i] = smart_object_id
		end
	end

	if #TEMP_SMART_OBJECT_IDS > 0 then
		self._nav_graph_system:register_smart_object_ids_to_extension(TEMP_SMART_OBJECT_IDS, self)
	end
end

NavGraphExtension._check_component_registered = function (self, component_guid)
	local smart_object_id_to_component = self._smart_object_id_to_component

	for _, guid in pairs(smart_object_id_to_component) do
		if guid == component_guid then
			return true
		end
	end

	return false
end

NavGraphExtension.add_smart_object = function (self, smart_object, smart_object_id)
	local smart_objects = self._smart_objects
	smart_objects[#smart_objects + 1] = smart_object

	self._nav_graph_system:register_smart_object_id_to_extension(smart_object_id, self)
	self:_create_nav_graph(smart_object, smart_object_id)
	self:add_nav_graph_to_database(smart_object_id)
end

NavGraphExtension._create_nav_graph = function (self, smart_object, smart_object_id)
	local smart_object_id_to_nav_graph = self._smart_object_id_to_nav_graph
	local nav_world = self._nav_world
	local debug_color = Color.orange()
	local layer_type = smart_object:layer_type()
	local entrance_position, exit_position = smart_object:get_entrance_exit_positions()
	local is_bidirectional = smart_object:is_bidirectional()
	local layer_id = Managers.state.nav_mesh:nav_tag_layer_id(layer_type)
	NAV_GRAPH_POINTS[1] = entrance_position
	NAV_GRAPH_POINTS[2] = exit_position
	local created, nav_graph = GwNavGraph.create(nav_world, is_bidirectional, NAV_GRAPH_POINTS, debug_color, layer_id, smart_object_id)

	if created then
		local register_for_crowd_dispersion = REGISTER_FOR_CROWD_DISPERSION[layer_type] == nil or REGISTER_FOR_CROWD_DISPERSION[layer_type]

		if register_for_crowd_dispersion then
			GwNavWorld.register_all_navgraphedges_for_crowd_dispersion(nav_world, nav_graph, SLOT_COUNT, OCCUPIED_COST)
		end

		local nav_graphs = self._nav_graphs
		nav_graphs[#nav_graphs + 1] = nav_graph
		smart_object_id_to_nav_graph[smart_object_id] = nav_graph
	end
end

NavGraphExtension.remove_smart_object = function (self, smart_object_id)
	local smart_object_index_to_remove = nil
	local smart_objects = self._smart_objects

	for i = 1, #smart_objects do
		local smart_object = smart_objects[i]

		if smart_object:id() == smart_object_id then
			smart_object_index_to_remove = i

			break
		end
	end

	local smart_object_id_to_nav_graph = self._smart_object_id_to_nav_graph
	local nav_graph = smart_object_id_to_nav_graph[smart_object_id]
	local nav_graphs = self._nav_graphs
	local nav_graph_index = table.index_of(nav_graphs, nav_graph)

	GwNavGraph.destroy(nav_graph)
	table.swap_delete(nav_graphs, nav_graph_index)

	smart_object_id_to_nav_graph[smart_object_id] = nil
	self._smart_object_id_to_component[smart_object_id] = nil

	table.swap_delete(smart_objects, smart_object_index_to_remove)
	self._nav_graph_system:unregister_smart_object_id_from_extension(smart_object_id, self)
end

NavGraphExtension.smart_objects = function (self)
	return self._smart_objects
end

NavGraphExtension.smart_object_from_id = function (self, smart_object_id)
	local smart_objects = self._smart_objects

	for i = 1, #smart_objects do
		local smart_object = smart_objects[i]

		if smart_object:id() == smart_object_id then
			return smart_object
		end
	end

	return nil
end

NavGraphExtension.add_nav_graph_to_database = function (self, smart_object_id)
	local nav_graph = self._smart_object_id_to_nav_graph[smart_object_id]
	local unit_id = self._unit_id

	if nav_graph then
		local nav_graph_added = self._nav_graph_added

		GwNavGraph.add_to_database(nav_graph)

		nav_graph_added[nav_graph] = true
	end
end

NavGraphExtension.add_nav_graphs_to_database = function (self)
	local nav_graphs = self._nav_graphs
	local nav_graph_added = self._nav_graph_added

	for i = 1, #nav_graphs do
		local nav_graph = nav_graphs[i]

		if not nav_graph_added[nav_graph] then
			GwNavGraph.add_to_database(nav_graph)

			nav_graph_added[nav_graph] = true
		end
	end
end

NavGraphExtension.remove_nav_graph_from_database = function (self, smart_object_id)
	local nav_graph = self._smart_object_id_to_nav_graph[smart_object_id]
	local unit_id = self._unit_id
	local nav_graph_added = self._nav_graph_added

	GwNavGraph.remove_from_database(nav_graph)

	nav_graph_added[nav_graph] = false
end

NavGraphExtension.remove_nav_graphs_from_database = function (self)
	local nav_graphs = self._nav_graphs
	local nav_graph_added = self._nav_graph_added

	for i = 1, #nav_graphs do
		local nav_graph = nav_graphs[i]

		if nav_graph_added[nav_graph] then
			GwNavGraph.remove_from_database(nav_graph)

			nav_graph_added[nav_graph] = false
		end
	end
end

NavGraphExtension.nav_graph_added = function (self, smart_object_id)
	local nav_graph = self._smart_object_id_to_nav_graph[smart_object_id]

	if nav_graph == nil then
		return false
	end

	local nav_graph_added = self._nav_graph_added[nav_graph]

	return nav_graph_added
end

NavGraphExtension.unit = function (self)
	return self._unit
end

return NavGraphExtension
