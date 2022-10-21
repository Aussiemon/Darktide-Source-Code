local ImguiWidgetUtilities = {
	focus_widget = function (label)
		local id = Imgui.get_id(label)

		Imgui.nav_move_request_cancel()
		Imgui.focus_item(id)
	end,
	activate_widget = function (label)
		local id = Imgui.get_id(label)

		Imgui.activate_item(id)
	end,
	open_tree_node = function (label)
		local id = Imgui.get_id(label)

		Imgui.set_state_storage_integer(id, 1)
	end,
	close_tree_node = function (label)
		local id = Imgui.get_id(label)

		Imgui.set_state_storage_integer(id, 0)
	end,
	is_tree_node_open = function (label)
		local id = Imgui.get_id(label)
		local is_open = Imgui.get_state_storage_integer(id) == 1

		return is_open
	end,
	scroll_last_item_into_view = function ()
		local _, window_x = Imgui.get_window_pos()
		local _, item_min_y = Imgui.get_item_rect_min()

		if item_min_y < window_x + 20 then
			Imgui.set_scroll_here(0)
		else
			local _, window_h = Imgui.get_window_size()
			local _, item_max_y = Imgui.get_item_rect_max()

			if item_max_y > window_x + window_h - 5 then
				Imgui.set_scroll_here(1)
			end
		end
	end
}

ImguiWidgetUtilities.wrap_array = function (array, index, step)
	local size = #array
	local new_index = index + step

	if size < new_index then
		new_index = 1
	elseif new_index < 1 then
		new_index = size
	end

	return array[new_index]
end

ImguiWidgetUtilities.calculate_max_text_size = function (texts)
	local max_width = 0
	local max_height = 0

	for i = 1, #texts do
		local text = texts[i]
		local width, height = Imgui.calculate_text_size(tostring(text))

		if max_width < width then
			max_width = width
		end

		if max_height < height then
			max_height = height
		end
	end

	return max_width, max_height
end

ImguiWidgetUtilities.dropdown_value_to_string = function (value, number_format)
	local value_type = type(value)
	local result = nil

	if value_type == "number" then
		result = string.format(number_format, value)
	elseif value_type == "boolean" then
		result = tostring(value)
	elseif value_type == "table" then
		local str = "{"
		local size = #value

		for i = 1, size do
			local field_value = value[i]
			str = str .. ImguiWidgetUtilities.dropdown_value_to_string(field_value, number_format)

			if i ~= size then
				str = str .. ", "
			end
		end

		str = str .. "}"
		result = str
	else
		result = value
	end

	return result
end

ImguiWidgetUtilities.filter_functions = {
	match_substring = function (source_table, result_table, filter_string)
		filter_string = string.lower(filter_string)
		local initial_index = 1
		local use_plain_search = true
		local result_index = 1

		for i = 1, #source_table do
			local value = source_table[i]

			if string.find(string.lower(value), filter_string, initial_index, use_plain_search) then
				result_table[result_index] = value
				result_index = result_index + 1
			end
		end
	end,
	match_substring_replace_underscore = function (source_table, result_table, filter_string)
		filter_string = string.lower(filter_string)
		local initial_index = 1
		local use_plain_search = true
		local filter_table = {}
		local result_index = 1

		for i = 1, #source_table do
			local value = source_table[i]

			if string.find(string.lower(value), filter_string, initial_index, use_plain_search) then
				filter_table[value] = true
				result_table[result_index] = value
				result_index = result_index + 1
			end
		end

		filter_string = string.gsub(filter_string, " ", "_")

		for i = 1, #source_table do
			local value = source_table[i]

			if string.find(string.lower(value), filter_string, initial_index, use_plain_search) and not filter_table[value] then
				result_table[result_index] = value
				result_index = result_index + 1
			end
		end
	end
}

ImguiWidgetUtilities.filter_array = function (source_table, result_table, filter_string, filter_function)
	if filter_string == "" then
		for i = 1, #source_table do
			result_table[i] = source_table[i]
		end
	else
		filter_function(source_table, result_table, filter_string)
	end
end

ImguiWidgetUtilities.create_unique_label = function (optional_name)
	local name = optional_name or ""
	local id = tostring(math.random())
	local label = string.format("%s##%s", name, id)

	return label
end

return ImguiWidgetUtilities
