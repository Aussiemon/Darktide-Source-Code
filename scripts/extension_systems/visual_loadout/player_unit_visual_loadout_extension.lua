local EquipmentComponent = require("scripts/extension_systems/visual_loadout/equipment_component")
local ImpactFxResourceDependencies = require("scripts/settings/damage/impact_fx_resource_dependencies")
local Luggable = require("scripts/utilities/luggable")
local Pocketable = require("scripts/utilities/pocketable")
local MispredictPackageHandler = require("scripts/extension_systems/visual_loadout/mispredict_package_handler")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerCharacterParticles = require("scripts/settings/particles/player_character_particles")
local PlayerCharacterSounds = require("scripts/settings/sound/player_character_sounds")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WieldableSlotScripts = require("scripts/extension_systems/visual_loadout/utilities/wieldable_slot_scripts")
local MasterItems = require("scripts/backend/master_items")
local PlayerUnitVisualLoadoutExtension = class("PlayerUnitVisualLoadoutExtension")

PlayerUnitVisualLoadoutExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, unit_spawn_parameter_or_game_object_id)
	self.UNEQUIPPED_SLOT = "not_equipped"
	self.NO_WIELDED_SLOT = "none"
	self._unit = unit
	self._player = extension_init_data.player
	local is_local_unit = extension_init_data.is_local_unit
	self._is_local_unit = is_local_unit
	local is_server = extension_init_data.is_server

	if not is_server then
		self._game_session = game_object_data_or_game_session
		self._game_object_id = unit_spawn_parameter_or_game_object_id
	end

	self._is_server = is_server
	local slot_configuration = extension_init_data.slot_configuration
	self._slot_configuration = slot_configuration
	local slot_configuration_by_type = {}

	for slot_name, config in pairs(slot_configuration) do
		local slot_type = config.slot_type

		if not slot_configuration_by_type[slot_type] then
			slot_configuration_by_type[slot_type] = {}
		end

		slot_configuration_by_type[slot_type][slot_name] = config
	end

	self._slot_configuration_by_type = slot_configuration_by_type
	local optional_item_streaming_settings = nil
	local package_synchronizer_client = extension_init_data.package_synchronizer_client

	if package_synchronizer_client then
		optional_item_streaming_settings = {
			package_synchronizer_client = package_synchronizer_client,
			player = self._player
		}
	end

	local world = extension_init_context.world
	local physics_world = extension_init_context.physics_world
	local unit_spawner = Managers.state.unit_spawner
	local extension_manager = Managers.state.extension
	self._item_definitions = MasterItems.get_cached()
	local equipment_component = EquipmentComponent:new(world, self._item_definitions, unit_spawner, unit, extension_manager, optional_item_streaming_settings)
	self._equipment_component = equipment_component
	self._physics_world = physics_world
	local equipment = equipment_component.initialize_equipment(slot_configuration)
	self._equipment = equipment
	self._locally_wielded_slot = nil
	local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	local is_in_first_person_mode = first_person_extension:is_in_first_person_mode()
	self._is_in_first_person_mode = is_in_first_person_mode
	local first_person_unit = first_person_extension:first_person_unit()
	self._first_person_unit = first_person_unit
	self._first_person_extension = first_person_extension
	self._weapon_extension = ScriptUnit.extension(unit, "weapon_system")
	local fx_extension = ScriptUnit.extension(unit, "fx_system")
	self._fx_extension = fx_extension
	self._fx_sources = {}
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	self._unit_data_extension = unit_data_extension
	local inventory_component = unit_data_extension:write_component("inventory")
	self._inventory_component = inventory_component
	inventory_component.wielded_slot = self.NO_WIELDED_SLOT
	inventory_component.previously_wielded_slot = self.NO_WIELDED_SLOT
	inventory_component.previously_wielded_weapon_slot = self.NO_WIELDED_SLOT
	self._character_state_component = unit_data_extension:read_component("character_state")
	local wieldable_slot_components = {}
	self._wieldable_slot_components = wieldable_slot_components
	local wieldable_slot_scripts = {}
	self._wieldable_slot_scripts = wieldable_slot_scripts
	self._wieldable_slot_scripts_context = {
		is_husk = false,
		owner_unit = unit,
		is_local_unit = is_local_unit,
		equipment_component = equipment_component,
		is_server = is_server,
		game_session = game_object_data_or_game_session,
		first_person_unit = first_person_unit,
		world = world,
		physics_world = physics_world,
		wwise_world = extension_init_context.wwise_world,
		visual_loadout_extension = self,
		unit_data_extension = unit_data_extension,
		fx_extension = fx_extension,
		player_particle_group_id = Managers.state.extension:system("fx_system").unit_to_particle_group_lookup[unit]
	}
	local inventory_component_data = PlayerCharacterConstants.inventory_component_data

	for slot_name, config in pairs(slot_configuration) do
		if config.wieldable then
			wieldable_slot_components[slot_name] = unit_data_extension:write_component(slot_name)
			local wieldable_component = unit_data_extension:write_component(slot_name)
			local slot_type = config.slot_type
			local component_data = inventory_component_data[slot_type]

			for key, data in pairs(component_data) do
				wieldable_component[key] = data.default_value
			end

			wieldable_slot_scripts[slot_name] = {}
		end
	end

	local mission = extension_init_data.mission

	if not is_server then
		self._mispredict_package_handler = MispredictPackageHandler:new(unit_data_extension, self._item_definitions, mission)
	end

	self._mission = mission

	if is_server then
		self._game_object_created = false
	else
		self._game_object_created = true
	end

	self._dialogue_extension = ScriptUnit.extension(unit, "dialogue_system")
	local initial_items = extension_init_data.initial_items
	local optional_existing_unit_3p = nil
	local fixed_frame_t = extension_init_context.fixed_frame_t
	local slot_equip_order = PlayerCharacterConstants.slot_equip_order

	for i = 1, #slot_equip_order do
		local slot_name = slot_equip_order[i]
		local item = initial_items[slot_name]

		if item then
			self:equip_item_to_slot(item, slot_name, optional_existing_unit_3p, fixed_frame_t)
		else
			inventory_component[slot_name] = self.UNEQUIPPED_SLOT
		end
	end

	self._archetype_property = extension_init_data.archetype.name
	self._selected_voice_property = extension_init_data.selected_voice
	self._profile_properties = equipment_component.resolve_profile_properties(equipment, self._locally_wielded_slot, self._archetype_property, self._selected_voice_property)
	local default_wielded_slot_name = extension_init_data.default_wielded_slot_name
	self._default_wielded_slot_name = default_wielded_slot_name
	self._initialized_fixed_t = fixed_frame_t
	self._fixed_time_step = Managers.state.game_session.fixed_time_step
end

PlayerUnitVisualLoadoutExtension.extensions_ready = function (self, world, unit)
	WieldableSlotScripts.extensions_ready(self._wieldable_slot_scripts)

	if not self._is_server then
		PlayerUnitVisualLoadout.wield_slot(self._default_wielded_slot_name, unit, self._initialized_fixed_t)
	end
end

PlayerUnitVisualLoadoutExtension.game_object_initialized = function (self, session, object_id)
	self._game_session = session
	self._game_object_id = object_id
	self._game_object_created = true
	self._wieldable_slot_scripts_context.game_session = session
	local slot_equip_order = PlayerCharacterConstants.slot_equip_order

	for i = 1, #slot_equip_order do
		local slot_name = slot_equip_order[i]
		local slot = self._equipment[slot_name]
		local slot_config = self._slot_configuration[slot_name]

		if slot.equipped then
			local slot_id = NetworkLookup.player_inventory_slot_names[slot_name]

			if slot_config.profile_field then
				local item = slot.item
				local item_id = NetworkLookup.player_item_names[item.name]

				Managers.state.game_session:send_rpc_clients_except("rpc_player_equip_item_from_profile_to_slot", self._player:channel_id(), object_id, slot_id, item_id)
			else
				local item = slot.item
				local item_id = NetworkLookup.player_item_names[item.name]
				local optional_existing_unit_3p_id = slot.use_existing_unit_3p and Managers.state.unit_spawner:game_object_id(slot.unit_3p) or NetworkConstants.invalid_game_object_id

				Managers.state.game_session:send_rpc_clients_except("rpc_player_equip_item_to_slot", self._player:channel_id(), object_id, slot_id, item_id, optional_existing_unit_3p_id)
			end
		end
	end

	local inventory_component = self._unit_data_extension:read_component("inventory")

	if PlayerUnitVisualLoadout.slot_equipped(inventory_component, self, self._default_wielded_slot_name) then
		PlayerUnitVisualLoadout.wield_slot(self._default_wielded_slot_name, self._unit, self._initialized_fixed_t)
	else
		Log.error("PlayerUnitVisualLoadoutExtension", "[game_object_initialized] slot(%s) is unequipped.", tostring(self._default_wielded_slot_name))
	end
end

local function _register_fx_sources(fx_extension, unit_1p, unit_3p, attachments_1p, attachments_3p, source_config, slot_name, is_in_first_person_mode)
	local sources = {}

	for alias, node_name in pairs(source_config) do
		local source_name = slot_name .. alias

		fx_extension:register_sound_source(source_name, unit_1p, attachments_1p, node_name)

		local parent_unit, vfx_attachments = nil

		if is_in_first_person_mode then
			parent_unit = unit_1p
			vfx_attachments = attachments_1p
		else
			parent_unit = unit_3p
			vfx_attachments = attachments_3p
		end

		fx_extension:register_vfx_spawner(source_name, parent_unit, vfx_attachments, node_name)

		sources[alias] = source_name
	end

	return sources
end

local function _move_fx_sources(fx_extension, source_config, sources, slot, is_in_first_person_mode)
	local unit_1p = slot.unit_1p
	local unit_3p = slot.unit_3p
	local attachments_1p = slot.attachments_1p
	local attachments_3p = slot.attachments_3p
	local parent_unit, attachments = nil

	if is_in_first_person_mode then
		parent_unit = unit_1p
		attachments = attachments_1p
	else
		parent_unit = unit_3p
		attachments = attachments_3p
	end

	for alias, source_name in pairs(sources) do
		local node_name = source_config[alias]

		fx_extension:move_sound_source(source_name, parent_unit, attachments, node_name)
		fx_extension:move_vfx_spawner(source_name, parent_unit, attachments, node_name)
	end
end

local function _unregister_fx_sources(fx_extension, sources)
	for alias, source_name in pairs(sources) do
		fx_extension:unregister_vfx_spawner(source_name)
		fx_extension:unregister_sound_source(source_name)
	end
end

PlayerUnitVisualLoadoutExtension.update = function (self, unit, dt, t)
	local mission = self._mission
	local slot_equip_order = PlayerCharacterConstants.slot_equip_order
	local spawned_attachments, spawned_slots = self._equipment_component:try_spawn_attachments(self._equipment, slot_equip_order, mission)
	local inventory_component = self._inventory_component
	local wielded_slot_name = inventory_component.wielded_slot
	local first_person_extension = self._first_person_extension
	local is_in_first_person_mode = first_person_extension:is_in_first_person_mode()
	local wieldable_slot_scripts = self._wieldable_slot_scripts

	if spawned_attachments then
		local fx_sources = self._fx_sources

		for slot_name, slot in pairs(spawned_slots) do
			if slot.wieldable then
				local item = slot.item
				local slot_fx_sources = fx_sources[slot_name]

				WieldableSlotScripts.create(self._wieldable_slot_scripts_context, wieldable_slot_scripts, slot_fx_sources, slot, item)

				local slot_scripts = wieldable_slot_scripts[slot_name]

				if self._is_local_unit and wielded_slot_name == slot_name and slot_scripts then
					WieldableSlotScripts.wield(slot_scripts)
				end
			end
		end
	end

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

PlayerUnitVisualLoadoutExtension.post_update = function (self, unit, dt, t, context, ...)
	if self._mispredict_package_handler then
		self._mispredict_package_handler:post_update()
	end

	local inventory_component = self._inventory_component
	local wielded_slot_name = inventory_component.wielded_slot
	local wieldable_slot_scripts = self._wieldable_slot_scripts
	local slot_scripts = wieldable_slot_scripts[wielded_slot_name]

	if slot_scripts then
		WieldableSlotScripts.post_update(slot_scripts, unit, dt, t)
	end
end

PlayerUnitVisualLoadoutExtension.fixed_update = function (self, unit, dt, t, frame)
	local inventory_component = self._inventory_component
	local wielded_slot_name = inventory_component.wielded_slot
	local wielded_slot_scripts = self._wieldable_slot_scripts[wielded_slot_name]

	if wielded_slot_scripts then
		WieldableSlotScripts.fixed_update(wielded_slot_scripts, unit, dt, t)
	end

	local equipment = self._equipment
	local luggable_slots = self._slot_configuration_by_type.luggable

	for slot_name, slot_config in pairs(luggable_slots) do
		local slot = equipment[slot_name]

		if slot.equipped and slot_name ~= wielded_slot_name then
			local character_state_component = self._character_state_component
			local current_state = character_state_component.state_name
			local previous_state = character_state_component.previous_state_name

			Crashify.print_exception("PlayerUnitVisualLoadoutExtension", "Luggable dropped through fail-safe means.")
			Luggable.drop_luggable(t, unit, inventory_component, self, true)
		end
	end
end

PlayerUnitVisualLoadoutExtension.update_delayed_unequipped_slots = function (self, unit, dt, t, frame)
	local inventory = self._inventory_component
	local wieldable_slot_components = self._wieldable_slot_components
	local equipment = self._equipment
	local pocketable_slots = self._slot_configuration_by_type.pocketable

	for slot_name, slot_config in pairs(pocketable_slots) do
		local slot_component = wieldable_slot_components[slot_name]
		local slot = equipment[slot_name]
		local item = slot.item

		if slot_component.unequip_slot and item ~= nil then
			if inventory.wielded_slot == slot_name then
				PlayerUnitVisualLoadout.wield_previous_weapon_slot(inventory, unit, t)
			end

			PlayerUnitVisualLoadout.unequip_item_from_slot(unit, slot_name, t)

			slot_component.unequip_slot = false
		end
	end
end

PlayerUnitVisualLoadoutExtension.update_unit_position = function (self, unit, dt, t)
	local inventory_component = self._inventory_component
	local wielded_slot_name = inventory_component.wielded_slot
	local wielded_slot_scripts = self._wieldable_slot_scripts[wielded_slot_name]

	if wielded_slot_scripts then
		WieldableSlotScripts.update_unit_position(wielded_slot_scripts, unit, dt, t)
	end
end

PlayerUnitVisualLoadoutExtension.server_correction_occurred = function (self, unit, from_frame)
	local UNEQUIPPED_SLOT = self.UNEQUIPPED_SLOT
	local rewield = false
	local wieldable_slot_components = self._wieldable_slot_components
	local inventory_component = self._inventory_component
	local equipment = self._equipment
	local self_fx_sources = self._fx_sources
	local fx_extension = self._fx_extension
	local mispredicted_frame = from_frame - 1
	local mispredicted_frame_t = mispredicted_frame * self._fixed_time_step
	local from_server_correction_occurred = true
	local slot_configuration = self._slot_configuration

	for slot_name, config in pairs(slot_configuration) do
		local slot = equipment[slot_name]
		local equipped = slot.equipped
		local item_name = equipped and slot.item.name
		local local_item = item_name or UNEQUIPPED_SLOT
		local wieldable_slot_component = wieldable_slot_components[slot_name]
		local server_auth_item = inventory_component[slot_name]

		if server_auth_item ~= local_item then
			local is_locally_wielded_slot = slot_name == self._locally_wielded_slot

			if local_item ~= UNEQUIPPED_SLOT then
				if is_locally_wielded_slot then
					self:_unwield_slot(self._locally_wielded_slot)
				end

				local fx_sources = self_fx_sources[slot_name]

				if fx_sources then
					for _, source_name in pairs(fx_sources) do
						fx_extension:stop_looping_wwise_events_for_source_on_mispredict(source_name)
					end
				end

				self:_unequip_item_from_slot(slot_name, from_server_correction_occurred, from_frame, false)
			elseif is_locally_wielded_slot then
				rewield = true
			end

			if server_auth_item ~= UNEQUIPPED_SLOT then
				local profile_item = config.profile_field
				local item = nil

				if profile_item then
					local player = self._player
					local profile = player:profile()
					local visual_loadout = profile.visual_loadout
					item = visual_loadout[slot_name]
				else
					item = self._item_definitions[server_auth_item]
				end

				local optional_existing_unit_3p = config.use_existing_unit_3p and wieldable_slot_component.existing_unit_3p

				self:_equip_item_to_slot(item, slot_name, mispredicted_frame_t, optional_existing_unit_3p, from_server_correction_occurred)
			end
		end
	end

	local wielded_slot = inventory_component.wielded_slot
	local locally_wielded_slot = self._locally_wielded_slot

	if wielded_slot ~= "none" and (locally_wielded_slot ~= wielded_slot or rewield) then
		if self._locally_wielded_slot then
			self:_unwield_slot(locally_wielded_slot)
		end

		self:_wield_slot(wielded_slot)
	end

	WieldableSlotScripts.server_correction_occurred(self._wieldable_slot_scripts, unit, from_frame)
end

PlayerUnitVisualLoadoutExtension.destroy = function (self)
	local fixed_time_step = self._fixed_time_step
	local gameplay_time = Managers.time:time("gameplay")
	local latest_frame = math.floor(gameplay_time / fixed_time_step)
	local mispredict_package_handler = self._mispredict_package_handler
	local slot_equip_order = PlayerCharacterConstants.slot_equip_order
	local slot_configuration = self._slot_configuration
	local unit_data_extension = self._unit_data_extension
	local is_server = self._is_server

	for i = #slot_equip_order, 1, -1 do
		local slot_name = slot_equip_order[i]
		local slot = self._equipment[slot_name]

		if slot.equipped then
			local slot_config = slot_configuration[slot_name]

			if is_server and slot_config.slot_type == "luggable" then
				local first_person_component = unit_data_extension:read_component("first_person")
				local locomotion_component = unit_data_extension:read_component("locomotion")

				Luggable.enable_physics(first_person_component, locomotion_component, slot.unit_3p)
			end

			if slot_name == "slot_pocketable" or slot_name == "slot_pocketable_small" then
				local is_grimoire = PlayerUnitVisualLoadout.has_weapon_keyword_from_slot(self, "slot_pocketable", "grimoire")

				if is_grimoire then
					self:unequip_item_from_slot(slot_name, latest_frame)

					if is_server then
						local mission_objective_system = Managers.state.extension:system("mission_objective_system")

						mission_objective_system:store_grimoire()
					end
				else
					local unit = self._unit
					local inventory_component = self._inventory_component

					Pocketable.drop_pocketable(latest_frame, self._physics_world, is_server, unit, inventory_component, self, slot_name)
				end
			else
				self:_unequip_item_from_slot(slot_name, false, latest_frame, true)
			end
		end
	end

	if mispredict_package_handler then
		mispredict_package_handler:delete()
	end
end

PlayerUnitVisualLoadoutExtension.hot_join_sync = function (self, unit, sender)
	local channel = Managers.state.game_session:peer_to_channel(sender)
	local game_object_id = self._game_object_id
	local slot_equip_order = PlayerCharacterConstants.slot_equip_order

	for i = 1, #slot_equip_order do
		local slot_name = slot_equip_order[i]
		local slot = self._equipment[slot_name]
		local slot_config = self._slot_configuration[slot_name]

		if slot.equipped then
			local slot_id = NetworkLookup.player_inventory_slot_names[slot_name]

			if slot_config.profile_field then
				local item_id = NetworkLookup.player_item_names[slot.item.name]

				RPC.rpc_player_equip_item_from_profile_to_slot(channel, game_object_id, slot_id, item_id)
			else
				local item_id = NetworkLookup.player_item_names[slot.item.name]
				local optional_existing_unit_3p_id = slot.use_existing_unit_3p and Managers.state.unit_spawner:game_object_id(slot.unit_3p) or NetworkConstants.invalid_game_object_id

				RPC.rpc_player_equip_item_to_slot(channel, game_object_id, slot_id, item_id, optional_existing_unit_3p_id)
			end

			if slot_name == self._inventory_component.wielded_slot then
				RPC.rpc_player_wield_slot(channel, game_object_id, slot_id)
			end
		end
	end
end

PlayerUnitVisualLoadoutExtension.equip_item_to_slot = function (self, item, slot_name, optional_existing_unit_3p, t)
	local from_server_correction_occurred = false

	self:_equip_item_to_slot(item, slot_name, t, optional_existing_unit_3p, from_server_correction_occurred)

	self._inventory_component[slot_name] = item.name

	if self._is_server and self._game_object_created then
		local slot_config = self._slot_configuration[slot_name]
		local slot_id = NetworkLookup.player_inventory_slot_names[slot_name]

		if slot_config.profile_field then
			local item_id = NetworkLookup.player_item_names[item.name]

			Managers.state.game_session:send_rpc_clients_except("rpc_player_equip_item_from_profile_to_slot", self._player:channel_id(), self._game_object_id, slot_id, item_id)
		else
			local item_id = NetworkLookup.player_item_names[item.name]
			local optional_existing_unit_3p_id = optional_existing_unit_3p and Managers.state.unit_spawner:game_object_id(optional_existing_unit_3p) or NetworkConstants.invalid_game_object_id

			Managers.state.game_session:send_rpc_clients_except("rpc_player_equip_item_to_slot", self._player:channel_id(), self._game_object_id, slot_id, item_id, optional_existing_unit_3p_id)
		end
	end
end

PlayerUnitVisualLoadoutExtension._equip_item_to_slot = function (self, item, slot_name, t, optional_existing_unit_3p, from_server_correction_occurred)
	local equipment = self._equipment
	local slot_config = self._slot_configuration[slot_name]
	local slot = equipment[slot_name]
	local parent_unit_3p = self._unit
	local parent_unit_1p = self._first_person_unit
	local deform_overrides = item.deform_overrides and table.clone(item.deform_overrides) or {}
	local profile = self._player:profile()

	if profile.gender == "female" then
		deform_overrides[#deform_overrides + 1] = "wrap_deform_human_body_female"
	end

	local breed = self._unit_data_extension:breed()
	local breed_name = breed.name
	local mission = self._mission
	local equipment_component = self._equipment_component

	equipment_component:equip_item(parent_unit_3p, parent_unit_1p, slot, item, optional_existing_unit_3p, deform_overrides, breed_name, mission)

	if slot_config.slot_type == "luggable" then
		local luggable_extension = ScriptUnit.extension(optional_existing_unit_3p, "luggable_system")

		luggable_extension:set_carried_by(self._unit)
	end

	slot.equipped_t = t
	local is_in_first_person_mode = self._is_in_first_person_mode

	if slot.wieldable then
		local weapon_template = WeaponTemplate.weapon_template_from_item(item)
		local weapon_template_name = weapon_template.name
		local fx_source_config = weapon_template.fx_sources
		local fx_sources = _register_fx_sources(self._fx_extension, slot.unit_1p, slot.unit_3p, slot.attachments_1p, slot.attachments_3p, fx_source_config, slot_name, is_in_first_person_mode)

		self._weapon_extension:on_wieldable_slot_equipped(item, slot_name, slot.unit_1p, fx_sources, t, optional_existing_unit_3p, from_server_correction_occurred)

		self._fx_sources[slot_name] = fx_sources

		if slot.attachment_spawn_status == "fully_spawned" then
			WieldableSlotScripts.create(self._wieldable_slot_scripts_context, self._wieldable_slot_scripts, fx_sources, slot, item)
		end

		local template_name = weapon_template.name
		local decal_unit_ids = ImpactFxResourceDependencies.impact_decal_units(template_name, weapon_template)

		Managers.state.decal:register_decal_unit_ids(decal_unit_ids)
		self:_cache_node_names(weapon_template, slot_name)
	end

	self:_update_item_visibility(is_in_first_person_mode)

	local voice_fx_preset = item.voice_fx_preset

	if voice_fx_preset then
		self._dialogue_extension:set_voice_fx_preset(voice_fx_preset)
	end

	local mispredict_packages = slot_config.mispredict_packages

	if self._mispredict_package_handler and mispredict_packages then
		self._mispredict_package_handler:item_equipped(item)
	end

	self._profile_properties = equipment_component.resolve_profile_properties(equipment, self._locally_wielded_slot, self._archetype_property, self._selected_voice_property)
end

PlayerUnitVisualLoadoutExtension.unequip_item_from_slot = function (self, slot_name, fixed_frame)
	local from_server_correction_occurred = false

	self:_unequip_item_from_slot(slot_name, from_server_correction_occurred, fixed_frame, false)

	self._inventory_component[slot_name] = self.UNEQUIPPED_SLOT
	local inventory_component = self._inventory_component

	if inventory_component.previously_wielded_slot == slot_name then
		local previously_wielded_weapon_slot = inventory_component.previously_wielded_weapon_slot

		if previously_wielded_weapon_slot ~= slot_name and previously_wielded_weapon_slot ~= "none" then
			inventory_component.previously_wielded_slot = previously_wielded_weapon_slot
		else
			local default_wielded_slot_name = Managers.state.game_mode:default_wielded_slot_name()
			inventory_component.previously_wielded_slot = default_wielded_slot_name
		end
	end

	if self._is_server then
		local slot_id = NetworkLookup.player_inventory_slot_names[slot_name]

		Managers.state.game_session:send_rpc_clients_except("rpc_player_unequip_item_from_slot", self._player:channel_id(), self._game_object_id, slot_id)
	end
end

PlayerUnitVisualLoadoutExtension._unequip_item_from_slot = function (self, slot_name, from_server_correction_occurred, fixed_frame, from_destroy)
	local equipment = self._equipment
	local slot = equipment[slot_name]
	local item = slot.item
	local voice_fx_preset = item.voice_fx_preset

	if voice_fx_preset then
		self._dialogue_extension:set_voice_fx_preset(nil)
	end

	local slot_config = self._slot_configuration[slot_name]

	if slot_config.slot_type == "luggable" then
		local luggable_unit = slot.unit_3p
		local luggable_extension = ScriptUnit.extension(luggable_unit, "luggable_system")

		luggable_extension:set_carried_by(nil)
	end

	if slot_config.slot_type == "pocketable" then
		local slot_component = self._wieldable_slot_components[slot_name]
		slot_component.unequip_slot = false
	end

	local equipment_component = self._equipment_component

	equipment_component:unequip_item(slot)

	if slot.wieldable then
		self._weapon_extension:on_wieldable_slot_unequipped(slot_name, from_server_correction_occurred)

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

		if slot_config.slot_type == "weapon" then
			self._fx_extension:destroy_particle_group()
		end
	end

	if not from_destroy then
		local is_in_first_person_mode = self._is_in_first_person_mode

		self:_update_item_visibility(is_in_first_person_mode)
	end

	local slot_configuration = self._slot_configuration[slot_name]
	local mispredict_packages = slot_configuration.mispredict_packages

	if self._mispredict_package_handler and mispredict_packages then
		self._mispredict_package_handler:item_unequipped(item, fixed_frame)
	end

	self._profile_properties = equipment_component.resolve_profile_properties(equipment, self._locally_wielded_slot, self._archetype_property, self._selected_voice_property)
end

PlayerUnitVisualLoadoutExtension.wield_slot = function (self, slot_name)
	local inventory = self._inventory_component
	local currently_wielded_slot = inventory.wielded_slot
	inventory.wielded_slot = slot_name

	if self._is_server then
		local slot_id = NetworkLookup.player_inventory_slot_names[slot_name]

		Managers.state.game_session:send_rpc_clients_except("rpc_player_wield_slot", self._player:channel_id(), self._game_object_id, slot_id)
	end

	self:_wield_slot(slot_name)
end

PlayerUnitVisualLoadoutExtension._wield_slot = function (self, slot_name)
	local equipment = self._equipment
	local slot = equipment[slot_name]
	local is_in_first_person_mode = self._is_in_first_person_mode
	local equipment_component = self._equipment_component

	equipment_component.wield_slot(slot, is_in_first_person_mode)
	self:_update_item_visibility(is_in_first_person_mode)

	self._locally_wielded_slot = slot_name
	self._profile_properties = equipment_component.resolve_profile_properties(equipment, slot_name, self._archetype_property, self._selected_voice_property)
	local slot_scripts = self._wieldable_slot_scripts[slot_name]

	if slot_scripts then
		WieldableSlotScripts.wield(slot_scripts)
	end
end

PlayerUnitVisualLoadoutExtension.rewield_current_slot = function (self)
	local inventory = self._inventory_component
	local wielded_slot_name = inventory.wielded_slot

	self:wield_slot(wielded_slot_name)
end

PlayerUnitVisualLoadoutExtension.weapon_template_from_slot = function (self, slot_name)
	local slot = self._equipment[slot_name]
	local weapon_template = WeaponTemplate.weapon_template_from_item(slot and slot.item)

	return weapon_template, slot
end

PlayerUnitVisualLoadoutExtension.item_from_slot = function (self, slot_name)
	local slot = self._equipment[slot_name]
	local item = slot and slot.item

	return item
end

PlayerUnitVisualLoadoutExtension.equipped_t_from_slot = function (self, slot_name)
	local slot = self._equipment[slot_name]
	local equipped_t = slot and slot.equipped_t

	return equipped_t
end

PlayerUnitVisualLoadoutExtension.unit_3p_from_slot = function (self, slot_name)
	local slot = self._equipment[slot_name]
	local unit_3p = slot and slot.unit_3p

	return unit_3p
end

PlayerUnitVisualLoadoutExtension.unwield_slot = function (self, slot_name)
	local inventory_component = self._inventory_component
	local current_wielded_slot = inventory_component.wielded_slot
	inventory_component.wielded_slot = self.NO_WIELDED_SLOT
	local slot_type = self._slot_configuration[slot_name].slot_type
	local can_be_assigned_to_previously_wielded_slot = PlayerCharacterConstants.previously_wielded_slot_types[slot_type]

	if can_be_assigned_to_previously_wielded_slot then
		inventory_component.previously_wielded_slot = slot_name
	end

	if slot_type == "weapon" then
		inventory_component.previously_wielded_weapon_slot = slot_name
	end

	self:_unwield_slot(slot_name)

	if self._is_server then
		local slot_id = NetworkLookup.player_inventory_slot_names[slot_name]

		Managers.state.game_session:send_rpc_clients_except("rpc_player_unwield_slot", self._player:channel_id(), self._game_object_id, slot_id)
	end
end

PlayerUnitVisualLoadoutExtension._unwield_slot = function (self, slot_name)
	local equipment_component = self._equipment_component
	local equipment = self._equipment
	local slot_scripts = self._wieldable_slot_scripts[slot_name]

	if slot_scripts then
		WieldableSlotScripts.unwield(slot_scripts)
	end

	local slot = equipment[slot_name]
	local is_in_first_person_mode = self._is_in_first_person_mode

	equipment_component.unwield_slot(slot, is_in_first_person_mode)

	self._locally_wielded_slot = nil
	self._profile_properties = equipment_component.resolve_profile_properties(equipment, nil, self._archetype_property, self._selected_voice_property)
end

PlayerUnitVisualLoadoutExtension.can_wield = function (self, slot_name)
	local slot_config = self._slot_configuration[slot_name]

	if not slot_config.wieldable then
		return false
	end

	local inventory_comp = self._inventory_component

	if slot_name == inventory_comp.wielded_slot then
		return false
	end

	if inventory_comp[slot_name] == self.UNEQUIPPED_SLOT then
		return false
	end

	return true
end

PlayerUnitVisualLoadoutExtension.slot_configuration = function (self)
	return self._slot_configuration
end

PlayerUnitVisualLoadoutExtension.slot_configuration_by_type = function (self, slot_type)
	return self._slot_configuration_by_type[slot_type]
end

PlayerUnitVisualLoadoutExtension.wielded_slot_configuration = function (self)
	local wielded_slot = self._inventory_component.wielded_slot

	return self._slot_configuration[wielded_slot]
end

PlayerUnitVisualLoadoutExtension.is_wielding = function (self)
	return self._inventory_component.wielded_slot ~= self.NO_WIELDED_SLOT
end

PlayerUnitVisualLoadoutExtension.source_fx_for_slot = function (self, slot_name)
	return self._fx_sources[slot_name]
end

PlayerUnitVisualLoadoutExtension.force_update_item_visibility = function (self)
	self:_update_item_visibility(self._is_in_first_person_mode)
end

PlayerUnitVisualLoadoutExtension._update_item_visibility = function (self, first_person_mode)
	self._equipment_component.update_item_visibility(self._equipment, self._inventory_component.wielded_slot, self._unit, self._first_person_unit, first_person_mode)

	local inventory_component = self._inventory_component
	local slot_name = inventory_component.wielded_slot
	local slot_scripts = self._wieldable_slot_scripts[slot_name]

	if slot_scripts then
		local num_scripts = #slot_scripts

		for i = 1, num_scripts do
			local wieldable_slot_script = slot_scripts[i]

			wieldable_slot_script:update_first_person_mode(first_person_mode)
		end
	end
end

PlayerUnitVisualLoadoutExtension.resolve_gear_sound = function (self, sound_alias, optional_external_properties)
	local properties = self._profile_properties

	return PlayerCharacterSounds.resolve_sound(sound_alias, properties, optional_external_properties)
end

PlayerUnitVisualLoadoutExtension.resolve_gear_particle = function (self, particle_alias, optional_external_properties)
	local properties = self._profile_properties

	return PlayerCharacterParticles.resolve_particle(particle_alias, properties, optional_external_properties)
end

PlayerUnitVisualLoadoutExtension.current_wielded_slot_scripts = function (self)
	local inventory_component = self._inventory_component
	local current_wielded_slot = inventory_component.wielded_slot

	return self:wieldable_slot_scripts_from_slot(current_wielded_slot)
end

PlayerUnitVisualLoadoutExtension.wieldable_slot_scripts_from_slot = function (self, slot_name)
	local wieldable_slot_scripts = self._wieldable_slot_scripts

	return wieldable_slot_scripts[slot_name]
end

PlayerUnitVisualLoadoutExtension.unit_and_attachments_from_slot = function (self, slot_name)
	local slot = self._equipment[slot_name]

	return slot.unit_1p, slot.unit_3p, slot.attachments_1p, slot.attachments_3p
end

PlayerUnitVisualLoadoutExtension._cache_node_names = function (self, weapon_template, slot_name)
	local fx_sources = weapon_template.fx_sources
	local slot = self._equipment[slot_name]
	local cached_nodes = slot.cached_nodes

	table.clear(cached_nodes)

	for _, node_name in pairs(fx_sources) do
		local node_unit_1p, node_index_1p, node_unit_3p, node_index_3p = self:_unit_and_node_from_node_name(slot_name, node_name)
		cached_nodes[node_name] = {
			node_unit_1p = node_unit_1p,
			node_index_1p = node_index_1p,
			node_unit_3p = node_unit_3p,
			node_index_3p = node_index_3p
		}
	end
end

PlayerUnitVisualLoadoutExtension._unit_and_node_from_node_name = function (self, slot_name, node_name)
	local node_unit_1p, node_index_1p, node_unit_3p, node_index_3p = nil
	local slot = self._equipment[slot_name]
	local unit_1p = slot.unit_1p
	local unit_3p = slot.unit_3p
	local attachments_1p = slot.attachments_1p
	local attachments_3p = slot.attachments_3p

	if unit_1p and Unit.has_node(unit_1p, node_name) then
		node_unit_1p = unit_1p
		node_index_1p = Unit.node(unit_1p, node_name)
	elseif attachments_1p then
		local num_attachments = #attachments_1p

		for i = 1, num_attachments do
			local unit = attachments_1p[i]

			if Unit.has_node(unit, node_name) then
				node_unit_1p = unit
				node_index_1p = Unit.node(unit, node_name)
			end
		end
	end

	if unit_3p and Unit.has_node(unit_3p, node_name) then
		node_unit_3p = unit_3p
		node_index_3p = Unit.node(unit_3p, node_name)
	elseif attachments_3p then
		local num_attachments = #attachments_3p

		for i = 1, num_attachments do
			local unit = attachments_3p[i]

			if Unit.has_node(unit, node_name) then
				node_unit_3p = unit
				node_index_3p = Unit.node(unit, node_name)
			end
		end
	end

	return node_unit_1p, node_index_1p, node_unit_3p, node_index_3p
end

PlayerUnitVisualLoadoutExtension.unit_and_node_from_node_name = function (self, slot_name, node_name)
	local slot = self._equipment[slot_name]
	local cached_nodes = slot.cached_nodes
	local chaced_node = cached_nodes[node_name]

	if chaced_node then
		return chaced_node.node_unit_1p, chaced_node.node_index_1p, chaced_node.node_unit_3p, chaced_node.node_index_3p
	end

	return nil, nil, nil, nil
end

PlayerUnitVisualLoadoutExtension.item_in_slot = function (self, slot_name)
	local slot = self._equipment[slot_name]
	local item = slot.item

	if not item then
		return nil
	end

	return item.item or item
end

PlayerUnitVisualLoadoutExtension.slot_to_item = function (self, item)
	local equipment = self._equipment

	for slot_name, slot_item in pairs(equipment) do
		if slot_item == item then
			return slot_name
		end
	end

	return nil
end

PlayerUnitVisualLoadoutExtension.telemetry_wielded_weapon = function (self)
	local inventory = self._inventory_component
	local equipment = self._equipment
	local wielded_slot = inventory.wielded_slot
	local item = equipment[wielded_slot]

	if not item then
		Crashify.print_exception("PlayerUnitVisualLoadoutExtension", "Wielded item is nil when fetching for telemetry")
	end

	return item and (item.item or item)
end

PlayerUnitVisualLoadoutExtension.set_force_hide_wieldable_slot = function (self, slot_name, first_person, third_person)
	local slot = self._equipment[slot_name]
	slot.wants_hidden_by_gameplay_1p = first_person
	slot.wants_hidden_by_gameplay_3p = third_person

	self:_update_item_visibility(self._is_in_first_person_mode)
end

return PlayerUnitVisualLoadoutExtension
