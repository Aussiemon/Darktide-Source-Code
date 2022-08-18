local Breed = require("scripts/utilities/breed")
local MinionAttackSelection = require("scripts/utilities/minion_attack_selection/minion_attack_selection")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local stagger_types = StaggerSettings.stagger_types
local optional_stagger_types = StaggerSettings.optional_stagger_types
local ALLOWED_BREED_PATTERN = "%s_allowed"
local ATTACK_SELECTION_TEMPLATE_OVERRIDE_PATTERN = "%s_attack_selection_template_override"
local CUSTOM_ATTACK_NAME_PATTERN = "%s_custom_attack_selection_%s"
local TEMP_MISSING_ENTRIES = {}

local function _init_and_run_tests(breeds)
	local player_character_breeds = {}

	for breed_name, breed_data in pairs(breeds) do
		if Breed.is_player(breed_data) then
			player_character_breeds[breed_name] = true
		end
	end

	local running_from_batch = rawget(_G, "arg") ~= nil

	for breed_name, breed_data in pairs(breeds) do
		local breed_type = breed_data.breed_type

		fassert(breed_type ~= nil, "[BreedsTest] Breed: %q is missing 'breed_type' entry", breed_name)

		local target_breed_items = breed_data.target_breed_items

		if target_breed_items then
			for name, data in pairs(target_breed_items) do
				for player_breed_name, _ in pairs(player_character_breeds) do
					fassert(data[player_breed_name] ~= nil, "[BreedsTest] Breed: %q has missing %s target_breed_items entry for %s.", breed_name, name, player_breed_name)
				end
			end
		end

		local attack_selection_templates = breed_data.attack_selection_templates

		if attack_selection_templates then
			local default_template_name = MinionAttackSelection.match_template_by_tag(attack_selection_templates, "default")

			fassert(default_template_name ~= nil, "[BreedsTest] Breed %q is missing a default attack selection template.", breed_name)

			if not running_from_batch then
				local dev_parameter_name = string.format(ATTACK_SELECTION_TEMPLATE_OVERRIDE_PATTERN, breed_name)

				fassert(DevParameters[dev_parameter_name] ~= nil, "[BreedsTest] Breed: %q is missing the dev parameter %s.", breed_name, dev_parameter_name)
			end
		end

		local blackboard_component_config = breed_data.blackboard_component_config

		if blackboard_component_config then
			local available_attacks_fields = blackboard_component_config.available_attacks

			if available_attacks_fields and not running_from_batch then
				local num_missing_dev_parameters = 0

				for field_name, _ in pairs(available_attacks_fields) do
					local dev_parameter_name = string.format(CUSTOM_ATTACK_NAME_PATTERN, breed_name, field_name)

					if DevParameters[dev_parameter_name] == nil then
						num_missing_dev_parameters = num_missing_dev_parameters + 1
						TEMP_MISSING_ENTRIES[num_missing_dev_parameters] = dev_parameter_name
					end
				end

				table.sort(TEMP_MISSING_ENTRIES)

				local missing_dev_parameters_string = table.concat(TEMP_MISSING_ENTRIES, "\n\t")

				fassert(num_missing_dev_parameters == 0, "[BreedsTest] Breed: %q is missing the following dev parameters:\n\t%s", breed_name, missing_dev_parameters_string)
				table.clear_array(TEMP_MISSING_ENTRIES, num_missing_dev_parameters)
			end
		end

		local stagger_durations = breed_data.stagger_durations

		if stagger_durations then
			local num_missing_stagger_types = 0

			for stagger_type, _ in pairs(stagger_types) do
				if not stagger_durations[stagger_type] and not optional_stagger_types[stagger_type] then
					num_missing_stagger_types = num_missing_stagger_types + 1
					TEMP_MISSING_ENTRIES[num_missing_stagger_types] = stagger_type
				end
			end

			table.sort(TEMP_MISSING_ENTRIES)

			local missing_stagger_types_string = table.concat(TEMP_MISSING_ENTRIES, "\n\t")

			fassert(num_missing_stagger_types == 0, "[BreedsTest] Breed: %q is missing stagger_duration entries for the following stagger types:\n\t%s", breed_name, missing_stagger_types_string)
			table.clear_array(TEMP_MISSING_ENTRIES, num_missing_stagger_types)
		end

		if Breed.is_minion(breed_data) then
			local target_selection_template = breed_data.target_selection_template

			fassert(target_selection_template, "[BreedsTest] Breed: %q is a not a player breed but is missing target_selection_template", breed_name)

			local target_selection_weights = breed_data.target_selection_weights

			fassert(target_selection_weights, "[BreedsTest] Breed: %q is a not a player breed but is missing target_selection_weights", breed_name)
			fassert((target_selection_weights.max_distance and target_selection_weights.max_distance < math.huge) or breed_data.detection_radius < math.huge, "[BreedsTest] Breed: %q has invalid target selection distsance usage. Ensure that 'target_selection_template.max_distance' is set or that 'breed.detection_radius' is not math.huge", breed_name)

			if breed_data.tags.special and not running_from_batch then
				local dev_parameter_name = string.format(ALLOWED_BREED_PATTERN, breed_name)

				fassert(DevParameters[dev_parameter_name] ~= nil, "[BreedsTest] Breed: %q is missing the dev parameter %s.", breed_name, dev_parameter_name)
			end
		end
	end
end

return _init_and_run_tests
