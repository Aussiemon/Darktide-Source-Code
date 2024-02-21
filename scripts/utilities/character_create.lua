local Breeds = require("scripts/settings/breed/breeds")
local Archetypes = require("scripts/settings/archetype/archetypes")
local HomePlanets = require("scripts/settings/character/home_planets")
local Childhood = require("scripts/settings/character/childhood")
local GrowingUp = require("scripts/settings/character/growing_up")
local FormativeEvent = require("scripts/settings/character/formative_event")
local Crimes = require("scripts/settings/character/crimes")
local Personalities = require("scripts/settings/character/personalities")
local PlayerCharacterCreatorPresets = require("scripts/settings/player_character/player_character_creator_presets")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local MasterItems = require("scripts/backend/master_items")
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
	"slot_gear_extra_cosmetic",
	"slot_gear_head",
	"slot_gear_lowerbody",
	"slot_gear_upperbody"
}

if BUILD == "release" then
	fallback_slots_to_strip = {
		"slot_body_face"
	}
end

CharacterCreate.init = function (self, item_definitions, owned_gear, optional_real_profile)
	self._archetype_random_names = {}
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
		local backstory = optional_real_profile.lore.backstory
		local selected_voice = optional_real_profile.selected_voice
		local gender = optional_real_profile.gender
		local breed = optional_real_profile.archetype.breed
		local height = optional_real_profile.personal.character_height
		self._character_height = height
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
		local loadout = optional_real_profile.loadout

		if loadout then
			for slot_name, slot_settings in pairs(ItemSlotSettings) do
				local show_in_character_create = slot_settings.show_in_character_create

				if show_in_character_create then
					if slot_settings.slot_type == "gear" then
						self:set_item_per_slot(slot_name, nil)
					else
						local item = loadout[slot_name]

						self:set_item_per_slot(slot_name, item)
					end
				end
			end
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

CharacterCreate._reset_loadout = function (self)
	self._profile.loadout = {}
end

CharacterCreate.reset_backstory = function (self)
	self._profile.lore.backstory = {}

	self:_randomize_lore_properties()
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
	local archetype_names_array = {}

	for archetype_name, archetype in pairs(Archetypes) do
		archetypes_array[#archetypes_array + 1] = archetype
		archetype_names_array[#archetype_names_array + 1] = archetype_name
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
	local sorted_personalities = {}

	for key, settings in pairs(Personalities) do
		local archetype = settings.archetype
		local destination = nil

		if not sorted_personalities[archetype] then
			sorted_personalities[archetype] = {}
		end

		destination = sorted_personalities[archetype]
		local breed = settings.breed

		if not destination[breed] then
			destination[breed] = {}
		end

		destination = destination[breed]
		local gender = settings.gender

		if not destination[gender] then
			destination[gender] = {}
		end

		destination = destination[gender]
		destination[#destination + 1] = key
	end

	self._sorted_personalities = sorted_personalities
	local home_planets_array = {}

	for key, settings in pairs(HomePlanets) do
		home_planets_array[#home_planets_array + 1] = key
	end

	self._home_planets_array = home_planets_array
	local childhood_array = {}

	for key, settings in pairs(Childhood) do
		childhood_array[#childhood_array + 1] = key
	end

	self._childhood_array = childhood_array
	local growing_up_array = {}

	for key, settings in pairs(GrowingUp) do
		growing_up_array[#growing_up_array + 1] = key
	end

	self._growing_up_array = growing_up_array
	local formative_event_array = {}

	for key, settings in pairs(FormativeEvent) do
		formative_event_array[#formative_event_array + 1] = key
	end

	self._formative_event_array = formative_event_array
	local sorted_crimes = {}

	for key, settings in pairs(Crimes) do
		local destination = nil
		local archetype = settings.archetype

		if not sorted_crimes[archetype] then
			sorted_crimes[archetype] = {}
		end

		destination = sorted_crimes[archetype]
		destination[#destination + 1] = key
	end

	self._sorted_crimes = sorted_crimes
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
	local breed = self._profile.breed
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

				for i = 1, #self._inventory_slots_array do
					local slot_name = self._inventory_slots_array[i]
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
	local archetype = archetypes[math.random(1, #archetypes)]

	return archetype
end

CharacterCreate._randomize_gender = function (self)
	local genders = self:gender_options()
	local gender = genders[math.random(1, #genders)]

	return gender
end

CharacterCreate._presets_options = function (self)
	local profile = self._profile
	local breed = profile.breed
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

	local function next_category(item, lookup_index, destination)
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
		local table_key = loop_table_order[lookup_index]
		local values = {}
		values = item[table_key] and not table.is_empty(item[table_key]) and item[table_key] or default_table_arrays[table_key] or {}
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
	return self._profile.breed
end

CharacterCreate.set_breed = function (self, breed_name)
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
		self:set_item_per_slot(slot_name, body_part)
	end

	local personality_option = self:_randomize_personality()

	self:set_personality(personality_option)
end

CharacterCreate.set_gender = function (self, gender)
	self._profile.gender = gender

	self:randomize_presets()
	self:_increase_value_version("gender")
end

CharacterCreate.set_archetype = function (self, archetype)
	local is_diff_archetype = self._profile.archetype ~= archetype
	self._profile.archetype = archetype

	self:_increase_value_version("archetype")

	local breed_name = archetype.breed

	self:set_breed(breed_name)

	if is_diff_archetype then
		self:_randomize_archetype_properties()
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

CharacterCreate.specialization = function (self)
	if self._profile.specialization then
		local specialization_name = self._profile.specialization

		return self._profile.archetype.specializations[specialization_name]
	end
end

CharacterCreate._fetch_suggested_names_by_profile = function (self)
	self._archetype_random_names = {}
	local archetype = self._profile.archetype.name
	local gender = self:gender()
	local planet_option = self:planet()
	local planet_id = HomePlanets[planet_option].id

	return Managers.data_service.profiles:fetch_suggested_names_by_archetype(archetype, gender, planet_id):next(function (names)
		self._archetype_random_names = names
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
	local breed = self._profile.breed
	local genders = Breeds[breed].genders

	return genders
end

CharacterCreate.archetype_options = function (self)
	return self._archetypes_array
end

CharacterCreate.personality = function (self)
	return self._profile.lore.backstory.personality
end

CharacterCreate.set_personality = function (self, option)
	self._profile.lore.backstory.personality = option

	self:_increase_value_version("personality")
end

CharacterCreate.personality_options = function (self)
	local profile = self._profile
	local archetype = profile.archetype
	local archetype_name = archetype.name
	local breed = profile.breed
	local gender = profile.gender
	local sorted_personalities = self._sorted_personalities

	return sorted_personalities[archetype_name][breed][gender]
end

CharacterCreate._randomize_personality = function (self)
	local personality = self:personality_options()

	return personality[math.random(1, #personality)]
end

CharacterCreate.planet = function (self)
	return self._profile.lore.backstory.planet
end

CharacterCreate.set_planet = function (self, option)
	self._profile.lore.backstory.planet = option

	self:_increase_value_version("planet")
end

CharacterCreate.planet_options = function (self)
	return self._home_planets_array
end

CharacterCreate.childhood = function (self)
	return self._profile.lore.backstory.childhood
end

CharacterCreate.set_childhood = function (self, option)
	self._profile.lore.backstory.childhood = option

	self:_increase_value_version("childhood")
end

CharacterCreate.childhood_options = function (self)
	return self._childhood_array
end

CharacterCreate._randomize_childhood = function (self)
	local childhood_options = self:childhood_options()

	return childhood_options[math.random(1, #childhood_options)]
end

CharacterCreate.growing_up = function (self)
	return self._profile.lore.backstory.growing_up
end

CharacterCreate.set_growing_up = function (self, option)
	self._profile.lore.backstory.growing_up = option

	self:_increase_value_version("growing_up")
end

CharacterCreate.growing_up_options = function (self)
	return self._growing_up_array
end

CharacterCreate._randomize_growing_up = function (self)
	local growing_up_options = self:growing_up_options()

	return growing_up_options[math.random(1, #growing_up_options)]
end

CharacterCreate.formative_event = function (self)
	return self._profile.lore.backstory.formative_event
end

CharacterCreate.set_formative_event = function (self, option)
	self._profile.lore.backstory.formative_event = option

	self:_increase_value_version("formative_event")
end

CharacterCreate.formative_event_options = function (self)
	return self._formative_event_array
end

CharacterCreate._randomize_formative_event = function (self)
	local formative_events = self:formative_event_options()

	return formative_events[math.random(1, #formative_events)]
end

CharacterCreate._randomize_planet = function (self)
	local planet = self:planet_options()

	return planet[math.random(1, #planet)]
end

CharacterCreate.crime = function (self)
	return self._profile.lore.backstory.crime
end

CharacterCreate.set_crime = function (self, option)
	self._profile.lore.backstory.crime = option

	if self._visible then
		local crime_settings = Crimes[option]
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

CharacterCreate.randomize_name = function (self)
	local names = self._archetype_random_names
	local num_names = #names

	if num_names == 0 then
		return ""
	end

	local random_name_index = math.random(1, #names)

	return self._archetype_random_names[random_name_index]
end

CharacterCreate.set_name = function (self, name)
	self._profile.name = name
end

CharacterCreate.name = function (self)
	return self._profile.name
end

CharacterCreate.crime_options = function (self)
	local profile = self._profile
	local archetype = profile.archetype.name

	return self._sorted_crimes[archetype]
end

CharacterCreate._randomize_crime = function (self)
	local crimes = self:crime_options()

	return crimes[math.random(1, #crimes)]
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
	local breed = profile.breed
	local gender = profile.gender
	local items = self._item_categories[archetype_name] and self._item_categories[archetype_name][breed] and self._item_categories[archetype_name][breed][gender] and self._item_categories[archetype_name][breed][gender][slot_name]

	return items
end

CharacterCreate.set_gear_visible = function (self, visible)
	local previous_visiblity = self._visible
	self._visible = visible

	if not visible and visible ~= previous_visiblity then
		for slot_name, slot_settings in pairs(ItemSlotSettings) do
			if slot_settings.slot_type == "gear" then
				self:set_item_per_slot(slot_name, nil)
			end
		end
	elseif visible and visible ~= previous_visiblity then
		local crime_option = self:crime()

		self:set_crime(crime_option)
	end
end

CharacterCreate.check_name = function (self, name)
	local profiles_service = Managers.data_service.profiles

	return profiles_service:check_name(name)
end

CharacterCreate.destroy = function (self)
	return
end

CharacterCreate.profile_value_versions = function (self)
	return self._profile_value_versions
end

CharacterCreate._increase_value_version = function (self, value_keys)
	if type(value_keys) == "table" then
		local register_value_version = nil

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
		new_loadout[slot_name] = {
			id = item.name
		}
	end

	local personality = self:personality()
	local personality_settings = Personalities[personality]
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

CharacterCreate.created_character_profile = function (self)
	return self._created_profile
end

return CharacterCreate
