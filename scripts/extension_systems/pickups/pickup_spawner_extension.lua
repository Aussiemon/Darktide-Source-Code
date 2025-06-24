-- chunkname: @scripts/extension_systems/pickups/pickup_spawner_extension.lua

local MainPathQueries = require("scripts/utilities/main_path_queries")
local PickupSettings = require("scripts/settings/pickup/pickup_settings")
local PickupSpawnerExtension = class("PickupSpawnerExtension")
local DISTRIBUTION_TYPES = PickupSettings.distribution_types
local FLOW_SPAWN_METHOD = table.enum("none", "next_in_list", "random_in_list")

PickupSpawnerExtension.init = function (self, extension_init_context, unit, extension_init_data)
	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._components = {}
	self._seed = nil
	self._percentage_through_level = 0
	self._pickup_system = Managers.state.extension:system("pickup_system")
	self._chest_extension = nil

	if self._is_server then
		self._seed = math.random_seed()
	end
end

PickupSpawnerExtension.setup_from_component = function (self, component, spawn_method, ignore_item_list, items, item_spawn_selection, spawn_nodes)
	local component_guid = component.guid
	local num_components = #self._components
	local components = self._components
	local pool_spawner = false
	local data = {}

	data.guid = component_guid
	data.is_side_mission = false

	if spawn_method == "primary_distribution" then
		pool_spawner = true
		data.distribution_type = DISTRIBUTION_TYPES.primary
	elseif spawn_method == "secondary_distribution" then
		pool_spawner = true
		data.distribution_type = DISTRIBUTION_TYPES.secondary
	elseif spawn_method == "mid_event_distribution" then
		pool_spawner = true
		data.distribution_type = DISTRIBUTION_TYPES.mid_event
	elseif spawn_method == "end_event_distribution" then
		pool_spawner = true
		data.distribution_type = DISTRIBUTION_TYPES.end_event
	elseif spawn_method == "guaranteed_spawn" then
		data.distribution_type = DISTRIBUTION_TYPES.guaranteed
	elseif spawn_method == "manual_spawn" or spawn_method == "flow_spawn" then
		data.distribution_type = DISTRIBUTION_TYPES.manual
	elseif spawn_method == "side_mission" then
		data.distribution_type = DISTRIBUTION_TYPES.side_mission
		data.is_side_mission = true
	else
		Log.error("PickupSpawnerExtension", "[setup_from_component][Unit: %s] PickupSpawner invalid spawn method: %s.", Unit.id_string(self._unit), spawn_method)

		data.distribution_type = DISTRIBUTION_TYPES.manual
	end

	local num_items = #items
	local spawnable_pickups

	if pool_spawner and ignore_item_list then
		spawnable_pickups = "all"
	else
		spawnable_pickups = {}

		for i = 1, num_items do
			if items[i] ~= "none" then
				spawnable_pickups[#spawnable_pickups + 1] = items[i]
			end
		end
	end

	data.spawnable_pickups = spawnable_pickups

	if data.item_spawn_selection == "next_in_list" then
		data.item_spawn_selection = FLOW_SPAWN_METHOD.next_in_list
	elseif item_spawn_selection == "random_in_list" then
		data.item_spawn_selection = FLOW_SPAWN_METHOD.random_in_list
	else
		data.item_spawn_selection = FLOW_SPAWN_METHOD.none
	end

	data.last_item_index_spawned = 0

	if self._is_server then
		data.spawned_items = {}

		local new_seed, rnd_index = math.next_random(self._seed, 1, #spawn_nodes)

		self._seed = new_seed
		data.target_node = spawn_nodes[rnd_index]
	end

	components[num_components + 1] = data
end

PickupSpawnerExtension.on_gameplay_post_init = function (self, unit)
	self._chest_extension = ScriptUnit.has_extension(self._unit, "chest_system")

	self:calculate_percentage_through_level()
end

PickupSpawnerExtension.calculate_percentage_through_level = function (self)
	if not Managers.state.main_path:is_main_path_available() then
		return
	end

	local unit_position = POSITION_LOOKUP[self._unit]
	local _, _, percentage, _, _ = MainPathQueries.closest_position(unit_position)

	self._percentage_through_level = percentage
end

PickupSpawnerExtension.percentage_through_level = function (self)
	return self._percentage_through_level
end

PickupSpawnerExtension.unit = function (self)
	return self._unit
end

PickupSpawnerExtension.spawner_count = function (self)
	return #self._components
end

PickupSpawnerExtension.can_spawn_pickup = function (self, component_index, pickup_name)
	local component = self._components[component_index]

	return component.spawnable_pickups == "all" or table.contains(component.spawnable_pickups, pickup_name)
end

PickupSpawnerExtension.spawnable_pickups_amount = function (self, component_index)
	component_index = component_index or 1

	local component = self._components[component_index]
	local num_items = #component.spawnable_pickups

	return num_items
end

PickupSpawnerExtension._fetch_next_item = function (self, component_index)
	local component = self._components[component_index]
	local num_items = #component.spawnable_pickups
	local item = component.spawnable_pickups[1]

	if num_items > 1 then
		local last_index = component.last_item_index_spawned

		if component.item_spawn_selection == FLOW_SPAWN_METHOD.next_in_list then
			local current_index = last_index + 1

			current_index = current_index % num_items
			item = component.spawnable_pickups[current_index]
			component.last_item_index_spawned = current_index
		elseif component.item_spawn_selection == FLOW_SPAWN_METHOD.random_in_list then
			local max_tries = 5

			for i = 1, max_tries do
				local new_seed, rnd_index = math.next_random(self._seed, 1, num_items)

				if rnd_index ~= last_index then
					item = component.spawnable_pickups[rnd_index]
					component.last_item_index_spawned = rnd_index
					self._seed = new_seed

					break
				end
			end
		end
	end

	return item
end

PickupSpawnerExtension._check_reserve = function (self, component_index, pickup_name)
	local chest_extension = self._chest_extension
	local component = self._components[component_index]

	if chest_extension then
		chest_extension:reserve_pickup(component_index, pickup_name)

		return true
	end

	return false
end

PickupSpawnerExtension.register_spawn_locations = function (self, node_list, distribution_type, pickup_settings)
	local num_components = #self._components
	local components = self._components

	for i = 1, num_components do
		local component = components[i]

		if component.distribution_type == distribution_type then
			node_list[#node_list + 1] = {
				extension = self,
				index = i,
				chest = not not self._chest_extension,
			}
		end
	end
end

PickupSpawnerExtension.spawn_guaranteed = function (self)
	local num_components = #self._components
	local components = self._components

	for i = 1, num_components do
		local component = components[i]

		if component.distribution_type == DISTRIBUTION_TYPES.guaranteed and component.spawnable_pickups ~= "all" and #component.spawnable_pickups > 0 then
			local pickup_name = self._pickup_system:get_guaranteed_pickup(component.spawnable_pickups)

			if pickup_name then
				local check_reserve = true

				self:spawn_specific_item(i, pickup_name, check_reserve)
			end
		end
	end
end

PickupSpawnerExtension.request_rubberband_pickup = function (self, component_index)
	local chest_extension = self._chest_extension
	local component = self._components[component_index]
	local pickup_name = self._pickup_system:get_rubberband_pickup(component.distribution_type, self._percentage_through_level)

	chest_extension:reserve_pickup(component_index, pickup_name)

	return pickup_name
end

PickupSpawnerExtension.spawn_item = function (self, component_index)
	component_index = component_index or 1

	local pickup_name = self:_fetch_next_item(component_index)
	local check_reserve = true
	local unit_item, unit_item_id = self:spawn_specific_item(component_index, pickup_name, check_reserve)

	return unit_item, unit_item_id
end

PickupSpawnerExtension.spawn_specific_item = function (self, component_index, pickup_name, check_reserve)
	component_index = component_index or 1

	local unit_item
	local unit_item_id = NetworkConstants.invalid_level_unit_id

	if check_reserve and self:_check_reserve(component_index, pickup_name) then
		return unit_item, unit_item_id
	end

	local pickup_system = self._pickup_system
	local position, rotation = self:spawn_position_rotation(component_index)

	unit_item, unit_item_id = pickup_system:spawn_pickup(pickup_name, position, rotation, self)

	Unit.flow_event(self._unit, "lua_item_spawned")

	local component_spawn_list = self._components[component_index].spawned_items

	component_spawn_list[#component_spawn_list + 1] = unit_item

	return unit_item, unit_item_id
end

PickupSpawnerExtension.spawned_item_picked_up = function (self, unit_item)
	Unit.flow_event(self._unit, "lua_item_picked_up")

	local components = self._components
	local num_components = #self._components

	for i = 1, num_components do
		local items = components[i].spawned_items

		for p = 1, #items do
			local item = items[p]

			if unit_item == item then
				table.remove(items, p)

				return
			end
		end
	end
end

PickupSpawnerExtension.despawn_items = function (self)
	if not self._is_server then
		return
	end

	local components = self._components
	local num_components = #self._components

	for i = 1, num_components do
		local items = components[i].spawned_items

		for p = 1, #items do
			local item = items[p]

			if ALIVE[item] then
				self:despawn_item(item)
			end
		end

		table.clear(items)
	end
end

PickupSpawnerExtension.despawn_item = function (self, item_unit)
	local pickup_system = self._pickup_system

	pickup_system:despawn_pickup(item_unit)
end

PickupSpawnerExtension.spawn_position_rotation = function (self, component_index)
	local unit = self._unit

	component_index = component_index or 1

	local component = self._components[component_index]
	local target_node = Unit.node(unit, component.target_node)
	local position = Unit.world_position(unit, target_node)
	local rotation = Unit.world_rotation(unit, target_node)

	return position, rotation
end

return PickupSpawnerExtension
