﻿-- chunkname: @scripts/extension_systems/cutscene_character/cutscene_character_system.lua

local CutscenePlayerLoadout = require("scripts/extension_systems/cutscene_character/utilities/cutscene_player_loadout")
local CinematicSceneTemplates = require("scripts/settings/cinematic_scene/cinematic_scene_templates")
local PlayerVisibility = require("scripts/utilities/player_visibility")

require("scripts/extension_systems/cutscene_character/cutscene_character_extension")
require("scripts/extension_systems/cutscene_character/cutscene_companion_extension")

local CutsceneCharacterSystem = class("CutsceneCharacterSystem", "ExtensionSystemBase")

CutsceneCharacterSystem.init = function (self, extension_init_context, system_init_data, ...)
	CutsceneCharacterSystem.super.init(self, extension_init_context, system_init_data, ...)

	self._cinematic_to_extensions = {}
	self._cinematic_to_player_loadouts = {}
	self._cinematic_to_companion_extensions_by_slots = {}
	self._hide_players = false
	self._level_seed = system_init_data and system_init_data.level_seed
end

CutsceneCharacterSystem.destroy = function (self, ...)
	Managers.event:unregister(self, "assign_player_unit_ownership")
	Managers.event:unregister(self, "player_unit_spawned")
	Managers.event:unregister(self, "unit_registered")

	if self._hide_players then
		PlayerVisibility.show_players()

		self._hide_players = false
	end

	CutsceneCharacterSystem.super.destroy(self, ...)
end

CutsceneCharacterSystem.register_cutscene_character = function (self, extension)
	local cinematic_name = extension:cinematic_name()

	if cinematic_name ~= "none" then
		self._cinematic_to_extensions[cinematic_name] = self._cinematic_to_extensions[cinematic_name] or {}

		local cinematic_to_extensions = self._cinematic_to_extensions[cinematic_name]

		cinematic_to_extensions[#cinematic_to_extensions + 1] = extension
	end
end

CutsceneCharacterSystem.unregister_cutscene_character = function (self, extension)
	local cinematic_to_extensions = self._cinematic_to_extensions

	for cinematic_name, extension_list in pairs(cinematic_to_extensions) do
		for index = #extension_list, 1, -1 do
			local registered_extension = extension_list[index]

			if registered_extension == extension then
				table.swap_delete(extension_list, index)
			end
		end
	end
end

CutsceneCharacterSystem.register_cutscene_companion = function (self, extension)
	local cinematic_name = extension:cinematic_name()
	local character_slot_index = extension:slot()

	if cinematic_name ~= "none" and character_slot_index ~= "none" then
		self._cinematic_to_companion_extensions_by_slots[cinematic_name] = self._cinematic_to_companion_extensions_by_slots[cinematic_name] or {}

		local cinematic_to_companion_extensions = self._cinematic_to_companion_extensions_by_slots[cinematic_name]

		cinematic_to_companion_extensions[character_slot_index] = cinematic_to_companion_extensions[character_slot_index] or {}

		local cinematic_slot_companions = cinematic_to_companion_extensions[character_slot_index]

		cinematic_slot_companions[#cinematic_slot_companions + 1] = extension
	end
end

CutsceneCharacterSystem.unregister_cutscene_companion = function (self, extension)
	local cinematic_to_companion_extensions_by_slots = self._cinematic_to_companion_extensions_by_slots

	for cinematic_name, slots_list in pairs(cinematic_to_companion_extensions_by_slots) do
		for slot_index, companions_in_slot in pairs(slots_list) do
			for index = #companions_in_slot, 1, -1 do
				local registered_extension = companions_in_slot[index]

				if registered_extension == extension then
					table.swap_delete(companions_in_slot, index)
				end
			end
		end
	end
end

CutsceneCharacterSystem.get_cutscene_companion_for_slot = function (self, cinematic_name, slot_index, target_companion_breed_name)
	if target_companion_breed_name == "none" then
		return nil
	end

	local cinematic_to_companion_extensions_by_slots = self._cinematic_to_companion_extensions_by_slots[cinematic_name]
	local companions_in_slot = cinematic_to_companion_extensions_by_slots and cinematic_to_companion_extensions_by_slots[slot_index]

	if not companions_in_slot then
		return nil
	end

	for index = #companions_in_slot, 1, -1 do
		local companion_cutscene_extension = companions_in_slot[index]
		local companion_breed_name = companion_cutscene_extension:breed_name()

		if target_companion_breed_name == companion_breed_name then
			return companion_cutscene_extension
		end
	end

	return nil
end

CutsceneCharacterSystem.initialize_characters_for_cinematic = function (self, cinematic_name)
	local player_loadouts, sorted_player_unique_ids = self:_fetch_players_loadout(cinematic_name)
	local template = CinematicSceneTemplates[cinematic_name]

	Managers.event:register(self, "player_unit_spawned", "_on_player_unit_spawned")
	Managers.event:register(self, "unit_registered", "_on_unit_registered")

	local extensions = self._cinematic_to_extensions[cinematic_name] or {}
	local extensions_per_level = {}
	local unit_level = Unit.level

	for i = 1, #extensions do
		local extension = extensions[i]

		extension:unassign_player_loadout()

		local level = unit_level(extension._unit)
		local list = extensions_per_level[level] or {}

		list[#list + 1] = extension
		extensions_per_level[level] = list
	end

	local num_players = #sorted_player_unique_ids

	table.shuffle(sorted_player_unique_ids, self._level_seed)

	if template.randomize_equipped_weapon then
		for i = 1, num_players do
			local unique_id = sorted_player_unique_ids[i]

			if i <= 2 then
				player_loadouts[unique_id].items.slot_primary = nil
			elseif i <= 4 then
				player_loadouts[unique_id].items.slot_secondary = nil
			else
				Log.warning("More than 4 players added to cutscene. This could cause duplicate walking animations")

				if math.random() < 0.5 then
					player_loadouts[unique_id].items.slot_primary = nil
				else
					player_loadouts[unique_id].items.slot_secondary = nil
				end
			end
		end
	end

	local weapon_specific_walk_animations = template.available_weapon_animation_events

	self._hide_players = template.hide_players

	local slots_taken = {}
	local none_slot = "none"

	for i = 1, num_players do
		local unique_id = sorted_player_unique_ids[i]
		local loadout_info = player_loadouts[unique_id]

		for level, extensions_list in pairs(extensions_per_level) do
			for j = 1, #extensions_list do
				local extension = extensions_list[j]
				local slot = extension:slot()
				local slot_companion_inclusion_setting = extension:companion_inclusion_setting()
				local slot_prohibits_companion = slot_companion_inclusion_setting == "without_companion"
				local needs_slot_with_companion = loadout_info.should_show_companion
				local slot_matches_companion_requirement = slot_companion_inclusion_setting == "any" or needs_slot_with_companion ~= slot_prohibits_companion
				local slot_matches_character_requirements = extension:character_type() == "player" and extension:breed_name() == loadout_info.breed_name

				slot_matches_character_requirements = slot_matches_character_requirements and slot_matches_companion_requirement

				if slot_matches_character_requirements and not extension:has_player_assigned() and (slot == none_slot or not slots_taken[slot]) then
					local companion_breed_name = loadout_info.archetype_companion_breed_name
					local companion_cutscene_character_extension = self:get_cutscene_companion_for_slot(cinematic_name, slot, companion_breed_name)

					loadout_info.companion_extension = companion_cutscene_character_extension

					local items = loadout_info.items

					extension:assign_player_loadout(unique_id, items, companion_cutscene_character_extension)

					loadout_info.extension = extension
					slots_taken[slot] = true

					if template.randomize_equipped_weapon then
						local weapon = items.slot_primary or items.slot_secondary

						if weapon then
							extension:set_equipped_weapon(weapon)

							local slot_name = items.slot_primary and "slot_primary" or items.slot_secondary and "slot_secondary"

							extension:wield_slot(slot_name)
						end
					end

					if template.set_random_weapon_event then
						extension:set_weapon_animation_event(weapon_specific_walk_animations[i % 2 + 1])
					end

					break
				end
			end
		end
	end

	if self._hide_players then
		PlayerVisibility.hide_players()
	end

	self._cinematic_to_player_loadouts[cinematic_name] = player_loadouts

	Managers.event:register(self, "assign_player_unit_ownership", "_on_assign_player_unit_ownership")
end

CutsceneCharacterSystem.uninitialize_characters_for_cinematic = function (self, cinematic_name)
	local player_loadouts = self._cinematic_to_player_loadouts[cinematic_name] or {}

	Managers.event:unregister(self, "player_unit_spawned")
	Managers.event:unregister(self, "unit_registered")
	Managers.event:unregister(self, "assign_player_unit_ownership")

	for unique_id, loadout_info in pairs(player_loadouts) do
		local extension = loadout_info.extension

		if extension then
			extension:unassign_player_loadout()
		end

		local companion_extension = loadout_info.companion_extension

		if companion_extension then
			companion_extension:unassign_player_loadout()
		end
	end

	table.clear(player_loadouts)

	if self._hide_players then
		PlayerVisibility.show_players()

		self._hide_players = false
	end

	Managers.event:unregister(self, "assign_player_unit_ownership")
end

local function _player_has_companion_enabled(player)
	local player_profile = player:profile()
	local equiped_talents = player_profile.talents
	local archetype = player_profile.archetype
	local archetype_talents = archetype.talents

	if not archetype.companion_breed then
		return false, nil
	end

	for archetype_name, _ in pairs(equiped_talents) do
		local talent_data = archetype_talents[archetype_name]

		if talent_data and talent_data.special_rule and talent_data.special_rule.special_rule_name == "disable_companion" then
			return false, nil
		end
	end

	return true, archetype.companion_breed
end

local function create_loadout(cinematic_name, player)
	local new_player_loadout = {}
	local should_show_companion, companion_breed_name = _player_has_companion_enabled(player)
	local items = CutscenePlayerLoadout.fetch_player_items(cinematic_name, player)

	new_player_loadout.should_show_companion = should_show_companion
	new_player_loadout.archetype_companion_breed_name = companion_breed_name or "none"
	new_player_loadout.archetype_name = player:archetype_name()
	new_player_loadout.breed_name = player:breed_name()
	new_player_loadout.items = items

	return new_player_loadout
end

CutsceneCharacterSystem._fetch_players_loadout = function (self, cinematic_name)
	local player_manager = Managers.player
	local player_loadouts = {}
	local template = CinematicSceneTemplates[cinematic_name]
	local local_player = player_manager:local_player(1)
	local local_unique_id = local_player and local_player:unique_id()
	local local_player_only = template.local_player_only
	local num_slots = local_player_only and 1 or GameParameters.max_players
	local slots_taken = 0
	local package_synchronizer_client = Managers.package_synchronization:synchronizer_client()
	local human_players = player_manager:human_players()
	local sorted_unique_ids = {}

	for unique_id, player in pairs(human_players) do
		if (not local_player_only or unique_id == local_unique_id) and package_synchronizer_client:peer_enabled(player:peer_id()) then
			player_loadouts[unique_id] = create_loadout(cinematic_name, player)
			slots_taken = slots_taken + 1
			sorted_unique_ids[slots_taken] = unique_id
		end
	end

	if not local_player_only and slots_taken < num_slots then
		local bot_players = player_manager:bot_players()

		for unique_id, player in pairs(bot_players) do
			player_loadouts[unique_id] = create_loadout(cinematic_name, player)
			slots_taken = slots_taken + 1
			sorted_unique_ids[slots_taken] = unique_id

			if num_slots <= slots_taken then
				break
			end
		end
	end

	table.sort(sorted_unique_ids)

	return player_loadouts, sorted_unique_ids
end

CutsceneCharacterSystem._show_player = function (self, unique_id)
	local player_manager = Managers.player
	local player = player_manager:player_from_unique_id(unique_id)

	if player then
		local player_unit = player.player_unit

		if ALIVE[player_unit] then
			local player_visibility_ext = ScriptUnit.extension(player_unit, "player_visibility_system")

			player_visibility_ext:show()
		end
	end
end

CutsceneCharacterSystem._hide_player_unit = function (self, player_unit)
	if Unit.alive(player_unit) then
		local player_visibility_ext = ScriptUnit.has_extension(player_unit, "player_visibility_system")

		if player_visibility_ext then
			player_visibility_ext:hide()
		end
	end
end

CutsceneCharacterSystem._on_assign_player_unit_ownership = function (self, player, player_unit)
	if self._hide_players then
		self:_hide_player_unit(player_unit)
	end
end

CutsceneCharacterSystem._on_player_unit_spawned = function (self, player)
	if self._hide_players then
		self:_hide_player_unit(player.player_unit)
	end
end

CutsceneCharacterSystem._on_unit_registered = function (self, unit)
	if self._hide_players and Managers.player:player_by_unit(unit) then
		self:_hide_player_unit(unit)
	end
end

return CutsceneCharacterSystem
