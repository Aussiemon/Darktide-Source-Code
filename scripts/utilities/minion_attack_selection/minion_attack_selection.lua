-- chunkname: @scripts/utilities/minion_attack_selection/minion_attack_selection.lua

local MinionAttackSelectionTemplates = require("scripts/settings/minion_attack_selection/minion_attack_selection_templates")
local MinionAttackSelection = {}
local TEMP_CATEGORY_ATTACK_ENTRIES, TEMP_CATEGORIES = {}, {}

MinionAttackSelection.generate = function (attack_selection_template_name, initial_random_seed)
	local attack_selection_template = MinionAttackSelectionTemplates[attack_selection_template_name]
	local selected_attack_names, used_weapon_slot_names, random_seed = {}, {}, initial_random_seed

	table.merge_recursive(TEMP_CATEGORY_ATTACK_ENTRIES, attack_selection_template.categories)

	local amount_from_category = attack_selection_template.amount_from_category

	if amount_from_category then
		local category_keys = table.keys(amount_from_category)

		table.sort(category_keys)

		for category_index = 1, #category_keys do
			local category = category_keys[category_index]
			local amount = amount_from_category[category]
			local entries = TEMP_CATEGORY_ATTACK_ENTRIES[category]
			local num_entries = #entries

			for i = 1, amount do
				random_seed, num_entries = MinionAttackSelection._select_and_remove_random_attack(random_seed, entries, num_entries, selected_attack_names, used_weapon_slot_names)
			end
		end
	end

	local multi_selection = attack_selection_template.multi_selection

	if multi_selection then
		table.merge_array(TEMP_CATEGORIES, multi_selection.categories)

		local amount, num_categories, category_index = multi_selection.amount, #TEMP_CATEGORIES

		for i = 1, amount do
			random_seed, category_index = math.next_random(random_seed, num_categories)

			local category = TEMP_CATEGORIES[category_index]
			local entries = TEMP_CATEGORY_ATTACK_ENTRIES[category]
			local num_entries = #entries

			random_seed, num_entries = MinionAttackSelection._select_and_remove_random_attack(random_seed, entries, num_entries, selected_attack_names, used_weapon_slot_names)

			if num_entries == 0 then
				table.swap_delete(TEMP_CATEGORIES, category_index)

				num_categories = num_categories - 1
			end
		end

		table.clear_array(TEMP_CATEGORIES, num_categories)
	end

	for _, entries in pairs(TEMP_CATEGORY_ATTACK_ENTRIES) do
		table.clear_array(entries, #entries)
	end

	return selected_attack_names, used_weapon_slot_names
end

MinionAttackSelection._select_and_remove_random_attack = function (random_seed, entries, num_entries, selected_attack_names, used_weapon_slot_names)
	local attack_random_seed, entry_index = math.next_random(random_seed, num_entries)
	local entry_data = entries[entry_index]
	local required_weapon_slot_name = entry_data.required_weapon_slot_name

	if required_weapon_slot_name then
		used_weapon_slot_names[required_weapon_slot_name] = true
	end

	local attack_names = entry_data.attack_names
	local num_attack_names = #attack_names
	local new_random_seed, attack_index = math.next_random(attack_random_seed, num_attack_names)
	local attack_name = attack_names[attack_index]

	selected_attack_names[attack_name] = true

	table.swap_delete(attack_names, attack_index)

	num_attack_names = num_attack_names - 1

	if num_attack_names == 0 then
		table.swap_delete(entries, entry_index)

		num_entries = num_entries - 1
	end

	return new_random_seed, num_entries
end

local TEMP_MATCHED_TEMPLATES = {}

MinionAttackSelection.match_template_by_tag = function (attack_selection_templates, tag)
	local matched_index = 0

	for i = 1, #attack_selection_templates do
		local template = attack_selection_templates[i]
		local template_tag = template.tag

		if template_tag == tag then
			matched_index = matched_index + 1
			TEMP_MATCHED_TEMPLATES[matched_index] = template
		end
	end

	if matched_index > 0 then
		local num_temp_matched_templates = matched_index
		local chosen_index = math.random(num_temp_matched_templates)
		local chosen_template = TEMP_MATCHED_TEMPLATES[chosen_index]
		local chosen_template_name = chosen_template.name

		table.clear_array(TEMP_MATCHED_TEMPLATES, num_temp_matched_templates)

		return chosen_template_name, chosen_template
	else
		return nil, nil
	end
end

return MinionAttackSelection
