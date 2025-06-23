-- chunkname: @scripts/utilities/profile_utils.lua

local Archetypes = require("scripts/settings/archetype/archetypes")
local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local BotCharacterProfiles = require("scripts/settings/bot_character_profiles")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local MasterItems = require("scripts/backend/master_items")
local PlayerTalents = require("scripts/utilities/player_talents/player_talents")
local PrologueCharacterProfileOverride = require("scripts/settings/prologue_character_profile_override")
local RaritySettings = require("scripts/settings/item/rarity_settings")
local SaveData = require("scripts/managers/save/save_data")
local TalentLayoutParser = require("scripts/ui/views/talent_builder_view/utilities/talent_layout_parser")
local TestifyCharacterProfiles = not EDITOR and DevParameters.use_testify_profiles and require("scripts/settings/testify_character_profiles")
local UISettings = require("scripts/settings/ui/ui_settings")
local ViewElementProfilePresetsSettings = require("scripts/ui/view_elements/view_element_profile_presets/view_element_profile_presets_settings")
local ProfileUtils = {}

ProfileUtils.character_names = {
	male_names_1 = {
		"Ackor",
		"Barbor",
		"Baudlarn",
		"Brack",
		"Candorick",
		"Claren",
		"Cockerill",
		"Corot",
		"Derlin",
		"Dickot",
		"Doran",
		"Dorfan",
		"Dorsworth",
		"Farridge",
		"Fascal",
		"Foronat",
		"Fusell",
		"Goyan",
		"Harken",
		"Haveloch",
		"Henam",
		"Hugot",
		"Jerican",
		"Keating",
		"Kradd",
		"Lamark",
		"Lukas",
		"Martack",
		"Mikel",
		"Montov",
		"Mussat",
		"Narvast",
		"Nura",
		"Nzoni",
		"Onceda",
		"Rossel",
		"Rudge",
		"Salcan",
		"Saldar",
		"Scottor",
		"Shaygor",
		"Shiller",
		"Skyv",
		"Smither",
		"Tademar",
		"Taur",
		"Tecker",
		"Tuttor",
		"Verbal",
		"Victor",
		"Villan",
		"Xavier",
		"Zapard",
		"Zek"
	},
	female_names_1 = {
		"Erith",
		"Agda",
		"Ambre",
		"Amelia",
		"Avrilia",
		"Axella",
		"Beretille",
		"Blonthe",
		"Clea",
		"Coletta",
		"Constanze",
		"Dalilla",
		"Diana",
		"Doriana",
		"Edithia",
		"Eglantia",
		"Elodine",
		"Ephrael",
		"Felicia",
		"Genevieve",
		"Greyla",
		"Guendolys",
		"Guenhvya",
		"Guenievre",
		"Heinrike",
		"Helene",
		"Helmia",
		"Honorine",
		"Ines",
		"Iris",
		"Isaure",
		"Jacinta",
		"Josea",
		"Justine",
		"Kelvi",
		"Kerstin",
		"Kinnia",
		"Kline",
		"Lassana",
		"Leana",
		"Leatha",
		"Liari",
		"Lorette",
		"Lyta",
		"Maia",
		"Mallava",
		"Marakanthe",
		"Maylin",
		"Mejara",
		"Meliota",
		"Melisande",
		"Mira",
		"Mylene",
		"Nadia",
		"Nalana",
		"Natacha",
		"Ophelia",
		"Prothei",
		"Rosemonde",
		"Rosine",
		"Ruby",
		"Sanei",
		"Sarine",
		"Severa",
		"Silvana",
		"Undine",
		"Unkara",
		"Valleni",
		"Vissia",
		"Waynoka",
		"Yvette",
		"Zelie",
		"Zellith"
	}
}

local function _fill_talents_and_selected_nodes(profile, character, archetype_name)
	local archetype = Archetypes[archetype_name]
	local talents = profile.talents
	local talent_layout_file_path = archetype.talent_layout_file_path
	local active_layout = require(talent_layout_file_path)
	local backend_talents = character.vocation and character.vocation.talents or ""
	local selected_nodes = profile.selected_nodes

	TalentLayoutParser.unpack_backend_data(active_layout, backend_talents, selected_nodes)
	TalentLayoutParser.selected_talents_from_selected_nodes(active_layout, selected_nodes, talents)
	PlayerTalents.add_archetype_base_talents(archetype, talents)
end

local function profile_from_backend_data(backend_profile_data)
	local profile_data = table.clone(backend_profile_data)
	local character = profile_data.character
	local archetype_name = character.archetype
	local specialization = character.career and character.career.specialization or "none"
	local progression = backend_profile_data.progression
	local current_level = progression and progression.currentLevel or 1
	local talent_points = progression and progression.talentPoints or 0
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
		selected_nodes = {},
		talents = {},
		current_level = current_level,
		talent_points = talent_points,
		specialization = specialization,
		name = character.name,
		personal = character.personal,
		companion = character.companion
	}
	local items = profile_data.items
	local loadout_item_data = backend_profile.loadout_item_data

	for slot_name, item_id in pairs(item_ids) do
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

	_fill_talents_and_selected_nodes(backend_profile, character, archetype_name)

	return backend_profile
end

ProfileUtils.pack_backend_profile_data = function (backend_profile_data)
	local profile = profile_from_backend_data(backend_profile_data)
	local profile_json = cjson.encode(profile)

	return profile_json
end

local _combine_item

function _combine_item(slot_name, entry, attachments, visual_items, voice_fx_presets, hide_facial_hair, stabilize_neck, mask_facial_hair, mask_hair, mask_hair_override, mask_face)
	for child_slot_name, child_entry in pairs(entry) do
		if child_slot_name ~= "parent_slot_names" then
			local child_attachments = {}

			_combine_item(child_slot_name, child_entry, child_attachments, visual_items, voice_fx_presets, hide_facial_hair)

			local data = visual_items[child_slot_name]

			attachments[child_slot_name] = {
				item = data.item,
				children = child_attachments
			}

			if data.item.voice_fx_preset then
				voice_fx_presets[#voice_fx_presets + 1] = data.item.voice_fx_preset
			end

			if data.item.hide_eyebrows then
				hide_facial_hair.hide_eyebrows = hide_facial_hair.hide_eyebrows or data.item.hide_eyebrows
			end

			if data.item.hide_beard then
				hide_facial_hair.hide_beard = hide_facial_hair.hide_beard or data.item.hide_beard
			end

			if data.item.stabilize_neck then
				stabilize_neck[1] = stabilize_neck[1] or data.item.stabilize_neck
			end

			if data.item.mask_facial_hair then
				mask_facial_hair[1] = mask_facial_hair[1] or data.item.mask_facial_hair
			end

			if data.item.mask_hair then
				mask_hair[1] = mask_hair[1] or data.item.mask_hair
			end

			if data.item.mask_hair_override then
				mask_hair_override[1] = mask_hair_override[1] or data.item.mask_hair_override
			end

			if data.item.mask_face then
				mask_face[1] = mask_face[1] or data.item.mask_face
			end
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
			local voice_fx_presets = {}
			local hide_facial_hair = {
				hide_beard = false,
				hide_eyebrows = false
			}
			local stabilize_neck = {}
			local mask_facial_hair = {}
			local mask_hair = {}
			local mask_hair_override = {}
			local mask_face = {}

			_combine_item(slot_name, entry, attachments, visual_items, voice_fx_presets, hide_facial_hair, stabilize_neck, mask_facial_hair, mask_hair, mask_hair_override, mask_face)

			local data = visual_items[slot_name]
			local gear = data.gear
			local item_id = data.item_id
			local overrides = gear.masterDataInstance.overrides

			if next(attachments) then
				overrides = overrides or {}
				overrides.attachments = overrides.attachments or {}

				for index, attachment_data in pairs(attachments) do
					overrides.attachments[index] = attachment_data
				end
			end

			if #voice_fx_presets > 0 then
				overrides = overrides or {}
				overrides.voice_fx_preset = voice_fx_presets[1]
			end

			if hide_facial_hair.hide_eyebrows then
				overrides = overrides or {}
				overrides.hide_eyebrows = hide_facial_hair.hide_eyebrows
			end

			if hide_facial_hair.hide_beard then
				overrides = overrides or {}
				overrides.hide_beard = hide_facial_hair.hide_beard
			end

			if stabilize_neck[1] then
				overrides = overrides or {}
				overrides.stabilize_neck = stabilize_neck[1]
			end

			if mask_facial_hair then
				overrides = overrides or {}
				overrides.mask_facial_hair = mask_facial_hair[1]
			end

			if mask_hair then
				overrides = overrides or {}
				overrides.mask_hair = mask_hair[1]
			end

			if mask_hair_override then
				overrides = overrides or {}
				overrides.mask_hair_override = mask_hair_override[1]
			end

			if mask_face then
				overrides = overrides or {}
				overrides.mask_face = mask_face[1]
			end

			gear.masterDataInstance.overrides = overrides

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
					overrides = item_data.overrides and table.clone_instance(item_data.overrides)
				},
				slots = {
					slot_name
				}
			}
			local item = MasterItems.get_item_instance(gear, item_id)

			if item and item.base_unit then
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

local function _validate_talent_items(talents, archetype_name)
	local talent_definitions = ArchetypeTalents[archetype_name]
	local item_definitions = MasterItems.get_cached()

	for talent_name, _ in pairs(talents) do
		local talent_definition = talent_definitions[talent_name]

		if talent_definition then
			local player_ability = talent_definition and talent_definition.player_ability
			local ability = player_ability and player_ability.ability
			local inventory_item_name = ability and ability.inventory_item_name

			if inventory_item_name and not item_definitions[inventory_item_name] then
				talents[talent_name] = nil
			end
		else
			talents[talent_name] = nil
		end
	end
end

local function _convert_profile_from_lookups_to_data(profile)
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

	_validate_talent_items(talents, archetype_name)
end

ProfileUtils.process_backend_body = function (body)
	local items_by_uuid

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

	_convert_profile_from_lookups_to_data(profile)

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

	_convert_profile_from_lookups_to_data(profile)

	return profile
end

ProfileUtils.split_for_network = function (profile_json, chunk_array)
	local max_string_length = 400
	local length = #profile_json
	local num_chunks = math.ceil(length / max_string_length)
	local remaining_json = profile_json

	for i = 1, num_chunks do
		local remaining_length = #remaining_json
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
	local profile = table.shallow_copy(bot_profile)

	_convert_profile_from_lookups_to_data(profile)

	return profile
end

ProfileUtils.replace_profile_for_prologue = function (profile)
	local item_definitions = MasterItems.get_cached()
	local override_profiles = PrologueCharacterProfileOverride(item_definitions)
	local archetype = profile.archetype
	local override_table = override_profiles[archetype.name]

	if not override_table then
		return profile
	end

	local new_profile = table.clone_instance(profile)
	local loadout_item_ids = new_profile.loadout_item_ids
	local loadout_item_data = new_profile.loadout_item_data
	local override_loadout = override_table.loadout

	for slot_name, item_data in pairs(override_loadout) do
		new_profile.loadout[slot_name] = item_data
		new_profile.visual_loadout[slot_name] = item_data

		local item_name = item_data.name

		loadout_item_ids[slot_name] = item_name .. slot_name
		loadout_item_data[slot_name] = {
			id = item_name
		}
	end

	return new_profile
end

ProfileUtils.replace_profile_for_training_grounds = function (profile)
	return ProfileUtils.replace_profile_for_prologue(profile)
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
	local talent_points = progression and progression.talentPoints or 0
	local item_ids = character.inventory
	local profile = {
		character_id = character.id,
		archetype = archetype,
		specialization = specialization,
		current_level = current_level,
		talent_points = talent_points,
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
		selected_nodes = {},
		talents = {},
		name = character.name,
		personal = character.personal
	}

	if character.companion then
		profile.companion = character.companion
	end

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

	_fill_talents_and_selected_nodes(profile, character, archetype_name)

	local profile_talents = profile.talents

	_validate_talent_items(profile_talents, archetype_name)

	return profile
end

ProfileUtils.character_name = function (profile)
	return profile.name or "<profile_character_name>"
end

ProfileUtils.character_companion_name = function (profile)
	return profile.companion and profile.companion.name or "<profile_companion_name>"
end

ProfileUtils.generate_random_name = function (profile)
	local name_list = ProfileUtils.character_names[profile.name_list_id]
	local name = name_list and name_list[math.random(1, #name_list)] or "???"

	return name
end

ProfileUtils.character_archetype_title = function (profile, exclude_symbol)
	if not profile or table.is_empty(profile) then
		Log.error("ProfileUtils", "Empty argument profile in function character_archetype_title")

		return "???"
	end

	local archetype = profile.archetype
	local text

	if UISettings.archetype_font_icon[archetype.name] and not exclude_symbol then
		text = string.format("%s %s", UISettings.archetype_font_icon[archetype.name], Localize(archetype.archetype_name))
	else
		text = Localize(archetype.archetype_name)
	end

	return text
end

ProfileUtils.title_item_name_no_color = function (title_item, profile)
	local title_text = ""

	if profile then
		local gender = profile.gender

		if gender == "male" then
			title_text = title_item.title_male
		elseif gender == "female" then
			title_text = title_item.title_female
		end
	end

	if not title_text or title_text == "" then
		title_text = title_item.title_default or title_item.display_name
	end

	if title_text == "" then
		return title_text
	end

	title_text = Localize(title_text)

	return title_text
end

ProfileUtils.character_title_no_color = function (profile)
	local text = ""
	local loadout = profile.loadout

	if loadout then
		local title_item = loadout.slot_character_title

		if title_item then
			local gender = profile.gender
			local title_text = ""

			if gender == "male" then
				title_text = title_item.title_male
			elseif gender == "female" then
				title_text = title_item.title_female
			end

			title_text = title_text or title_item.title_default or title_item.display_name

			if title_text == "" then
				return title_text
			end

			title_text = Localize(title_text)

			return title_text
		end
	end

	return text
end

ProfileUtils.character_title = function (profile)
	local text = ""
	local loadout = profile.loadout

	if loadout then
		local title_item = loadout.slot_character_title

		if title_item then
			local save_manager = Managers.save
			local color_type = "no_colors"

			if save_manager then
				local save_data = save_manager:account_data()
				local interface_settings = save_data.interface_settings
				local game_mode_name = Managers.state.game_mode and Managers.state.game_mode:game_mode_name()
				local is_in_hub = not game_mode_name or game_mode_name == "hub"

				if is_in_hub then
					color_type = interface_settings.character_titles_color_type
				else
					color_type = interface_settings.character_titles_in_mission_color_type
				end
			end

			if color_type == "rarity_colors" then
				local rarity = title_item.rarity

				if rarity and rarity > 0 then
					local rarity_color = RaritySettings[rarity].color_desaturated

					if rarity_color then
						local color_string = "{#color(" .. rarity_color[2] .. "," .. rarity_color[3] .. "," .. rarity_color[4] .. ")}"

						text = color_string
					end
				end
			end

			local gender = profile.gender
			local title_text = ""

			if gender == "male" then
				title_text = title_item.title_male
			elseif gender == "female" then
				title_text = title_item.title_female
			end

			if not title_item then
				title_text = title_item.title_default or title_item.display_name
			end

			if title_text == "" then
				return title_text
			end

			title_text = Localize(title_text)
			text = text .. title_text
		end
	end

	return text
end

local function _character_save_data()
	local local_player_id = 1
	local player_manager = Managers.player
	local player = player_manager and player_manager:local_player(local_player_id)
	local character_id = player and player:character_id()
	local save_manager = Managers.save
	local character_data = character_id and save_manager and save_manager:character_data(character_id)

	return character_data
end

ProfileUtils.save_active_profile_preset_id = function (profile_preset_id)
	local character_data = _character_save_data()

	if not character_data then
		return
	end

	character_data.active_profile_preset_id = profile_preset_id

	Managers.save:queue_save()
end

ProfileUtils.get_available_profile_preset_id = function ()
	return math.uuid()
end

ProfileUtils.add_profile_preset = function ()
	local profile_presets = ProfileUtils.get_profile_presets()
	local num_profile_presets = #profile_presets
	local optional_preset_icon_reference_keys = ViewElementProfilePresetsSettings.optional_preset_icon_reference_keys
	local icon_index = math.index_wrapper(num_profile_presets + 1, #optional_preset_icon_reference_keys)
	local icon_key = optional_preset_icon_reference_keys[icon_index]
	local profile_preset_id = ProfileUtils.get_available_profile_preset_id()

	profile_presets[num_profile_presets + 1] = {
		loadout = {},
		talents = {},
		custom_icon_key = icon_key,
		id = profile_preset_id
	}

	Managers.save:queue_save()

	return profile_preset_id, profile_presets[profile_preset_id]
end

ProfileUtils.remove_profile_preset = function (profile_preset_id)
	local profile_preset = profile_preset_id and ProfileUtils.get_profile_preset(profile_preset_id)

	if not profile_preset then
		return
	end

	local profile_presets = ProfileUtils.get_profile_presets()

	for i = 1, #profile_presets do
		if profile_presets[i].id == profile_preset_id then
			table.remove(profile_presets, i)

			if profile_preset_id == ProfileUtils.get_active_profile_preset_id() then
				ProfileUtils.save_active_profile_preset_id(nil)
			end

			break
		end
	end

	Managers.save:queue_save()
end

ProfileUtils.get_active_profile_preset_id = function ()
	local character_data = _character_save_data()

	if not character_data then
		return
	end

	return character_data.active_profile_preset_id
end

ProfileUtils.save_item_id_for_profile_preset = function (profile_preset_id, slot_id, item_gear_id)
	local character_data = _character_save_data()

	if not character_data then
		return
	end

	if not character_data.profile_presets then
		character_data.profile_presets = table.clone_instance(SaveData.default_character_data.profile_presets)
	end

	local profile_presets = character_data.profile_presets
	local profile_preset = ProfileUtils.get_profile_preset(profile_preset_id)

	if not profile_preset then
		profile_presets[#profile_presets + 1] = {}
	end

	profile_preset = ProfileUtils.get_profile_preset(profile_preset_id)

	if not profile_preset.loadout then
		profile_preset.loadout = {}
	end

	local loadout = profile_preset.loadout

	loadout[slot_id] = item_gear_id

	Managers.save:queue_save()
end

ProfileUtils.save_talent_id_for_profile_preset = function (profile_preset_id, talent_name, activated)
	local character_data = _character_save_data()

	if not character_data then
		return
	end

	if not character_data.profile_presets then
		character_data.profile_presets = table.clone_instance(SaveData.default_character_data.profile_presets)
	end

	local profile_presets = character_data.profile_presets
	local profile_preset = ProfileUtils.get_profile_preset(profile_preset_id)

	if not profile_preset then
		profile_presets[#profile_presets + 1] = {}
	end

	profile_preset = ProfileUtils.get_profile_preset(profile_preset_id)

	if not profile_preset.talents then
		profile_preset.talents = {}
	end

	Managers.save:queue_save()
end

ProfileUtils.save_talent_nodes_for_profile_preset = function (profile_preset_id, talent_nodes, talents_version)
	local character_data = _character_save_data()

	if not character_data then
		return
	end

	if not character_data.profile_presets then
		character_data.profile_presets = table.clone_instance(SaveData.default_character_data.profile_presets)

		return
	end

	local profile_preset = ProfileUtils.get_profile_preset(profile_preset_id)

	if not profile_preset then
		return
	end

	if not profile_preset.talents then
		profile_preset.talents = {}
	elseif profile_preset.talents ~= talent_nodes then
		table.clear(profile_preset.talents)
	end

	Log.info("ProfileUtils", "Saving talent changes for profile preset: %s. Currently running preset version: %s", tostring(profile_preset_id), tostring(character_data.profile_presets and character_data.profile_presets.profile_presets_version))

	local talents = profile_preset.talents

	for talent_node_name, points_spent in pairs(talent_nodes) do
		talents[talent_node_name] = points_spent and points_spent > 0 and points_spent or nil
	end

	profile_preset.talents_version = talents_version

	Managers.save:queue_save()
end

ProfileUtils.save_talent_node_for_profile_preset = function (profile_preset_id, talent_node_name, points_spent)
	local character_data = _character_save_data()

	if not character_data then
		return
	end

	if points_spent and type(points_spent) ~= "number" then
		return
	end

	if not character_data.profile_presets then
		character_data.profile_presets = table.clone_instance(SaveData.default_character_data.profile_presets)

		return
	end

	local profile_preset = ProfileUtils.get_profile_preset(profile_preset_id)

	if not profile_preset then
		return
	end

	if not profile_preset.talents then
		profile_preset.talents = {}
	end

	local talents = profile_preset.talents

	talents[talent_node_name] = points_spent and points_spent > 0 and points_spent or nil

	Managers.save:queue_save()
end

ProfileUtils.clear_all_talent_nodes_for_profile_preset = function (profile_preset_id)
	local character_data = _character_save_data()

	if not character_data then
		return
	end

	if not character_data.profile_presets then
		character_data.profile_presets = table.clone_instance(SaveData.default_character_data.profile_presets)
	end

	local profile_presets = character_data.profile_presets
	local profile_preset = ProfileUtils.get_profile_preset(profile_preset_id)

	if not profile_preset then
		profile_presets[#profile_presets + 1] = {}
	end

	profile_preset = ProfileUtils.get_profile_preset(profile_preset_id)

	if not profile_preset.talents then
		profile_preset.talents = {}
	else
		table.clear(profile_preset.talents)
	end

	Managers.save:queue_save()
end

ProfileUtils.get_profile_preset = function (profile_preset_id)
	local character_data = _character_save_data()

	if not character_data then
		return
	end

	local profile_presets = character_data.profile_presets

	if not profile_presets then
		return
	end

	local profile_preset

	for i = 1, #profile_presets do
		local preset = profile_presets[i]

		if preset.id == profile_preset_id then
			profile_preset = preset

			break
		end
	end

	return profile_preset
end

ProfileUtils.get_profile_presets = function ()
	local character_data = _character_save_data()

	if not character_data then
		return
	end

	local profile_presets = character_data.profile_presets

	if not profile_presets then
		profile_presets = table.clone_instance(SaveData.default_character_data.profile_presets)
		character_data.profile_presets = profile_presets

		Managers.save:queue_save()
	end

	return profile_presets
end

ProfileUtils.verify_saved_profile_presets_talents_version = function (character_id, archetype_name)
	local archetype = Archetypes[archetype_name]
	local talent_layout_file_path = archetype.talent_layout_file_path
	local talent_layout = require(talent_layout_file_path)
	local talent_layout_version = talent_layout.version
	local save_manager = Managers.save
	local character_data = character_id and save_manager and save_manager:character_data(character_id)

	if not character_data then
		return
	end

	local profile_presets = character_data.profile_presets

	if profile_presets then
		for i = 1, #profile_presets do
			local preset = profile_presets[i]

			if preset.talents_version and preset.talents_version ~= talent_layout_version then
				-- Nothing
			end
		end
	end

	return profile_presets
end

ProfileUtils.generate_visual_loadout = function (loadout)
	local ui_loadout = {}

	for slot_name, item in pairs(loadout) do
		local visual_item = ProfileUtils.generate_visual_item(item)

		if visual_item then
			ui_loadout[slot_name] = visual_item
		end
	end

	return _generate_visual_loadout(ui_loadout)
end

ProfileUtils.generate_visual_item = function (item)
	local visual_item

	if not item.is_ui_item_preview then
		visual_item = item and item.name and MasterItems.get_ui_item_instance(item)
	else
		visual_item = item
	end

	if visual_item and visual_item.base_unit then
		return {
			item = visual_item,
			gear = visual_item.gear,
			item_id = visual_item.gear_id
		}
	end
end

ProfileUtils.has_companion = function (profile)
	local equiped_talents = profile.talents
	local archetype = profile.archetype
	local archetype_talents = archetype.talents

	if not archetype.companion_breed then
		return false
	end

	if equiped_talents then
		for archetype_name, _ in pairs(equiped_talents) do
			local talent_data = archetype_talents[archetype_name]

			if talent_data and talent_data.special_rule and talent_data.special_rule.special_rule_name == "disable_companion" then
				return false
			end
		end
	end

	return true, archetype.companion_breed
end

return ProfileUtils
