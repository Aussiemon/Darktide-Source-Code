-- chunkname: @scripts/utilities/character_create.lua

local Archetypes = require("scripts/settings/archetype/archetypes")
local ArchetypeSettings = require("scripts/settings/archetype/archetype_settings")
local Breeds = require("scripts/settings/breed/breeds")
local Childhood = require("scripts/settings/character/childhood")
local Crimes = require("scripts/settings/character/crimes")
local FormativeEvent = require("scripts/settings/character/formative_event")
local GrowingUp = require("scripts/settings/character/growing_up")
local HomePlanets = require("scripts/settings/character/home_planets")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Personalities = require("scripts/settings/character/personalities")
local PlayerCharacterCreatorPresets = require("scripts/settings/player_character/player_character_creator_presets")
local ProfileUtils = require("scripts/utilities/profile_utils")
local CrimesCompabilityMap = require("scripts/settings/character/crimes_compability_mapping")
local CharacterCreate = class("CharacterCreate")
local fallback_slots_to_strip = {
	"slot_body_face",
	"slot_body_face_tattoo",
	"slot_body_face_scar",
	"slot_body_face_hair",
	"slot_body_hair",
	"slot_body_tattoo"
}
local can_use_empty_item = {
	"slot_companion_body_skin_color",
	"slot_companion_body_fur_color",
	"slot_companion_body_coat_pattern",
	"slot_companion_gear_full",
	"slot_gear_material_override_decal",
	"slot_gear_extra_cosmetic",
	"slot_gear_head",
	"slot_gear_lowerbody",
	"slot_gear_upperbody"
}
local default_companion_items = {
	slot_companion_body_coat_pattern = "content/items/characters/companion/companion_dog/body_coat_patterns/dog_coat_spots_01",
	slot_companion_body_skin_color = "content/items/characters/companion/companion_dog/body_skin_colors/dog_skin_color_tan_01",
	slot_companion_gear_full = "content/items/characters/companion/companion_dog/gear_full/companion_dog_set_03_var_01",
	slot_companion_body_fur_color = "content/items/characters/companion/companion_dog/body_fur_colors/dog_fur_color_black_01"
}

if BUILD == "release" then
	fallback_slots_to_strip = {
		"slot_body_face"
	}
end

CharacterCreate.init = function (self, item_definitions, owned_gear, optional_real_profile)
	self._stored_companion_items = {}
	self._archetype_random_names = {}
	self._companion_random_names = {}
	self._profile_value_versions = {
		loadout = {}
	}
	self._visible = false

	self:_setup_default_values()

	self._item_definitions = item_definitions

	local verified_items = self:_verify_items(item_definitions, owned_gear)
	local item_categories = self:_setup_item_categories(verified_items)

	self._item_categories = item_categories

	local appearance_presets = self:_setup_appearance_presets(verified_items)

	self._appearance_presets = appearance_presets

	if optional_real_profile then
		local archetype = optional_real_profile.archetype
		local specialization = optional_real_profile.specialization
		local backstory = table.clone(optional_real_profile.lore.backstory)

		backstory.crime = CrimesCompabilityMap[backstory.crime] or backstory.crime

		local selected_voice = optional_real_profile.selected_voice
		local gender = optional_real_profile.gender
		local breed = optional_real_profile.archetype.breed

		self._profile = {
			name = "",
			loadout = {},
			selected_voice = selected_voice,
			lore = {
				backstory = backstory
			},
			archetype = archetype,
			specialization = specialization,
			gender = gender,
			breed = breed
		}

		local breed_height_range = self:get_height_values_range()
		local min_height, max_height = breed_height_range.min, breed_height_range.max
		local default_height = math.lerp(min_height, max_height, 0.5)
		local height = optional_real_profile.personal and optional_real_profile.personal.character_height or default_height

		self._character_height = height

		local companion_name = optional_real_profile.companion and optional_real_profile.companion.name

		if companion_name or archetype.name == "adamant" then
			self._profile.companion = {
				name = companion_name or ""
			}
		end

		local loadout = optional_real_profile.loadout

		if loadout then
			self._saved_gender_loadout = {}

			local breed_table = {}

			breed_table[gender] = {}
			self._saved_gender_loadout[breed] = breed_table

			for slot_name, slot_settings in pairs(ItemSlotSettings) do
				local show_in_character_create = slot_settings.show_in_character_create

				if show_in_character_create then
					if slot_settings.slot_type == "gear" and not default_companion_items[slot_name] then
						self:set_item_per_slot(slot_name, nil)
					else
						local item = loadout[slot_name]

						self:set_item_per_slot(slot_name, item)

						self._saved_gender_loadout[breed][gender][slot_name] = item
					end
				end
			end

			self._real_profile_gear = {
				slot_gear_upperbody = loadout.slot_gear_upperbody,
				slot_gear_lowerbody = loadout.slot_gear_lowerbody
			}

			local crime_items_promise = self:_fetch_crime_items()

			crime_items_promise:next(function (crime_items)
				self._old_crime_items = self:_get_current_crime_items_ids(crime_items)
				self._all_crime_items = crime_items
			end)
		end
	else
		self._profile = {
			selected_voice = "ogryn_a",
			name = "",
			loadout = {},
			abilities = {
				support_ability = "grenade",
				combat_ability = "dash"
			},
			lore = {
				backstory = {}
			}
		}
		self._character_height = 1

		local randomized_archetype = self:_randomize_archetype()

		self:set_archetype(randomized_archetype)
		self:_randomize_lore_properties()
	end
end

CharacterCreate.is_option_visible = function (self, option)
	local is_item = not not option.value and type(option.value) == "table" and (not not option.value.gear_id or not not option.value.always_owned)
	local start_data_table_path

	if is_item then
		start_data_table_path = option
	else
		start_data_table_path = option.visibility
	end

	if start_data_table_path then
		local profile = self._profile
		local archetype = profile.archetype.name
		local gender = profile.gender
		local breed = profile.archetype.breed
		local planet = self:planet()
		local validation_tables = {
			{
				value = breed,
				validations = start_data_table_path.breeds
			},
			{
				value = gender,
				validations = start_data_table_path.genders
			},
			{
				value = archetype,
				validations = start_data_table_path.archetypes
			},
			{
				value = planet and planet.id,
				validations = start_data_table_path.home_planets
			}
		}

		for i = 1, #validation_tables do
			local validation_table = validation_tables[i]
			local validations = validation_table.validations
			local value = validation_table.value

			if value and validations and type(validations) == "table" and not table.is_empty(validations) and not table.array_contains(validations, value) then
				return false
			end
		end
	end

	return true
end

CharacterCreate.is_option_available = function (self, option)
	local is_item = not not option.value and type(option.value) == "table" and (not not option.value.gear_id or option.value.always_owned ~= nil)
	local start_data_table_path, home_planet_data_table, childhood_data_table, growing_up_data_table, formative_event_data_table

	if is_item then
		start_data_table_path = option.value
	else
		start_data_table_path = option.restrictions
	end

	local available = true

	if start_data_table_path then
		local planet = self:planet()
		local childhood = self:childhood()
		local growing_up = self:growing_up()
		local formative_event = self:formative_event()
		local validation_tables = {
			{
				reason = "home_planet",
				value = planet,
				validations = start_data_table_path.home_planets,
				options_data = self._home_planets_array
			},
			{
				reason = "childhood",
				value = childhood,
				validations = start_data_table_path.childhood,
				options_data = self._childhood_array
			},
			{
				reason = "growing_up",
				value = growing_up,
				validations = start_data_table_path.growing_up,
				options_data = self._growing_up_array
			},
			{
				reason = "formative_event",
				value = formative_event,
				validations = start_data_table_path.formative_event,
				options_data = self._formative_event_array
			}
		}
		local reason, reason_display_name

		for i = 1, #validation_tables do
			local validation_table = validation_tables[i]
			local validations = validation_table.validations
			local value = validation_table.value

			if value and value.id and validations and type(validations) == "table" and not table.is_empty(validations) then
				local result = table.find(validations, value.id)
				local restriction_id = validations[1]
				local restriction_data = validation_table.options_data[restriction_id]

				if not result then
					available = false

					local restriction_display_name = restriction_data and restriction_data.display_name

					return available, validation_table.reason, restriction_display_name
				elseif not reason then
					reason = validation_table.reason
					reason_display_name = restriction_data and restriction_data.display_name
				end
			end
		end

		return available, reason, reason_display_name
	end

	return available
end

CharacterCreate._filter_options_by_visibility = function (self, options)
	local filter_options = {}

	for id, option in pairs(options) do
		local visible = self:is_option_visible(option)

		if visible then
			filter_options[id] = option
		end
	end

	return filter_options
end

CharacterCreate._filter_options_by_restrictions = function (self, options)
	local filter_options = {}

	for id, option in pairs(options) do
		local available = self:is_option_available(option)

		if available then
			filter_options[id] = option
		end
	end

	return filter_options
end

CharacterCreate._reset_loadout = function (self)
	for slot, item in pairs(self._profile.loadout) do
		if self._profile.archetype.name ~= "adamant" or not default_companion_items[slot] then
			self._profile.loadout[slot] = nil
		end
	end
end

CharacterCreate.reset_backstory = function (self)
	self._profile.lore.backstory = {}

	self:_randomize_lore_properties()
	self:_randomize_backstory_properties()
end

CharacterCreate._randomize_lore_properties = function (self)
	local planet_option = self:_randomize_planet()

	self:set_planet(planet_option)

	local crime_option = self:_randomize_crime()

	self:set_crime(crime_option)

	local personality_option = self:_randomize_personality()

	self:set_personality(personality_option)
end

CharacterCreate._randomize_backstory_properties = function (self)
	local formative_event_option = self:_randomize_formative_event()

	self:set_formative_event(formative_event_option)

	local growing_up_option = self:_randomize_growing_up()

	self:set_growing_up(growing_up_option)

	local childhood_option = self:_randomize_childhood()

	self:set_childhood(childhood_option)
end

CharacterCreate.randomize_backstory_properties = function (self)
	self:_randomize_backstory_properties()
end

CharacterCreate._randomize_archetype_properties = function (self)
	local randomized_gender = self:_randomize_gender()

	self:set_gender(randomized_gender)
end

CharacterCreate.profile = function (self)
	return self._profile
end

CharacterCreate._setup_default_values = function (self)
	local archetypes_array = {}
	local archetype_names_array = ArchetypeSettings.archetype_names_array

	for archetype_name, archetype in pairs(Archetypes) do
		archetypes_array[#archetypes_array + 1] = archetype
	end

	table.sort(archetypes_array, function (a, b)
		return a.ui_selection_order < b.ui_selection_order
	end)

	self._archetypes_array = archetypes_array
	self._archetype_names_array = archetype_names_array
	self._breeds_array = {
		"human",
		"ogryn"
	}
	self._genders_array = {
		"female",
		"male"
	}
	self._home_planets_array = table.clone(HomePlanets)
	self._childhood_array = table.clone(Childhood)
	self._growing_up_array = table.clone(GrowingUp)
	self._formative_event_array = table.clone(FormativeEvent)
	self._personalities_array = table.clone(Personalities)
	self._crimes_array = table.clone(Crimes)

	local inventory_slots_array = {}

	for slot_name, slot_info in pairs(ItemSlotSettings) do
		local show_in_character_create = slot_info.show_in_character_create

		if show_in_character_create then
			inventory_slots_array[#inventory_slots_array + 1] = slot_name
		end
	end

	self._inventory_slots_array = inventory_slots_array
end

CharacterCreate.get_height_values_range = function (self)
	local breed = self._profile.archetype.breed
	local height_range = {
		max = 1,
		min = 1
	}
	local breed_height_values = Breeds[breed].size_variation_range

	if breed_height_values then
		height_range.min = breed_height_values[1]
		height_range.max = breed_height_values[2]
	end

	return height_range
end

CharacterCreate._setup_appearance_presets = function (self, verified_items)
	local presets = {}

	for breed, gender_presets in pairs(PlayerCharacterCreatorPresets) do
		local breed_presets = {}

		for gender, appearance_presets in pairs(gender_presets) do
			local presets_array = {}

			for preset_name, preset_slots in pairs(appearance_presets) do
				local preset = {
					body_parts = {}
				}

				for ii = 1, #self._inventory_slots_array do
					local slot_name = self._inventory_slots_array[ii]
					local preset_item = preset_slots[slot_name]

					if preset_item and verified_items[preset_item] then
						preset.body_parts[slot_name] = verified_items[preset_item]
					else
						preset.body_parts[slot_name] = {}
					end
				end

				presets_array[#presets_array + 1] = preset
			end

			breed_presets[gender] = presets_array
		end

		presets[breed] = breed_presets
	end

	return presets
end

CharacterCreate._randomize_archetype = function (self)
	local archetypes = self:archetype_options()
	local archetype = archetypes[math.random(1, math.clamp(#archetypes, 0, 4))]

	return archetype
end

CharacterCreate._randomize_gender = function (self)
	local genders = self:gender_options()
	local gender = genders[math.random(1, #genders)]

	return gender
end

CharacterCreate._presets_options = function (self)
	local profile = self._profile
	local breed = profile.archetype.breed
	local gender = profile.gender
	local presets = self._appearance_presets[breed][gender]

	return presets
end

CharacterCreate._is_fallback_item = function (self, slot, item_name)
	for i = 1, #fallback_slots_to_strip do
		local fallback_slot = fallback_slots_to_strip[i]

		if slot == fallback_slot then
			local fallback_item = MasterItems.find_fallback_item_id(slot)

			return fallback_item == item_name
		end
	end

	return false
end

CharacterCreate._verify_items = function (self, source_items, owned_gear)
	local verified_items = {}
	local inventory_slots_array = self._inventory_slots_array
	local owned_gear_by_master_id = {}

	if owned_gear then
		for id, item in pairs(owned_gear) do
			owned_gear_by_master_id[item.masterDataInstance.id] = item
		end
	end

	for item_name, item in pairs(source_items) do
		local slots = item.slots

		if slots then
			for i = 1, #slots do
				local slot_name = slots[i]
				local is_fallback = self:_is_fallback_item(slot_name, item_name)

				if table.contains(inventory_slots_array, slot_name) and (item.always_owned or owned_gear_by_master_id[item_name]) and not is_fallback then
					verified_items[item_name] = item

					break
				end
			end
		end
	end

	return verified_items
end

CharacterCreate._setup_item_categories = function (self, source_items)
	local destination_table = {}
	local loop_table_order = {
		"archetypes",
		"breeds",
		"genders",
		"slots"
	}
	local default_table_arrays = {
		archetypes = self._archetype_names_array,
		breed = self._breeds_array,
		genders = self._genders_array,
		slots = self._inventory_slots_array
	}

	local function next_category(item, lookup_index, destination)
		local table_key = loop_table_order[lookup_index]
		local values

		if item[table_key] and not table.is_empty(item[table_key]) then
			values = item[table_key]
		else
			values = default_table_arrays[table_key] or {}
		end

		local next_lookup_index = lookup_index < #loop_table_order and lookup_index + 1 or nil

		for _, key in ipairs(values) do
			if not destination[key] then
				destination[key] = {}
			end

			if not next_lookup_index then
				destination[key][#destination[key] + 1] = item
			else
				next_category(item, next_lookup_index, destination[key])
			end
		end
	end

	for item_name, item in pairs(source_items) do
		local table_index = 1

		next_category(item, table_index, destination_table)
	end

	return destination_table
end

CharacterCreate.height = function (self)
	return self._character_height
end

CharacterCreate.set_height = function (self, scale_factor)
	self._character_height = scale_factor
end

CharacterCreate.breed = function (self)
	return self._profile.archetype.breed
end

CharacterCreate._set_breed = function (self, breed_name)
	self._profile.breed = breed_name

	self:_increase_value_version("breed")
end

CharacterCreate.gender = function (self)
	return self._profile.gender
end

CharacterCreate.randomize_presets = function (self)
	local presets = self:_presets_options()
	local preset_index = math.random(1, #presets) or 1
	local random_preset = presets[preset_index]

	self:_reset_loadout()

	for slot_name, body_part in pairs(random_preset.body_parts) do
		if not self._profile.loadout[slot_name] and (self._profile.archetype.name ~= "adamant" and not default_companion_items[slot_name] or self._profile.archetype.name == "adamant") then
			self:set_item_per_slot(slot_name, body_part)
		end
	end

	local personality_option = self:_randomize_personality()

	self:set_personality(personality_option)
end

CharacterCreate._add_companion_items = function (self, profile)
	for slot, item_name in pairs(default_companion_items) do
		if not self:set_item_per_slot(slot, nil) then
			local item = MasterItems.get_item(item_name)

			self:set_item_per_slot(slot, item)
		end
	end
end

CharacterCreate._remove_companion_items = function (self, profile)
	for slot, item_name in pairs(default_companion_items) do
		self:set_item_per_slot(slot, nil)
	end
end

CharacterCreate.set_gender = function (self, gender)
	self._profile.gender = gender

	local breed = self._profile.archetype.breed
	local saved_preset = self._saved_gender_loadout and self._saved_gender_loadout[breed][gender]

	if saved_preset then
		self:_reset_loadout()

		for slot_name, body_part in pairs(saved_preset) do
			if not self._profile.loadout[slot_name] then
				self:set_item_per_slot(slot_name, body_part)
			end
		end

		local personality_option = self:_randomize_personality()

		self:set_personality(personality_option)
	else
		self:randomize_presets()
	end

	self:_increase_value_version("gender")
end

CharacterCreate.set_archetype = function (self, archetype)
	local is_diff_archetype = self._profile.archetype ~= archetype

	self._profile.archetype = archetype

	self:_increase_value_version("archetype")

	local breed_name = archetype.breed

	self:_set_breed(breed_name)

	if is_diff_archetype then
		self:_randomize_archetype_properties()

		if archetype.name == "adamant" then
			self:_add_companion_items()

			self._profile.companion = {
				name = ""
			}
		else
			self._profile.companion = nil

			self:_remove_companion_items()
		end
	end

	self:reset_height()
end

CharacterCreate.reset_height = function (self)
	local breed_height_range = self:get_height_values_range()
	local min_height = breed_height_range.min
	local max_height = breed_height_range.max
	local scale_factor = math.lerp(min_height, max_height, 0.5)

	self:set_height(scale_factor)
end

CharacterCreate.set_specialization = function (self, specialization)
	self._profile.specialization = specialization

	self:_increase_value_version("specialization")
end

CharacterCreate._fetch_suggested_names_by_profile = function (self)
	self._archetype_random_names = {}
	self._companion_random_names = {}

	local archetype = self._profile.archetype.name
	local gender = self:gender()
	local planet_option = self:planet()
	local planet_id = planet_option.id

	return Managers.data_service.profiles:fetch_suggested_names_by_archetype(archetype, gender, planet_id):next(function (result)
		self._archetype_random_names = result.character
		self._companion_random_names = result.companion
	end)
end

CharacterCreate.set_item_per_slot = function (self, slot_name, item)
	local profile = self._profile
	local loadout = profile.loadout
	local can_be_empty = false

	for i = 1, #can_use_empty_item do
		local empty_slot = can_use_empty_item[i]

		if slot_name == empty_slot then
			can_be_empty = true

			break
		end
	end

	if (not item or table.is_empty(item)) and not can_be_empty then
		local available_items = self:slot_item_options(slot_name)

		if available_items then
			item = available_items[1]
		else
			item = MasterItems.find_fallback_item(slot_name)
		end
	end

	local breed = profile.archetype.breed
	local gender = profile.gender
	local saved_preset = self._saved_gender_loadout and self._saved_gender_loadout[breed][gender]
	local saved_preset_breed = self._saved_gender_loadout and self._saved_gender_loadout[breed]

	if saved_preset then
		self._saved_gender_loadout[breed][gender][slot_name] = item
	elseif saved_preset_breed then
		local gender_table = {}

		gender_table[slot_name] = {}
		self._saved_gender_loadout[breed][gender] = gender_table
		self._saved_gender_loadout[breed][gender][slot_name] = item
	end

	loadout[slot_name] = item

	self:_increase_value_version({
		"inventory",
		slot_name
	})
end

CharacterCreate.set_item_per_slot_preview = function (self, slot_name, item, profile)
	local loadout = profile.loadout

	loadout[slot_name] = item

	self:_increase_value_version({
		"inventory",
		slot_name
	})
end

CharacterCreate.gender_options = function (self)
	local breed = self._profile.archetype.breed
	local genders = Breeds[breed].genders

	return genders
end

CharacterCreate.archetype_options = function (self)
	return self._archetypes_array
end

CharacterCreate.personality = function (self)
	local id = self._profile.lore.backstory.personality

	return self._personalities_array[id]
end

CharacterCreate.set_personality = function (self, option)
	self._profile.lore.backstory.personality = option

	self:_increase_value_version("personality")
end

CharacterCreate.personality_options = function (self)
	local options = self:_filter_options_by_visibility(self._personalities_array)

	return options
end

CharacterCreate._randomize_personality = function (self)
	local available_options = self:personality_options()
	local index = math.random(1, table.size(available_options))
	local count = 1

	for id, _ in pairs(available_options) do
		if count == index then
			return id
		end

		count = count + 1
	end
end

CharacterCreate.planet = function (self)
	local id = self._profile.lore.backstory.planet

	return self._home_planets_array[id]
end

CharacterCreate.set_planet = function (self, id)
	self._profile.lore.backstory.planet = id

	self:_increase_value_version("planet")
end

CharacterCreate.planet_options = function (self)
	local option = self:_filter_options_by_visibility(self._home_planets_array)

	return option
end

CharacterCreate.childhood = function (self)
	local id = self._profile.lore.backstory.childhood

	return self._childhood_array[id]
end

CharacterCreate.set_childhood = function (self, id)
	self._profile.lore.backstory.childhood = id

	self:_increase_value_version("childhood")
end

CharacterCreate.childhood_options = function (self)
	local option = self:_filter_options_by_visibility(self._childhood_array)

	return option
end

CharacterCreate._randomize_childhood = function (self)
	local available_options = self:childhood_options()
	local index = math.random(1, table.size(available_options))
	local count = 1

	for id, _ in pairs(available_options) do
		if count == index then
			return id
		end

		count = count + 1
	end
end

CharacterCreate.growing_up = function (self)
	local id = self._profile.lore.backstory.growing_up

	return self._growing_up_array[id]
end

CharacterCreate.set_growing_up = function (self, id)
	self._profile.lore.backstory.growing_up = id

	self:_increase_value_version("growing_up")
end

CharacterCreate.growing_up_options = function (self)
	local option = self:_filter_options_by_visibility(self._growing_up_array)

	return option
end

CharacterCreate._randomize_growing_up = function (self)
	local available_options = self:growing_up_options()
	local index = math.random(1, table.size(available_options))
	local count = 1

	for id, _ in pairs(available_options) do
		if count == index then
			return id
		end

		count = count + 1
	end
end

CharacterCreate.formative_event = function (self)
	local id = self._profile.lore.backstory.formative_event

	return self._formative_event_array[id]
end

CharacterCreate.set_formative_event = function (self, id)
	self._profile.lore.backstory.formative_event = id

	self:_increase_value_version("formative_event")
end

CharacterCreate.formative_event_options = function (self)
	local option = self:_filter_options_by_visibility(self._formative_event_array)

	return option
end

CharacterCreate._randomize_formative_event = function (self)
	local available_options = self:formative_event_options()
	local index = math.random(1, table.size(available_options))
	local count = 1

	for id, _ in pairs(available_options) do
		if count == index then
			return id
		end

		count = count + 1
	end
end

CharacterCreate._randomize_planet = function (self)
	local available_options = self:planet_options()
	local index = math.random(1, table.size(available_options))
	local count = 1

	for id, _ in pairs(available_options) do
		if count == index then
			return id
		end

		count = count + 1
	end
end

CharacterCreate.crime = function (self)
	local id = CrimesCompabilityMap[self._profile.lore.backstory.crime] or self._profile.lore.backstory.crime

	return self._crimes_array[id]
end

CharacterCreate.set_crime = function (self, id)
	self._profile.lore.backstory.crime = id

	if self._visible then
		local crime_settings = Crimes[id]

		if crime_settings ~= nil then
			local slot_items = crime_settings.slot_items

			if slot_items then
				local item_definitions = self._item_definitions

				for slot_name, item_name in pairs(slot_items) do
					local item = item_definitions[item_name]

					self:set_item_per_slot(slot_name, item)
				end
			end
		end
	end
end

CharacterCreate.randomize_name = function (self)
	local names = self._archetype_random_names
	local num_names = #names

	if num_names == 0 then
		return ""
	end

	local random_name_index = math.random(1, #names)

	return self._archetype_random_names[random_name_index]
end

CharacterCreate.randomize_companion_name = function (self)
	local names = self._companion_random_names
	local num_names = #names

	if num_names == 0 then
		return ""
	end

	local random_name_index = math.random(1, #names)

	return self._companion_random_names[random_name_index]
end

CharacterCreate.set_name = function (self, name)
	self._profile.name = name
end

CharacterCreate.companion_name = function (self, name)
	return self._profile.companion and self._profile.companion.name or ""
end

CharacterCreate.set_companion_name = function (self, name)
	if self._profile.companion and self._profile.companion.name then
		self._profile.companion.name = name
	end
end

CharacterCreate.name = function (self)
	return self._profile.name or ""
end

CharacterCreate.crime_options = function (self)
	local option = self:_filter_options_by_visibility(self._crimes_array)

	return option
end

CharacterCreate._randomize_crime = function (self)
	local available_options = self:crime_options()
	local index = math.random(1, table.size(available_options))
	local count = 1

	for id, _ in pairs(available_options) do
		if count == index then
			return id
		end

		count = count + 1
	end
end

CharacterCreate.slot_item = function (self, slot_name)
	local profile = self._profile
	local loadout = profile.loadout

	return loadout[slot_name]
end

CharacterCreate.slot_item_options = function (self, slot_name)
	local profile = self._profile
	local archetype = profile.archetype
	local archetype_name = archetype.name
	local breed = profile.archetype.breed
	local gender = profile.gender
	local items = self._item_categories[archetype_name] and self._item_categories[archetype_name][breed] and self._item_categories[archetype_name][breed][gender] and self._item_categories[archetype_name][breed][gender][slot_name]

	return items
end

CharacterCreate.set_gear_visible = function (self, visible)
	local previous_visiblity = self._visible

	self._visible = visible

	if not visible and visible ~= previous_visiblity then
		for slot_name, slot_settings in pairs(ItemSlotSettings) do
			if slot_settings.slot_type == "gear" and not default_companion_items[slot_name] then
				self:set_item_per_slot(slot_name, nil)
			end
		end
	elseif visible and visible ~= previous_visiblity then
		local crime_option = self:crime()

		self:set_crime(crime_option.id)
	end
end

CharacterCreate.check_name = function (self, name)
	local profiles_service = Managers.data_service.profiles

	return profiles_service:check_name(name)
end

CharacterCreate.check_companion_name = function (self, name)
	local profiles_service = Managers.data_service.profiles

	return profiles_service:check_companion_name(name)
end

CharacterCreate.destroy = function (self)
	return
end

CharacterCreate.profile_value_versions = function (self)
	return self._profile_value_versions
end

CharacterCreate._increase_value_version = function (self, value_keys)
	if type(value_keys) == "table" then
		local register_value_version

		function register_value_version(save_location, value_keys, current_index)
			local current_key = value_keys[current_index]

			if current_index < #value_keys then
				save_location[current_key] = save_location[current_key] or {}

				register_value_version(save_location[current_key], value_keys, current_index + 1)
			else
				save_location[current_key] = (save_location[current_key] or 0) + 1
			end
		end

		register_value_version(self._profile_value_versions, value_keys, 1)
	else
		self._profile_value_versions[value_keys] = (self._profile_value_versions[value_keys] or 0) + 1
	end

	self._profile_value_versions.profile = (self._profile_value_versions.profile or 0) + 1
end

CharacterCreate._generate_backend_profile = function (self)
	local profile = self._profile
	local new_profile = table.create_copy_instance(nil, profile)

	new_profile.archetype = profile.archetype.name
	new_profile.career = {
		specialization = profile.specialization
	}
	new_profile.specialization = nil

	local new_loadout = {}

	new_profile.inventory = new_loadout
	new_profile.loadout = nil

	for slot_name, item in pairs(profile.loadout) do
		if item and not table.is_empty(item) then
			new_loadout[slot_name] = {
				id = item.name
			}
		end
	end

	local personality = self:personality()
	local personality_settings = Personalities[personality.id]
	local character_voice = personality_settings.character_voice

	new_profile.selected_voice = character_voice
	new_profile.character_height = self._character_height
	new_profile.id = Application.guid()

	return new_profile
end

CharacterCreate.completed = function (self)
	return self._done
end

CharacterCreate.failed = function (self)
	return self._failed
end

CharacterCreate.upload_profile = function (self)
	local parsed_profile = self:_generate_backend_profile()
	local profiles_service = Managers.data_service.profiles

	profiles_service:create_profile(parsed_profile):next(function (character)
		return profiles_service:new_character_to_profile(character)
	end):next(function (profile)
		self._created_profile = profile
		self._done = true
	end):catch(function (errors)
		self._done = true
		self._failed = true

		Log.error("CharacterCreate", "Uploading character profile failed")
	end)
end

CharacterCreate.get_transformation_complete = function (self)
	local transformation_complete = self._transformation_complete
	local result = transformation_complete.success or transformation_complete.fail

	if result then
		return transformation_complete
	end
end

CharacterCreate._add_crime_items_to_parsed_profile = function (self)
	local option = CrimesCompabilityMap[self._profile.lore.backstory.crime] or self._profile.lore.backstory.crime
	local crime_settings = Crimes[option]
	local items = {}

	if crime_settings ~= nil then
		local slot_items = crime_settings.slot_items

		if slot_items then
			local item_definitions = self._item_definitions

			for slot_name, item_name in pairs(slot_items) do
				local item = item_definitions[item_name]

				items[slot_name] = {
					id = item.name
				}
			end
		end
	end

	return items
end

local function _granted_item_to_gear(item)
	local gear = table.clone(item)
	local gear_id = gear.uuid

	gear.overrides = nil
	gear.id = nil
	gear.uuid = nil
	gear.gear_id = nil

	return gear_id, gear
end

CharacterCreate.transform = function (self, character_id, operation_cost)
	self._transformation_complete = {}

	local parsed_profile = self:_generate_backend_profile()

	parsed_profile.id = nil
	parsed_profile.archetype = nil
	parsed_profile.abilities = nil
	parsed_profile.career = nil
	parsed_profile.inventory.slot_animation_end_of_round = nil

	local prison_garbs = self:_add_crime_items_to_parsed_profile()
	local upperbody_slot = "slot_gear_upperbody"
	local lowerbody_slot = "slot_gear_lowerbody"

	parsed_profile.inventory[upperbody_slot] = prison_garbs[upperbody_slot]
	parsed_profile.inventory[lowerbody_slot] = prison_garbs[lowerbody_slot]

	local real_profile_gear = self._real_profile_gear
	local slots_to_equip = {}

	for slot, item in pairs(real_profile_gear) do
		if not table.is_empty(item.crimes) then
			slots_to_equip[slot] = true
		end
	end

	local character_interface = Managers.backend.interfaces.characters
	local promise = character_interface:transform(character_id, parsed_profile, operation_cost)
	local granted_garbs = {}

	promise:next(function (data)
		if data then
			local new_items = data.body and data.body.gear
			local upperbody = "slot_gear_upperbody"
			local lowerbody = "slot_gear_lowerbody"

			if new_items then
				for i = 1, #new_items do
					local item = new_items[i]
					local slot = item.slots and item.slots[1]

					if slot == upperbody or slot == lowerbody then
						granted_garbs[#granted_garbs + 1] = item
					end

					local gear_id, gear = _granted_item_to_gear(item)

					Managers.data_service.gear:on_gear_created(gear_id, gear)
				end
			end
		end

		self:reload_real_character()
	end):next(function (result)
		self:_replace_old_crime_items_in_loadouts(slots_to_equip, granted_garbs)

		self._transformation_complete.success = true
	end):catch(function (errors)
		self._transformation_complete.fail = true

		Log.error("CharacterCreate", "Character transform failed")
	end)
end

CharacterCreate.reload_real_character = function (self)
	local peer_id = Network.peer_id()
	local local_player_id = 1

	if Managers.connection:is_host() then
		local profile_synchronizer_host = Managers.profile_synchronization:synchronizer_host()

		profile_synchronizer_host:profile_changed(peer_id, local_player_id)
	elseif Managers.connection:is_client() then
		local ui_manager = Managers.ui

		if ui_manager then
			ui_manager:update_client_loadout_waiting_state(true)
		end

		Managers.connection:send_rpc_server("rpc_notify_profile_changed", peer_id, local_player_id)
	end
end

CharacterCreate._fetch_crime_items = function (self)
	local player = Managers.player:local_player(1)
	local character_id = player:character_id()
	local body_gear_slots = {}

	body_gear_slots[1] = "slot_gear_lowerbody"
	body_gear_slots[2] = "slot_gear_upperbody"

	local gear_service = Managers.data_service.gear

	return gear_service:fetch_inventory(character_id, body_gear_slots):next(function (items)
		if self._destroyed then
			return
		end

		self._body_gear_items = items

		local crime_items = {}

		for id, item in pairs(items) do
			local master_item = item.__master_item

			if master_item then
				local item_name = master_item.name
				local crimes = master_item.crimes

				if crimes and not table.is_empty(crimes) then
					crime_items[item_name] = id
				end
			end
		end

		return crime_items
	end):catch(function ()
		Managers.event:trigger("event_add_notification_message", "alert", {
			text = Localize("loc_popup_description_backend_error")
		})
		self:cb_on_close_pressed()
	end)
end

CharacterCreate._get_current_crime_items_ids = function (self, crime_items)
	local items = {}
	local crime = self:crime()
	local crime_id = crime.is_diff_archetype
	local crime_settings = Crimes[crime_id]

	if crime_settings ~= nil then
		local slot_items = crime_settings.slot_items

		if slot_items then
			for slot_name, item_name in pairs(slot_items) do
				for master_item_name, id in pairs(crime_items) do
					if item_name == master_item_name then
						items[slot_name] = id
					end
				end
			end
		end
	end

	return items
end

CharacterCreate._replace_old_crime_items_in_loadouts = function (self, slots_to_equip, granted_garbs)
	local old_crime_items = self._old_crime_items
	local new_crime_items = {}

	if #granted_garbs > 0 then
		for i = 1, #granted_garbs do
			local item = granted_garbs[i]
			local slot = item.slots[1]
			local uuid = item.uuid

			new_crime_items[slot] = uuid
			item.gear_id = uuid
			self._body_gear_items[uuid] = item
		end
	else
		local all_crime_items = self._all_crime_items

		new_crime_items = self:_get_current_crime_items_ids(all_crime_items)
	end

	local profile_presets = ProfileUtils.get_profile_presets()
	local num_profile_presets = profile_presets and #profile_presets or 0

	for i = num_profile_presets, 1, -1 do
		local profile_preset = profile_presets[i]
		local preset_loadout = profile_preset.loadout

		for slot, id in pairs(old_crime_items) do
			if preset_loadout[slot] == id then
				ProfileUtils.save_item_id_for_profile_preset(profile_preset.id, slot, new_crime_items[slot])
			end
		end
	end

	for slot_to_equip, _ in pairs(slots_to_equip) do
		for slot, id in pairs(new_crime_items) do
			if slot_to_equip == slot then
				local item = self:_get_crime_item_by_id(id)

				if item then
					ItemUtils.equip_item_in_slot(slot, item)
				end
			end
		end
	end
end

CharacterCreate._get_crime_item_by_id = function (self, gear_id)
	if not gear_id then
		return
	end

	local crime_items = self._body_gear_items

	for _, item in pairs(crime_items) do
		if item.gear_id == gear_id then
			return item
		end
	end
end

CharacterCreate.created_character_profile = function (self)
	return self._created_profile
end

return CharacterCreate
