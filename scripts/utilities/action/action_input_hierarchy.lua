-- chunkname: @scripts/utilities/action/action_input_hierarchy.lua

local ActionInputHierarchy = {}

ActionInputHierarchy.update_hierarchy_entry = function (hierarchy, target_input, new_transition)
	local target_index

	for ii, entry in ipairs(hierarchy) do
		if entry.input == target_input then
			target_index = ii

			break
		end
	end

	local new_entry = {
		input = target_input,
		transition = new_transition
	}

	if target_index then
		hierarchy[target_index] = new_entry
	else
		table.insert(hierarchy, #hierarchy + 1, new_entry)
	end
end

ActionInputHierarchy.find_hierarchy_transition = function (hierarchy, action_input)
	for _, entry in ipairs(hierarchy) do
		if entry.input == action_input then
			return entry.transition
		end
	end

	return nil
end

ActionInputHierarchy.find_hierarchy_entry = function (hierarchy, action_input)
	for _, entry in ipairs(hierarchy) do
		if entry.input == action_input then
			return entry
		end
	end

	return nil
end

ActionInputHierarchy.add_missing = function (dest, source)
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

return ActionInputHierarchy
