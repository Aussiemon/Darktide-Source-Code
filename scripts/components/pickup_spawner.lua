local PickupSpawner = component("PickupSpawner")

PickupSpawner.init = function (self, unit, is_server)
	self._unit = unit
	self._is_server = is_server
	local spawn_method = self:get_data(unit, "spawn_method")
	self._spawn_method = spawn_method
	local pickup_spawner_extension = ScriptUnit.fetch_component_extension(unit, "pickup_system")

	if pickup_spawner_extension then
		local ignore_item_list = self:get_data(unit, "ignore_item_list")
		local items = self:get_data(unit, "items")
		local item_spawn_selection = self:get_data(unit, "item_spawn_selection")
		local spawn_nodes = self:get_data(unit, "spawn_nodes")

		pickup_spawner_extension:setup_from_component(self, spawn_method, ignore_item_list, items, item_spawn_selection, spawn_nodes)

		self._pickup_spawner_extension = pickup_spawner_extension
	end
end

PickupSpawner.editor_init = function (self, unit)
	return
end

PickupSpawner.enable = function (self, unit)
	return
end

PickupSpawner.disable = function (self, unit)
	return
end

PickupSpawner.destroy = function (self, unit)
	return
end

PickupSpawner.spawn_item = function (self)
	local pickup_spawner_extension = self._pickup_spawner_extension

	if pickup_spawner_extension and self._is_server then
		pickup_spawner_extension:spawn_item()
	end
end

PickupSpawner.component_data = {
	spawn_method = {
		value = "primary_distribution",
		ui_type = "combo_box",
		category = "Spawn Parameters",
		ui_name = "Spawn Method",
		options_keys = {
			"primary_distribution",
			"secondary_distribution",
			"mid_event_distribution",
			"end_event_distribution",
			"guaranteed_spawn",
			"manual_spawn",
			"side_mission",
			"flow_spawn"
		},
		options_values = {
			"primary_distribution",
			"secondary_distribution",
			"mid_event_distribution",
			"end_event_distribution",
			"guaranteed_spawn",
			"manual_spawn",
			"side_mission",
			"flow_spawn"
		}
	},
	ignore_item_list = {
		ui_type = "check_box",
		value = true,
		ui_name = "Accept any pool items",
		category = "Items"
	},
	items = {
		category = "Items",
		ui_type = "combo_box_array",
		size = 0,
		ui_name = "Items",
		values = {},
		options_keys = {
			"none",
			"ammo_cache_pocketable",
			"battery_01_luggable",
			"consumable",
			"container_01_luggable",
			"container_02_luggable",
			"container_03_luggable",
			"control_rod_01_luggable",
			"grimoire",
			"large_clip",
			"large_metal",
			"large_platinum",
			"medical_crate_pocketable",
			"small_clip",
			"small_grenade",
			"small_metal",
			"small_platinum",
			"tome"
		},
		options_values = {
			"none",
			"ammo_cache_pocketable",
			"battery_01_luggable",
			"consumable",
			"container_01_luggable",
			"container_02_luggable",
			"container_03_luggable",
			"control_rod_01_luggable",
			"grimoire",
			"large_clip",
			"large_metal",
			"large_platinum",
			"medical_crate_pocketable",
			"small_clip",
			"small_grenade",
			"small_metal",
			"small_platinum",
			"tome"
		}
	},
	item_spawn_selection = {
		value = "random_in_list",
		ui_type = "combo_box",
		category = "Spawn Parameters",
		ui_name = "Item Spawn Selection",
		options_keys = {
			"next_in_list",
			"random_in_list"
		},
		options_values = {
			"next_in_list",
			"random_in_list"
		}
	},
	spawn_nodes = {
		category = "Spawn Parameters",
		ui_type = "text_box_array",
		size = 1,
		ui_name = "Spawn Nodes",
		values = {
			"c_pickup"
		}
	},
	inputs = {
		spawn_item = {
			accessibility = "public",
			type = "event"
		}
	},
	extensions = {
		"PickupSpawnerExtension"
	}
}

return PickupSpawner
