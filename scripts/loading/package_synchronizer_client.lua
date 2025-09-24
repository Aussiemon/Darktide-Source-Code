-- chunkname: @scripts/loading/package_synchronizer_client.lua

local ArchetypeResourceDependencies = require("scripts/utilities/archetype_resource_dependencies")
local CharacterSheet = require("scripts/utilities/character_sheet")
local GameModeSettings = require("scripts/settings/game_mode/game_mode_settings")
local ItemPackage = require("scripts/foundation/managers/package/utilities/item_package")
local MasterItems = require("scripts/backend/master_items")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local PackagePrioritizationTemplates = require("scripts/loading/package_prioritization_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerCharacterDecals = require("scripts/settings/decal/player_character_decals")
local PlayerCharacterParticles = require("scripts/settings/particles/player_character_particles")
local PlayerCharacterSounds = require("scripts/settings/sound/player_character_sounds")
local PlayerPackageAliases = require("scripts/settings/player/player_package_aliases")
local ability_configuration = PlayerCharacterConstants.ability_configuration
local ability_types = table.keys(PlayerCharacterConstants.ability_configuration)
local PackageSynchronizerClient = class("PackageSynchronizerClient")
local RPCS = {
	"rpc_set_package_prioritization",
	"rpc_package_synchronizer_enable_peers",
	"rpc_player_profile_packages_changed",
	"rpc_reevaluate_all_profile_packages",
	"rpc_package_synchronizer_set_mission_name",
	"rpc_set_alias_version",
}
local PACKAGE_MANAGER_REFERENCE = "PackageSynchronizer"

PackageSynchronizerClient.DEBUG_TAG = "Package Sync Client"

local function _debug_print(str, ...)
	Log.info(PackageSynchronizerClient.DEBUG_TAG, str, ...)
end

local LOADING_STATES = table.enum("loading", "ready_to_load", "loaded", "dirty")

PackageSynchronizerClient.init = function (self, peer_id, is_host, network_delegate, host_channel_id)
	self._peer_id = peer_id
	self._is_host = is_host
	self._network_delegate = network_delegate
	self._host_channel_id = host_channel_id
	self._packages = {}
	self.NO_LOOKUP = 0
	self._enabled_peers_cache = {}
	self._pending_peers = {}
	self._player_alias_versions = {}
	self._unload_delayer = {}
	self._mission_name = nil

	if not is_host then
		network_delegate:register_connection_channel_events(self, host_channel_id, unpack(RPCS))
		RPC.rpc_package_synchronizer_ready_peer(host_channel_id)
	end
end

PackageSynchronizerClient.init_item_definitions = function (self, item_definitions)
	self._item_definitions = item_definitions

	local pending_peers = self._pending_peers

	for i = 1, #self._pending_peers do
		local peer_id = pending_peers[i]

		self:add_peer(peer_id)
	end

	table.clear(self._pending_peers)
end

PackageSynchronizerClient.item_definitions_initialized = function (self)
	return self._item_definitions and true
end

PackageSynchronizerClient.set_mission_name = function (self, mission_name)
	self._mission_name = mission_name
end

PackageSynchronizerClient.add_peer = function (self, peer_id)
	if not self._item_definitions then
		self._pending_peers[#self._pending_peers + 1] = peer_id

		return
	end

	local players = Managers.player:players_at_peer(peer_id)
	local packages = {}

	for local_player_id, player in pairs(players) do
		local profile = player:profile()
		local profile_packages = self:resolve_profile_packages(profile)

		packages[local_player_id] = profile_packages

		local player_string = player:is_human_controlled() and "Player" or "Bot Player"

		_debug_print("Add %s, peer_id: %s, local_player_id: %s", player_string, peer_id, local_player_id)
	end

	local data = {
		enabled = self._enabled_peers_cache[peer_id] or false,
		peer_packages = packages,
	}

	self._packages[peer_id] = data
end

PackageSynchronizerClient.remove_peer = function (self, peer_id)
	local data = self._packages[peer_id]

	if not data then
		return
	end

	local package_ids = {}

	self:_get_loaded_packages_from_peer_packages(data.peer_packages, package_ids)
	self:_add_to_unload_delayer(package_ids)

	self._packages[peer_id] = nil
	self._pending_peers[peer_id] = nil
	self._player_alias_versions[peer_id] = nil
	self._enabled_peers_cache[peer_id] = nil
end

PackageSynchronizerClient.add_bot = function (self, peer_id, local_player_id)
	local data = self._packages[peer_id]

	if not data then
		self:add_peer(peer_id)
		self:enable_peers({
			peer_id,
		})
	else
		local player = Managers.player:player(peer_id, local_player_id)
		local profile = player:profile()
		local profile_packages = self:resolve_profile_packages(profile)
		local peer_packages = data.peer_packages

		peer_packages[local_player_id] = profile_packages

		_debug_print("Add Bot Player, peer_id: %s, local_player_id: %s", peer_id, local_player_id)
	end
end

PackageSynchronizerClient.remove_bot = function (self, peer_id, local_player_id)
	local data = self._packages[peer_id]

	if not data then
		return
	end

	local peer_packages = data.peer_packages
	local player_packages = peer_packages[local_player_id]
	local package_ids = {}

	self:_get_loaded_packages_from_player_packages(player_packages, package_ids)
	self:_add_to_unload_delayer(package_ids)

	peer_packages[local_player_id] = nil

	local player_alias_versions = self._player_alias_versions[peer_id]

	if player_alias_versions then
		player_alias_versions[local_player_id] = nil
	end
end

local function _add_package_chunk(alias, dependencies, packages)
	packages[alias].dependencies = dependencies
end

PackageSynchronizerClient.resolve_profile_packages = function (self, profile)
	local profile_packages = {}
	local sound_dependencies = {}
	local particle_dependencies = {}
	local decal_dependencies = {}

	for i = 1, #PlayerPackageAliases do
		local alias = PlayerPackageAliases[i]

		profile_packages[alias] = {
			dependencies = {},
			state = LOADING_STATES.ready_to_load,
		}
	end

	local archetype = profile.archetype
	local archetype_name = archetype.name
	local selected_voice = profile.selected_voice
	local game_mode_settings, mission

	if self._mission_name then
		mission = MissionTemplates[self._mission_name]

		local game_mode_name = mission.game_mode_name

		game_mode_settings = GameModeSettings[game_mode_name]
	end

	local default_items = MasterItems.default_inventory(archetype_name, game_mode_settings)
	local visual_loadout = profile.visual_loadout

	self:_resolve_item_packages(default_items, profile_packages, mission)
	self:_resolve_item_packages(visual_loadout, profile_packages, mission)

	local all_items = {}

	for slot_name, item in pairs(default_items) do
		all_items[slot_name] = item
	end

	for slot_name, item in pairs(visual_loadout) do
		all_items[slot_name] = item
	end

	self:_resolve_base_units(all_items, profile_packages)

	local talents = profile.talents
	local ability_items = self:_resolve_ability_packages(archetype, talents, profile_packages, mission, game_mode_settings, profile)

	for slot_name, item in pairs(ability_items) do
		all_items[slot_name] = item
	end

	self:_resolve_profile_properties(all_items, archetype, selected_voice, sound_dependencies, particle_dependencies, decal_dependencies)
	self:_resolve_archetype_dependencies(archetype, sound_dependencies, particle_dependencies, decal_dependencies)
	_add_package_chunk("sound_dependencies", sound_dependencies, profile_packages)
	_add_package_chunk("particle_dependencies", particle_dependencies, profile_packages)
	_add_package_chunk("decal_dependencies", decal_dependencies, profile_packages)

	return profile_packages
end

PackageSynchronizerClient._resolve_item_packages = function (self, items, profile_packages, mission)
	for slot_name, item in pairs(items) do
		local item_name = item.name

		if item_name then
			local dependencies = ItemPackage.compile_item_instance_dependencies(item, self._item_definitions, nil, mission)

			for dependency, _ in pairs(dependencies) do
				dependencies[dependency] = false
			end

			_add_package_chunk(slot_name, dependencies, profile_packages)
		else
			Log.warning(PackageSynchronizerClient.DEBUG_TAG, "Unknown item for slot %s", slot_name)
		end
	end
end

PackageSynchronizerClient._resolve_base_units = function (self, items, profile_packages)
	local dependencies = {}

	for _, item in pairs(items) do
		local base_unit = item.base_unit

		if base_unit then
			dependencies[base_unit] = false

			local base_unit_1p = item.base_unit_1p

			if base_unit_1p then
				dependencies[base_unit_1p] = false
			end
		end
	end

	_add_package_chunk("base_units", dependencies, profile_packages)
end

local temp_abilities = {}
local temp_abilities_items = {}
local class_loadout = {}

PackageSynchronizerClient._resolve_ability_packages = function (self, archetype, talents, profile_packages, mission, game_mode_settings, profile)
	local force_base_talents = game_mode_settings and game_mode_settings.force_base_talents
	local selected_nodes = CharacterSheet.convert_talents_to_node_layout(profile, talents)

	CharacterSheet.class_loadout(profile, class_loadout, force_base_talents, selected_nodes)
	table.clear(temp_abilities)
	table.clear(temp_abilities_items)

	for i = 1, #ability_types do
		local ability_type = ability_types[i]
		local ability = class_loadout[ability_type]

		temp_abilities[ability_configuration[ability_type]] = ability
	end

	for slot_name, ability in pairs(temp_abilities) do
		local ability_dependencies = {}
		local item_name = ability.inventory_item_name

		if item_name then
			local dependencies = ItemPackage.compile_item_dependencies(item_name, self._item_definitions, nil, mission)

			for dependency, _ in pairs(dependencies) do
				ability_dependencies[dependency] = false
			end

			local ability_item = rawget(self._item_definitions, item_name)

			if ability_item then
				temp_abilities_items[slot_name] = ability_item
			else
				Log.error("PackageSynchronizerClient", "Unable to find item %s for ability slot %s", item_name, slot_name)
			end
		end

		_add_package_chunk(slot_name, ability_dependencies, profile_packages)
	end

	return temp_abilities_items
end

PackageSynchronizerClient._resolve_profile_properties = function (self, items, archetype, selected_voice, sound_dependencies, particle_dependencies, decal_dependencies)
	local profile_properties = {}

	profile_properties.archetype = archetype.name
	profile_properties.selected_voice = selected_voice

	for slot_name, item in pairs(items) do
		local item_properties = item.profile_properties

		if item_properties and type(item_properties) ~= "userdata" then
			for name, value in pairs(item_properties) do
				if value ~= "" then
					profile_properties[name] = value
				end
			end
		end
	end

	local events = PlayerCharacterSounds.events

	for sound_alias, _ in pairs(events) do
		local resolved, event, has_husk_events = PlayerCharacterSounds.resolve_sound(sound_alias, profile_properties)

		if resolved then
			sound_dependencies[event] = false

			if has_husk_events then
				local husk_event = string.format("%s_husk", event)

				sound_dependencies[husk_event] = false
			end
		end
	end

	local particle_aliases = PlayerCharacterParticles.particle_aliases

	for particle_alias, _ in pairs(particle_aliases) do
		local resolved, particle = PlayerCharacterParticles.resolve_particle(particle_alias, profile_properties)

		if resolved then
			particle_dependencies[particle] = false
		end
	end

	local decal_aliases = PlayerCharacterDecals.decal_aliases

	for decal_alias, _ in pairs(decal_aliases) do
		local resolved, decal = PlayerCharacterDecals.resolve_decal(decal_alias, profile_properties)

		if resolved then
			decal_dependencies[decal] = false
		end
	end

	for _, item in pairs(items) do
		local weapon_template = item.weapon_template

		if weapon_template and weapon_template ~= "" then
			profile_properties.wielded_weapon_template = weapon_template

			local relevant_events = PlayerCharacterSounds.find_relevant_events(profile_properties)
			local relevant_particles = PlayerCharacterParticles.find_relevant_particles(profile_properties)
			local relevant_decals = PlayerCharacterDecals.find_relevant_decals(profile_properties)

			for event, _ in pairs(relevant_events) do
				sound_dependencies[event] = false
			end

			for particle, _ in pairs(relevant_particles) do
				particle_dependencies[particle] = false
			end

			for decal, _ in pairs(relevant_decals) do
				decal_dependencies[decal] = false
			end
		end
	end

	profile_properties.wielded_weapon_template = nil
end

PackageSynchronizerClient._resolve_archetype_dependencies = function (self, archetype, sound_dependencies, particle_dependencies, decal_dependencies)
	local sound_resources, particle_resources, decal_resources = ArchetypeResourceDependencies.generate(archetype)

	for ii = 1, #sound_resources do
		sound_dependencies[sound_resources[ii]] = false
	end

	for ii = 1, #particle_resources do
		particle_dependencies[particle_resources[ii]] = false
	end

	for ii = 1, #decal_resources do
		decal_dependencies[decal_resources[ii]] = false
	end
end

PackageSynchronizerClient.update = function (self, dt, hosted_synchronizer_host)
	local template = self._prioritization_template

	if template then
		self:_update_package_loading(template, hosted_synchronizer_host)
	end

	self:_update_unload_delayer(dt)
end

PackageSynchronizerClient._update_package_loading = function (self, template, hosted_synchronizer_host)
	local packages = self._packages
	local player_alias_versions = self._player_alias_versions
	local required_package_aliases = template.required_package_aliases
	local remaining_package_aliases = template.remaining_package_aliases
	local all_required_packages_loaded = true
	local client_peer_id = self._peer_id
	local all_required_packages_for_client_peer_loaded = packages[client_peer_id] ~= nil

	for peer_id, data in pairs(packages) do
		local enabled = data.enabled

		if enabled then
			local peer_packages = data.peer_packages

			for local_player_id, player_packages in pairs(peer_packages) do
				for i = 1, #required_package_aliases do
					local alias = required_package_aliases[i]
					local package_data = player_packages[alias]
					local previous_state = package_data.state
					local prioritize = true

					self:_handle_dependency_loading(package_data, prioritize)

					if package_data.state ~= LOADING_STATES.loaded then
						all_required_packages_loaded = false

						if peer_id == client_peer_id then
							all_required_packages_for_client_peer_loaded = false
						end
					elseif previous_state ~= LOADING_STATES.loaded then
						if hosted_synchronizer_host then
							hosted_synchronizer_host:alias_loading_complete(client_peer_id, peer_id, local_player_id, alias)
						else
							local alias_index = table.index_of(PlayerPackageAliases, alias)
							local alias_version = player_alias_versions[peer_id] and player_alias_versions[peer_id][local_player_id] or 1

							RPC.rpc_alias_loading_complete(self._host_channel_id, client_peer_id, peer_id, local_player_id, alias_index, alias_version)
						end
					end
				end
			end
		elseif peer_id == client_peer_id then
			all_required_packages_for_client_peer_loaded = false
		end
	end

	if all_required_packages_for_client_peer_loaded then
		local data = packages[client_peer_id]
		local peer_packages = data.peer_packages

		for local_player_id, player_packages in pairs(peer_packages) do
			for i = 1, #remaining_package_aliases do
				local alias = remaining_package_aliases[i]
				local package_data = player_packages[alias]

				self:_handle_dependency_loading(package_data)
			end
		end
	end

	local all_remaining_packages_loaded = true

	if all_required_packages_loaded then
		for peer_id, data in pairs(packages) do
			local enabled = data.enabled

			if enabled then
				local peer_packages = data.peer_packages

				for local_player_id, player_packages in pairs(peer_packages) do
					for i = 1, #remaining_package_aliases do
						local alias = remaining_package_aliases[i]
						local package_data = player_packages[alias]

						self:_handle_dependency_loading(package_data)

						if package_data.state ~= LOADING_STATES.loaded then
							all_remaining_packages_loaded = false
						end
					end
				end
			end
		end
	end
end

PackageSynchronizerClient._handle_dependency_loading = function (self, package_data, prioritize)
	local state = package_data.state
	local dependencies = package_data.dependencies
	local package_manager = Managers.package

	if state == LOADING_STATES.ready_to_load then
		self:_load_dependencies(dependencies, prioritize)

		package_data.state = LOADING_STATES.loading
	elseif state == LOADING_STATES.loading or state == LOADING_STATES.dirty then
		local all_loaded = true

		for package_name, id in pairs(dependencies) do
			if not package_manager:has_loaded_id(id) then
				all_loaded = false
			end
		end

		if all_loaded then
			package_data.state = LOADING_STATES.loaded
		end
	end
end

PackageSynchronizerClient._load_dependencies = function (self, dependencies, prioritize)
	local no_callback

	for package_name, _ in pairs(dependencies) do
		dependencies[package_name] = Managers.package:load(package_name, PACKAGE_MANAGER_REFERENCE, no_callback, prioritize)
	end
end

local function _unload_packages(package_ids)
	for i = 1, #package_ids do
		local id = package_ids[i]

		Managers.package:release(id)
	end
end

PackageSynchronizerClient._update_unload_delayer = function (self, dt)
	local unload_delayer = self._unload_delayer
	local queue_size = #unload_delayer

	for i = queue_size, 1, -1 do
		local data = unload_delayer[i]
		local time = data.time - dt

		if time <= 0 then
			local package_ids = data.package_ids

			_unload_packages(package_ids)
			table.swap_delete(unload_delayer, i)
		else
			data.time = time
		end
	end
end

PackageSynchronizerClient.set_package_prioritization_template = function (self, template_name)
	local template = PackagePrioritizationTemplates[template_name]

	self:_set_package_prioritization(template)
end

PackageSynchronizerClient.reevaluate_all_profiles_packages = function (self)
	local packages = self._packages

	for peer_id, data in pairs(packages) do
		local peer_packages = data.peer_packages

		for local_player_id, _ in pairs(peer_packages) do
			self:player_profile_packages_changed(peer_id, local_player_id)
		end
	end
end

PackageSynchronizerClient.player_profile_packages_changed = function (self, peer_id, local_player_id)
	local player = Managers.player:player(peer_id, local_player_id)
	local profile = player:profile()
	local new_profile_packages = self:resolve_profile_packages(profile)
	local data = self._packages[peer_id]
	local player_packages = data.peer_packages[local_player_id]
	local package_ids = {}

	for alias, package_data in pairs(player_packages) do
		if not new_profile_packages[alias] then
			self:_get_loaded_packages_from_package_data(package_data, package_ids)

			player_packages[alias] = nil
		else
			local new_package_data = new_profile_packages[alias]

			self:_handle_dependency_differences(new_package_data, package_data, package_ids)
		end
	end

	self:_add_to_unload_delayer(package_ids)

	for alias, package_data in pairs(new_profile_packages) do
		if not player_packages[alias] then
			player_packages[alias] = table.clone(new_profile_packages[alias])
		end
	end

	self:_make_aliases_dirty(peer_id, local_player_id)
end

PackageSynchronizerClient._unload_alias_dependencies = function (self, package_data)
	if package_data.state ~= LOADING_STATES.ready_to_load then
		for package_name, id in pairs(package_data.dependencies) do
			Managers.package:release(id)
		end
	end
end

PackageSynchronizerClient._get_loaded_packages_from_peer_packages = function (self, peer_packages, input_array)
	for _, player_packages in pairs(peer_packages) do
		self:_get_loaded_packages_from_player_packages(player_packages, input_array)
	end
end

PackageSynchronizerClient._get_loaded_packages_from_player_packages = function (self, player_packages, input_array)
	for _, package_data in pairs(player_packages) do
		self:_get_loaded_packages_from_package_data(package_data, input_array)
	end
end

PackageSynchronizerClient._get_loaded_packages_from_package_data = function (self, package_data, input_array)
	if package_data.state ~= LOADING_STATES.ready_to_load then
		local keys = table.keys(package_data.dependencies)

		table.sort(keys)

		local dependencies = package_data.dependencies

		for key_index = 1, #keys do
			local key = keys[key_index]

			input_array[#input_array + 1] = dependencies[key]
		end
	end
end

PackageSynchronizerClient._handle_dependency_differences = function (self, new_package_data, package_data, package_ids)
	local current_state = package_data.state
	local dependencies = package_data.dependencies
	local new_dependencies = new_package_data.dependencies
	local sorted_dependencies = table.keys(dependencies)

	table.sort(sorted_dependencies)

	for sorted_dependencie_index = 1, #sorted_dependencies do
		local package_name = sorted_dependencies[sorted_dependencie_index]

		if new_dependencies[package_name] == nil then
			if current_state ~= LOADING_STATES.ready_to_load then
				package_ids[#package_ids + 1] = dependencies[package_name]
			end

			dependencies[package_name] = nil
		end
	end

	local no_callback
	local loading_new_dependencies = false
	local package_manager = Managers.package

	for package_name, _ in pairs(new_dependencies) do
		if dependencies[package_name] == nil then
			dependencies[package_name] = false

			if current_state ~= LOADING_STATES.ready_to_load then
				dependencies[package_name] = package_manager:load(package_name, PACKAGE_MANAGER_REFERENCE, no_callback)
				loading_new_dependencies = true
			end
		end
	end

	if loading_new_dependencies then
		package_data.state = LOADING_STATES.loading
	end
end

PackageSynchronizerClient.enable_peers = function (self, peer_ids)
	local packages = self._packages
	local enabled_peers_cache = self._enabled_peers_cache

	for i = 1, #peer_ids do
		local peer_id = peer_ids[i]

		if packages[peer_id] then
			packages[peer_id].enabled = true
		end

		enabled_peers_cache[peer_id] = true
	end
end

PackageSynchronizerClient._make_aliases_dirty = function (self, peer_id, local_player_id)
	local packages = self._packages
	local player_packages = packages[peer_id].peer_packages[local_player_id]

	for alias, package_data in pairs(player_packages) do
		if package_data.state == LOADING_STATES.loaded then
			package_data.state = LOADING_STATES.dirty
		end
	end
end

PackageSynchronizerClient.peer_enabled = function (self, peer_id)
	local peer_data = self._packages[peer_id]

	return peer_data and peer_data.enabled
end

PackageSynchronizerClient.alias_loaded = function (self, peer_id, local_player_id, alias)
	local peer_packages = self._packages[peer_id].peer_packages
	local player_packages = peer_packages[local_player_id]
	local package_data = player_packages[alias]

	return package_data.state == LOADING_STATES.loaded
end

local UNLOAD_DELAY = 3

PackageSynchronizerClient._add_to_unload_delayer = function (self, package_ids)
	local unload_delayer = self._unload_delayer

	unload_delayer[#unload_delayer + 1] = {
		time = UNLOAD_DELAY,
		package_ids = package_ids,
	}
end

PackageSynchronizerClient.rpc_package_synchronizer_enable_peers = function (self, channel_id, peer_ids)
	self:enable_peers(peer_ids)
end

PackageSynchronizerClient.rpc_set_package_prioritization = function (self, channel_id, template_id)
	local template_name = NetworkLookup.package_synchronization_template_names[template_id]
	local template = PackagePrioritizationTemplates[template_name]

	self:_set_package_prioritization(template)
end

PackageSynchronizerClient._set_package_prioritization = function (self, template)
	self._prioritization_template = template

	for peer_id, data in pairs(self._packages) do
		local peer_packages = data.peer_packages

		for local_player_id, _ in pairs(peer_packages) do
			self:_make_aliases_dirty(peer_id, local_player_id)
		end
	end
end

PackageSynchronizerClient.rpc_set_alias_version = function (self, channel_id, peer_id, local_player_id, alias_version)
	self:_set_player_alias_version(peer_id, local_player_id, alias_version)

	local data = self._packages[peer_id]

	if data then
		local player_packages = data.peer_packages[local_player_id]

		if player_packages then
			for alias, package_data in pairs(player_packages) do
				if package_data.state == LOADING_STATES.loaded then
					local alias_index = table.index_of(PlayerPackageAliases, alias)

					RPC.rpc_alias_loading_complete(self._host_channel_id, self._peer_id, peer_id, local_player_id, alias_index, alias_version)
				end
			end
		end
	end
end

PackageSynchronizerClient.rpc_player_profile_packages_changed = function (self, channel_id, peer_id, local_player_id, alias_version)
	self:_set_player_alias_version(peer_id, local_player_id, alias_version)

	local data = self._packages[peer_id]

	if data then
		self:player_profile_packages_changed(peer_id, local_player_id)
	end
end

PackageSynchronizerClient._set_player_alias_version = function (self, peer_id, local_player_id, alias_version)
	local alias_versions = self._player_alias_versions

	if not alias_versions[peer_id] then
		alias_versions[peer_id] = {}
	end

	alias_versions[peer_id][local_player_id] = alias_version
end

PackageSynchronizerClient.rpc_reevaluate_all_profile_packages = function (self, channel_id)
	self:reevaluate_all_profiles_packages()
end

PackageSynchronizerClient.rpc_package_synchronizer_set_mission_name = function (self, channel_id, mission_name_id)
	local mission_name = NetworkLookup.missions[mission_name_id]

	self:set_mission_name(mission_name)
end

PackageSynchronizerClient.destroy = function (self)
	if not self._is_host then
		self._network_delegate:unregister_channel_events(self._host_channel_id, unpack(RPCS))
	end

	local packages = self._packages

	for _, data in pairs(packages) do
		local peer_packages = data.peer_packages

		for _, player_packages in pairs(peer_packages) do
			for _, package_data in pairs(player_packages) do
				self:_unload_alias_dependencies(package_data)
			end
		end
	end

	local unload_delayer = self._unload_delayer
	local delayer_size = #unload_delayer

	for i = delayer_size, 1, -1 do
		local data = unload_delayer[i]

		_unload_packages(data.package_ids)
	end

	self._unload_delayer = nil
	self._packages = nil
end

return PackageSynchronizerClient
