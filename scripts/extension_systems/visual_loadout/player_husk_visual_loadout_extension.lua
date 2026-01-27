-- chunkname: @scripts/extension_systems/visual_loadout/player_husk_visual_loadout_extension.lua

local Breeds = require("scripts/settings/breed/breeds")
local EquipmentComponent = require("scripts/extension_systems/visual_loadout/equipment_component")
local ImpactFxResourceDependencies = require("scripts/settings/damage/impact_fx_resource_dependencies")
local MasterItems = require("scripts/backend/master_items")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerCharacterDecals = require("scripts/settings/decal/player_character_decals")
local PlayerCharacterLoopingSoundAliases = require("scripts/settings/sound/player_character_looping_sound_aliases")
local PlayerCharacterParticles = require("scripts/settings/particles/player_character_particles")
local PlayerCharacterSounds = require("scripts/settings/sound/player_character_sounds")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WieldableSlotScripts = require("scripts/extension_systems/visual_loadout/utilities/wieldable_slot_scripts")
local PlayerHuskVisualLoadoutExtension = class("PlayerHuskVisualLoadoutExtension")
local RPCS = {
	"rpc_player_equip_item_to_slot",
	"rpc_player_equip_item_from_profile_to_slot",
	"rpc_player_unequip_item_from_slot",
}

local function _register_fx_sources(fx_extension, slot, source_config, slot_name, is_in_first_person_mode)
	local unit_1p = slot.unit_1p
	local attachments_by_unit_1p = slot.attachments_by_unit_1p
	local attachment_id_lookup_1p = slot.attachment_id_lookup_1p
	local sources = {}

	for alias, node_name in pairs(source_config) do
		local source_name = slot_name .. alias

		fx_extension:register_sound_source(source_name, unit_1p, attachments_by_unit_1p, attachment_id_lookup_1p, node_name)

		local parent_unit, vfx_attachments, attachment_id_lookup

		if is_in_first_person_mode then
			parent_unit = unit_1p
			vfx_attachments = attachments_by_unit_1p
			attachment_id_lookup = attachment_id_lookup_1p
		else
			parent_unit = slot.unit_3p
			vfx_attachments = slot.attachments_by_unit_3p
			attachment_id_lookup = slot.attachment_id_lookup_3p
		end

		fx_extension:register_vfx_spawner(source_name, parent_unit, vfx_attachments, attachment_id_lookup, node_name)

		sources[alias] = source_name
	end

	return sources
end

local function _move_fx_sources(fx_extension, source_config, sources, slot, is_in_first_person_mode)
	local unit_1p, unit_3p = slot.unit_1p, slot.unit_3p
	local parent_unit, attachments, attachment_id_lookup

	if is_in_first_person_mode then
		parent_unit = unit_1p
		attachments = slot.attachments_by_unit_1p
		attachment_id_lookup = slot.attachment_id_lookup_1p
	else
		parent_unit = unit_3p
		attachments = slot.attachments_by_unit_3p
		attachment_id_lookup = slot.attachment_id_lookup_3p
	end

	for alias, source_name in pairs(sources) do
		local node_name = source_config[alias]

		fx_extension:move_sound_source(source_name, parent_unit, attachments, attachment_id_lookup, node_name)
		fx_extension:move_vfx_spawner(source_name, parent_unit, attachments, attachment_id_lookup, node_name)
	end
end

local function _unregister_fx_sources(fx_extension, sources)
	for alias, source_name in pairs(sources) do
		fx_extension:unregister_vfx_spawner(source_name)
		fx_extension:unregister_sound_source(source_name)
	end
end

PlayerHuskVisualLoadoutExtension.NO_WIELDABLE_SLOT = "not_wielded"

PlayerHuskVisualLoadoutExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id)
	self._unit = unit
	self._game_object_id = game_object_id
	self.is_husk = true

	local slot_configuration = extension_init_data.slot_configuration

	self._slot_configuration = slot_configuration
	self._player = extension_init_data.player

	local world = extension_init_context.world
	local unit_spawner = Managers.state.unit_spawner
	local extension_manager = Managers.state.extension
	local item_streaming_settings = {
		package_synchronizer_client = extension_init_data.package_synchronizer_client,
		player = self._player,
	}

	self._item_definitions = MasterItems.get_cached()

	local equipment_component = EquipmentComponent:new(world, self._item_definitions, unit_spawner, unit, extension_manager, item_streaming_settings, nil, nil)

	self._equipment_component = equipment_component

	local breed_name = extension_init_data.archetype.breed
	local breed_settings = Breeds[breed_name]
	local equipment = equipment_component.initialize_equipment(slot_configuration, breed_settings)

	self._equipment = equipment
	self._wielded_slot = PlayerHuskVisualLoadoutExtension.NO_WIELDABLE_SLOT

	local network_event_delegate = extension_init_context.network_event_delegate

	network_event_delegate:register_session_unit_events(self, self._game_object_id, unpack(RPCS))

	self._network_event_delegate = network_event_delegate

	local fx_extension = ScriptUnit.extension(unit, "fx_system")

	self._fx_extension = fx_extension
	self._fx_sources = {}

	local first_person_extension = ScriptUnit.extension(unit, "first_person_system")

	self._first_person_extension = first_person_extension

	local first_person_unit = first_person_extension:first_person_unit()

	self._first_person_unit = first_person_unit

	local is_in_first_person_mode = first_person_extension:is_in_first_person_mode()

	self._is_in_first_person_mode = is_in_first_person_mode

	local wieldable_slot_scripts = {}

	self._wieldable_slot_scripts = wieldable_slot_scripts
	self._wieldable_slot_scripts_context = {
		is_husk = true,
		is_local_unit = false,
		is_server = false,
		owner_unit = unit,
		equipment_component = equipment_component,
		game_session = game_session,
		first_person_unit = first_person_unit,
		world = extension_init_context.world,
		physics_world = extension_init_context.physics_world,
		wwise_world = extension_init_context.wwise_world,
		visual_loadout_extension = self,
		unit_data_extension = ScriptUnit.extension(unit, "unit_data_system"),
		fx_extension = fx_extension,
		player_particle_group_id = Managers.state.extension:system("fx_system").unit_to_particle_group_lookup[unit],
	}
	self._mission = extension_init_data.mission
	self._static_profile_properties = {
		breed = extension_init_data.archetype.breed,
		companion_breed = extension_init_data.archetype.companion_breed,
		archetype = extension_init_data.archetype.name,
		selected_voice = extension_init_data.selected_voice,
	}
	self._profile_properties = equipment_component.resolve_profile_properties(equipment, self._wielded_slot, self._static_profile_properties)
	self._dialogue_extension = ScriptUnit.extension(unit, "dialogue_system")
	self._companion_slots = {}

	for slot_name, config in pairs(slot_configuration) do
		if config.wieldable then
			wieldable_slot_scripts[slot_name] = {}
		end
	end
end

PlayerHuskVisualLoadoutExtension.extensions_ready = function (self, world, unit)
	WieldableSlotScripts.extensions_ready(self._wieldable_slot_scripts)
end

PlayerHuskVisualLoadoutExtension.destroy = function (self)
	self._network_event_delegate:unregister_unit_events(self._game_object_id, unpack(RPCS))

	for _, slot_scripts in pairs(self._wieldable_slot_scripts) do
		WieldableSlotScripts.destroy(slot_scripts)
	end

	for _, slot in pairs(self._equipment) do
		if slot.equipped then
			if slot.wieldable then
				local item = slot.item
				local weapon_template = WeaponTemplate.weapon_template_from_item(item)
				local template_name = weapon_template.name
				local decal_unit_ids = ImpactFxResourceDependencies.impact_decal_units(template_name, weapon_template)

				Managers.state.decal:unregister_decal_unit_ids(decal_unit_ids)
			end

			self._equipment_component:unequip_item(slot)
		end
	end

	for slot_name, source in pairs(self._fx_sources) do
		_unregister_fx_sources(self._fx_extension, source)
	end
end

PlayerHuskVisualLoadoutExtension.update = function (self, unit, dt, t)
	local mission = self._mission
	local slot_equip_order = PlayerCharacterConstants.slot_equip_order
	local spawned_attachments, spawned_slots = self._equipment_component:try_spawn_attachments(self._equipment, slot_equip_order, mission)
	local wieldable_slot_scripts = self._wieldable_slot_scripts
	local wielded_slot_name = self._wielded_slot

	if spawned_attachments then
		local fx_sources = self._fx_sources

		for slot_name, slot in pairs(spawned_slots) do
			if slot.wieldable then
				local slot_fx_sources = fx_sources[slot_name]

				WieldableSlotScripts.create(self._wieldable_slot_scripts_context, wieldable_slot_scripts, slot_fx_sources, slot)

				local slot_scripts = wieldable_slot_scripts[slot_name]

				if self._is_local_unit and wielded_slot_name == slot_name and slot_scripts then
					WieldableSlotScripts.wield(slot_scripts)
				end
			end
		end
	end

	local first_person_extension = self._first_person_extension
	local is_in_first_person_mode = first_person_extension:is_in_first_person_mode()

	if self._is_in_first_person_mode ~= is_in_first_person_mode or spawned_attachments then
		self._is_in_first_person_mode = is_in_first_person_mode

		self:_update_item_visibility(is_in_first_person_mode)

		local fx_sources = self._fx_sources
		local fx_extension = self._fx_extension

		for slot_name, slot in pairs(self._equipment) do
			if slot.equipped and slot.wieldable then
				local item = slot.item
				local weapon_template = WeaponTemplate.weapon_template_from_item(item)
				local fx_source_config = weapon_template.fx_sources
				local slot_fx_sources = fx_sources[slot_name]

				_move_fx_sources(fx_extension, fx_source_config, slot_fx_sources, slot, is_in_first_person_mode)
			end
		end
	end

	local slot_scripts = wieldable_slot_scripts[wielded_slot_name]

	if slot_scripts then
		WieldableSlotScripts.update(slot_scripts, unit, dt, t)
	end
end

PlayerHuskVisualLoadoutExtension.update_unit_position = function (self, unit, dt, t)
	local wielded_slot_name = self._wielded_slot
	local wielded_slot_scripts = self._wieldable_slot_scripts[wielded_slot_name]

	if wielded_slot_scripts then
		WieldableSlotScripts.update_unit_position(wielded_slot_scripts, unit, dt, t)
	end
end

PlayerHuskVisualLoadoutExtension.force_update_item_visibility = function (self)
	self:_update_item_visibility(self._is_in_first_person_mode)
end

PlayerHuskVisualLoadoutExtension._update_item_visibility = function (self, is_in_first_person_mode)
	self._equipment_component.update_item_visibility(self._equipment, self._wielded_slot, self._unit, self._first_person_unit, is_in_first_person_mode, self._item_definitions)

	local slot_scripts = self._wieldable_slot_scripts[self._wielded_slot]

	if slot_scripts then
		WieldableSlotScripts.update_first_person_mode(slot_scripts, is_in_first_person_mode)
	end
end

PlayerHuskVisualLoadoutExtension.wield_slot = function (self, slot_name)
	self._wielded_slot = slot_name

	local first_person_mode = self._first_person_extension:is_in_first_person_mode()
	local equipment_component = self._equipment_component
	local equipment = self._equipment

	equipment_component.wield_slot(equipment, first_person_mode)
	self:_update_item_visibility(self._is_in_first_person_mode)

	self._profile_properties = equipment_component.resolve_profile_properties(equipment, slot_name, self._static_profile_properties)

	local slot_scripts = self._wieldable_slot_scripts[slot_name]

	if slot_scripts then
		WieldableSlotScripts.wield(slot_scripts)
	end
end

PlayerHuskVisualLoadoutExtension.weapon_template_from_slot = function (self, slot_name)
	local slot = self._equipment[slot_name]

	return WeaponTemplate.weapon_template_from_item(slot and slot.item)
end

PlayerHuskVisualLoadoutExtension.item_from_slot = function (self, slot_name)
	local slot = self._equipment[slot_name]
	local item = slot and slot.item

	return item
end

PlayerHuskVisualLoadoutExtension.unit_3p_from_slot = function (self, slot_name)
	local slot = self._equipment[slot_name]
	local unit_3p = slot and slot.unit_3p

	return unit_3p
end

PlayerHuskVisualLoadoutExtension.unwield_slot = function (self, slot_name)
	local slot_scripts = self._wieldable_slot_scripts[slot_name]

	if slot_scripts then
		WieldableSlotScripts.unwield(slot_scripts)
	end

	local first_person_mode = false
	local equipment_component = self._equipment_component
	local equipment = self._equipment

	equipment_component.unwield_slot(equipment[slot_name], first_person_mode)

	self._wielded_slot = PlayerHuskVisualLoadoutExtension.NO_WIELDABLE_SLOT
	self._profile_properties = equipment_component.resolve_profile_properties(equipment, nil, self._static_profile_properties)
end

PlayerHuskVisualLoadoutExtension._equip_item_to_slot = function (self, slot_name, item, optional_existing_unit_3p)
	local equipment = self._equipment
	local slot = equipment[slot_name]
	local player = self._player
	local profile = player:profile()
	local parent_unit_3p = self._unit
	local parent_unit_1p = self._first_person_unit
	local deform_overrides = item.deform_overrides and table.clone(item.deform_overrides) or {}
	local deform_override_items = item.deform_override_items and table.clone(item.deform_override_items) or {}

	if profile.gender == "female" then
		deform_overrides[#deform_overrides + 1] = "wrap_deform_human_body_female"
		deform_override_items[#deform_override_items + 1] = "content/items/material_overrides/player_wrap_deform/wrap_deform_human_body_female"
	end

	local unit_data_extension = ScriptUnit.extension(self._unit, "unit_data_system")
	local breed = unit_data_extension:breed()
	local breed_name = breed.name
	local equipment_component = self._equipment_component
	local mission = self._mission

	equipment_component:equip_item(parent_unit_3p, parent_unit_1p, slot, item, optional_existing_unit_3p, deform_overrides, deform_override_items, breed_name, mission)

	local is_in_first_person_mode = self._is_in_first_person_mode

	if slot.wieldable then
		local weapon_template = WeaponTemplate.weapon_template_from_item(item)
		local weapon_template_fx_sources = weapon_template.fx_sources
		local fx_sources = _register_fx_sources(self._fx_extension, slot, weapon_template_fx_sources, slot_name, is_in_first_person_mode)

		self._fx_sources[slot_name] = fx_sources

		if slot.attachment_spawn_status == "fully_spawned" then
			WieldableSlotScripts.create(self._wieldable_slot_scripts_context, self._wieldable_slot_scripts, fx_sources, slot)
		end

		local template_name = weapon_template.name
		local decal_unit_ids = ImpactFxResourceDependencies.impact_decal_units(template_name, weapon_template)

		Managers.state.decal:register_decal_unit_ids(decal_unit_ids)
	end

	local voice_fx_preset = item.voice_fx_preset

	if voice_fx_preset then
		self._dialogue_extension:set_voice_fx_preset(voice_fx_preset)
	end

	self:_update_item_visibility(is_in_first_person_mode)

	self._profile_properties = equipment_component.resolve_profile_properties(equipment, self._wielded_slot, self._static_profile_properties)
end

PlayerHuskVisualLoadoutExtension.rpc_player_equip_item_from_profile_to_slot = function (self, channel_id, go_id, slot_id, debug_item_id)
	local slot_name = NetworkLookup.player_inventory_slot_names[slot_id]
	local player = self._player
	local profile = player:profile()
	local visual_loadout = profile.visual_loadout
	local item = visual_loadout[slot_name]
	local optional_existing_unit_3p
	local debug_item_name = NetworkLookup.player_item_names[debug_item_id]
	local client_item_name = item and item.name

	if client_item_name ~= debug_item_name then
		client_item_name = client_item_name or "N/A"

		local channel_peer_id = Network.peer_id(channel_id)
		local player_peer_id = player:peer_id()

		Crashify.print_exception("PlayerHuskVisualLoadoutExtension", "Client has a different item than server has in player profile.")
		ferror("[PlayerHuskVisualLoadoutExtension] Profile item mismatch. Failed to equip item `%s` in slot `%s`. Client item was `%s`", debug_item_name, slot_name, client_item_name)
	end

	self:_equip_item_to_slot(slot_name, item, optional_existing_unit_3p)
end

PlayerHuskVisualLoadoutExtension.rpc_player_equip_item_to_slot = function (self, channel_id, go_id, slot_id, item_id, optional_existing_unit_3p_id)
	local slot_name = NetworkLookup.player_inventory_slot_names[slot_id]
	local item_name = NetworkLookup.player_item_names[item_id]
	local item = self._item_definitions[item_name]
	local optional_existing_unit_3p = Managers.state.unit_spawner:unit(optional_existing_unit_3p_id)

	self:_equip_item_to_slot(slot_name, item, optional_existing_unit_3p)
end

PlayerHuskVisualLoadoutExtension.rpc_player_unequip_item_from_slot = function (self, channel_id, go_id, slot_id)
	local slot_name = NetworkLookup.player_inventory_slot_names[slot_id]
	local equipment = self._equipment
	local slot = equipment[slot_name]
	local item = slot.item
	local voice_fx_preset = item.voice_fx_preset

	if voice_fx_preset then
		self._dialogue_extension:set_voice_fx_preset(nil)
	end

	local equipment_component = self._equipment_component

	equipment_component:unequip_item(slot)

	if slot.wieldable then
		local slot_scripts = self._wieldable_slot_scripts[slot_name]

		if slot_scripts then
			WieldableSlotScripts.destroy(slot_scripts)
			table.clear(slot_scripts)
		end

		_unregister_fx_sources(self._fx_extension, self._fx_sources[slot_name])

		self._fx_sources[slot_name] = nil

		local weapon_template = WeaponTemplate.weapon_template_from_item(item)
		local template_name = weapon_template.name
		local decal_unit_ids = ImpactFxResourceDependencies.impact_decal_units(template_name, weapon_template)

		Managers.state.decal:unregister_decal_unit_ids(decal_unit_ids)

		local slot_config = self._slot_configuration[slot_name]

		if slot_config.slot_type == "weapon" or GameParameters.destroy_unmanaged_particles and slot_config.slot_type == "ability" then
			self._fx_extension:destroy_particle_group()
		end
	end

	self:_update_item_visibility(self._is_in_first_person_mode)

	self._profile_properties = equipment_component.resolve_profile_properties(equipment, self._wielded_slot, self._static_profile_properties)
end

PlayerHuskVisualLoadoutExtension.source_fx_for_slot = function (self, slot_name)
	return self._fx_sources[slot_name]
end

PlayerHuskVisualLoadoutExtension.resolve_gear_sound = function (self, sound_alias, optional_external_properties)
	local properties = self._profile_properties

	return PlayerCharacterSounds.resolve_sound(sound_alias, properties, optional_external_properties)
end

PlayerHuskVisualLoadoutExtension.resolve_looping_gear_sound = function (self, looping_sound_alias, use_husk_event, optional_external_properties)
	local LOOPING_SFX_CONFIG = PlayerCharacterLoopingSoundAliases[looping_sound_alias]
	local start_config = LOOPING_SFX_CONFIG.start
	local stop_config = LOOPING_SFX_CONFIG.stop
	local start_event_alias = start_config.event_alias
	local stop_event_alias = stop_config.event_alias
	local resolved, event_name, has_husk_events = self:resolve_gear_sound(start_event_alias, optional_external_properties)

	if resolved then
		event_name = use_husk_event and has_husk_events and event_name .. "_husk" or event_name

		local stop_resolved, stop_event_name, stop_has_husk_events = self:resolve_gear_sound(stop_event_alias, optional_external_properties)

		if stop_resolved then
			stop_event_name = use_husk_event and stop_has_husk_events and stop_event_name .. "_husk" or stop_event_name

			return true, event_name, true, stop_event_name
		else
			return true, event_name, false, nil
		end
	end

	return false, nil, false, nil
end

PlayerHuskVisualLoadoutExtension.resolve_gear_particle = function (self, particle_alias, optional_external_properties)
	local properties = self._profile_properties

	return PlayerCharacterParticles.resolve_particle(particle_alias, properties, optional_external_properties)
end

PlayerHuskVisualLoadoutExtension.resolve_gear_decal = function (self, decal_alias, optional_external_properties)
	local properties = self._profile_properties

	return PlayerCharacterDecals.resolve_decal(decal_alias, properties, optional_external_properties)
end

PlayerHuskVisualLoadoutExtension.profile_properties = function (self)
	return self._profile_properties
end

PlayerHuskVisualLoadoutExtension.current_wielded_slot_scripts = function (self)
	local current_wielded_slot = self._wielded_slot

	return self:wieldable_slot_scripts_from_slot(current_wielded_slot)
end

PlayerHuskVisualLoadoutExtension.wieldable_slot_scripts_from_slot = function (self, slot_name)
	local wieldable_slot_scripts = self._wieldable_slot_scripts

	return wieldable_slot_scripts[slot_name]
end

PlayerHuskVisualLoadoutExtension.unit_and_attachments_from_slot = function (self, slot_name)
	local slot = self._equipment[slot_name]

	return slot.unit_1p, slot.unit_3p, slot.attachments_by_unit_1p, slot.attachments_by_unit_3p
end

PlayerHuskVisualLoadoutExtension.telemetry_wielded_weapon = function (self)
	local equipment = self._equipment
	local item = equipment[self._wielded_slot]

	return item
end

PlayerHuskVisualLoadoutExtension.is_unit_part_of_attachment = function (self, unit, slot_name, attachment_id)
	local equipment = self._equipment
	local slot = equipment[slot_name]

	if slot then
		local root_unit_1p_or_nil = slot.attachment_id_lookup_1p[attachment_id]

		if unit == root_unit_1p_or_nil or root_unit_1p_or_nil and slot.attachment_map_by_unit_1p[root_unit_1p_or_nil][unit] then
			return true
		end

		local root_unit_3p_or_nil = slot.attachment_id_lookup_3p[attachment_id]

		if unit == root_unit_3p_or_nil or root_unit_3p_or_nil and slot.attachment_map_by_unit_3p[root_unit_3p_or_nil][unit] then
			return true
		end
	end

	return false
end

PlayerHuskVisualLoadoutExtension.set_force_hide_wieldable_slot = function (self, slot_name, first_person, third_person)
	local slot = self._equipment[slot_name]

	slot.wants_hidden_by_gameplay_1p = first_person
	slot.wants_hidden_by_gameplay_3p = third_person

	self:_update_item_visibility(self._is_in_first_person_mode)
end

PlayerHuskVisualLoadoutExtension.companion_slots = function (self)
	local gear_full = self._equipment.slot_companion_gear_full.item_name_by_unit_3p

	self._companion_slots = {}

	for unit, path in pairs(gear_full) do
		table.insert(self._companion_slots, {
			use_outline = true,
			unit = unit,
		})
	end

	return self._companion_slots
end

PlayerHuskVisualLoadoutExtension.is_slot_unit_spawned = function (self, slot_name)
	local gear_full = self._equipment[slot_name]

	return gear_full and gear_full.attachment_spawn_status == "fully_spawned"
end

PlayerHuskVisualLoadoutExtension.is_slot_unit_valid = function (self, slot_name)
	local gear_full = self._equipment[slot_name]

	return gear_full and ALIVE[gear_full.unit_3p]
end

return PlayerHuskVisualLoadoutExtension
