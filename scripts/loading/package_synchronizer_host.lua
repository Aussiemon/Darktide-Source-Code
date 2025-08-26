-- chunkname: @scripts/loading/package_synchronizer_host.lua

local FixedFrame = require("scripts/utilities/fixed_frame")
local Interrupt = require("scripts/utilities/attack/interrupt")
local ItemPackage = require("scripts/foundation/managers/package/utilities/item_package")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local PackagePrioritizationTemplates = require("scripts/loading/package_prioritization_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerPackageAliases = require("scripts/settings/player/player_package_aliases")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local ability_configuration = PlayerCharacterConstants.ability_configuration
local unit_alive = Unit.alive
local PackageSynchronizerHost = class("PackageSynchronizerHost")
local RPCS = {
	"rpc_package_synchronizer_ready_peer",
	"rpc_alias_loading_complete",
}

PackageSynchronizerHost.DEBUG_TAG = "PackageSynchronizerHost"

local function _debug_print(str, ...)
	Log.info(PackageSynchronizerHost.DEBUG_TAG, str, ...)
end

local function _debug_warning(str, ...)
	Log.warning(PackageSynchronizerHost.DEBUG_TAG, str, ...)
end

local SYNC_STATES = table.enum("not_synced", "synced")

PackageSynchronizerHost.init = function (self, network_delegate, hosted_synchronizer_client)
	self.NO_LOOKUP = 0
	self._peer_id = Network.peer_id()
	self._sync_states = {}
	self._syncs = {}
	self._next_sync_change_id = 1
	self._network_delegate = network_delegate
	self._hosted_synchronizer_client = hosted_synchronizer_client
	self._mission_name = nil

	local mechanism_manager = Managers.mechanism
	local settings = mechanism_manager:player_package_synchronization_settings()

	if settings then
		local prioritization_template_name = settings.prioritization_template

		self:_set_prioritization_template(prioritization_template_name)
	end

	Managers.event:register(self, "updated_player_profile_synced", "event_updated_player_profile_synced")
	Managers.event:register(self, "mechanism_changed", "event_mechanism_changed")
end

PackageSynchronizerHost.event_mechanism_changed = function (self)
	local mechanism_manager = Managers.mechanism
	local settings = mechanism_manager:player_package_synchronization_settings()
	local prioritization_template_name = settings.prioritization_template

	self:_set_prioritization_template(prioritization_template_name)
end

PackageSynchronizerHost.set_mission_name = function (self, mission_name)
	self._mission_name = mission_name

	local hosted_synchronizer_client = self._hosted_synchronizer_client

	if hosted_synchronizer_client then
		hosted_synchronizer_client:set_mission_name(mission_name)
	end

	local my_peer_id = self._peer_id

	for peer_id, data in pairs(self._sync_states) do
		if data.ready and peer_id ~= my_peer_id then
			RPC.rpc_package_synchronizer_set_mission_name(data.channel_id, NetworkLookup.missions[mission_name])
		end
	end

	self:_reevaluate_all_profile_packages()
end

PackageSynchronizerHost._reevaluate_all_profile_packages = function (self)
	local hosted_synchronizer_client = self._hosted_synchronizer_client

	if hosted_synchronizer_client then
		hosted_synchronizer_client:reevaluate_all_profiles_packages()
	end

	local my_peer_id = self._peer_id
	local player_package_aliases = PlayerPackageAliases
	local num_player_package_aliases = #player_package_aliases
	local sync_states = self._sync_states

	for peer_id, data in pairs(sync_states) do
		if data.ready and peer_id ~= my_peer_id then
			local channel_id = data.channel_id

			RPC.rpc_reevaluate_all_profile_packages(channel_id)

			local peer_states = data.peer_states

			for sync_peer_id, peer_data in pairs(peer_states) do
				local player_states = peer_data.player_states

				for sync_local_player_id, player_data in pairs(player_states) do
					local alias_states = player_data.alias_states

					for i = 1, num_player_package_aliases do
						local alias = player_package_aliases[i]

						alias_states[alias] = SYNC_STATES.not_synced
					end

					local alias_version = self:_increment_alias_version(peer_id, sync_peer_id, sync_local_player_id)

					RPC.rpc_set_alias_version(channel_id, sync_peer_id, sync_local_player_id, alias_version)
				end
			end
		end
	end
end

PackageSynchronizerHost._set_prioritization_template = function (self, template_name)
	local sync_states = self._sync_states
	local template = PackagePrioritizationTemplates[template_name]
	local template_id = NetworkLookup.package_synchronization_template_names[template_name]
	local alias_states = {}

	for i = 1, #PlayerPackageAliases do
		local alias = PlayerPackageAliases[i]

		alias_states[alias] = SYNC_STATES.not_synced
	end

	for peer_id, data in pairs(sync_states) do
		local peer_states = data.peer_states

		if data.ready and peer_id ~= self._peer_id then
			local channel_id = data.channel_id

			RPC.rpc_set_package_prioritization(channel_id, template_id)

			for sync_peer_id, peer_data in pairs(peer_states) do
				local player_sync_states = peer_data.player_states

				for sync_local_player_id, _ in pairs(player_sync_states) do
					local alias_version = self:_increment_alias_version(peer_id, sync_peer_id, sync_local_player_id)

					RPC.rpc_set_alias_version(channel_id, sync_peer_id, sync_local_player_id, alias_version)
				end
			end
		end

		for sync_peer_id, peer_data in pairs(peer_states) do
			local player_sync_states = peer_data.player_states

			for sync_local_player_id, player_data in pairs(player_sync_states) do
				player_data.alias_states = table.clone(alias_states)
			end
		end
	end

	local hosted_synchronizer_client = self._hosted_synchronizer_client

	if hosted_synchronizer_client then
		hosted_synchronizer_client:set_package_prioritization_template(template_name)
	end

	self._prioritization_template = template
end

PackageSynchronizerHost.init_item_definitions = function (self, item_definitions)
	self._item_definitions = item_definitions
end

PackageSynchronizerHost.item_definitions_initialized = function (self)
	return self._item_definitions and true
end

PackageSynchronizerHost.event_updated_player_profile_synced = function (self, peer_id, local_player_id, old_profile)
	local syncs = self._syncs

	_debug_print("LoadingTimes: Player Profile Synced (peer: %s, player_id: %s)", peer_id, local_player_id)

	local old_sync_data

	if syncs[peer_id] and syncs[peer_id][local_player_id] then
		old_sync_data = syncs[peer_id][local_player_id]

		_debug_print("LoadingTimes: Player Profile Interrupt Sync-Change: %i (peer: %s, player_id: %s)", old_sync_data.sync_change_id, peer_id, local_player_id)
	end

	self:_player_profile_changed(peer_id, local_player_id, old_profile, old_sync_data)
end

PackageSynchronizerHost._player_profile_changed = function (self, sync_peer_id, sync_local_player_id, old_profile, old_sync_data)
	local syncs = self._syncs
	local player = Managers.player:player(sync_peer_id, sync_local_player_id)
	local new_profile = player:profile()
	local changed_profile_fields = {}

	changed_profile_fields.player_unit_respawn = self:_calculate_player_unit_respawn(old_profile, new_profile)

	if not changed_profile_fields.player_unit_respawn then
		changed_profile_fields.inventory = self:_calculate_changed_inventory_items(old_profile, new_profile)
		changed_profile_fields.talents = self:_calculate_changed_talents(old_profile, new_profile)
	end

	if old_sync_data then
		changed_profile_fields = self:_merge_old_and_new_profile_changes(old_sync_data.changed_profile_fields, changed_profile_fields)
	end

	local sync_change_id = self._next_sync_change_id

	self._next_sync_change_id = sync_change_id + 1

	_debug_print("LoadingTimes: Player Profile Begin Sync-Change: %i (peer: %s, player_id: %s)", sync_change_id, sync_peer_id, sync_local_player_id)

	syncs[sync_peer_id] = syncs[sync_peer_id] or {}

	local sync_data = {
		handled_notify_clients = false,
		handled_profile_changes = false,
		sync_change_id = sync_change_id,
		changed_profile_fields = changed_profile_fields,
	}

	syncs[sync_peer_id][sync_local_player_id] = sync_data

	if old_sync_data then
		local is_despawned = old_sync_data.changed_profile_fields.player_unit_respawn

		if is_despawned then
			sync_data.after_sync_spawn_pose_box = old_sync_data.after_sync_spawn_pose_box
		else
			local temp_sync_data = {
				changed_profile_fields = self:_collect_new_changes_between_sync_data(old_sync_data, sync_data),
				wield_slot_after_sync = old_sync_data.wield_slot_after_sync,
			}

			self:_handle_profile_changes_before_sync(player, temp_sync_data)

			sync_data.wield_slot_after_sync = temp_sync_data.wield_slot_after_sync
		end
	else
		self:_handle_profile_changes_before_sync(player, sync_data)
	end

	local sync_states = self._sync_states

	for peer_id, data in pairs(sync_states) do
		local peer_states = data.peer_states
		local player_states = peer_states[sync_peer_id].player_states
		local player_data = player_states[sync_local_player_id]
		local alias_states = player_data.alias_states

		for alias, _ in pairs(alias_states) do
			alias_states[alias] = SYNC_STATES.not_synced
		end

		self:_increment_alias_version(peer_id, sync_peer_id, sync_local_player_id)
	end
end

PackageSynchronizerHost._merge_old_and_new_profile_changes = function (self, old_changed_profile_fields, new_changed_profile_fields)
	if old_changed_profile_fields.player_unit_respawn then
		return old_changed_profile_fields
	end

	if new_changed_profile_fields.player_unit_respawn then
		return new_changed_profile_fields
	end

	local merged_profile_fields = table.clone_instance(old_changed_profile_fields)
	local new_inventory_changes = new_changed_profile_fields.inventory
	local merged_inventory_changes = merged_profile_fields.inventory

	for slot_name, change in pairs(new_inventory_changes) do
		merged_inventory_changes[slot_name] = change
	end

	local new_talent_changes = new_changed_profile_fields.talents

	if new_talent_changes then
		merged_profile_fields.talents = new_talent_changes
	end

	return merged_profile_fields
end

local EMPTY_TABLE = {}

PackageSynchronizerHost._calculate_player_unit_respawn = function (self, profile, new_profile)
	if profile.archetype.name ~= new_profile.archetype.name then
		return true
	end

	if profile.gender ~= new_profile.gender then
		return true
	end

	if profile.selected_voice ~= new_profile.selected_voice then
		return true
	end

	local personal = profile.personal or EMPTY_TABLE
	local new_personal = profile.personal or EMPTY_TABLE
	local old_character_height = personal.character_height or 1
	local new_character_height = new_personal.character_height or 1
	local character_height_diff = math.abs(new_character_height - old_character_height)

	if character_height_diff > 0.01 then
		return true
	end

	return false
end

PackageSynchronizerHost._calculate_changed_inventory_items = function (self, profile, new_profile)
	local changed_loadout_items = {}
	local loadout = profile.visual_loadout
	local new_loadout = new_profile.visual_loadout
	local mission_name = self._mission_name
	local mission_template

	if mission_name then
		mission_template = MissionTemplates[mission_name]
	end

	for slot_name, item in pairs(loadout) do
		repeat
			local new_item = new_loadout[slot_name]

			if not new_item then
				changed_loadout_items[slot_name] = {
					reason = "item_removed",
				}

				break
			end

			local item_gear_id = item.gear_id
			local new_item_gear_id = new_item.gear_id

			if item_gear_id ~= new_item_gear_id then
				changed_loadout_items[slot_name] = {
					reason = "item_replaced",
					new_item = new_item,
				}

				break
			end

			local dependencies = ItemPackage.compile_item_instance_dependencies(item, self._item_definitions, nil, mission_template)
			local new_dependencies = ItemPackage.compile_item_instance_dependencies(new_item, self._item_definitions, nil, mission_template)
			local item_altered = false

			for package_name, _ in pairs(dependencies) do
				if new_dependencies[package_name] == nil then
					item_altered = true

					break
				end
			end

			if not item_altered then
				for package_name, _ in pairs(new_dependencies) do
					if dependencies[package_name] == nil then
						item_altered = true

						break
					end
				end
			end

			item_altered = item_altered or self:_item_instance_altered(slot_name, item, profile, new_profile)

			if item_altered then
				changed_loadout_items[slot_name] = {
					reason = "item_altered",
					new_item = new_item,
				}
			end

			break
		until true
	end

	for slot_name, new_item in pairs(new_loadout) do
		repeat
			if ItemSlotSettings[slot_name] then
				do
					local item = loadout[slot_name]

					if not item then
						changed_loadout_items[slot_name] = {
							reason = "item_added",
							new_item = new_item,
						}
					end

					break
				end

				break
			end

			Log.error("ProfileUtil", string.format("Unknown gear slot %s", slot_name))
		until true
	end

	return changed_loadout_items
end

local function _find_modifier(modifier_list, modifier_key, modifier_id)
	for i = 1, #modifier_list do
		local modifier = modifier_list[i]

		if modifier[modifier_key] == modifier_id then
			return modifier
		end
	end

	return false
end

local function _compare_modifier_list(modifier_list_a, modifier_list_b, idintifier_key, value_key)
	if modifier_list_a == nil and modifier_list_b == nil then
		return true
	end

	if modifier_list_a == nil or modifier_list_b == nil then
		return false
	end

	for i = 1, #modifier_list_a do
		local modifier_a = modifier_list_a[i]
		local modifier_a_id = modifier_a[idintifier_key]
		local modifier_b = _find_modifier(modifier_list_b, idintifier_key, modifier_a_id)
		local modifier_a_value = modifier_a[value_key]
		local modifier_b_value = modifier_b and modifier_b[value_key]

		if modifier_a_value and modifier_b_value then
			local diff = modifier_a_value - modifier_b_value

			if math.abs(diff) > 0.0001 then
				return false
			end
		else
			return false
		end
	end

	return true
end

PackageSynchronizerHost._item_instance_altered = function (self, slot_name, item, profile, new_profile)
	local old_profile_slot_item_data = profile.loadout_item_data[slot_name]
	local new_profile_slot_item_data = new_profile.loadout_item_data[slot_name]
	local old_overrides = old_profile_slot_item_data.overrides
	local new_overrides = new_profile_slot_item_data.overrides

	if old_overrides == nil and new_overrides == nil then
		return false
	end

	if old_overrides == nil and new_overrides ~= nil or old_overrides ~= nil and new_overrides == nil then
		return true
	end

	if not _compare_modifier_list(old_overrides.base_stats, new_overrides.base_stats, "name", "value") then
		return true
	end

	if not _compare_modifier_list(old_overrides.traits, new_overrides.traits, "id", "rarity") then
		return true
	end

	return false
end

PackageSynchronizerHost._calculate_changed_talents = function (self, old_profile, new_profile)
	local old_talents = old_profile.talents
	local new_talents = new_profile.talents
	local talents_changed = false

	for talent_name, tier in pairs(old_talents) do
		if not new_talents[talent_name] or new_talents[talent_name] ~= tier then
			talents_changed = true

			break
		end
	end

	if not talents_changed then
		for talent_name, tier in pairs(new_talents) do
			if not old_talents[talent_name] or old_talents[talent_name] ~= tier then
				talents_changed = true

				break
			end
		end
	end

	if talents_changed then
		local changes = {
			talents = new_talents,
		}

		return changes
	end
end

PackageSynchronizerHost._increment_alias_version = function (self, peer_id, sync_peer_id, sync_local_player_id)
	local data = self._sync_states[peer_id]
	local peer_data = data.peer_states[sync_peer_id]
	local player_data = peer_data.player_states[sync_local_player_id]
	local alias_version = player_data.alias_version
	local new_alias_version = alias_version + 1

	if new_alias_version > 16 then
		new_alias_version = 1
	end

	player_data.alias_version = new_alias_version

	return new_alias_version
end

PackageSynchronizerHost.update = function (self, dt)
	local syncs = self._syncs

	for peer_id, players_data in pairs(syncs) do
		for local_player_id, sync_data in pairs(players_data) do
			if sync_data.handled_profile_changes and sync_data.handled_notify_clients then
				local is_player_synced_by_all = self:_is_player_synced_by_all(peer_id, local_player_id)

				if is_player_synced_by_all then
					_debug_print("LoadingTimes: Player Profile Finish Sync-Change: %i (peer: %s, player_id: %s)", sync_data.sync_change_id, peer_id, local_player_id)
					self:_handle_profile_changes_after_sync(peer_id, local_player_id, sync_data)

					players_data[local_player_id] = nil
				end
			end

			if sync_data.handled_profile_changes and not sync_data.handled_notify_clients then
				local sync_states = self._sync_states

				for sync_peer_id, data in pairs(sync_states) do
					if data.ready then
						local channel_id = data.channel_id
						local alias_version = data.peer_states[peer_id].player_states[local_player_id].alias_version

						if channel_id then
							RPC.rpc_player_profile_packages_changed(channel_id, peer_id, local_player_id, alias_version)
						else
							self._hosted_synchronizer_client:rpc_player_profile_packages_changed(channel_id, peer_id, local_player_id, alias_version)
						end
					end
				end

				sync_data.handled_notify_clients = true
			end

			if not sync_data.handled_profile_changes then
				sync_data.handled_profile_changes = true
			end
		end

		if not next(players_data) then
			syncs[peer_id] = nil
		end
	end
end

PackageSynchronizerHost._collect_new_changes_between_sync_data = function (self, old_sync_data, sync_data)
	if sync_data.changed_profile_fields.player_unit_respawn then
		return sync_data.changed_profile_fields
	end

	local old_changed_profile_fields = old_sync_data.changed_profile_fields
	local new_changed_profile_fields = table.clone_instance(sync_data.changed_profile_fields)
	local old_inventory_changes = old_changed_profile_fields.inventory
	local new_inventory_changes = new_changed_profile_fields.inventory

	if old_inventory_changes and new_inventory_changes then
		for slot_name, change in pairs(old_inventory_changes) do
			new_inventory_changes[slot_name] = nil
		end
	end

	if old_changed_profile_fields.talents then
		new_changed_profile_fields.talents = nil
	end

	return new_changed_profile_fields
end

PackageSynchronizerHost._handle_profile_changes_before_sync = function (self, player, sync_data)
	local changed_profile_fields = sync_data.changed_profile_fields

	if changed_profile_fields.player_unit_respawn then
		self:_handle_player_unit_respawn_before_sync(player, sync_data)
	end

	local changed_inventory_items = changed_profile_fields.inventory

	if changed_inventory_items then
		self:_handle_inventory_changes_before_sync(changed_inventory_items, player, sync_data)
	end

	local changed_talents = changed_profile_fields.talents

	if changed_talents then
		self:_handle_talent_changes_before_sync(player, sync_data)
	end

	local cleanup_owned_units = changed_inventory_items or changed_talents or changed_profile_fields.player_unit_respawn

	if cleanup_owned_units then
		self:_cleanup_owned_units(player)
	end
end

PackageSynchronizerHost._handle_player_unit_respawn_before_sync = function (self, player, sync_data)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn

	if not player_unit_spawn_manager then
		return
	end

	local player_unit = player.player_unit

	if not player_unit then
		return
	end

	local pose = Unit.world_pose(player_unit, 1)
	local pose_box = sync_data.after_sync_spawn_pose_box

	if pose_box then
		pose_box:store(pose)
	else
		sync_data.after_sync_spawn_pose_box = Matrix4x4Box(pose)
	end

	player_unit_spawn_manager:despawn_player_safe(player)
end

PackageSynchronizerHost._handle_inventory_changes_before_sync = function (self, inventory_changes, player, sync_data)
	local player_unit = player.player_unit

	if not player_unit then
		return
	end

	local fixed_t = FixedFrame.get_latest_fixed_time()
	local inventory_component = ScriptUnit.extension(player_unit, "unit_data_system"):read_component("inventory")
	local wielded_slot = inventory_component.wielded_slot
	local unequipped_wielded_slot = false
	local slot_to_wield_after_sync = wielded_slot
	local slot_configuration = PlayerCharacterConstants.slot_configuration

	for slot_name, data in pairs(inventory_changes) do
		if slot_configuration[slot_name] then
			local reason = data.reason

			if reason == "item_removed" or reason == "item_replaced" or reason == "item_altered" then
				if slot_name == wielded_slot then
					PlayerUnitVisualLoadout.wield_slot("slot_unarmed", player_unit, fixed_t)

					unequipped_wielded_slot = true

					if reason == "item_removed" then
						_debug_warning("Wielded item was removed and won't be re-equipped. Fallback to wield `slot_primary` after sync.")

						slot_to_wield_after_sync = "slot_primary"
					end
				end

				PlayerUnitVisualLoadout.unequip_item_from_slot(player_unit, slot_name, fixed_t)
			end
		end
	end

	if unequipped_wielded_slot then
		sync_data.wield_slot_after_sync = slot_to_wield_after_sync
	end
end

PackageSynchronizerHost._handle_talent_changes_before_sync = function (self, player, sync_data)
	local player_unit = player.player_unit

	if not unit_alive(player_unit) then
		return
	end

	local fixed_t = FixedFrame.get_latest_fixed_time()
	local inventory_component = ScriptUnit.extension(player_unit, "unit_data_system"):read_component("inventory")
	local wielded_slot = inventory_component.wielded_slot
	local unequipped_wielded_slot = false

	for _, ability_slot_name in pairs(ability_configuration) do
		if wielded_slot == ability_slot_name then
			PlayerUnitVisualLoadout.wield_slot("slot_unarmed", player_unit, fixed_t)

			unequipped_wielded_slot = true

			break
		end
	end

	local talent_extension = ScriptUnit.extension(player_unit, "talent_system")

	talent_extension:remove_gameplay_features(fixed_t)

	if unequipped_wielded_slot then
		sync_data.wield_slot_after_sync = "slot_primary"
	end
end

PackageSynchronizerHost._handle_profile_changes_after_sync = function (self, peer_id, local_player_id, sync_data)
	local changed_profile_fields = sync_data.changed_profile_fields
	local player = Managers.player:player(peer_id, local_player_id)

	if changed_profile_fields.player_unit_respawn then
		self:_handle_player_unit_respawn_after_sync(player, sync_data)
	end

	local player_unit = player.player_unit

	if not player_unit then
		return
	end

	local fixed_t = FixedFrame.get_latest_fixed_time()
	local changed_inventory_items = changed_profile_fields.inventory

	if changed_inventory_items then
		self:_handle_inventory_changes_after_sync(changed_inventory_items, player_unit, fixed_t)
	end

	local changed_talents = changed_profile_fields.talents

	if changed_talents then
		self:_handle_talent_changes_after_sync(changed_talents, player)
	end

	local wield_slot_after_sync = sync_data.wield_slot_after_sync

	if wield_slot_after_sync then
		PlayerUnitVisualLoadout.wield_slot(wield_slot_after_sync, player_unit, fixed_t)
	end
end

PackageSynchronizerHost._handle_player_unit_respawn_after_sync = function (self, player, sync_data)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn

	if not player_unit_spawn_manager then
		return
	end

	local spawn_pose = sync_data.after_sync_spawn_pose_box:unbox()
	local position, rotation = Matrix4x4.translation(spawn_pose), Matrix4x4.rotation(spawn_pose)
	local parent
	local force_spawn = true
	local side_name, breed_name, character_state
	local is_respawn = false
	local optional_damage, optional_permanent_damage

	player_unit_spawn_manager:spawn_player(player, position, rotation, parent, force_spawn, side_name, breed_name, character_state, is_respawn, optional_damage, optional_permanent_damage)
end

PackageSynchronizerHost._handle_inventory_changes_after_sync = function (self, inventory_changes, player_unit, fixed_t)
	local slot_configuration = PlayerCharacterConstants.slot_configuration

	for slot_name, data in pairs(inventory_changes) do
		if slot_configuration[slot_name] then
			local reason = data.reason

			if reason == "item_added" or reason == "item_replaced" or reason == "item_altered" then
				local item = data.new_item

				PlayerUnitVisualLoadout.equip_item_to_slot(player_unit, item, slot_name, nil, fixed_t)
			end
		end
	end
end

PackageSynchronizerHost._handle_talent_changes_after_sync = function (self, talent_changes, player)
	local player_unit = player.player_unit

	if not unit_alive(player_unit) then
		return
	end

	local talents = talent_changes.talents
	local fixed_t = FixedFrame.get_latest_fixed_time()
	local talent_extension = ScriptUnit.extension(player_unit, "talent_system")

	talent_extension:select_new_talents(talents, fixed_t)
end

PackageSynchronizerHost._cleanup_owned_units = function (self, player)
	local unit_spawner_manager = Managers.state.unit_spawner

	if not unit_spawner_manager then
		return
	end

	local owned_units = player.owned_units
	local player_unit = player.player_unit

	if player_unit then
		local t = FixedFrame.get_latest_fixed_time()

		Interrupt.ability_and_action(t, player_unit, "PackageSynchronizer", nil, true)
	end

	local companion_spawner_extension = ScriptUnit.has_extension(player_unit, "companion_spawner_system")
	local companion_unit = companion_spawner_extension and companion_spawner_extension:companion_unit()

	for unit, _ in pairs(owned_units) do
		if unit ~= player_unit and unit ~= companion_unit then
			unit_spawner_manager:mark_for_deletion(unit)
		end
	end
end

PackageSynchronizerHost.is_peer_synced = function (self, peer_id, peers_filter_map, debug_log)
	local prioritization_template = self._prioritization_template
	local required_package_aliases = prioritization_template.required_package_aliases
	local sync_states = self._sync_states
	local peer_states = sync_states[peer_id].peer_states

	for sync_peer_id, peer_data in pairs(peer_states) do
		repeat
			if peers_filter_map and not peers_filter_map[sync_peer_id] then
				break
			end

			local player_states = peer_data.player_states

			for sync_local_player_id, player_data in pairs(player_states) do
				local alias_states = player_data.alias_states

				if not sync_states[sync_peer_id] or sync_states[sync_peer_id].enabled then
					local synced = true

					for i = 1, #required_package_aliases do
						local alias = required_package_aliases[i]
						local alias_state = alias_states[alias]

						if alias_state ~= SYNC_STATES.synced then
							synced = false

							break
						end
					end

					if not synced then
						if debug_log then
							Log.info("PackageSynchronizerHost", "peer %s has not synced all other peers! has not synced: %s", peer_id, sync_peer_id)
						end

						return false
					end
				end
			end
		until true
	end

	for sync_peer_id, data in pairs(sync_states) do
		repeat
			if peers_filter_map and not peers_filter_map[sync_peer_id] then
				break
			elseif not data.enabled then
				break
			end

			local player_states = data.peer_states[peer_id].player_states
			local synced = true

			for _, player_data in pairs(player_states) do
				local alias_states = player_data.alias_states

				for i = 1, #required_package_aliases do
					local alias = required_package_aliases[i]
					local alias_state = alias_states[alias]

					if alias_state ~= SYNC_STATES.synced then
						synced = false

						break
					end
				end
			end

			if not synced then
				if debug_log then
					Log.info("PackageSynchronizerHost", "peer %s is not synced by all other peers! not synced by: %s", peer_id, sync_peer_id)
				end

				return false
			end
		until true
	end

	return true
end

PackageSynchronizerHost._is_player_synced_by_all = function (self, peer_id, local_player_id, peers_filter_map)
	local prioritization_template = self._prioritization_template
	local required_package_aliases = prioritization_template.required_package_aliases
	local sync_states = self._sync_states

	for sync_peer_id, data in pairs(sync_states) do
		repeat
			if peers_filter_map and not peers_filter_map[sync_peer_id] then
				break
			elseif not data.enabled then
				break
			end

			local alias_states = data.peer_states[peer_id].player_states[local_player_id].alias_states

			for i = 1, #required_package_aliases do
				local alias = required_package_aliases[i]
				local alias_state = alias_states[alias]

				if alias_state ~= SYNC_STATES.synced then
					return false
				end
			end
		until true
	end

	return true
end

PackageSynchronizerHost.bot_synced_by_all = function (self, local_player_id)
	local peer_id = self._peer_id
	local synced = self:_is_player_synced_by_all(peer_id, local_player_id)

	return synced
end

PackageSynchronizerHost.peers_synced = function (self, peer_ids, peers_filter_map)
	for _, peer_id in ipairs(peer_ids) do
		if not self:is_peer_synced(peer_id, peers_filter_map) then
			return false
		end
	end

	return true
end

local temp_non_synced_peers_map = {
	peer_to_others = Script.new_array(8),
	others_to_peer = Script.new_array(8),
}

PackageSynchronizerHost.peers_not_synced_with = function (self, peer_id, peers_filter_map)
	local non_synced_peers_map = temp_non_synced_peers_map
	local peer_to_others = non_synced_peers_map.peer_to_others
	local others_to_peer = non_synced_peers_map.others_to_peer

	table.clear(peer_to_others)
	table.clear(others_to_peer)

	local prioritization_template = self._prioritization_template
	local required_package_aliases = prioritization_template.required_package_aliases
	local sync_states = self._sync_states
	local peer_states = sync_states[peer_id].peer_states

	for sync_peer_id, peer_data in pairs(peer_states) do
		repeat
			if peers_filter_map and not peers_filter_map[sync_peer_id] then
				break
			end

			local synced = true
			local player_states = peer_data.player_states

			for sync_local_player_id, player_data in pairs(player_states) do
				local alias_states = player_data.alias_states

				if not sync_states[sync_peer_id] or sync_states[sync_peer_id].enabled then
					for i = 1, #required_package_aliases do
						local alias = required_package_aliases[i]
						local alias_state = alias_states[alias]

						if alias_state ~= SYNC_STATES.synced then
							synced = false

							break
						end
					end

					if not synced then
						break
					end
				end
			end

			if not synced then
				peer_to_others[#peer_to_others + 1] = sync_peer_id
			end
		until true
	end

	for sync_peer_id, data in pairs(sync_states) do
		repeat
			if peers_filter_map and not peers_filter_map[sync_peer_id] then
				break
			elseif not data.enabled then
				break
			elseif sync_peer_id == peer_id then
				break
			end

			local player_states = data.peer_states[peer_id].player_states
			local synced = true

			for _, player_data in pairs(player_states) do
				local alias_states = player_data.alias_states

				for i = 1, #required_package_aliases do
					local alias = required_package_aliases[i]
					local alias_state = alias_states[alias]

					if alias_state ~= SYNC_STATES.synced then
						synced = false

						break
					end
				end
			end

			if not synced then
				others_to_peer[#others_to_peer + 1] = sync_peer_id
			end
		until true
	end

	return peer_to_others, others_to_peer
end

PackageSynchronizerHost.enable_peers = function (self, peer_ids)
	local sync_states = self._sync_states

	for _, peer_id in ipairs(peer_ids) do
		if sync_states[peer_id] then
			sync_states[peer_id].enabled = true
		else
			_debug_warning("LoadingTimes: Failed to enable sync state. Peer %s is not known!", tostring(peer_id))
		end
	end

	for peer_id, data in pairs(sync_states) do
		if peer_id ~= self._peer_id and data.enabled then
			local channel_id = data.channel_id

			RPC.rpc_package_synchronizer_enable_peers(channel_id, peer_ids)
		end
	end

	local hosted_synchronizer_client = self._hosted_synchronizer_client

	if hosted_synchronizer_client then
		hosted_synchronizer_client:enable_peers(peer_ids)
	end
end

PackageSynchronizerHost.add_peer = function (self, new_peer_id)
	local new_peer_states = {}
	local alias_states = {}

	for i = 1, #PlayerPackageAliases do
		local alias = PlayerPackageAliases[i]

		alias_states[alias] = SYNC_STATES.not_synced
	end

	local players = Managers.player:players_at_peer(new_peer_id)

	for peer_id, data in pairs(self._sync_states) do
		local peer_states = data.peer_states

		peer_states[new_peer_id] = {
			player_states = {},
		}

		for local_player_id, _ in pairs(players) do
			peer_states[new_peer_id].player_states[local_player_id] = {
				alias_version = 1,
				alias_states = table.clone(alias_states),
			}
		end

		new_peer_states[peer_id] = {
			player_states = {},
		}

		local player_states = peer_states[peer_id].player_states

		for local_player_id, _ in pairs(player_states) do
			new_peer_states[peer_id].player_states[local_player_id] = {
				alias_version = 1,
				alias_states = table.clone(alias_states),
			}
		end
	end

	new_peer_states[new_peer_id] = {
		player_states = {},
	}

	if players then
		for local_player_id, _ in pairs(players) do
			new_peer_states[new_peer_id].player_states[local_player_id] = {
				alias_version = 1,
				alias_states = table.clone(alias_states),
			}
		end
	end

	local data = {
		enabled = false,
		ready = false,
		peer_states = new_peer_states,
	}

	self._sync_states[new_peer_id] = data

	if new_peer_id ~= self._peer_id then
		self._hosted_synchronizer_client:add_peer(new_peer_id)

		local channel_id = Managers.connection:peer_to_channel(new_peer_id)

		data.channel_id = channel_id

		self._network_delegate:register_connection_channel_events(self, channel_id, unpack(RPCS))
	end
end

PackageSynchronizerHost.add_bot = function (self, local_player_id)
	local alias_states = {}

	for i = 1, #PlayerPackageAliases do
		local alias = PlayerPackageAliases[i]

		alias_states[alias] = SYNC_STATES.not_synced
	end

	local sync_states = self._sync_states
	local peer_id = self._peer_id

	for _, data in pairs(sync_states) do
		local peer_data = data.peer_states[peer_id]
		local player_states = peer_data.player_states

		player_states[local_player_id] = {
			alias_version = 1,
			alias_states = table.clone(alias_states),
		}
	end

	self._hosted_synchronizer_client:add_bot(peer_id, local_player_id)
end

PackageSynchronizerHost.remove_bot = function (self, local_player_id)
	local sync_states = self._sync_states
	local peer_id = self._peer_id

	for _, data in pairs(sync_states) do
		local peer_data = data.peer_states[peer_id]
		local player_states = peer_data.player_states

		player_states[local_player_id] = nil
	end

	self._hosted_synchronizer_client:remove_bot(peer_id, local_player_id)

	if self._syncs[peer_id] then
		self._syncs[peer_id][local_player_id] = nil
	end
end

PackageSynchronizerHost.ready_peer = function (self, peer_id)
	local data = self._sync_states[peer_id]

	data.ready = true

	local my_peer_id = self._peer_id

	if peer_id ~= my_peer_id and self._mission_name then
		local channel_id = data.channel_id
		local mission_name_id = NetworkLookup.missions[self._mission_name]

		RPC.rpc_package_synchronizer_set_mission_name(channel_id, mission_name_id)
		RPC.rpc_reevaluate_all_profile_packages(channel_id)
	end
end

PackageSynchronizerHost.remove_peer = function (self, peer_id)
	local data = self._sync_states[peer_id]

	self._sync_states[peer_id] = nil

	for other_peer_id, other_peer_data in pairs(self._sync_states) do
		local peer_states = other_peer_data.peer_states

		peer_states[peer_id] = nil
	end

	if peer_id ~= self._peer_id then
		self._hosted_synchronizer_client:remove_peer(peer_id)

		local channel_id = data.channel_id

		self._network_delegate:unregister_channel_events(channel_id, unpack(RPCS))
	end

	self._syncs[peer_id] = nil
end

PackageSynchronizerHost.alias_loading_complete = function (self, peer_id, loaded_peer_id, loaded_local_player_id, alias)
	local peer_states = self._sync_states[peer_id].peer_states
	local player_states = peer_states[loaded_peer_id].player_states
	local alias_states = player_states[loaded_local_player_id].alias_states

	alias_states[alias] = SYNC_STATES.synced
end

PackageSynchronizerHost.destroy = function (self)
	local sync_states = self._sync_states
	local local_peer_id = self._peer_id

	for peer_id, data in pairs(sync_states) do
		if peer_id ~= local_peer_id then
			local channel_id = data.channel_id

			self._network_delegate:unregister_channel_events(channel_id, unpack(RPCS))
		end
	end

	Managers.event:unregister(self, "mechanism_changed")
	Managers.event:unregister(self, "updated_player_profile_synced")
end

PackageSynchronizerHost.rpc_package_synchronizer_ready_peer = function (self, channel_id)
	local peer_id = Managers.connection:channel_to_peer(channel_id)
	local template_name = self._prioritization_template.name
	local template_id = NetworkLookup.package_synchronization_template_names[template_name]

	RPC.rpc_set_package_prioritization(channel_id, template_id)
	self:ready_peer(peer_id)

	local sync_states = self._sync_states
	local data = sync_states[peer_id]
	local peer_states = data.peer_states

	for sync_peer_id, peer_data in pairs(peer_states) do
		local player_sync_states = peer_data.player_states

		for sync_local_player_id, _ in pairs(player_sync_states) do
			local alias_version = self:_increment_alias_version(peer_id, sync_peer_id, sync_local_player_id)

			RPC.rpc_set_alias_version(channel_id, sync_peer_id, sync_local_player_id, alias_version)
		end
	end
end

PackageSynchronizerHost.rpc_alias_loading_complete = function (self, channel_id, peer_id, loaded_peer_id, loaded_local_player_id, alias_index, alias_version)
	local sync_states = self._sync_states
	local data = sync_states[peer_id]
	local peer_states = data.peer_states
	local other_peer_data = peer_states[loaded_peer_id]

	if not other_peer_data then
		return
	end

	local player_states = other_peer_data.player_states
	local player_data = player_states[loaded_local_player_id]

	if not player_data then
		return
	end

	local player_alias_version = player_data.alias_version

	if player_alias_version ~= alias_version then
		return
	end

	local alias = PlayerPackageAliases[alias_index]

	self:alias_loading_complete(peer_id, loaded_peer_id, loaded_local_player_id, alias)
end

return PackageSynchronizerHost
