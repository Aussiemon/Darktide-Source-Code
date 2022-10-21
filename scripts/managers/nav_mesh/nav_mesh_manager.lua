local Attack = require("scripts/utilities/attack/attack")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local GameplayInitTimeSlice = require("scripts/game_states/game/utilities/gameplay_init_time_slice")
local Navigation = require("scripts/extension_systems/navigation/utilities/navigation")
local NavigationCostSettings = require("scripts/settings/navigation/navigation_cost_settings")
local NavMeshManager = class("NavMeshManager")
local CLIENT_RPCS = {
	"rpc_set_allowed_nav_tag_layer"
}
local NAV_COST_MAP_MAX_VOLUMES = 1024
local NAV_COST_MAP_NUM_VOLUMES_GUESS = 16
local NAV_COST_MAP_RECOMPUTATION_INTERVAL = 0.5

NavMeshManager.init = function (self, world, nav_world, is_server, network_event_delegate, level_name)
	self._world = world
	self._nav_world = nav_world
	self._is_server = is_server
	self._level_spawned = false
	self._sparse_nav_graph_connected = false
	local nav_tag_volume_data = self:_require_nav_tag_volume_data(level_name, {})
	local nav_tag_volume_layers = self:_create_nav_tag_volumes_from_level_data(nav_tag_volume_data)
	self._nav_tag_volume_data = nav_tag_volume_data
	self._nav_cost_map_lookup = self:_setup_nav_cost_map_lookup()
	self._nav_tag_layer_lookup = self:_setup_nav_tag_layer_lookup(nav_tag_volume_layers)
	self._nav_tag_allowed_layers = table.set(self._nav_tag_layer_lookup)
	self._nav_cost_map_volume_id_data = {
		size = 0,
		current_id = 1,
		ids = Script.new_array(NAV_COST_MAP_MAX_VOLUMES),
		max_size = NAV_COST_MAP_MAX_VOLUMES
	}

	self:_create_nav_cost_maps()

	self._should_recompute_nav_cost_maps = false
	self._next_nav_cost_map_recomputation_t = NAV_COST_MAP_RECOMPUTATION_INTERVAL

	if not is_server then
		self._network_event_delegate = network_event_delegate

		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
		self:_initialize_client_traverse_logic(nav_world)
	end
end

NavMeshManager._require_nav_tag_volume_data = function (self, level_name, nav_tag_volume_data)
	local num_nested_levels = LevelResource.nested_level_count(level_name)

	for i = 1, num_nested_levels do
		local nested_level_name = LevelResource.nested_level_resource_name(level_name, i)

		self:_require_nav_tag_volume_data(nested_level_name, nav_tag_volume_data)
	end

	local file_path = level_name .. "_volume_data"

	if Application.can_get_resource("lua", file_path) then
		local volume_data = require(file_path).volume_data

		for i = 1, #volume_data do
			local data = volume_data[i]

			if string.find(data.type, "content/volume_types/nav_tag_volumes/") ~= nil then
				nav_tag_volume_data[#nav_tag_volume_data + 1] = table.clone(data)
			end
		end
	end

	return nav_tag_volume_data
end

NavMeshManager._create_nav_tag_volumes_from_level_data = function (self, nav_tag_volume_data)
	local nav_world = self._nav_world
	local layer_id_to_name = {}
	local layer_name_to_id = {}
	local layer_index = 1

	for i = 1, #nav_tag_volume_data do
		local data = nav_tag_volume_data[i]
		local alt_min_z = data.alt_min_vector[3]
		local alt_max_z = data.alt_max_vector[3]
		local color_table = data.color
		local color = Color(color_table[1], color_table[2], color_table[3], color_table[4])
		local bottom_points = Navigation.vector3s_from_arrays(data.bottom_points)
		local volume_name = data.name
		local layer_id = layer_name_to_id[volume_name]

		if not layer_id then
			layer_name_to_id[volume_name] = layer_index
			layer_id_to_name[layer_index] = volume_name
			layer_id = layer_index
			layer_index = layer_index + 1
		end

		data.nav_tag_volume = Navigation.create_nav_tag_volume(nav_world, bottom_points, alt_min_z, alt_max_z, layer_id, color)
	end

	return layer_id_to_name
end

NavMeshManager.add_nav_tag_volume = function (self, bottom_points, altitude_min, altitude_max, layer_name, allowed, optional_type)
	local nav_tag_layer_lookup = self._nav_tag_layer_lookup
	local layer_id = nav_tag_layer_lookup[layer_name]

	if not layer_id then
		layer_id = #nav_tag_layer_lookup + 1
		nav_tag_layer_lookup[layer_name] = layer_id
		nav_tag_layer_lookup[layer_id] = layer_name
	end

	self._nav_tag_allowed_layers[layer_name] = allowed
	local nav_tag_volume_data = self._nav_tag_volume_data
	nav_tag_volume_data[#nav_tag_volume_data + 1] = {
		name = layer_name,
		type = optional_type,
		bottom_points = Navigation.vector3s_to_arrays(bottom_points),
		nav_tag_volume = Navigation.create_nav_tag_volume(self._nav_world, bottom_points, altitude_min, altitude_max, layer_id, Color.orange())
	}

	if not self._is_server then
		local cost_table = self._navtag_layer_cost_table
		local layer_cost = 1

		GwNavTagLayerCostTable.set_layer_cost_multiplier(cost_table, layer_id, layer_cost)

		if allowed then
			GwNavTagLayerCostTable.allow_layer(cost_table, layer_id)
		else
			GwNavTagLayerCostTable.forbid_layer(cost_table, layer_id)
		end
	end
end

NavMeshManager._setup_nav_cost_map_lookup = function (self)
	local default_nav_cost_maps = {}

	table.merge(default_nav_cost_maps, NavigationCostSettings.default_nav_cost_maps_minions)
	table.merge(default_nav_cost_maps, NavigationCostSettings.default_nav_cost_maps_bots)

	local lookup = table.keys(default_nav_cost_maps)

	table.mirror_array_inplace(lookup)

	return lookup
end

NavMeshManager._setup_nav_tag_layer_lookup = function (self, nav_tag_volume_layers)
	local lookup = table.clone(nav_tag_volume_layers)
	local default_nav_tag_layers = {}

	table.merge(default_nav_tag_layers, NavigationCostSettings.default_nav_tag_layers_minions)
	table.merge(default_nav_tag_layers, NavigationCostSettings.default_nav_tag_layers_bots)

	local default_nav_tag_layer_names = table.keys(default_nav_tag_layers)

	for i = 1, #default_nav_tag_layer_names do
		local layer_name = default_nav_tag_layer_names[i]

		if not table.contains(lookup, layer_name) then
			lookup[#lookup + 1] = layer_name
		end
	end

	table.mirror_array_inplace(lookup)

	return lookup
end

NavMeshManager._initialize_client_traverse_logic = function (self, nav_world)
	local navtag_layer_cost_table = GwNavTagLayerCostTable.create()
	self._navtag_layer_cost_table = navtag_layer_cost_table

	self:initialize_nav_tag_cost_table(navtag_layer_cost_table, {})

	self._traverse_logic = GwNavTraverseLogic.create(nav_world)

	GwNavTraverseLogic.set_navtag_layer_cost_table(self._traverse_logic, navtag_layer_cost_table)
end

NavMeshManager.initialize_nav_tag_cost_table = function (self, cost_table, layer_costs)
	local nav_tag_layer_lookup = self._nav_tag_layer_lookup
	local allowed_layers = self._nav_tag_allowed_layers

	for layer_id = 1, #nav_tag_layer_lookup do
		local layer_name = nav_tag_layer_lookup[layer_id]
		local layer_cost = layer_costs[layer_name] or 1

		GwNavTagLayerCostTable.set_layer_cost_multiplier(cost_table, layer_id, layer_cost)

		if allowed_layers[layer_name] then
			GwNavTagLayerCostTable.allow_layer(cost_table, layer_id)
		else
			GwNavTagLayerCostTable.forbid_layer(cost_table, layer_id)
		end
	end

	return cost_table
end

NavMeshManager.initialize_nav_cost_map_multiplier_table = function (self, multiplier_table, map_multipliers)
	local nav_cost_map_lookup = self._nav_cost_map_lookup

	for map_name, multiplier in pairs(map_multipliers) do
		local map_id = nav_cost_map_lookup[map_name]

		GwNavCostMapMultiplierTable.set_multiplier(multiplier_table, map_id, multiplier)
	end
end

NavMeshManager.nav_tag_layer_id = function (self, layer_name)
	return self._nav_tag_layer_lookup[layer_name]
end

NavMeshManager.nav_cost_map_id = function (self, map_name)
	return self._nav_cost_map_lookup[map_name]
end

NavMeshManager.nav_tag_volume_data = function (self)
	return self._nav_tag_volume_data
end

NavMeshManager.nav_tag_volume_layer_ids_by_volume_type = function (self, volume_type)
	local volume_data = self._nav_tag_volume_data
	local layer_ids = {}

	for i = 1, #volume_data do
		local data = volume_data[i]

		if data.type == volume_type then
			layer_ids[#layer_ids + 1] = self:nav_tag_layer_id(data.name)
		end
	end

	return layer_ids
end

NavMeshManager.destroy = function (self)
	self:_destroy_nav_cost_maps()
	self:_destroy_nav_tag_volumes()

	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))

		self._network_event_delegate = nil

		if self._traverse_logic then
			GwNavTagLayerCostTable.destroy(self._navtag_layer_cost_table)
			GwNavTraverseLogic.destroy(self._traverse_logic)
		end
	end
end

local NAV_COST_MAP_MAX_COST_MAPS = 16

NavMeshManager._create_nav_cost_maps = function (self)
	local nav_cost_map_lookup = self._nav_cost_map_lookup
	local num_cost_maps = #nav_cost_map_lookup
	local nav_world = self._nav_world
	local nav_cost_maps_data = Script.new_array(num_cost_maps)

	for i = 1, num_cost_maps do
		nav_cost_maps_data[i] = {
			recompute = false,
			cost_map = GwNavVolumeCostMap.create(nav_world, i),
			volumes = Script.new_map(NAV_COST_MAP_NUM_VOLUMES_GUESS)
		}
	end

	self._nav_cost_maps_data = nav_cost_maps_data
end

NavMeshManager._destroy_nav_cost_maps = function (self)
	local nav_cost_maps_data = self._nav_cost_maps_data
	local num_cost_maps = #nav_cost_maps_data

	for i = 1, num_cost_maps do
		local cost_map_data = nav_cost_maps_data[i]
		local volumes = cost_map_data.volumes

		GwNavVolumeCostMap.destroy(cost_map_data.cost_map)

		nav_cost_maps_data[i] = nil
	end

	self._nav_cost_maps_data = nil
end

NavMeshManager._destroy_nav_tag_volumes = function (self)
	self._nav_tag_volume_data = nil
end

NavMeshManager.nav_cost_map = function (self, cost_map_id)
	local nav_cost_maps_data = self._nav_cost_maps_data
	local cost_map_data = nav_cost_maps_data[cost_map_id]
	local cost_map = cost_map_data.cost_map

	return cost_map
end

NavMeshManager.add_nav_cost_map_box_volume = function (self, transform, scale_vector, cost, cost_map_id)
	local volume_id_data = self._nav_cost_map_volume_id_data
	local volume_id = volume_id_data.current_id
	local volume_ids = volume_id_data.ids
	local volume_ids_size = volume_id_data.size
	local volume_ids_max_size = volume_id_data.max_size

	while volume_ids[volume_id] do
		volume_id = volume_id % volume_ids_max_size + 1
	end

	local cost_map_data = self._nav_cost_maps_data[cost_map_id]
	local cost_map = cost_map_data.cost_map
	local volume = GwNavVolumeCostMap.create_box_volume(transform, scale_vector, cost)

	GwNavVolumeCostMap.add_volume(cost_map, volume)

	cost_map_data.recompute = true
	cost_map_data.volumes[volume_id] = volume
	volume_id_data.size = volume_ids_size + 1
	volume_id_data.current_id = volume_id
	volume_ids[volume_id] = true
	self._should_recompute_nav_cost_maps = true

	return volume_id
end

NavMeshManager.add_nav_cost_map_sphere_volume = function (self, position, radius, cost, cost_map_id)
	local volume_id_data = self._nav_cost_map_volume_id_data
	local volume_id = volume_id_data.current_id
	local volume_ids = volume_id_data.ids
	local volume_ids_size = volume_id_data.size
	local volume_ids_max_size = volume_id_data.max_size

	while volume_ids[volume_id] do
		volume_id = volume_id % volume_ids_max_size + 1
	end

	local cost_map_data = self._nav_cost_maps_data[cost_map_id]
	local cost_map = cost_map_data.cost_map
	local volume = GwNavVolumeCostMap.create_sphere_volume(position, radius, cost)

	GwNavVolumeCostMap.add_volume(cost_map, volume)

	cost_map_data.recompute = true
	cost_map_data.volumes[volume_id] = volume
	volume_id_data.size = volume_ids_size + 1
	volume_id_data.current_id = volume_id
	volume_ids[volume_id] = true
	self._should_recompute_nav_cost_maps = true

	return volume_id
end

NavMeshManager.set_nav_cost_map_volume_transform = function (self, volume_id, cost_map_id, transform)
	local volume_id_data = self._nav_cost_map_volume_id_data
	local volume_ids = volume_id_data.ids
	local cost_map_data = self._nav_cost_maps_data[cost_map_id]
	local volumes = cost_map_data.volumes
	local volume = volumes[volume_id]

	GwNavVolumeCostMap.set_volume_transform(volume, transform)

	cost_map_data.recompute = true
	self._should_recompute_nav_cost_maps = true
end

NavMeshManager.set_nav_cost_map_volume_scale = function (self, volume_id, cost_map_id, scale)
	local volume_id_data = self._nav_cost_map_volume_id_data
	local volume_ids = volume_id_data.ids
	local cost_map_data = self._nav_cost_maps_data[cost_map_id]
	local volumes = cost_map_data.volumes
	local volume = volumes[volume_id]

	GwNavVolumeCostMap.set_volume_scale(volume, scale)

	cost_map_data.recompute = true
	self._should_recompute_nav_cost_maps = true
end

NavMeshManager.remove_nav_cost_map_volume = function (self, volume_id, cost_map_id)
	local volume_id_data = self._nav_cost_map_volume_id_data
	local volume_id_size = volume_id_data.size
	local volume_ids = volume_id_data.ids
	local cost_map_data = self._nav_cost_maps_data[cost_map_id]
	local volumes = cost_map_data.volumes
	local volume = volumes[volume_id]
	local cost_map = cost_map_data.cost_map

	GwNavVolumeCostMap.remove_volume(cost_map, volume)
	GwNavVolumeCostMap.destroy_volume(volume)

	cost_map_data.recompute = true
	cost_map_data.volumes[volume_id] = nil
	volume_ids[volume_id] = false
	volume_id_data.size = volume_id_size - 1
	self._should_recompute_nav_cost_maps = true
end

NavMeshManager.client_traverse_logic = function (self)
	return self._traverse_logic
end

NavMeshManager.update_time_slice_volumes_integration = function (self)
	local done = GwNavWorld.force_integrate_volumes(self._nav_world, GameplayInitTimeSlice.MAX_DT_IN_SEC)

	return done
end

NavMeshManager.on_gameplay_post_init = function (self)
	local num_nav_tag_layers = #self._nav_tag_layer_lookup

	GwNavWorld.connect_sparse_graph(self._nav_world)

	self._sparse_nav_graph_connected = true
	self._level_spawned = true
end

NavMeshManager._recompute_nav_cost_maps = function (self)
	local nav_cost_maps_data = self._nav_cost_maps_data
	local num_nav_cost_maps = #nav_cost_maps_data
	local nav_world = self._nav_world

	for i = 1, num_nav_cost_maps do
		local cost_map_data = nav_cost_maps_data[i]

		if cost_map_data.recompute then
			local cost_map = cost_map_data.cost_map

			GwNavVolumeCostMap.recompute(cost_map, nav_world)

			cost_map_data.recompute = false
		end
	end
end

NavMeshManager.update = function (self, dt, t)
	if self._should_recompute_nav_cost_maps and self._next_nav_cost_map_recomputation_t < t then
		self:_recompute_nav_cost_maps()

		self._should_recompute_nav_cost_maps = false
		self._next_nav_cost_map_recomputation_t = t + NAV_COST_MAP_RECOMPUTATION_INTERVAL
	end
end

NavMeshManager.hot_join_sync = function (self, sender, channel)
	local nav_tag_layer_lookup = self._nav_tag_layer_lookup
	local allowed_layers = self._nav_tag_allowed_layers

	for layer_id = 1, #nav_tag_layer_lookup do
		local layer_name = nav_tag_layer_lookup[layer_id]
		local allowed = allowed_layers[layer_name]

		if not allowed then
			RPC.rpc_set_allowed_nav_tag_layer(channel, layer_id, allowed)
		end
	end
end

local NAV_MESH_ABOVE = 0.5
local NAV_MESH_BELOW = 0.5

NavMeshManager.set_allowed_nav_tag_layer = function (self, layer_name, allowed)
	if not self._is_server then
		return
	end

	local layer_id = self._nav_tag_layer_lookup[layer_name]
	self._nav_tag_allowed_layers[layer_name] = allowed
	local nav_world = self._nav_world
	local damage_profile = DamageProfileTemplates.default
	local slot_system = Managers.state.extension:system("slot_system")
	local minion_navigation_extensions = Managers.state.extension:get_entities("MinionNavigationExtension")

	for unit, extension in pairs(minion_navigation_extensions) do
		extension:allow_nav_tag_layer(layer_name, allowed)

		if not allowed then
			local unit_position = POSITION_LOOKUP[unit]

			if Navigation.inside_nav_tag_volume_layer(nav_world, unit_position, NAV_MESH_ABOVE, NAV_MESH_BELOW, layer_id) then
				Attack.execute(unit, damage_profile, "instakill", true)
			else
				local destination = extension:destination()

				if Navigation.inside_nav_tag_volume_layer(nav_world, destination, NAV_MESH_ABOVE, NAV_MESH_BELOW, layer_id) then
					extension:stop()
					slot_system:detach_user_unit(unit)
				end
			end
		end
	end

	if slot_system:is_traverse_logic_initialized() then
		slot_system:allow_nav_tag_layer(layer_name, allowed)
	end

	local combat_vector_system = Managers.state.extension:system("combat_vector_system")

	if combat_vector_system:is_traverse_logic_initialized() then
		combat_vector_system:allow_nav_tag_layer(layer_name, allowed)
	end

	local liquid_area_system = Managers.state.extension:system("liquid_area_system")

	if liquid_area_system:is_traverse_logic_initialized() then
		liquid_area_system:allow_nav_tag_layer(layer_name, allowed)
	end

	Managers.state.pacing:allow_nav_tag_layer(layer_name, allowed)
	Managers.state.main_path:allow_nav_tag_layer(layer_name, allowed)
	Managers.state.bot_nav_transition:allow_nav_tag_layer(layer_name, allowed)

	local bot_navigation_extensions = Managers.state.extension:get_entities("BotNavigationExtension")

	for unit, extension in pairs(bot_navigation_extensions) do
		extension:allow_nav_tag_layer(layer_name, allowed)
	end

	Managers.state.game_session:send_rpc_clients("rpc_set_allowed_nav_tag_layer", layer_id, allowed)
end

NavMeshManager.is_nav_tag_volume_layer_allowed = function (self, layer_name)
	return self._nav_tag_allowed_layers[layer_name]
end

NavMeshManager.allowed_nav_tag_layers = function (self)
	return self._nav_tag_allowed_layers
end

NavMeshManager.rpc_set_allowed_nav_tag_layer = function (self, channel_id, layer_id, allowed)
	local layer_name = self._nav_tag_layer_lookup[layer_id]
	self._nav_tag_allowed_layers[layer_name] = allowed

	if allowed then
		GwNavTagLayerCostTable.allow_layer(self._navtag_layer_cost_table, layer_id)
	else
		GwNavTagLayerCostTable.forbid_layer(self._navtag_layer_cost_table, layer_id)
	end
end

return NavMeshManager
