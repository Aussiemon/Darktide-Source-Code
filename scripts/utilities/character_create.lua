-- chunkname: @scripts/utilities/character_create.lua

local Archetypes = require("scripts/settings/archetype/archetypes")
local ArchetypeSettings = require("scripts/settings/archetype/archetype_settings")
local BreedQueries = require("scripts/utilities/breed_queries")
local Breeds = require("scripts/settings/breed/breeds")
local Childhood = require("scripts/settings/character/childhood")
local Crimes = require("scripts/settings/character/crimes")
local CrimesCompabilityMap = require("scripts/settings/character/crimes_compability_mapping")
local FormativeEvent = require("scripts/settings/character/formative_event")
local GrowingUp = require("scripts/settings/character/growing_up")
local HomePlanets = require("scripts/settings/character/home_planets")
local Items = require("scripts/utilities/items")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ItemSourceSettings = require("scripts/settings/item/item_source_settings_new")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Personalities = require("scripts/settings/character/personalities")
local PlayerCharacterCreatorPresets = require("scripts/settings/player_character/player_character_creator_presets")
local ProfileUtils = require("scripts/utilities/profile_utils")
local Voices = require("scripts/settings/character/voice_effects_cryptic")
local CrimesCompabilityMapping = require("scripts/settings/character/crimes_compability_mapping")
local CharacterCreate = class("CharacterCreate")
local EMPTY_TABLE = {}
local FALLBACK_SLOTS_TO_STRIP = {
	"slot_body_face",
	"slot_body_face_tattoo",
	"slot_body_face_scar",
	"slot_body_face_hair",
	"slot_body_hair",
	"slot_body_tattoo",
}
local CAN_USE_EMPTY_ITEM = table.set({
	"slot_companion_body_skin_color",
	"slot_companion_body_fur_color",
	"slot_companion_body_coat_pattern",
	"slot_companion_gear_full",
	"slot_gear_material_override_decal",
	"slot_gear_extra_cosmetic",
	"slot_gear_head",
	"slot_gear_lowerbody",
	"slot_gear_upperbody",
	"slot_body_face_hair_color",
	"slot_body_face_makeup",
	"slot_body_skin_color_secondary",
	"slot_body_skin_discoloration",
	"slot_body_eye_color_secondary",
})
local BACKSTORY_FIELD_TO_OPTIONS = {
	childhood = Childhood,
	crime = Crimes,
	formative_event = FormativeEvent,
	growing_up = GrowingUp,
	personality = Personalities,
	planet = HomePlanets,
}
local BACKSTORY_FIELD_TO_ITEM_FIELD = {
	childhood = "childhoods",
	crime = "crimes",
	formative_event = "formative_events",
	growing_up = "upbringings",
	personality = nil,
	planet = "home_planets",
}
local VALID_BACKENDS_BY_SLOT = {}
local CHARACTER_CREATOR_ITEMS_BY_ARCHETYPE = {
	adamant = {
		slot_companion_body_skin_color = {
			item_name = "content/items/characters/companion/companion_dog/body_skin_colors/dog_skin_color_tan_01",
		},
		slot_companion_body_fur_color = {
			item_name = "content/items/characters/companion/companion_dog/body_fur_colors/dog_fur_color_black_01",
		},
		slot_companion_body_coat_pattern = {
			item_name = "content/items/characters/companion/companion_dog/body_coat_patterns/dog_coat_spots_01",
		},
		slot_companion_gear_full = {
			item_name = "content/items/characters/companion/companion_dog/gear_full/companion_dog_set_03_var_01",
		},
	},
	cryptic = {
		slot_prop = {
			character_creator_only = true,
			item_name = "content/items/characters/player/human/backpacks/cryptic_creator_arm_attachment",
		},
		slot_companion_gear_full = {
			character_creator_only = true,
			item_name = "content/items/characters/companion/companion_servo_skull/gear_full/cryptic_servo_skull_scanning_var_01",
		},
	},
}
local BARBER_ITEMS_BY_ARCHETYPE = {
	cryptic = {
		slot_prop = {
			character_creator_only = true,
			item_name = "content/items/characters/player/human/backpacks/cryptic_creator_arm_attachment",
		},
	},
}
local DEFAULT_PROFILE_DATA_BY_ARCHETYPE = {
	adamant = {
		companion = {
			name = "",
		},
	},
	cryptic = {
		voice_effects = {
			vox_effect_01 = 0,
			vox_effect_02 = 0,
			vox_effect_03 = 0,
		},
	},
}

if BUILD == "release" then
	FALLBACK_SLOTS_TO_STRIP = {
		"slot_body_face",
	}
end

local _is_fallback_item

CharacterCreate.init = function (self, item_definitions, owned_gear, optional_real_profile)
	self._stored_companion_items = {}
	self._archetype_random_names = {}
	self._companion_random_names = {}
	self._profile_value_versions = {
		abilities = nil,
		archetype = nil,
		breed = nil,
		gender = nil,
		loadout = {},
	}

	self:_setup_default_values()

	self._item_definitions = item_definitions

	self:refresh_gear(owned_gear)

	if optional_real_profile then
		local archetype = optional_real_profile.archetype
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
				backstory = backstory,
			},
			archetype = archetype,
			gender = gender,
			breed = breed,
		}

		local breed_height_range = self:get_height_values_range()
		local min_height, max_height = breed_height_range.min, breed_height_range.max
		local default_height = math.lerp(min_height, max_height, 0.5)
		local height = optional_real_profile.personal and optional_real_profile.personal.character_height or default_height

		self._character_height = height

		local default_data = DEFAULT_PROFILE_DATA_BY_ARCHETYPE[archetype.name] or EMPTY_TABLE

		for field_name, default_value in pairs(default_data) do
			if optional_real_profile[field_name] ~= nil then
				self._profile[field_name] = optional_real_profile[field_name]
			else
				self._profile[field_name] = default_value
			end

			if type(self._profile[field_name]) == "table" then
				self._profile[field_name] = table.clone(self._profile[field_name])
			end
		end

		local loadout = optional_real_profile.loadout

		if loadout then
			self._saved_gender_loadout = {
				[breed] = {
					[gender] = {},
				},
			}

			for slot_name, slot_settings in pairs(ItemSlotSettings) do
				local show_in_character_create = slot_settings.show_in_character_create

				if show_in_character_create then
					local item = loadout[slot_name]

					self:set_item_per_slot(slot_name, item)

					self._saved_gender_loadout[breed][gender][slot_name] = item
				end
			end
		end
	else
		self._profile = {
			name = "",
			selected_voice = "ogryn_a",
			loadout = {},
			abilities = {
				combat_ability = "dash",
				support_ability = "grenade",
			},
			lore = {
				backstory = {},
			},
		}
		self._character_height = 1

		local randomized_archetype = self:_random_archetype_option()

		self:set_archetype(randomized_archetype)
		self:_randomize_lore_properties()
	end
end

CharacterCreate.refresh_gear = function (self, owned_gear)
	local relevant_items = self:_filter_relevant_items(self._item_definitions, owned_gear)

	self._owned_gear = owned_gear

	local item_categories = self:_setup_item_categories(relevant_items)

	self._item_categories = item_categories

	local appearance_presets = self:_setup_appearance_presets(relevant_items)

	self._appearance_presets = appearance_presets
	self._owned_dlcs = self:_prewarm_dlc_ownership(relevant_items)
end

CharacterCreate.refresh_dlcs = function (self)
	local relevant_items = self:_filter_relevant_items(self._item_definitions, self._owned_gear)

	self._owned_dlcs = self:_prewarm_dlc_ownership(relevant_items)
end

CharacterCreate.is_option_visible = function (self, option)
	local is_item = not not option.value and type(option.value) == "table" and (not not option.value.gear_id or not not option.value.always_owned or not not ItemSourceSettings[option.value.source])
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
				validations = start_data_table_path.breeds,
			},
			{
				value = gender,
				validations = start_data_table_path.genders,
			},
			{
				value = archetype,
				validations = start_data_table_path.archetypes,
			},
			{
				value = planet and planet.id,
				validations = start_data_table_path.home_planets,
			},
		}

		for ii = 1, #validation_tables do
			local validation_table = validation_tables[ii]
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
	local is_item = not not option.value and type(option.value) == "table" and (not not option.value.gear_id or option.value.always_owned ~= nil or not not ItemSourceSettings[option.value.source])
	local start_data_table_path

	if is_item then
		start_data_table_path = option.value
	elseif option.restrictions then
		start_data_table_path = option.restrictions
	end

	local available = true

	if start_data_table_path then
		local planet = self:planet()
		local childhood = self:childhood()
		local growing_up = self:growing_up()
		local formative_event = self:formative_event()
		local source_settings = ItemSourceSettings[start_data_table_path.source]
		local external_validation_tables = option.validation_tables
		local validation_tables = {
			{
				reason = "home_planet",
				value = planet,
				validations = start_data_table_path.home_planets,
				options_data = self._home_planets_array,
			},
			{
				reason = "childhood",
				value = childhood,
				validations = start_data_table_path.childhood,
				options_data = self._childhood_array,
			},
			{
				reason = "growing_up",
				value = growing_up,
				validations = start_data_table_path.growing_up,
				options_data = self._growing_up_array,
			},
			{
				reason = "formative_event",
				value = formative_event,
				validations = start_data_table_path.formative_event,
				options_data = self._formative_event_array,
			},
		}

		if source_settings then
			table.insert(validation_tables, {
				reason = "source",
				value = {
					id = start_data_table_path.source,
				},
				validations = {
					start_data_table_path.source,
				},
				validation_function = self._is_gear_owned,
				options_data = ItemSourceSettings,
			})
		end

		if type(external_validation_tables) == "function" then
			external_validation_tables = external_validation_tables()
		end

		if external_validation_tables then
			table.append(validation_tables, external_validation_tables)
		end

		local reason, reason_display_name

		for ii = 1, #validation_tables do
			local validation_table = validation_tables[ii]
			local validations = validation_table.validations
			local value = validation_table.value

			if value and value.id ~= nil and validations and type(validations) == "table" and not table.is_empty(validations) then
				local result

				if validation_table.validation_function then
					result = validation_table.validation_function(self, option.value)
				elseif type(value.id) == "table" then
					for jj = 1, #value.id do
						result = table.find(validations, value.id[jj])

						if result then
							break
						end
					end
				else
					result = table.find(validations, value.id)
				end

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

		if not reason and start_data_table_path.archetypes and #start_data_table_path.archetypes == 1 then
			reason = "class"
			reason_display_name = "loc_class_" .. start_data_table_path.archetypes[1] .. "_name"
		end

		return available, reason, reason_display_name
	end

	return available
end

CharacterCreate._is_gear_owned = function (self, option)
	if not self._owned_gear then
		return false
	end

	for _, value in pairs(self._owned_gear) do
		if value.masterDataInstance.id == option.name then
			return true
		end
	end
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
	local character_creator_items = CHARACTER_CREATOR_ITEMS_BY_ARCHETYPE[self._profile.archetype.name] or EMPTY_TABLE

	for slot, item in pairs(self._profile.loadout) do
		if not character_creator_items[slot] then
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
	local planet_option = self:_random_planet_option()

	self:set_planet(planet_option)

	local crime_option = self:_random_crime_option()

	self:set_crime(crime_option)

	local personality_option = self:_random_personality_option()

	self:set_personality(personality_option)
	self:randomize_voice_effects()
end

CharacterCreate._randomize_backstory_properties = function (self)
	local formative_event_option = self:_random_formative_event_option()

	self:set_formative_event(formative_event_option)

	local growing_up_option = self:_random_growing_up_option()

	self:set_growing_up(growing_up_option)

	local childhood_option = self:_random_childhood_option()

	self:set_childhood(childhood_option)
end

CharacterCreate.randomize_backstory_properties = function (self)
	self:_randomize_backstory_properties()
end

CharacterCreate._randomize_archetype_properties = function (self)
	local randomized_gender = self:_random_gender_option()

	self:set_gender(randomized_gender)
end

CharacterCreate.profile = function (self)
	return self._profile
end

CharacterCreate._setup_default_values = function (self)
	self._home_planets_array = table.clone(HomePlanets)
	self._childhood_array = table.clone(Childhood)
	self._growing_up_array = table.clone(GrowingUp)
	self._formative_event_array = table.clone(FormativeEvent)
	self._personalities_array = table.clone(Personalities)
	self._crimes_array = table.clone(Crimes)
	self._dlc_options_data = table.remap(ItemSourceSettings, function (_, settings)
		if settings.dlc_name then
			return settings.dlc_name, settings
		end
	end)

	local inventory_slots_array = {}

	for slot_name, slot_info in pairs(ItemSlotSettings) do
		local show_in_character_create = slot_info.show_in_character_create

		if show_in_character_create then
			inventory_slots_array[#inventory_slots_array + 1] = slot_name
		end
	end

	self._inventory_slots_array = inventory_slots_array

	local archetypes_array = {}
	local archetype_names_array = ArchetypeSettings.archetype_names_array

	for archetype_name, archetype in pairs(Archetypes) do
		archetypes_array[#archetypes_array + 1] = archetype
	end

	table.sort(archetypes_array, function (a, b)
		return a.ui_selection_order < b.ui_selection_order
	end)

	self._archetypes_array = archetypes_array

	local breeds_array = BreedQueries.player_breed_names_array()
	local genders_array = {
		"female",
		"male",
	}

	self._default_table_arrays = {
		archetypes = archetype_names_array,
		breed = breeds_array,
		genders = genders_array,
		slots = inventory_slots_array,
	}
end

CharacterCreate.get_height_values_range = function (self)
	local breed = self._profile.archetype.breed
	local height_range = {
		max = 1,
		min = 1,
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

	for archetype, gender_presets in pairs(PlayerCharacterCreatorPresets) do
		local archetype_presets = {}

		for gender, appearance_presets in pairs(gender_presets) do
			local presets_array = {}

			for preset_name, preset_slots in pairs(appearance_presets) do
				local preset = {
					body_parts = {},
				}

				for ii = 1, #self._inventory_slots_array do
					local slot_name = self._inventory_slots_array[ii]
					local preset_item = preset_slots[slot_name]

					preset.body_parts[slot_name] = verified_items[preset_item] or {}
				end

				presets_array[#presets_array + 1] = preset
			end

			archetype_presets[gender] = presets_array
		end

		presets[archetype] = archetype_presets
	end

	return presets
end

CharacterCreate._random_archetype_option = function (self)
	local archetypes = self:archetype_options()
	local archetype = archetypes[math.random(1, math.clamp(#archetypes, 0, 4))]

	return archetype
end

CharacterCreate._random_gender_option = function (self)
	local genders = self:gender_options()
	local gender = genders[math.random(1, #genders)]

	return gender
end

CharacterCreate._presets_options = function (self)
	local profile = self._profile
	local archetype_name = profile.archetype.name
	local gender = profile.gender
	local gender_presets = self._appearance_presets[archetype_name]
	local presets = gender_presets[gender]

	return presets
end

CharacterCreate._filter_relevant_items = function (self, source_items, owned_gear)
	local filtered_items = {}
	local inventory_slots_array = self._inventory_slots_array
	local owned_gear_by_master_id = {}

	if owned_gear then
		for id, item in pairs(owned_gear) do
			owned_gear_by_master_id[item.masterDataInstance.id] = item
		end
	end

	local PROTOTYPE_STATE = Items.workflow_state_index("PROTOTYPE")

	for item_name, item in pairs(source_items) do
		local slots = item.slots

		if slots then
			for ii = 1, #slots do
				local slot_name = slots[ii]
				local is_fallback = _is_fallback_item(slot_name, item_name)

				if PROTOTYPE_STATE < Items.workflow_state_index(item.workflow_state) and table.contains(inventory_slots_array, slot_name) and (item.always_owned or owned_gear_by_master_id[item_name] or ItemSourceSettings[item.source]) and not is_fallback then
					filtered_items[item_name] = item

					break
				end
			end
		end
	end

	return filtered_items
end

CharacterCreate._prewarm_dlc_ownership = function (self, relevant_items)
	local owned_dlcs = {}
	local promises = {}

	for item_name, item in pairs(relevant_items) do
		local source_settings = ItemSourceSettings[item.source]
		local dlc_name = source_settings and source_settings.dlc_name

		if dlc_name and not promises[dlc_name] then
			promises[dlc_name] = Managers.dlc:is_owner_of(dlc_name, true):next(function (owns)
				if owns then
					table.insert(owned_dlcs, dlc_name)
				end
			end)
		end
	end

	return owned_dlcs
end

local LOOP_TABLE_ORDER = {
	"archetypes",
	"breeds",
	"genders",
	"slots",
}

CharacterCreate._setup_item_categories = function (self, source_items)
	local destination_table = {}
	local default_table_arrays = self._default_table_arrays

	local function next_category(item, lookup_index, destination)
		local table_key = LOOP_TABLE_ORDER[lookup_index]
		local values

		if item[table_key] and not table.is_empty(item[table_key]) then
			values = item[table_key]
		else
			values = default_table_arrays[table_key] or {}
		end

		local next_lookup_index = lookup_index < #LOOP_TABLE_ORDER and lookup_index + 1 or nil

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

CharacterCreate.randomize_character_apperance_preset = function (self)
	local presets = self:_presets_options()
	local preset_index = math.random(1, #presets) or 1
	local random_preset = presets[preset_index]

	self:_reset_loadout()

	for slot_name, body_part in pairs(random_preset.body_parts) do
		if not self._profile.loadout[slot_name] then
			self:set_item_per_slot(slot_name, body_part)
		end
	end
end

CharacterCreate.randomize_personality = function (self)
	local personality_option = self:_random_personality_option()

	self:set_personality(personality_option)
end

CharacterCreate.randomize_voice_effects = function (self)
	local matrix_x = math.random(0, 100)
	local matrix_y = math.random(0, 100)
	local slider = math.random(0, 100)

	self:set_voice_effect("vox_effect_01", matrix_x)
	self:set_voice_effect("vox_effect_02", matrix_y)
	self:set_voice_effect("vox_effect_03", slider)
end

CharacterCreate.add_default_barber_items = function (self, archetype_name)
	local barber_items = BARBER_ITEMS_BY_ARCHETYPE[archetype_name] or EMPTY_TABLE

	for slot, item_data in pairs(barber_items) do
		if not self:set_item_per_slot(slot, nil) then
			local item = MasterItems.get_item(item_data.item_name)

			self:set_item_per_slot(slot, item)
		end
	end
end

CharacterCreate._add_default_items = function (self, archetype_name)
	local character_creator_items = CHARACTER_CREATOR_ITEMS_BY_ARCHETYPE[archetype_name] or EMPTY_TABLE

	for slot, item_data in pairs(character_creator_items) do
		if not self:set_item_per_slot(slot, nil) then
			local item = MasterItems.get_item(item_data.item_name)

			self:set_item_per_slot(slot, item)
		end
	end
end

CharacterCreate._remove_default_items = function (self, archetype_name)
	local character_creator_items = CHARACTER_CREATOR_ITEMS_BY_ARCHETYPE[archetype_name] or EMPTY_TABLE

	for slot in pairs(character_creator_items) do
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

		local personality_option = self:_random_personality_option()

		self:set_personality(personality_option)
	else
		self:randomize_character_apperance_preset()
	end

	self:_increase_value_version("gender")
end

CharacterCreate.set_archetype = function (self, archetype)
	local previous_archetype = self._profile.archetype

	self._profile.archetype = archetype

	self:_increase_value_version("archetype")

	local breed_name = archetype.breed

	self:_set_breed(breed_name)

	if previous_archetype ~= archetype then
		self:_randomize_archetype_properties()

		local previous_default_data = previous_archetype and DEFAULT_PROFILE_DATA_BY_ARCHETYPE[previous_archetype.name] or EMPTY_TABLE

		for field_name, default_value in pairs(previous_default_data) do
			self._profile[field_name] = nil
		end

		local default_data = DEFAULT_PROFILE_DATA_BY_ARCHETYPE[archetype.name] or EMPTY_TABLE

		for field_name, default_value in pairs(default_data) do
			self._profile[field_name] = type(default_value) == "table" and table.clone(default_value) or default_value
		end

		if previous_archetype then
			self:_remove_default_items(previous_archetype.name)
		end

		self:_add_default_items(archetype.name)
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

CharacterCreate.fetch_suggested_names_by_profile = function (self)
	self._archetype_random_names = {}
	self._companion_random_names = {}

	local archetype_name = self._profile.archetype.name
	local gender = self:gender()
	local planet_option = self:planet()
	local planet_id = planet_option.id

	return Managers.data_service.profiles:fetch_suggested_names_by_archetype(archetype_name, gender, planet_id):next(function (result)
		self._archetype_random_names = result.character
		self._companion_random_names = result.companion
	end)
end

CharacterCreate.shelve_item_per_slot = function (self, slot_name, replacement_item_or_nil)
	local profile = self._profile
	local archetype_name = profile.archetype.name
	local gender = profile.gender
	local item_to_shelve = self._profile.loadout[slot_name]

	if item_to_shelve then
		self._shelved_gender_loadout = self._shelved_gender_loadout or {}
		self._shelved_gender_loadout[archetype_name] = self._shelved_gender_loadout[archetype_name] or {}
		self._shelved_gender_loadout[archetype_name][gender] = self._shelved_gender_loadout[archetype_name][gender] or {}
		self._shelved_gender_loadout[archetype_name][gender][slot_name] = item_to_shelve

		self:set_item_per_slot(slot_name, replacement_item_or_nil)
	end
end

CharacterCreate.try_unshelve_item_per_slot = function (self, slot_name)
	local profile = self._profile
	local archetype_name = profile.archetype.name
	local gender = profile.gender

	if self._shelved_gender_loadout and self._shelved_gender_loadout[archetype_name] then
		local shelf = self._shelved_gender_loadout[archetype_name][gender]
		local item = shelf and shelf[slot_name]

		if item then
			self:set_item_per_slot(slot_name, item)

			shelf[slot_name] = nil
		end
	end
end

CharacterCreate.shelved_item = function (self, slot_name)
	local profile = self._profile
	local archetype_name = profile.archetype.name
	local gender = profile.gender

	if self._shelved_gender_loadout and self._shelved_gender_loadout[archetype_name] then
		local shelf = self._shelved_gender_loadout[archetype_name][gender]
		local item = shelf and shelf[slot_name]

		if item then
			return item
		end
	end
end

CharacterCreate.set_item_per_slot = function (self, slot_name, item)
	local profile = self._profile
	local loadout = profile.loadout
	local can_be_empty = CAN_USE_EMPTY_ITEM[slot_name]

	if item and item.is_nil_item then
		item = nil
	end

	if (not item or table.is_empty(item)) and not can_be_empty then
		local available_items = self:slot_item_options(slot_name)
		local fallback_index = table.find_by_key(available_items, "is_fallback_item", true) or 1

		item = available_items[fallback_index] or MasterItems.find_fallback_item(slot_name)
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
		slot_name,
	})
end

CharacterCreate.set_item_per_slot_preview = function (self, slot_name, item, profile)
	local loadout = profile.loadout

	loadout[slot_name] = item

	self:_increase_value_version({
		"inventory",
		slot_name,
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

CharacterCreate.voice_options = function (self)
	return Voices
end

CharacterCreate.set_voice_effect = function (self, effect_id, amount)
	if not self._profile.voice_effects then
		return
	end

	self._profile.voice_effects[effect_id] = amount
end

CharacterCreate.voice_effects = function (self)
	return self._profile.voice_effects
end

CharacterCreate._random_personality_option = function (self)
	local personality_options = self:personality_options()
	local available_options = self:_filter_options_by_restrictions(personality_options)
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

CharacterCreate._random_childhood_option = function (self)
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

CharacterCreate._random_growing_up_option = function (self)
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

CharacterCreate._random_formative_event_option = function (self)
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

CharacterCreate._random_planet_option = function (self)
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
end

CharacterCreate.randomize_name = function (self)
	local names = self._archetype_random_names
	local num_names = self._archetype_random_names and #names or 0

	if num_names == 0 then
		return ""
	end

	local random_name_index = math.random(1, #names)

	return self._archetype_random_names[random_name_index]
end

CharacterCreate.randomize_companion_name = function (self)
	local names = self._companion_random_names
	local num_names = self._companion_random_names and #names or 0

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

CharacterCreate._random_crime_option = function (self)
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

local EMPTY_SLOT_ITEM_OPTIONS = {}

CharacterCreate.slot_item_options = function (self, slot_name)
	local profile = self._profile
	local archetype = profile.archetype
	local archetype_name = archetype.name
	local breed = profile.archetype.breed
	local gender = profile.gender
	local items = self._item_categories[archetype_name] and self._item_categories[archetype_name][breed] and self._item_categories[archetype_name][breed][gender] and self._item_categories[archetype_name][breed][gender][slot_name]

	return items or EMPTY_SLOT_ITEM_OPTIONS
end

CharacterCreate.set_gear_visible = function (self, visible)
	local profile = self._profile
	local archetype = profile.archetype
	local archetype_name = archetype.name
	local character_creator_items = CHARACTER_CREATOR_ITEMS_BY_ARCHETYPE[archetype_name] or EMPTY_TABLE

	if not visible then
		for slot_name, slot_settings in pairs(ItemSlotSettings) do
			if slot_settings.slot_type == "gear" and not character_creator_items[slot_name] then
				self:shelve_item_per_slot(slot_name)
			end
		end
	elseif visible then
		for slot_name, slot_settings in pairs(ItemSlotSettings) do
			if slot_settings.slot_type == "gear" and not character_creator_items[slot_name] then
				self:try_unshelve_item_per_slot(slot_name)
			end
		end
	end
end

CharacterCreate.check_name = function (self, name)
	local profiles_service = Managers.data_service.profiles
	local archetype = self._profile.archetype.name

	return profiles_service:check_name(name, nil, archetype)
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
	new_profile.career = {}

	local new_loadout = {}

	new_profile.inventory = new_loadout
	new_profile.loadout = nil

	for slot_name, item in pairs(profile.loadout) do
		if item and not table.is_empty(item) then
			new_loadout[slot_name] = {
				id = item.name,
			}
		end
	end

	for slot_name, valid_backends in pairs(VALID_BACKENDS_BY_SLOT) do
		if not valid_backends[BACKEND_ENV] then
			new_loadout[slot_name] = nil
		end
	end

	local character_creator_items = CHARACTER_CREATOR_ITEMS_BY_ARCHETYPE[profile.archetype.name] or EMPTY_TABLE

	for slot_name, item_data in pairs(character_creator_items) do
		if new_loadout[slot_name] and new_loadout[slot_name].id == item_data.item_name and item_data.character_creator_only then
			new_loadout[slot_name] = nil
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

CharacterCreate._add_backstory_items = function (self)
	local backstory = self._profile.lore.backstory
	local item_definitions = self._item_definitions
	local items = {}

	for backstory_field, option_id in pairs(backstory) do
		local option_settings = BACKSTORY_FIELD_TO_OPTIONS[backstory_field]
		local option = option_settings[option_id]
		local slot_items = option and option.slot_items

		if slot_items then
			for slot_name, item_name in pairs(slot_items) do
				if items[slot_name] then
					ferror("Multiple options add items in the same slot (%s). Tried to add '%s' while already having '%s'", slot_name, item_name, items[slot_name].id)
				end

				local item = item_definitions[item_name]

				items[slot_name] = {
					id = item.name,
				}
			end
		end
	end

	return items
end

CharacterCreate.filter_changed_items = function (self, real_profile)
	local original_loadout = real_profile.loadout
	local filtered_items = {}
	local new_loadout = self._profile.loadout
	local identical = true

	for slot_name, valid_backends in pairs(VALID_BACKENDS_BY_SLOT) do
		if not valid_backends[BACKEND_ENV] then
			new_loadout[slot_name] = nil

			if original_loadout[slot_name] then
				identical = false
			end
		end
	end

	local ignored_slots = CHARACTER_CREATOR_ITEMS_BY_ARCHETYPE[real_profile.archetype.name] or EMPTY_TABLE

	for slot_name, item in pairs(new_loadout) do
		local original_item = original_loadout[slot_name]
		local item_name = item.name
		local original_item_name = original_item and original_item.name
		local ignore_slot = (ignored_slots[slot_name] or EMPTY_TABLE).character_creator_only

		if item_name ~= original_item_name and not ignore_slot then
			filtered_items[slot_name] = item
			identical = false
		end
	end

	if not identical then
		return filtered_items
	end
end

CharacterCreate.has_modifications = function (self, real_profile, whitelist)
	local use_height = false
	local use_loadout = false
	local use_voice = false
	local use_backstory = false
	local use_name = false
	local use_companion_name = false
	local use_voice_effects = false

	if whitelist then
		for i = 1, #whitelist do
			local whitelist_id = whitelist[i]

			if whitelist_id == "loadout" then
				use_loadout = true
			elseif whitelist_id == "voice" then
				use_voice = true
			elseif whitelist_id == "backstory" then
				use_backstory = true
			elseif whitelist_id == "height" then
				use_height = true
			elseif whitelist_id == "name" then
				use_name = true
			elseif whitelist_id == "companion_name" then
				use_companion_name = true
			elseif whitelist_id == "voice_effects" then
				use_voice_effects = true
			end
		end
	else
		use_height = true
		use_loadout = true
		use_voice = true
		use_backstory = true
		use_name = true
		use_companion_name = true
		use_voice_effects = true
	end

	local transformed_voice = false
	local transformed_name = false
	local transformed_companion_name = false
	local transformed_loadout = false
	local transformed_height = false
	local transformed_backstory = false
	local transformed_voice_effects = false

	if use_voice then
		local voice = self._profile.selected_voice
		local real_voice = real_profile.selected_voice

		transformed_voice = voice ~= real_voice
	end

	if use_name then
		local name = self._profile.name
		local real_name = real_profile.name

		transformed_name = name ~= real_name
	end

	if use_companion_name then
		local companion = self._profile.companion

		if companion then
			local companion_name = companion.name
			local real_companion_name = real_profile.companion.name

			transformed_companion_name = companion_name ~= real_companion_name
		end
	end

	if use_height then
		local height = self._character_height
		local real_height = real_profile.personal.character_height

		transformed_height = real_height < height - 0.001 or real_height > height + 0.001
	end

	if use_loadout then
		transformed_loadout = not not self:filter_changed_items(real_profile)
	end

	if use_backstory then
		local backstory = self._profile.lore.backstory
		local real_backstory = real_profile.lore.backstory
		local equal_backstory = table.equals(backstory, real_backstory)

		transformed_backstory = not equal_backstory
	end

	if use_voice_effects then
		local voice_effects = self._profile.voice_effects

		if voice_effects then
			local real_voice_effects = real_profile.voice_effects
			local equal_voice_effects = table.equals(voice_effects, real_voice_effects)

			transformed_voice_effects = not equal_voice_effects
		end
	end

	return transformed_voice or transformed_name or transformed_loadout or transformed_height or transformed_backstory or transformed_companion_name or transformed_voice_effects
end

CharacterCreate.transform = function (self, character_id, operation_cost)
	self._transformation_complete = {}

	local parsed_profile = self:_generate_backend_profile()

	parsed_profile.id = nil
	parsed_profile.archetype = nil
	parsed_profile.abilities = nil
	parsed_profile.career = nil
	parsed_profile.inventory.slot_animation_end_of_round = nil

	local backstory_items = self:_add_backstory_items()

	for slot_id, item_data in pairs(backstory_items) do
		parsed_profile.inventory[slot_id] = item_data
	end

	local promise = Managers.data_service.profiles:transform_character(character_id, parsed_profile, operation_cost)
	local granted_gear_items_by_slot = {}

	promise:next(function (items)
		if self._destroyed then
			return
		end

		local relevant_gear_slots = {}

		if items then
			for i = 1, #items do
				local item = items[i]
				local slot = item.slots and item.slots[1]

				if ItemSlotSettings[slot].equipped_in_inventory then
					granted_gear_items_by_slot[slot] = item
					relevant_gear_slots[#relevant_gear_slots + 1] = slot
				end
			end
		end

		local player = Managers.player:local_player(1)
		local character_id = player:character_id()

		return Managers.data_service.gear:fetch_inventory(character_id, relevant_gear_slots)
	end):next(function (gear_inventory_items)
		if self._destroyed then
			return
		end

		self:_replace_invalid_items_in_loadouts(granted_gear_items_by_slot, gear_inventory_items, parsed_profile)
		self:reload_real_character()

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

		Managers.connection:send_rpc_server("rpc_notify_profile_changed", local_player_id)
	end
end

CharacterCreate._get_current_backstory_items_ids = function (self, backstory_items)
	local backstory = self._profile.lore.backstory
	local items = {}

	for backstory_field, option_id in pairs(backstory) do
		local option_settings = BACKSTORY_FIELD_TO_OPTIONS[backstory_field]
		local option = option_settings[option_id]
		local slot_items = option and option.slot_items

		if slot_items then
			for slot_name, setting_item_name in pairs(slot_items) do
				for backstory_item_name, id in pairs(backstory_items) do
					if setting_item_name == backstory_item_name then
						items[slot_name] = id
					end
				end
			end
		end
	end

	return items
end

CharacterCreate._item_valid_by_current_profile = function (self, item, parsed_profile)
	local player = Managers.player:local_player(1)
	local profile = player:profile()
	local archetype = profile.archetype
	local lore = profile.lore
	local backstory = lore.backstory

	if parsed_profile then
		lore = parsed_profile.lore
		backstory = lore.backstory
	end

	local crime = CrimesCompabilityMapping[backstory.crime] or backstory.crime
	local archetype_name = archetype.name
	local breed_name = archetype.breed
	local breed_valid = not item.breeds or table.is_empty(item.breeds) or table.contains(item.breeds, breed_name)
	local crime_valid = not item.crimes or table.is_empty(item.crimes) or table.contains(item.crimes, crime)
	local archetype_valid = not item.archetypes or table.is_empty(item.archetypes) or table.contains(item.archetypes, archetype_name)

	if archetype_valid and breed_valid and crime_valid then
		return true
	end

	return false
end

CharacterCreate._replace_invalid_items_in_loadouts = function (self, granted_items, inventory_items, parsed_profile)
	local profile_presets = ProfileUtils.get_profile_presets()

	if profile_presets then
		for i = 1, #profile_presets do
			local profile_preset = profile_presets[i]
			local preset_loadout = profile_preset.loadout

			for slot, preset_item_id in pairs(preset_loadout) do
				local granted_item_data = granted_items[slot]
				local granted_item_id = granted_item_data and granted_item_data.uuid

				if granted_item_id then
					local preset_item = math.is_uuid(preset_item_id) and inventory_items[preset_item_id] or MasterItems.get_item(preset_item_id)
					local item_valid = preset_item and self:_item_valid_by_current_profile(preset_item, parsed_profile)

					if not item_valid then
						ProfileUtils.save_item_id_for_profile_preset(profile_preset.id, slot, granted_item_id)
					end
				end
			end
		end
	end

	local player = Managers.player:local_player(1)
	local profile = player:profile()
	local loadout = profile.loadout

	for slot, profile_item in pairs(loadout) do
		local granted_item_data = granted_items[slot]
		local granted_item = granted_item_data and inventory_items[granted_item_data.uuid]

		if granted_item then
			local item_valid = profile_item and profile_item.gear_id and math.is_uuid(profile_item.gear_id) and inventory_items[profile_item.gear_id] and self:_item_valid_by_current_profile(inventory_items[profile_item.gear_id], parsed_profile)

			if not item_valid then
				ItemUtils.equip_item_in_slot(slot, granted_item)
			end
		end
	end
end

CharacterCreate.created_character_profile = function (self)
	return self._created_profile
end

function _is_fallback_item(slot, item_name)
	for ii = 1, #FALLBACK_SLOTS_TO_STRIP do
		local fallback_slot = FALLBACK_SLOTS_TO_STRIP[ii]

		if slot == fallback_slot then
			local fallback_item = MasterItems.find_fallback_item_id(slot)

			return fallback_item == item_name
		end
	end

	return false
end

return CharacterCreate
