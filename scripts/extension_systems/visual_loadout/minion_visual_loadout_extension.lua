local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local MasterItems = require("scripts/backend/master_items")
local MinionGibbing = require("scripts/managers/minion/minion_gibbing")
local SideColor = require("scripts/utilities/side_color")
local VisualLoadoutCustomization = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_customization")
local VisualLoadoutLodGroup = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_lod_group")
local CLIENT_RPCS = {
	"rpc_minion_wield_slot",
	"rpc_minion_unwield_slot",
	"rpc_minion_drop_slot",
	"rpc_minion_send_on_death_event",
	"rpc_minion_unequip_slot",
	"rpc_minion_set_slot_visibility",
	"rpc_minion_gib"
}
local MinionVisualLoadoutExtension = class("MinionVisualLoadoutExtension")

local function _link_unit(world, item_unit, target_unit, attach_node_name, map_nodes)
	local attach_node_index = Unit.node(target_unit, attach_node_name)

	World.link_unit(world, item_unit, 1, target_unit, attach_node_index, map_nodes)
end

local function _create_slot_entry(unit, lod_group, lod_shadow_group, world, item_slot_data, random_seed, item_definitions)
	local items = item_slot_data.items
	local num_items = #items
	local new_seed, item_index = math.next_random(random_seed, 1, num_items)
	local item_data = item_definitions[items[item_index]]
	local attach_node_name = item_data.unwielded_attach_node or item_data.attach_node
	local attach_node = nil

	if tonumber(attach_node_name) ~= nil then
		attach_node = tonumber(attach_node_name)
	else
		fassert(Unit.has_node(unit, attach_node_name), "[MinionVisualLoadoutExtension] Base unit does not have attach node %q to accomodate item %q.", attach_node_name, items[item_index])

		attach_node = Unit.node(unit, item_data.unwielded_attach_node or item_data.attach_node)
	end

	local attach_settings = {
		from_script_component = false,
		spawn_with_extensions = false,
		is_minion = true,
		world = world,
		unit_spawner = Managers.state.unit_spawner,
		character_unit = unit,
		item_definitions = item_definitions,
		attach_pose = Unit.world_pose(unit, attach_node),
		lod_group = lod_group,
		lod_shadow_group = lod_shadow_group
	}
	local extract_attachment_units_bind_poses = false
	local item_unit, attachments, _, _ = VisualLoadoutCustomization.spawn_item(item_data, attach_settings, unit, extract_attachment_units_bind_poses)
	local drop_on_death = item_slot_data.drop_on_death
	local slot_entry = {
		visible = true,
		state = "unwielded",
		unit = item_unit,
		attachments = attachments,
		item_data = item_data,
		drop_on_death = drop_on_death,
		starts_invisible = item_slot_data.starts_invisible
	}

	return slot_entry, new_seed
end

local function _create_material_override_slot_entry(unit, item_slot_data, random_seed, item_definitions)
	local items = item_slot_data.items
	local num_items = #items
	local new_seed, item_index = math.next_random(random_seed, 1, num_items)
	local item_data = item_definitions[items[item_index]]

	for i, material_override in pairs(item_data.material_overrides) do
		VisualLoadoutCustomization.apply_material_override(unit, unit, false, material_override, false)
	end

	local slot_entry = {
		item_data = item_data
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
	self._soft_cap_out_of_bounds_units = extension_init_context.soft_cap_out_of_bounds_units
	local slots = {}
	self._slots = slots
	self._wielded_slot_name = nil
	local breed = extension_init_data.breed
	self._breed_name = breed.name
	self._breed = breed
	local lod_group = VisualLoadoutLodGroup.try_init_and_fetch_lod_group(unit, "lod")
	local lod_shadow_group = VisualLoadoutLodGroup.try_init_and_fetch_lod_group(unit, "lod_shadow")
	local item_definitions = MasterItems.get_cached()
	local random_seed = extension_init_data.random_seed
	local inventory = extension_init_data.inventory
	self._random_seed = random_seed
	self._inventory = inventory
	local material_override_slots = {}
	self._material_override_slots = material_override_slots

	for slot_name, slot_data in pairs(inventory) do
		if slot_name ~= "gib_overrides" then
			if slot_data.is_material_override_slot then
				material_override_slots[slot_name] = slot_data
			elseif slot_data.is_weapon then
				slots[slot_name], random_seed = _create_slot_entry(unit, nil, nil, world, slot_data, random_seed, item_definitions)
			else
				slots[slot_name], random_seed = _create_slot_entry(unit, lod_group, lod_shadow_group, world, slot_data, random_seed, item_definitions)
			end

			if slot_data.starts_invisible then
				self:_set_slot_visibility(slot_name, false)
			end
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
	local tint_color = SideColor.minion_color(unit)

	if tint_color then
		local _, r, g, b = Quaternion.to_elements(tint_color)
		local vector_color = Vector3(r, g, b)
		local include_children = true
		local material_variables = breed.side_color_material_variables

		for i = 1, #material_variables do
			local variable_name = material_variables[i]

			Unit.set_vector3_for_materials(unit, variable_name, vector_color, include_children)
		end
	end

	local gib_template = breed.gib_template
	local use_wounds = breed.use_wounds

	if gib_template then
		local gib_overrides_or_nil = self._inventory.gib_overrides
		local random_seed = self._random_seed
		local wounds_extension_or_nil = use_wounds and ScriptUnit.extension(unit, "wounds_system") or nil
		self._minion_gibbing = MinionGibbing:new(unit, breed, world, self._wwise_world, gib_template, self, random_seed, gib_overrides_or_nil, wounds_extension_or_nil)
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

			unit_spawner_manager:mark_for_deletion(item_unit)
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

MinionVisualLoadoutExtension.update = function (self, unit, dt, t, ...)
	local breed_name = self._breed_name
	local minion_gibbing = self._minion_gibbing
	local soft_cap_out_of_bounds_units = self._soft_cap_out_of_bounds_units

	if minion_gibbing then
		minion_gibbing:update(breed_name, soft_cap_out_of_bounds_units)
	end

	local unit_is_local = self._unit_is_local
	local is_server = self._is_server

	for slot_name, slot_data in pairs(self._slots) do
		local item_unit = slot_data.unit

		if soft_cap_out_of_bounds_units[item_unit] then
			if unit_is_local then
				Log.info("MinionVisualLoadoutExtension", "%s's %s is out-of-bounds, despawning (%s).", breed_name, item_unit, tostring(Unit.world_position(item_unit, 1)))
				self:_unequip_slot(slot_name)
			elseif is_server then
				Log.info("MinionVisualLoadoutExtension", "%s's %s is out-of-bounds, despawning (%s).", breed_name, item_unit, tostring(Unit.world_position(item_unit, 1)))
				self:unequip_slot(slot_name)
			else
				local dropped_actor = Unit.actor(item_unit, "dropped")

				if dropped_actor then
					Log.info("MinionVisualLoadoutExtension", "%s's %s is out-of-bounds, destroying actor (%s).", breed_name, item_unit, tostring(Unit.world_position(item_unit, 1)))
					Unit.destroy_actor(item_unit, dropped_actor)
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

	fassert(slot_data, "[MinionVisualLoadoutExtension] Tried to wield non-existing slot %q.", slot_name)

	local slot_state = slot_data.state

	fassert(slot_state == "unwielded", "[MinionVisualLoadoutExtension] Tried to wield slot %q whilst it was in state %q.", slot_name, slot_state)

	local item_data = slot_data.item_data
	local wielded_node_name = item_data.wielded_attach_node

	fassert(wielded_node_name, "[MinionVisualLoadoutExtension] Tried to wield slot %q without a wielded attachment node.", slot_name)

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
	fassert(self._is_server, "[MinionVisualLoadoutExtension] Only server should call \"wield_slot\" directly!")
	self:_wield_slot(slot_name)

	local game_object_id = self._game_object_id
	local slot_id = NetworkLookup.minion_inventory_slot_names[slot_name]

	Managers.state.game_session:send_rpc_clients("rpc_minion_wield_slot", game_object_id, slot_id)
end

MinionVisualLoadoutExtension._unwield_slot = function (self, slot_name)
	local slots = self._slots
	local slot_data = slots[slot_name]

	fassert(slot_data, "[MinionVisualLoadoutExtension] Tried to unwield non-existing slot %q.", slot_name)

	local slot_state = slot_data.state

	fassert(slot_state == "wielded", "[MinionVisualLoadoutExtension] Tried to unwield slot %q whilst it was in state %q.", slot_name, slot_state)

	local item_data = slot_data.item_data
	local unwielded_node_name = item_data.unwielded_attach_node

	fassert(unwielded_node_name, "[MinionVisualLoadoutExtension] Tried to unwield slot %q without an unwielded attachment node.", slot_name)

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
	fassert(self._is_server, "[MinionVisualLoadoutExtension] Only server should call \"unwield_slot\" directly!")
	self:_unwield_slot(slot_name)

	local game_object_id = self._game_object_id
	local slot_id = NetworkLookup.minion_inventory_slot_names[slot_name]

	Managers.state.game_session:send_rpc_clients("rpc_minion_unwield_slot", game_object_id, slot_id)
end

MinionVisualLoadoutExtension._drop_slot = function (self, slot_name)
	local slots = self._slots
	local slot_data = slots[slot_name]

	fassert(slot_data, "[MinionVisualLoadoutExtension] Tried to drop non-existing slot %q.", slot_name)

	local slot_state = slot_data.state

	fassert(slot_state == "wielded" or slot_state == "unwielded", "[MinionVisualLoadoutExtension] Tried to drop slot %q whilst it was in state %q.", slot_name, slot_state)

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
		local x, y = math.random_inside_unit_circle()
		local random_offset = Vector3(x * random_radius, y * random_radius, 0)
		local direction = Vector3.up() + random_offset
		local speed = 5
		local velocity_vector = direction * speed

		Actor.add_velocity(actor, velocity_vector)

		local rotation = Unit.local_rotation(item_unit, 1)
		local min_angular_x = 3
		local max_angular_x = 6
		local max_angular_y = 0.25
		local max_angular_z = 0.25
		local torque_vector = Vector3(math.max(math.random() * max_angular_x, min_angular_x), math.random() * max_angular_y, math.random() * max_angular_z)
		torque_vector = Quaternion.rotate(rotation, torque_vector)

		Actor.add_angular_velocity(actor, torque_vector)
	end
end

MinionVisualLoadoutExtension.drop_slot = function (self, slot_name)
	fassert(self._is_server, "[MinionVisualLoadoutExtension] Only server should call \"drop_slot\" directly!")
	self:_drop_slot(slot_name)

	local game_object_id = self._game_object_id
	local slot_id = NetworkLookup.minion_inventory_slot_names[slot_name]

	Managers.state.game_session:send_rpc_clients("rpc_minion_drop_slot", game_object_id, slot_id)
end

MinionVisualLoadoutExtension._send_on_death_event = function (self)
	for slot_name, slot_data in pairs(self._slots) do
		if slot_data.state ~= "unequipped" then
			local item_unit = slot_data.unit

			Unit.flow_event(item_unit, "on_death")
		end
	end
end

MinionVisualLoadoutExtension.send_on_death_event = function (self)
	fassert(self._is_server, "[MinionVisualLoadoutExtension] Only server should call \"send_on_death_event\" directly!")
	self:_send_on_death_event()

	local game_object_id = self._game_object_id

	Managers.state.game_session:send_rpc_clients("rpc_minion_send_on_death_event", game_object_id)
end

MinionVisualLoadoutExtension._attach_slot_to_gib = function (self, slot_name, gib_unit)
	local slots = self._slots
	local slot_data = slots[slot_name]

	fassert(slot_data, "[MinionVisualLoadoutExtension] Tried to attach non-existing slot %q to gib.", slot_name)

	local slot_state = slot_data.state

	fassert(slot_state ~= "unequipped", "[MinionVisualLoadoutExtension] Tried to attach slot %q to gib whilst it was in state %q.", slot_name, slot_state)

	local world = self._world
	local item_unit = slot_data.unit

	World.unlink_unit(world, item_unit, true)
	World.link_unit(world, item_unit, 1, gib_unit, 1, true)

	local lod_group = Unit.has_lod_group(self._unit, "lod") and Unit.lod_group(self._unit, "lod")
	local gib_lod_group = Unit.has_lod_group(gib_unit, "lod") and Unit.lod_group(gib_unit, "lod")

	if lod_group and gib_lod_group and Unit.has_lod_object(item_unit, "lod") then
		local item_lod_object = Unit.lod_object(item_unit, "lod")

		LODGroup.remove_lod_object(lod_group, item_lod_object)
		LODGroup.add_lod_object(gib_lod_group, item_lod_object)

		local bv_mesh = Unit.mesh(gib_unit, "b_culling_volume")
		local bv = Mesh.bounding_volume(bv_mesh)

		LODGroup.override_bounding_volume(gib_lod_group, bv)
	end
end

MinionVisualLoadoutExtension._unequip_slot = function (self, slot_name)
	local slots = self._slots
	local slot_data = slots[slot_name]

	fassert(slot_data, "[MinionVisualLoadoutExtension] Tried to unequip non-existing slot %q.", slot_name)

	local slot_state = slot_data.state

	fassert(slot_state ~= "unequipped", "[MinionVisualLoadoutExtension] Tried to unequip slot %q whilst it was in state %q.", slot_name, slot_state)

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

	unit_spawner_manager:mark_for_deletion(item_unit)
	table.clear(slot_data)

	slot_data.state = "unequipped"
end

MinionVisualLoadoutExtension.unequip_slot = function (self, slot_name)
	fassert(self._is_server, "[MinionVisualLoadoutExtension] Only server should call \"unequip_slot\" directly!")
	self:_unequip_slot(slot_name)

	local game_object_id = self._game_object_id
	local slot_id = NetworkLookup.minion_inventory_slot_names[slot_name]

	Managers.state.game_session:send_rpc_clients("rpc_minion_unequip_slot", game_object_id, slot_id)
end

MinionVisualLoadoutExtension._set_slot_visibility = function (self, slot_name, visibility)
	local slots = self._slots
	local slot_data = slots[slot_name]

	fassert(slot_data, "[MinionVisualLoadoutExtension] Tried to set visibility for non-existing slot %q.", slot_name)
	fassert(slot_data.state ~= "unequipped", "[MinionVisualLoadoutExtension] Tried to set visibility for unequipped slot %q.", slot_name)
	fassert(slot_data.visible ~= visibility, "[MinionVisualLoadoutExtension] Tried to set visibility for slot %q to %q, which it already was.", slot_name, visibility)

	local item_unit = slot_data.unit

	Unit.set_unit_visibility(item_unit, visibility, true)

	slot_data.visible = visibility
end

MinionVisualLoadoutExtension.set_slot_visibility = function (self, slot_name, visibility)
	fassert(self._is_server, "[MinionVisualLoadoutExtension] Only server should call \"set_slot_visibility\" directly!")
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

	return slot_data.unit
end

MinionVisualLoadoutExtension.is_slot_visible = function (self, slot_name)
	local slots = self._slots
	local slot_data = slots[slot_name]

	if not slot_data then
		return nil
	end

	return slot_data.visible
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

MinionVisualLoadoutExtension.can_gib = function (self)
	return self._minion_gibbing ~= nil
end

MinionVisualLoadoutExtension.allow_gib_for_hit_zone = function (self, hit_zone, allowed)
	return self._minion_gibbing:allow_gib_for_hit_zone(hit_zone, allowed)
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

MinionVisualLoadoutExtension.slot_material_override = function (self, slot_name)
	local slots = self._slots
	local material_override_slots = self._material_override_slots
	local slot_data = slots[slot_name]
	slot_data = slot_data or material_override_slots[slot_name]
	local item_data = slot_data and slot_data.item_data
	local material_overrides = item_data and item_data.material_overrides
	local apply_to_parent = item_data and item_data.material_override_apply_to_parent

	return apply_to_parent, material_overrides
end

MinionVisualLoadoutExtension.gib = function (self, hit_zone_name_or_nil, attack_direction, damage_profile, optional_is_critical_strike)
	local spawned_gibs = nil

	if not DEDICATED_SERVER then
		spawned_gibs = self._minion_gibbing:gib(hit_zone_name_or_nil, attack_direction, damage_profile, nil, nil, optional_is_critical_strike)
	end

	local unit_is_local = self._unit_is_local
	local is_server = self._is_server

	if is_server and not unit_is_local and (spawned_gibs or DEDICATED_SERVER) then
		local game_object_id = self._game_object_id
		local hit_zone_id = hit_zone_name_or_nil and NetworkLookup.hit_zones[hit_zone_name_or_nil] or nil
		local damage_profile_id = NetworkLookup.damage_profile_templates[damage_profile.name]

		Managers.state.game_session:send_rpc_clients("rpc_minion_gib", game_object_id, attack_direction, damage_profile_id, hit_zone_id, not not optional_is_critical_strike)
	end

	return spawned_gibs
end

MinionVisualLoadoutExtension.hot_join_sync = function (self, unit, sender, channel)
	local game_object_id = self._game_object_id
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
		end

		if not slot_data.visible and not slot_data.starts_invisible and slot_state ~= "unequipped" then
			RPC.rpc_minion_set_slot_visibility(channel, game_object_id, slot_id, false)
		end
	end
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

MinionVisualLoadoutExtension.rpc_minion_unequip_slot = function (self, channel_id, go_id, slot_id)
	local slot_name = NetworkLookup.minion_inventory_slot_names[slot_id]

	self:_unequip_slot(slot_name)
end

MinionVisualLoadoutExtension.rpc_minion_set_slot_visibility = function (self, channel_id, go_id, slot_id, visibility)
	local slot_name = NetworkLookup.minion_inventory_slot_names[slot_id]

	self:_set_slot_visibility(slot_name, visibility)
end

MinionVisualLoadoutExtension.rpc_minion_gib = function (self, channel_id, go_id, attack_direction, damage_profile_id, hit_zone_id, is_critical_strike)
	fassert(not self._is_server, "rpc_minion_gib should only be called on clients.")

	local hit_zone_name = hit_zone_id and NetworkLookup.hit_zones[hit_zone_id]
	local damage_profile_name = NetworkLookup.damage_profile_templates[damage_profile_id]
	local damage_profile = DamageProfileTemplates[damage_profile_name]

	self:gib(hit_zone_name, attack_direction, damage_profile, is_critical_strike)
end

MinionVisualLoadoutExtension.wielded_weapon = function (self)
	local slots = self._slots
	local wielded_slot_name = self._wielded_slot_name

	if wielded_slot_name then
		local item = slots[wielded_slot_name]

		return item.item_data
	end
end

return MinionVisualLoadoutExtension
