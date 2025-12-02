-- chunkname: @scripts/extension_systems/visual_loadout/minion_visual_loadout_extension.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local MasterItems = require("scripts/backend/master_items")
local MinionGibbing = require("scripts/managers/minion/minion_gibbing")
local MutatorMinionVisualOverrideSettings = require("scripts/settings/mutator/mutator_mininion_visual_overrides_settings")
local RegionConstants = require("scripts/settings/region/region_constants")
local SideColor = require("scripts/utilities/side_color")
local VisualLoadoutCustomization = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_customization")
local VisualLoadoutLodGroup = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_lod_group")
local CLIENT_RPCS = {
	"rpc_minion_wield_slot",
	"rpc_minion_unwield_slot",
	"rpc_minion_drop_slot",
	"rpc_minion_send_on_death_event",
	"rpc_minion_send_on_show_hide_weapon_event",
	"rpc_minion_unequip_slot",
	"rpc_minion_override_slot",
	"rpc_minion_set_slot_visibility",
	"rpc_minion_gib",
}
local MinionVisualLoadoutExtension = class("MinionVisualLoadoutExtension")

local function _link_unit(world, item_unit, target_unit, attach_node_name, map_nodes)
	local attach_node_index = Unit.node(target_unit, attach_node_name)

	World.link_unit(world, item_unit, 1, target_unit, attach_node_index, map_nodes)
end

local _attach_settings = {
	attach_pose = nil,
	character_unit = nil,
	from_script_component = false,
	from_ui_profile_spawner = false,
	is_minion = true,
	item_definitions = nil,
	lod_group = nil,
	lod_shadow_group = nil,
	spawn_with_extensions = false,
	unit_spawner = nil,
	world = nil,
}

local function _create_slot_entry(unit, lod_group, lod_shadow_group, world, item_slot_data, random_seed, item_definitions)
	local items = item_slot_data.items
	local num_items = #items
	local new_seed, item_index = math.next_random(random_seed, 1, num_items)
	local item_name = items[item_index]
	local item_data = item_definitions[item_name]
	local attach_node_name = item_data.unwielded_attach_node or item_data.attach_node
	local attach_node

	if tonumber(attach_node_name) ~= nil then
		attach_node = tonumber(attach_node_name)
	else
		attach_node = Unit.node(unit, item_data.unwielded_attach_node or item_data.attach_node)
	end

	local item_unit, attachments

	if DEDICATED_SERVER and not item_slot_data.is_weapon then
		item_unit = nil
		attachments = nil
	else
		_attach_settings.world = world
		_attach_settings.unit_spawner = Managers.state.unit_spawner
		_attach_settings.character_unit = unit
		_attach_settings.item_definitions = item_definitions
		_attach_settings.attach_pose = Unit.world_pose(unit, attach_node)
		_attach_settings.lod_group = lod_group
		_attach_settings.lod_shadow_group = lod_shadow_group

		if item_slot_data.spawn_with_extensions then
			_attach_settings.extension_manager = Managers.state.extension
			_attach_settings.spawn_with_extensions = true
		else
			_attach_settings.extension_manager = nil
			_attach_settings.spawn_with_extensions = nil
		end

		local mission_template, equipment

		item_unit, attachments = VisualLoadoutCustomization.spawn_item(item_data, _attach_settings, unit, false, false, false, mission_template, equipment)
	end

	local drop_on_death = item_slot_data.drop_on_death
	local slot_entry = {
		state = "unwielded",
		visible = true,
		unit = item_unit,
		attachments = attachments and attachments[item_unit],
		item_data = item_data,
		drop_on_death = drop_on_death,
		starts_invisible = item_slot_data.starts_invisible,
	}

	return slot_entry, new_seed
end

MinionVisualLoadoutExtension.create_slot_entry = function (self, unit, item_slot_data)
	local lod_group = VisualLoadoutLodGroup.try_init_and_fetch_lod_group(unit, "lod")
	local lod_shadow_group = VisualLoadoutLodGroup.try_init_and_fetch_lod_group(unit, "lod_shadow")
	local item_definitions = MasterItems.get_cached()
	local seed = math.random_seed()
	local world = self._world
	local newly_equipped = _create_slot_entry(unit, lod_group, lod_shadow_group, world, item_slot_data, seed, item_definitions)

	return newly_equipped
end

local function _create_material_override_slot_entry(unit, item_slot_data, random_seed, item_definitions)
	local items = item_slot_data.items
	local num_items = #items
	local new_seed, item_index = math.next_random(random_seed, 1, num_items)
	local item_name = items[item_index]
	local item_data = item_definitions[item_name]

	for i, material_override in pairs(item_data.material_overrides) do
		VisualLoadoutCustomization.apply_material_override(unit, unit, false, material_override, false)
	end

	local material_override_items = item_data.material_override_items

	if material_override_items then
		for i, material_override_item in pairs(material_override_items) do
			VisualLoadoutCustomization.apply_material_override_item(unit, unit, false, material_override_item, false, item_definitions)
		end
	end

	local slot_entry = {
		item_data = item_data,
	}

	return slot_entry, new_seed
end

MinionVisualLoadoutExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	local is_server = extension_init_context.is_server
	local world = extension_init_context.world

	self._is_server = is_server
	self._unit = unit
	self._world = world
	self._wwise_world = extension_init_context.wwise_world

	local slots = {}

	self._slots = slots
	self._wielded_slot_name = nil

	local breed = extension_init_data.breed

	self._breed, self._breed_name = breed, breed.name

	local lod_group = VisualLoadoutLodGroup.try_init_and_fetch_lod_group(unit, "lod")
	local lod_shadow_group = VisualLoadoutLodGroup.try_init_and_fetch_lod_group(unit, "lod_shadow")
	local item_definitions = MasterItems.get_cached()
	local random_seed, inventory = extension_init_data.random_seed, extension_init_data.inventory

	self._random_seed = random_seed
	self._inventory = inventory

	local material_override_slots = {}

	self._material_override_slots = material_override_slots

	local inventory_slots = inventory.slots

	for slot_name, slot_data in pairs(inventory_slots) do
		local slot_unit

		if slot_data.is_material_override_slot then
			material_override_slots[slot_name] = slot_data
		elseif slot_data.is_weapon then
			slots[slot_name], random_seed = _create_slot_entry(unit, nil, nil, world, slot_data, random_seed, item_definitions)
			slot_unit = slots[slot_name].unit
		else
			slots[slot_name], random_seed = _create_slot_entry(unit, lod_group, lod_shadow_group, world, slot_data, random_seed, item_definitions)
			slot_unit = slots[slot_name].unit
		end

		if slot_data.starts_invisible then
			self:_set_slot_visibility(slot_name, false)
		end

		if slot_unit then
			Managers.state.out_of_bounds:register_soft_oob_unit(slot_unit, self, "_update_soft_oob")
		end
	end

	for slot_name, slot_data in pairs(material_override_slots) do
		material_override_slots[slot_name], random_seed = _create_material_override_slot_entry(unit, slot_data, random_seed, item_definitions)
	end

	if not is_server then
		local network_event_delegate = extension_init_context.network_event_delegate

		self._network_event_delegate = network_event_delegate
		self._game_object_id = nil_or_game_object_id

		network_event_delegate:register_session_unit_events(self, nil_or_game_object_id, unpack(CLIENT_RPCS))

		self._unit_rpcs_registered = true
	end
end

MinionVisualLoadoutExtension.extensions_ready = function (self, world, unit)
	local breed = self._breed

	if not DEDICATED_SERVER then
		local tint_color = SideColor.minion_color(unit)

		if tint_color then
			local _, r, g, b = Quaternion.to_elements(tint_color)
			local vector_color, include_children = Vector3(r, g, b), true
			local material_variables = breed.side_color_material_variables

			for i = 1, #material_variables do
				local variable_name = material_variables[i]

				Unit.set_vector3_for_materials(unit, variable_name, vector_color, include_children)
			end
		end
	end

	local gib_template, use_wounds = breed.gib_template, breed.use_wounds

	if gib_template then
		local gib_variations_or_nil = self._inventory.gib_variations
		local random_seed = self._random_seed
		local wounds_extension_or_nil = use_wounds and ScriptUnit.extension(unit, "wounds_system") or nil

		self._minion_gibbing = MinionGibbing:new(unit, breed, world, self._wwise_world, gib_template, self, random_seed, gib_variations_or_nil, wounds_extension_or_nil)
	end
end

MinionVisualLoadoutExtension.game_object_initialized = function (self, game_session, game_object_id)
	self._game_object_id = game_object_id
end

MinionVisualLoadoutExtension.destroy = function (self)
	local unit_spawner_manager = Managers.state.unit_spawner

	for slot_name, slot_data in pairs(self._slots) do
		if slot_data.state ~= "unequipped" then
			local attachments = slot_data.attachments

			if attachments then
				for i = #attachments, 1, -1 do
					local attach_unit = attachments[i]

					unit_spawner_manager:mark_for_deletion(attach_unit)
				end
			end

			local item_unit = slot_data.unit

			if item_unit then
				unit_spawner_manager:mark_for_deletion(item_unit)
				Managers.state.out_of_bounds:unregister_soft_oob_unit(item_unit, self)
			end
		end
	end

	if not self._is_server and self._unit_rpcs_registered then
		self._network_event_delegate:unregister_unit_events(self._game_object_id, unpack(CLIENT_RPCS))

		self._unit_rpcs_registered = false
	end

	if self._minion_gibbing then
		self._minion_gibbing:delete_gibs()
	end
end

MinionVisualLoadoutExtension.gib_from_queue = function (self, ...)
	self._minion_gibbing:spawn_gib_from_queue(...)
end

MinionVisualLoadoutExtension._update_soft_oob = function (self, unit)
	for slot_name, slot_data in pairs(self._slots) do
		if unit == slot_data.unit then
			if self._unit_is_local then
				Log.info("MinionVisualLoadoutExtension", "%s's %s is out-of-bounds, despawning (%s).", self._breed_name, unit, tostring(Unit.world_position(unit, 1)))
				self:_unequip_slot(slot_name)
			elseif self._is_server then
				Log.info("MinionVisualLoadoutExtension", "%s's %s is out-of-bounds, despawning (%s).", self._breed_name, unit, tostring(Unit.world_position(unit, 1)))
				self:unequip_slot(slot_name)
			else
				local dropped_actor = Unit.actor(unit, "dropped")

				if dropped_actor then
					Log.info("MinionVisualLoadoutExtension", "%s's %s is out-of-bounds, destroying actor (%s).", self._breed_name, unit, tostring(Unit.world_position(unit, 1)))
					Unit.destroy_actor(unit, dropped_actor)
				end
			end
		end
	end
end

MinionVisualLoadoutExtension.slots = function (self)
	return self._slots
end

MinionVisualLoadoutExtension.material_override_slots = function (self)
	return self._material_override_slots
end

MinionVisualLoadoutExtension.inventory = function (self)
	return self._inventory
end

MinionVisualLoadoutExtension.inventory_slots = function (self)
	return self._inventory.slots
end

MinionVisualLoadoutExtension.set_new_gib_template = function (self, template)
	self._minion_gibbing:set_new_gib_template(template)
end

MinionVisualLoadoutExtension.set_unit_local = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_unit_events(self._game_object_id, unpack(CLIENT_RPCS))

		self._unit_rpcs_registered = false
		self._game_object_id = nil
	end

	self._unit_is_local = true
end

MinionVisualLoadoutExtension._wield_slot = function (self, slot_name)
	local slots = self._slots
	local slot_data = slots[slot_name]
	local slot_state = slot_data.state
	local item_data = slot_data.item_data
	local wielded_node_name = item_data.wielded_attach_node
	local current_wielded_slot_name = self._wielded_slot_name

	if current_wielded_slot_name then
		self:_unwield_slot(current_wielded_slot_name)
	end

	local world = self._world
	local item_unit = slot_data.unit
	local unit = self._unit
	local reset_scene_graph = item_data.reset_scene_graph_on_unlink

	World.unlink_unit(world, item_unit, reset_scene_graph)
	_link_unit(world, item_unit, unit, wielded_node_name, true)

	slot_data.state = "wielded"
	self._wielded_slot_name = slot_name
end

MinionVisualLoadoutExtension.has_slot = function (self, slot_name)
	return self._slots[slot_name] and true or false
end

MinionVisualLoadoutExtension.wield_slot = function (self, slot_name)
	self:_wield_slot(slot_name)

	local game_object_id = self._game_object_id
	local slot_id = NetworkLookup.minion_inventory_slot_names[slot_name]

	Managers.state.game_session:send_rpc_clients("rpc_minion_wield_slot", game_object_id, slot_id)
end

MinionVisualLoadoutExtension._unwield_slot = function (self, slot_name)
	local slots = self._slots
	local slot_data = slots[slot_name]
	local slot_state = slot_data.state
	local item_data = slot_data.item_data
	local unwielded_node_name = item_data.unwielded_attach_node
	local world = self._world
	local item_unit = slot_data.unit
	local unit = self._unit
	local reset_scene_graph = item_data.reset_scene_graph_on_unlink

	World.unlink_unit(world, item_unit, reset_scene_graph)
	_link_unit(world, item_unit, unit, unwielded_node_name, false)

	slot_data.state = "unwielded"
	self._wielded_slot_name = nil
end

MinionVisualLoadoutExtension.unwield_slot = function (self, slot_name)
	self:_unwield_slot(slot_name)

	local game_object_id = self._game_object_id
	local slot_id = NetworkLookup.minion_inventory_slot_names[slot_name]

	Managers.state.game_session:send_rpc_clients("rpc_minion_unwield_slot", game_object_id, slot_id)
end

MinionVisualLoadoutExtension._drop_slot = function (self, slot_name)
	local slots = self._slots
	local slot_data = slots[slot_name]
	local slot_state = slot_data.state

	if self._wielded_slot_name == slot_name then
		self._wielded_slot_name = nil
	end

	if not DEDICATED_SERVER then
		local has_outline_system = Managers.state.extension:has_system("outline_system")

		if has_outline_system then
			local outline_system = Managers.state.extension:system("outline_system")

			outline_system:dropping_loadout_unit(self._unit, slot_data.unit)
		end
	end

	local world = self._world
	local item_unit = slot_data.unit
	local item_data = slot_data.item_data
	local reset_scene_graph = item_data.reset_scene_graph_on_unlink

	World.unlink_unit(world, item_unit, reset_scene_graph)

	local actor = Unit.create_actor(item_unit, "dropped")
	local collision_filter = "filter_minion_shooting_no_friendly_fire"

	Actor.set_collision_filter(actor, collision_filter)

	slot_data.state = "dropped"

	if slot_state == "wielded" then
		local random_radius = 0.25
		local x = math.random() * 2 - 1
		local y = math.random() * 2 - 1
		local random_offset = Vector3(x * random_radius, y * random_radius, 0)
		local direction = Vector3.up() + random_offset
		local speed = 5
		local velocity_vector = direction * speed

		Actor.add_velocity(actor, velocity_vector)

		local rotation = Unit.local_rotation(item_unit, 1)
		local min_angular_x, max_angular_x, max_angular_y, max_angular_z = 3, 6, 0.25, 0.25
		local torque_vector = Vector3(math.max(math.random() * max_angular_x, min_angular_x), math.random() * max_angular_y, math.random() * max_angular_z)

		torque_vector = Quaternion.rotate(rotation, torque_vector)

		Actor.add_angular_velocity(actor, torque_vector)
	end
end

MinionVisualLoadoutExtension.drop_slot = function (self, slot_name)
	self:_drop_slot(slot_name)

	local game_object_id = self._game_object_id
	local slot_id = NetworkLookup.minion_inventory_slot_names[slot_name]

	Managers.state.game_session:send_rpc_clients("rpc_minion_drop_slot", game_object_id, slot_id)
end

MinionVisualLoadoutExtension._send_on_show_hide_weapon_event = function (self, should_hide)
	for slot_name, slot_data in pairs(self._slots) do
		if slot_data.state ~= "unequipped" then
			local item_unit = slot_data.unit

			if item_unit then
				if should_hide then
					Unit.flow_event(item_unit, "hide_weapon")
				else
					Unit.flow_event(item_unit, "show_weapon")
				end
			end
		end

		if slot_data.attachments then
			for _, attachment in pairs(slot_data.attachments) do
				if should_hide then
					Unit.flow_event(attachment, "hide_weapon")
				else
					Unit.flow_event(attachment, "show_weapon")
				end
			end
		end
	end
end

MinionVisualLoadoutExtension.send_on_show_hide_weapon_event = function (self, should_hide)
	self:_send_on_show_hide_weapon_event(should_hide)

	local game_object_id = self._game_object_id

	Managers.state.game_session:send_rpc_clients("rpc_minion_send_on_show_hide_weapon_event", game_object_id, should_hide)
end

MinionVisualLoadoutExtension._send_on_death_event = function (self)
	for slot_name, slot_data in pairs(self._slots) do
		if slot_data.state ~= "unequipped" then
			local item_unit = slot_data.unit

			if item_unit then
				Unit.flow_event(item_unit, "on_death")
			end
		end

		if slot_data.attachments then
			for _, attachment in pairs(slot_data.attachments) do
				Unit.flow_event(attachment, "on_death")
			end
		end
	end
end

MinionVisualLoadoutExtension.send_on_death_event = function (self)
	self:_send_on_death_event()

	local game_object_id = self._game_object_id

	Managers.state.game_session:send_rpc_clients("rpc_minion_send_on_death_event", game_object_id)
end

MinionVisualLoadoutExtension._attach_slot_to_gib = function (self, slot_name, gib_unit)
	local slots = self._slots
	local slot_data = slots[slot_name]
	local slot_state = slot_data.state
	local world = self._world
	local item_unit = slot_data.unit

	if not DEDICATED_SERVER then
		local has_outline_system = Managers.state.extension:has_system("outline_system")

		if has_outline_system then
			local outline_system = Managers.state.extension:system("outline_system")

			outline_system:dropping_loadout_unit(self._unit, item_unit)
		end
	end

	World.unlink_unit(world, item_unit, true)
	World.link_unit(world, item_unit, 1, gib_unit, 1, true)

	local gib_lod_group = Unit.has_lod_group(gib_unit, "lod") and Unit.lod_group(gib_unit, "lod")

	if gib_lod_group and Unit.has_lod_object(item_unit, "lod") then
		local item_lod_object = Unit.lod_object(item_unit, "lod")
		local item_lod_group = LODObject.lod_group(item_lod_object)

		if item_lod_group then
			LODGroup.remove_lod_object(item_lod_group, item_lod_object)
		end

		LODGroup.add_lod_object(gib_lod_group, item_lod_object)

		local attachments = slot_data.attachments

		if attachments then
			for i = 1, #attachments do
				local attachment_unit = attachments[i]

				if Unit.has_lod_object(attachment_unit, "lod") then
					local attachment_lod_object = Unit.lod_object(attachment_unit, "lod")
					local attachment_lod_group = LODObject.lod_group(attachment_lod_object)

					if attachment_lod_group then
						LODGroup.remove_lod_object(attachment_lod_group, attachment_lod_object)
					end

					LODGroup.add_lod_object(gib_lod_group, attachment_lod_object)
				end
			end
		end

		local bv = LODGroup.compile_time_bounding_volume(gib_lod_group)

		if bv then
			LODGroup.override_bounding_volume(gib_lod_group, bv)
		end
	end
end

MinionVisualLoadoutExtension._unequip_slot = function (self, slot_name)
	local slots = self._slots
	local slot_data = slots[slot_name]
	local slot_state = slot_data.state

	if self._wielded_slot_name == slot_name then
		self._wielded_slot_name = nil
	end

	local unit_spawner_manager = Managers.state.unit_spawner
	local attachments = slot_data.attachments

	if attachments then
		for i = #attachments, 1, -1 do
			local attach_unit = attachments[i]

			unit_spawner_manager:mark_for_deletion(attach_unit)
		end
	end

	local item_unit = slot_data.unit

	if item_unit then
		unit_spawner_manager:mark_for_deletion(item_unit)
		Managers.state.out_of_bounds:unregister_soft_oob_unit(item_unit, self)
	end

	table.clear(slot_data)

	slot_data.state = "unequipped"
end

MinionVisualLoadoutExtension.unequip_slot = function (self, slot_name)
	self:_unequip_slot(slot_name)

	local game_object_id = self._game_object_id
	local slot_id = NetworkLookup.minion_inventory_slot_names[slot_name]

	Managers.state.game_session:send_rpc_clients("rpc_minion_unequip_slot", game_object_id, slot_id)
end

MinionVisualLoadoutExtension._set_slot_visibility = function (self, slot_name, visibility)
	local slots = self._slots
	local slot_data = slots[slot_name]

	if not DEDICATED_SERVER then
		local item_unit = slot_data.unit

		Unit.set_unit_visibility(item_unit, visibility, true)
	end

	slot_data.visible = visibility
end

MinionVisualLoadoutExtension.set_slot_visibility = function (self, slot_name, visibility)
	self:_set_slot_visibility(slot_name, visibility)

	local game_object_id = self._game_object_id
	local slot_id = NetworkLookup.minion_inventory_slot_names[slot_name]

	Managers.state.game_session:send_rpc_clients("rpc_minion_set_slot_visibility", game_object_id, slot_id, visibility)
end

MinionVisualLoadoutExtension.slot_items = function (self)
	return self._slots
end

MinionVisualLoadoutExtension.slot_item = function (self, slot_name)
	local slots = self._slots
	local slot_data = slots[slot_name]

	if not slot_data then
		return nil
	end

	return slot_data
end

MinionVisualLoadoutExtension.unit_3p_from_slot = function (self, slot_name)
	local unit_3p = self:slot_unit(slot_name)

	return unit_3p
end

MinionVisualLoadoutExtension.slot_unit = function (self, slot_name)
	local slots = self._slots
	local slot_data = slots[slot_name]

	if not slot_data then
		return nil
	end

	if DEDICATED_SERVER then
		return slot_data.unit or self._unit
	end

	return slot_data.unit, slot_data.attachments
end

MinionVisualLoadoutExtension.is_slot_visible = function (self, slot_name)
	local slots = self._slots
	local slot_data = slots[slot_name]

	if not slot_data then
		return nil
	end

	return slot_data.visible
end

MinionVisualLoadoutExtension.is_inventory_slot_ranged = function (self, slot_name)
	local inventory = self._inventory
	local inventory_slots = inventory.slots
	local inventory_slot_data = inventory_slots[slot_name]

	if not inventory_slot_data then
		return nil
	end

	return inventory_slot_data.is_ranged_weapon
end

MinionVisualLoadoutExtension.can_wield_slot = function (self, slot_name)
	local slots = self._slots
	local slot_data = slots[slot_name]

	if not slot_data then
		return false
	end

	local slot_state = slot_data.state

	if slot_state ~= "unwielded" then
		return false
	end

	local item_data = slot_data.item_data
	local wielded_node_name = item_data.wielded_attach_node

	return wielded_node_name ~= nil
end

MinionVisualLoadoutExtension.can_unwield_slot = function (self, slot_name)
	local slots = self._slots
	local slot_data = slots[slot_name]

	if not slot_data then
		return false
	end

	local slot_state = slot_data.state

	if slot_state ~= "wielded" then
		return false
	end

	local item_data = slot_data.item_data
	local unwielded_node_name = item_data.unwielded_attach_node

	return unwielded_node_name ~= nil
end

MinionVisualLoadoutExtension.can_drop_slot = function (self, slot_name)
	local slots = self._slots
	local slot_data = slots[slot_name]

	if not slot_data then
		return false
	end

	local slot_state = slot_data.state

	return slot_state == "wielded" or slot_state == "unwielded"
end

MinionVisualLoadoutExtension.can_unequip_slot = function (self, slot_name)
	local slots = self._slots
	local slot_data = slots[slot_name]

	if not slot_data then
		return false
	end

	local slot_state = slot_data.state

	return slot_state ~= "unequipped"
end

MinionVisualLoadoutExtension.wielded_slot_name = function (self)
	return self._wielded_slot_name
end

MinionVisualLoadoutExtension.can_gib = function (self, hit_zone)
	local can_gib = self._minion_gibbing ~= nil

	if not can_gib then
		return false
	end

	if self:hit_zone_is_disallowed(hit_zone) then
		return false
	end

	return true
end

MinionVisualLoadoutExtension.allow_gib_for_hit_zone = function (self, hit_zone, allowed)
	return self._minion_gibbing:allow_gib_for_hit_zone(hit_zone, allowed)
end

MinionVisualLoadoutExtension.hit_zone_is_disallowed = function (self, hit_zone)
	return self._minion_gibbing:hit_zone_is_disallowed(hit_zone)
end

MinionVisualLoadoutExtension.set_ailment_effect = function (self, effect_template)
	if self._ailment_effect_template then
		return
	end

	self._ailment_effect_template = effect_template
end

MinionVisualLoadoutExtension.ailment_effect = function (self)
	return self._ailment_effect_template
end

MinionVisualLoadoutExtension.inventory = function (self)
	return self._inventory
end

MinionVisualLoadoutExtension.slot_material_override = function (self, slot_name)
	local slot_data = self._slots[slot_name] or self._material_override_slots[slot_name]
	local item_data = slot_data and slot_data.item_data

	if not item_data then
		return nil, nil
	end

	return item_data.material_override_apply_to_parent, item_data.material_overrides
end

MinionVisualLoadoutExtension.gib = function (self, hit_zone_name_or_nil, attack_direction, damage_profile, optional_is_critical_strike)
	local gibbing_enabled_locally = Application.user_setting("gore_settings", "gibbing_enabled")

	if gibbing_enabled_locally == nil then
		gibbing_enabled_locally = GameParameters.gibbing_enabled
	end

	gibbing_enabled_locally = gibbing_enabled_locally and not Managers.account:region_has_restriction(RegionConstants.restrictions.gibbing)

	local spawned_gibs

	if not DEDICATED_SERVER and gibbing_enabled_locally then
		spawned_gibs = self._minion_gibbing:gib(hit_zone_name_or_nil, attack_direction, damage_profile, nil, nil, optional_is_critical_strike)
	end

	local unit_is_local = self._unit_is_local
	local is_server = self._is_server

	if (is_server or DEDICATED_SERVER) and not unit_is_local then
		local game_object_id = self._game_object_id
		local hit_zone_id = hit_zone_name_or_nil and NetworkLookup.hit_zones[hit_zone_name_or_nil] or nil
		local damage_profile_id = NetworkLookup.damage_profile_templates[damage_profile.name]

		Managers.state.game_session:send_rpc_clients("rpc_minion_gib", game_object_id, attack_direction, damage_profile_id, hit_zone_id, not not optional_is_critical_strike)
	end

	return spawned_gibs
end

MinionVisualLoadoutExtension.hot_join_sync = function (self, unit, sender, channel)
	local game_object_id = self._game_object_id
	local override_id = self._override_id
	local slots = self._slots

	for slot_name, slot_data in pairs(slots) do
		local slot_id = NetworkLookup.minion_inventory_slot_names[slot_name]
		local slot_state = slot_data.state

		if slot_state == "wielded" then
			RPC.rpc_minion_wield_slot(channel, game_object_id, slot_id)
		elseif slot_state == "dropped" then
			RPC.rpc_minion_drop_slot(channel, game_object_id, slot_id)
		elseif slot_state == "unequipped" then
			RPC.rpc_minion_unequip_slot(channel, game_object_id, slot_id)
		elseif slot_state == "overriden" then
			RPC.rpc_minion_override_slot(channel, game_object_id, override_id)

			break
		end

		if not slot_data.visible and not slot_data.starts_invisible and slot_state ~= "unequipped" then
			RPC.rpc_minion_set_slot_visibility(channel, game_object_id, slot_id, false)
		end
	end
end

MinionVisualLoadoutExtension.set_override_id = function (self, override_id)
	self._override_id = override_id
end

MinionVisualLoadoutExtension.rpc_minion_wield_slot = function (self, channel_id, go_id, slot_id)
	local slot_name = NetworkLookup.minion_inventory_slot_names[slot_id]

	self:_wield_slot(slot_name)
end

MinionVisualLoadoutExtension.rpc_minion_unwield_slot = function (self, channel_id, go_id, slot_id)
	local slot_name = NetworkLookup.minion_inventory_slot_names[slot_id]

	self:_unwield_slot(slot_name)
end

MinionVisualLoadoutExtension.rpc_minion_drop_slot = function (self, channel_id, go_id, slot_id)
	local slot_name = NetworkLookup.minion_inventory_slot_names[slot_id]

	self:_drop_slot(slot_name)
end

MinionVisualLoadoutExtension.rpc_minion_send_on_death_event = function (self, channel_id, go_id)
	self:_send_on_death_event()
end

MinionVisualLoadoutExtension.rpc_minion_send_on_show_hide_weapon_event = function (self, channel_id, go_id, should_hide)
	self:_send_on_show_hide_weapon_event(should_hide)
end

MinionVisualLoadoutExtension.rpc_minion_unequip_slot = function (self, channel_id, go_id, slot_id)
	local slot_name = NetworkLookup.minion_inventory_slot_names[slot_id]

	self:_unequip_slot(slot_name)
end

MinionVisualLoadoutExtension.override_slot = function (self, override_name, template)
	self:_override_slot(template)

	local override_id = NetworkLookup.MutatorMinionVisualOverrideSettings[override_name]

	self:set_override_id(override_id)

	local game_object_id = self._game_object_id

	Managers.state.game_session:send_rpc_clients("rpc_minion_override_slot", game_object_id, override_id)
end

MinionVisualLoadoutExtension.rpc_minion_override_slot = function (self, channel_id, go_id, override_id)
	local override_template_name = NetworkLookup.MutatorMinionVisualOverrideSettings[override_id]
	local override_template = MutatorMinionVisualOverrideSettings[override_template_name]
	local breed_name = self._breed_name
	local overrides
	local breed = self._breed

	if override_template[breed_name] then
		overrides = override_template[breed_name]
	end

	if overrides == nil then
		for tag, _ in pairs(breed.tags) do
			if override_template[tag] then
				overrides = override_template[tag]

				break
			end
		end
	end

	if overrides == nil then
		overrides = override_template.default
	end

	local chosen_template = overrides

	self:_override_slot(chosen_template)
end

MinionVisualLoadoutExtension._override_slot = function (self, template)
	local slots = self._slots
	local unit = self._unit

	if template.has_gib_override then
		self:set_new_gib_template(template.has_gib_override)
	end

	for slot, items in pairs(template.item_slot_data) do
		local slot_data = slots[slot]

		if not slot_data then
			return
		end

		if self._wielded_slot_name == slot then
			self._wielded_slot_name = nil
		end

		local unit_spawner_manager = Managers.state.unit_spawner
		local attachments = slot_data.attachments

		if attachments then
			for i = #attachments, 1, -1 do
				local attach_unit = attachments[i]

				unit_spawner_manager:mark_for_deletion(attach_unit)
			end
		end

		local item_unit = slot_data.unit

		if item_unit then
			unit_spawner_manager:mark_for_deletion(item_unit)
			Managers.state.out_of_bounds:unregister_soft_oob_unit(item_unit, self)
		end

		if not DEDICATED_SERVER then
			slot_data = self:create_slot_entry(unit, items)
		end

		slot_data.state = "overriden"
		slots[slot] = slot_data
	end
end

MinionVisualLoadoutExtension.rpc_minion_set_slot_visibility = function (self, channel_id, go_id, slot_id, visibility)
	local slot_name = NetworkLookup.minion_inventory_slot_names[slot_id]

	self:_set_slot_visibility(slot_name, visibility)
end

MinionVisualLoadoutExtension.rpc_minion_gib = function (self, channel_id, go_id, attack_direction, damage_profile_id, hit_zone_id, is_critical_strike)
	local hit_zone_name = hit_zone_id and NetworkLookup.hit_zones[hit_zone_id]
	local damage_profile_name = NetworkLookup.damage_profile_templates[damage_profile_id]
	local damage_profile = DamageProfileTemplates[damage_profile_name]

	self:gib(hit_zone_name, attack_direction, damage_profile, is_critical_strike)
end

MinionVisualLoadoutExtension.telemetry_wielded_weapon = function (self)
	local slots = self._slots
	local wielded_slot_name = self._wielded_slot_name

	if wielded_slot_name then
		local item = slots[wielded_slot_name]

		return item.item_data
	end
end

return MinionVisualLoadoutExtension
