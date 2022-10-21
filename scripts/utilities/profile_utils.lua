local Archetypes = require("scripts/settings/archetype/archetypes")
local BotCharacterProfiles = require("scripts/settings/bot_character_profiles")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local MasterItems = require("scripts/backend/master_items")
local PlayerSpecialization = require("scripts/utilities/player_specialization/player_specialization")
local PrologueCharacterProfileOverride = require("scripts/settings/prologue_character_profile_override")
local ProfileUtils = {}

local function profile_from_backend_data(backend_profile_data)
	local profile_data = table.clone(backend_profile_data)
	local character = profile_data.character
	local archetype_name = character.archetype
	local specialization = character.career and character.career.specialization or "none"
	local progression = backend_profile_data.progression
	local current_level = progression and progression.currentLevel or 1
	local item_ids = character.inventory
	local backend_profile = {
		character_id = character.id,
		archetype = archetype_name,
		gender = character.gender,
		selected_voice = character.selected_voice,
		skin_color = character.skin_color,
		hair_color = character.hair_color,
		eye_color = character.eye_color,
		loadout_item_ids = item_ids,
		loadout_item_data = {},
		lore = character.lore,
		talents = {},
		current_level = current_level,
		specialization = specialization,
		name = character.name,
		personal = character.personal
	}
	local items = profile_data.items
	local loadout_item_data = backend_profile.loadout_item_data

	for slot_name, item_id in pairs(item_ids) do
		if not items or not items[item_id] then
			print("-- items --")
			table.dump(items)
			print("-- item_ids --")
			table.dump(item_ids)
			print("-- missing item --")
			print(item_id)
		end

		if not items[item_id] then
			Log.error("ProfileUtil", "Equipped item %s was not present in the backend inventory", item_id)

			local master_id = MasterItems.find_fallback_item_id(slot_name)
			loadout_item_data[slot_name] = {
				id = master_id
			}
		else
			local data = items[item_id].masterDataInstance
			loadout_item_data[slot_name] = {
				id = data.id
			}
			local overrides = data.overrides

			if overrides then
				loadout_item_data[slot_name].overrides = overrides
			end
		end
	end

	local character_talents = character.career and character.career.talents
	local profile_talents = backend_profile.talents

	if character_talents then
		for i = 1, #character_talents do
			local talent_name = character_talents[i]
			profile_talents[#profile_talents + 1] = talent_name
		end
	end

	return backend_profile
end

ProfileUtils.pack_backend_profile_data = function (backend_profile_data)
	local profile = profile_from_backend_data(backend_profile_data)
	local profile_json = cjson.encode(profile)

	return profile_json
end

local _combine_item = nil

function _combine_item(slot_name, entry, attachments, visual_items)
	for child_slot_name, child_entry in pairs(entry) do
		if child_slot_name ~= "parent_slot_names" then
			local child_attachments = {}

			_combine_item(child_slot_name, child_entry, child_attachments, visual_items)

			local data = visual_items[child_slot_name]
			attachments[child_slot_name] = {
				item = data.item,
				children = child_attachments
			}
		end
	end
end

local function _generate_visual_loadout(visual_items)
	local structure = {}
	local visual_loadout = {}

	for slot_name, data in pairs(visual_items) do
		local entry = {}
		local parent_slot_names = data.item.parent_slot_names

		if parent_slot_names and next(parent_slot_names) then
			entry.parent_slot_names = parent_slot_names
		end

		structure[slot_name] = entry
	end

	for _, data in pairs(visual_items) do
		local hidden_slots = data.item.hide_slots

		if hidden_slots then
			for i = 1, #hidden_slots do
				local hidden_slot_name = hidden_slots[i]
				structure[hidden_slot_name] = nil
			end
		end
	end

	for slot_name, entry in pairs(structure) do
		local parent_slot_names = entry.parent_slot_names

		if parent_slot_names then
			for i = 1, #parent_slot_names do
				local parent_slot_name = parent_slot_names[i]
				local parent = structure[parent_slot_name]

				if parent then
					parent[slot_name] = entry
				end
			end
		end
	end

	for slot_name, entry in pairs(structure) do
		local parent_slot_names = entry.parent_slot_names

		if not parent_slot_names then
			local attachments = {}

			_combine_item(slot_name, entry, attachments, visual_items)

			local data = visual_items[slot_name]
			local gear = data.gear
			local item_id = data.item_id

			if next(attachments) then
				local overrides = gear.masterDataInstance.overrides or {}
				overrides.attachments = overrides.attachments or {}

				for index, attachment_data in pairs(attachments) do
					overrides.attachments[index] = attachment_data
				end

				gear.masterDataInstance.overrides = overrides
			end

			local item = MasterItems.get_item_instance(gear, item_id)
			visual_loadout[slot_name] = item
		end
	end

	return visual_loadout
end

local function _generate_loadout_from_data(loadout_item_ids, loadout_item_data)
	local loadout = {}

	for slot_name, item_id in pairs(loadout_item_ids) do
		local item_data = loadout_item_data[slot_name]

		if item_data then
			local gear = {
				masterDataInstance = {
					id = item_data.id,
					overrides = item_data.overrides
				},
				slots = {
					slot_name
				}
			}
			local item = MasterItems.get_item_instance(gear, item_id)
			loadout[slot_name] = item
		end
	end

	return loadout
end

local function _generate_visual_loadout_from_data(loadout_item_ids, loadout_item_data)
	local visual_items = {}

	for slot_name, item_id in pairs(loadout_item_ids) do
		local item_data = loadout_item_data[slot_name]

		if item_data then
			local gear = {
				masterDataInstance = {
					id = item_data.id,
					overrides = item_data.overrides
				},
				slots = {
					slot_name
				}
			}
			local gear_clone = table.clone(gear)
			local item = MasterItems.get_item_instance(gear_clone, item_id)

			if item.base_unit then
				visual_items[slot_name] = {
					item = item,
					gear = gear,
					item_id = item_id
				}
			end
		end
	end

	local visual_loadout = _generate_visual_loadout(visual_items)

	return visual_loadout
end

local function convert_profile_from_lookups_to_data(profile)
	local archetype_name = profile.archetype
	local archetype = Archetypes[archetype_name]
	profile.archetype = archetype
	local loadout_item_ids = profile.loadout_item_ids
	local loadout_item_data = profile.loadout_item_data
	local loadout = _generate_loadout_from_data(loadout_item_ids, loadout_item_data)
	profile.loadout = loadout
	local visual_loadout = _generate_visual_loadout_from_data(loadout_item_ids, loadout_item_data)
	profile.visual_loadout = visual_loadout
	local talents = profile.talents
	local num_talents = #talents

	for i = num_talents, 1, -1 do
		local talent_name = talents[i]
		talents[talent_name] = true
		talents[i] = nil
	end

	PlayerSpecialization.add_nonselected_talents(archetype, profile.specialization, profile.current_level, talents)
end

ProfileUtils.process_backend_body = function (body)
	local items_by_uuid = nil

	if body._embedded.items then
		local items = body._embedded.items
		items_by_uuid = {}

		for _, item_data in pairs(items) do
			local uuid = item_data.uuid
			items_by_uuid[uuid] = item_data
		end
	end

	return {
		character = body.character,
		items = items_by_uuid,
		progression = body._embedded.progression
	}
end

ProfileUtils.backend_profile_data_to_profile = function (backend_profile_data)
	local profile = profile_from_backend_data(backend_profile_data)

	convert_profile_from_lookups_to_data(profile)

	return profile
end

ProfileUtils.pack_profile = function (profile)
	local profile_with_lookups = table.clone_instance(profile)
	local archetype = profile_with_lookups.archetype
	profile_with_lookups.archetype = archetype.name
	profile_with_lookups.loadout = nil
	profile_with_lookups.visual_loadout = nil
	local profile_json = cjson.encode(profile_with_lookups)

	return profile_json
end

ProfileUtils.unpack_profile = function (profile_json)
	local profile = cjson.decode(profile_json)

	convert_profile_from_lookups_to_data(profile)

	return profile
end

ProfileUtils.split_for_network = function (profile_json, chunk_array)
	local max_string_length = 400
	local length = string.len(profile_json)
	local num_chunks = math.ceil(length / max_string_length)
	local remaining_json = profile_json

	for i = 1, num_chunks do
		local remaining_length = string.len(remaining_json)
		local chunk_length = math.min(max_string_length, remaining_length)
		local chunk = string.sub(remaining_json, 1, chunk_length)
		chunk_array[i] = chunk
		remaining_json = string.sub(remaining_json, chunk_length + 1, remaining_length)
	end
end

ProfileUtils.combine_network_chunks = function (chunk_array)
	local profile_json = ""

	for i = 1, #chunk_array do
		local profile_chunk = chunk_array[i]
		profile_json = profile_json .. profile_chunk
	end

	return profile_json
end

ProfileUtils.get_bot_profile = function (identifier)
	local item_definitions = MasterItems.get_cached()
	local bot_profiles = BotCharacterProfiles(item_definitions)
	local bot_profile = bot_profiles[identifier]

	fassert(bot_profiles, "Trying to get nonexistent bot profile, identifier: %s", identifier)

	local profile = table.shallow_copy(bot_profile)

	convert_profile_from_lookups_to_data(profile)

	return profile
end

ProfileUtils.replace_profile_for_prologue = function (profile)
	local item_definitions = MasterItems.get_cached()
	local override_profiles = PrologueCharacterProfileOverride(item_definitions)
	local archetype = profile.archetype
	local override_table = override_profiles[archetype]

	if not override_table then
		return profile
	end

	local new_profile = table.shallow_copy(profile)
	new_profile.loadout = table.shallow_copy(profile.loadout)
	local override_loadout = override_table.loadout

	for key, value in pairs(override_loadout) do
		new_profile.loadout[key] = value
		new_profile.visual_loadout[key] = value
	end

	return new_profile
end

ProfileUtils._override_table = function (new, override)
	for key, value in pairs(override) do
		if type(value) == "table" then
			ProfileUtils._override_table(new[key], value)
		else
			new[key] = override[key]
		end
	end
end

ProfileUtils.character_to_profile = function (character, gear_list, progression)
	local archetype_name = character.archetype
	local archetype = Archetypes[archetype_name]
	local specialization = character.career and character.career.specialization or "none"
	local current_level = progression and progression.currentLevel or 1
	local item_ids = character.inventory
	local profile = {
		character_id = character.id,
		archetype = archetype,
		specialization = specialization,
		current_level = current_level,
		gender = character.gender,
		selected_voice = character.selected_voice,
		skin_color = character.skin_color,
		hair_color = character.hair_color,
		eye_color = character.eye_color,
		loadout = {},
		visual_loadout = {},
		loadout_item_ids = item_ids,
		loadout_item_data = {},
		lore = character.lore,
		talents = {},
		name = character.name,
		personal = character.personal
	}

	for slot, gear_id in pairs(item_ids) do
		if ItemSlotSettings[slot] then
			local gear = gear_list[gear_id]
			local player_item = MasterItems.get_item_instance(gear, gear_id)

			if player_item then
				profile.loadout[slot] = player_item
				profile.loadout_item_ids[slot] = gear_id
				local data = gear.masterDataInstance
				profile.loadout_item_data[slot] = {
					id = data.id
				}
				local overrides = data.overrides

				if overrides then
					profile.loadout_item_data[slot].overrides = overrides
				end
			end
		else
			Log.error("ProfileUtil", string.format("Unknown gear slot %s(%s)", slot, gear_id))
		end
	end

	local visual_loadout = _generate_visual_loadout_from_data(profile.loadout_item_ids, profile.loadout_item_data)
	profile.visual_loadout = visual_loadout
	local character_talents = character.career and character.career.talents
	local profile_talents = profile.talents

	if character_talents then
		for i = 1, #character_talents do
			local talent_name = character_talents[i]
			profile_talents[talent_name] = true
		end
	end

	PlayerSpecialization.add_nonselected_talents(archetype, specialization, current_level, profile_talents)

	return profile
end

ProfileUtils.character_name = function (profile)
	return profile.name or "<profile_character_name>"
end

ProfileUtils.character_title = function (profile)
	local specialization_key = profile.specialization
	local archetype = profile.archetype
	local archetype_name = Localize(archetype.archetype_name)

	if specialization_key and specialization_key ~= "none" then
		local specializations = archetype.specializations
		local specialization = specializations[specialization_key]
		local title = specialization.title
		local specialization_name = title and Localize(title) or ""

		return archetype_name .. " " .. specialization_name
	else
		return archetype_name
	end
end

return ProfileUtils
