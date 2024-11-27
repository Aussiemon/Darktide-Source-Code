-- chunkname: @scripts/utilities/weapon/action_input_hierarchy.lua

local ActionInputHierarchyUtils = {}

ActionInputHierarchyUtils.update_hierarchy_entry = function (hierarchy, target_input, new_transition)
	local target_index

	for i, entry in ipairs(hierarchy) do
		if entry.input == target_input then
			target_index = i

			break
		end
	end

	local new_entry = {
		input = target_input,
		transition = new_transition,
	}

	if target_index then
		hierarchy[target_index] = new_entry
	else
		table.insert(hierarchy, #hierarchy + 1, new_entry)
	end
end

ActionInputHierarchyUtils.find_hierarchy_transition = function (hierarchy, action_input)
	for _, entry in ipairs(hierarchy) do
		if entry.input == action_input then
			return entry.transition
		end
	end

	return nil
end

ActionInputHierarchyUtils.find_hierarchy_entry = function (hierarchy, action_input)
	for _, entry in ipairs(hierarchy) do
		if entry.input == action_input then
			return entry
		end
	end

	return nil
end

ActionInputHierarchyUtils.get_hierarchy_path_text = function (base_hierarchy, hierarchy_position, max_depth, no_action_input)
	local text = ""
	local current_level = base_hierarchy

	for i = 1, max_depth do
		local pos = hierarchy_position[i]

		if pos == no_action_input then
			break
		end

		for _, entry in ipairs(current_level) do
			if entry.input == pos then
				text = string.format("%s %s", text, entry.input)
				current_level = entry.transition

				break
			end
		end
	end

	return text
end

ActionInputHierarchyUtils.add_missing_ordered = function (dest, source)
	local existing_keys = {}

	for _, entry in ipairs(dest) do
		existing_keys[entry.input] = true
	end

	for _, entry in ipairs(source) do
		if not existing_keys[entry.input] then
			table.insert(dest, entry)
		end
	end

	return dest
end

return ActionInputHierarchyUtils
