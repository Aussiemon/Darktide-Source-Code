local WidgetUtilities = require("scripts/managers/imgui/widgets/imgui_widget_utilities")
local ImguiInputWidgets = {}
local DEFAULT_NUM_DECIMALS = 0
local DEFAULT_INPUT_FIELD_WIDTH = 100
ImguiInputWidgets.debug_mission_input = require("scripts/managers/imgui/widgets/imgui_debug_mission_widget")
ImguiInputWidgets.checkbox = {
	new = function (display_name, get_value, on_value_changed)
		return {
			type = "checkbox",
			label = WidgetUtilities.create_unique_label(),
			display_name = display_name,
			get_value = get_value,
			on_value_changed = on_value_changed
		}
	end,
	render = function (widget)
		local label = widget.label
		local value = widget.get_value()
		local on_value_changed = widget.on_value_changed
		local new_value = Imgui.checkbox(label, value)
		local is_focused = Imgui.is_item_focused()
		local is_active = false

		if is_focused and Imgui.is_key_pressed(Imgui.KEY_RIGHT_ARROW) then
			WidgetUtilities.activate_widget(label)
		end

		if new_value ~= value then
			on_value_changed(new_value, value)
		end

		return is_focused, is_active
	end
}
ImguiInputWidgets.number_input = {
	new = function (display_name, get_value, on_value_changed, optional_num_decimals, optional_width)
		return {
			type = "number_input",
			label = WidgetUtilities.create_unique_label(),
			display_name = display_name,
			get_value = get_value,
			on_value_changed = on_value_changed,
			format = string.format("%%.%sf", optional_num_decimals or DEFAULT_NUM_DECIMALS),
			width = optional_width or DEFAULT_INPUT_FIELD_WIDTH
		}
	end,
	render = function (widget)
		local label = widget.label
		local value = widget.get_value()
		local on_value_changed = widget.on_value_changed
		local format = widget.format
		local width = widget.width

		Imgui.push_item_width(width)

		local new_value, enter_pressed = Imgui.input_float(label, value, format)
		local is_active = Imgui.is_item_active()
		local is_focused = Imgui.is_item_focused() or is_active

		if is_focused and not is_active and Imgui.is_key_pressed(Imgui.KEY_RIGHT_ARROW) then
			WidgetUtilities.activate_widget(label)
		end

		Imgui.pop_item_width()

		if enter_pressed then
			on_value_changed(tonumber(string.format(format, new_value)), value)
		end

		return is_focused, is_active
	end
}
ImguiInputWidgets.text_input = {
	new = function (display_name, get_value, on_value_changed, return_value_on_enter, optional_width)
		return {
			type = "text_input",
			label = WidgetUtilities.create_unique_label(),
			display_name = display_name,
			get_value = get_value,
			on_value_changed = on_value_changed,
			return_value_on_enter = return_value_on_enter,
			width = optional_width or DEFAULT_INPUT_FIELD_WIDTH
		}
	end,
	render = function (widget)
		local label = widget.label
		local value = widget.get_value()
		local on_value_changed = widget.on_value_changed
		local return_value_on_enter = widget.return_value_on_enter
		local width = widget.width

		Imgui.push_item_width(width)

		local new_value, enter_pressed = Imgui.input_text(label, value)
		local is_active = Imgui.is_item_active()
		local is_focused = Imgui.is_item_focused() or is_active

		if is_focused and not is_active and Imgui.is_key_pressed(Imgui.KEY_RIGHT_ARROW) then
			WidgetUtilities.activate_widget(label)
		end

		Imgui.pop_item_width()

		if (return_value_on_enter and enter_pressed) or value ~= new_value then
			on_value_changed(tostring(new_value), value)
		end

		return is_focused, is_active
	end
}
ImguiInputWidgets.vector3 = {
	new = function (display_name, button_text, on_activated, optional_width)
		return {
			type = "vector3",
			label = WidgetUtilities.create_unique_label(),
			label_button = WidgetUtilities.create_unique_label(button_text),
			display_name = display_name,
			on_activated = on_activated,
			teleport_target = {
				z = 0,
				x = 0,
				y = 0
			},
			width = optional_width or DEFAULT_INPUT_FIELD_WIDTH
		}
	end,
	render = function (widget)
		local label = widget.label
		local label_button = widget.label_button
		local on_activated = widget.on_activated
		local width = widget.width
		local target = widget.teleport_target

		Imgui.push_item_width(width)

		local x, y, z = Imgui.input_float_3(label, target.x, target.y, target.z)
		widget.teleport_target.x = x
		widget.teleport_target.y = y
		widget.teleport_target.z = z

		Imgui.same_line(10)

		if Imgui.button(label_button) then
			on_activated(Vector3(tonumber(x), tonumber(y), tonumber(z)))
		end

		local is_focused = Imgui.is_item_focused()
		local is_active = false

		if is_focused and Imgui.is_key_pressed(Imgui.KEY_RIGHT_ARROW) then
			WidgetUtilities.activate_widget(label_button)
		end

		Imgui.pop_item_width()

		return is_focused, is_active
	end
}
ImguiInputWidgets.dropdown = {
	new = function (display_name, get_value, options, on_value_changed, optional_num_decimals, has_dynamic_contents)
		local options_texts = {}
		local number_format, options_values, width = ImguiInputWidgets.dropdown._refresh_contents(display_name, options_texts, options, optional_num_decimals, has_dynamic_contents)

		return {
			type = "dropdown",
			label = WidgetUtilities.create_unique_label(),
			display_name = display_name,
			get_value = get_value,
			on_value_changed = on_value_changed,
			options = options,
			options_texts = options_texts,
			options_values = options_values,
			number_format = number_format,
			width = width,
			has_dynamic_contents = has_dynamic_contents
		}
	end,
	_refresh_contents = function (display_name, options_texts, options, optional_num_decimals, has_dynamic_contents)
		local has_options_function = type(options) == "function"

		fassert(not has_dynamic_contents or has_options_function, "%q can't have dynamic contents and static options list.", display_name)

		local number_format = string.format("%%.%sf", optional_num_decimals or DEFAULT_NUM_DECIMALS)
		local options_values = (has_options_function and options()) or options

		for i = 1, #options_values, 1 do
			options_texts[i] = WidgetUtilities.dropdown_value_to_string(options_values[i], number_format)
		end

		local max_text_width, _ = WidgetUtilities.calculate_max_text_size(options_texts)
		local width = math.max(max_text_width, Imgui.calculate_text_size("<not selected>")) + 40

		return number_format, options_values, width
	end,
	render = function (widget)
		if widget.has_dynamic_contents then
			local texts = widget.options_texts

			table.clear(texts)

			local number_format, options_values, width = ImguiInputWidgets.dropdown._refresh_contents(widget.display_name, widget.options_texts, widget.options, widget.optional_num_decimals, widget.has_dynamic_contents)
			widget.number_format = number_format
			widget.options_values = options_values
			widget.width = width
		end

		local label = widget.label
		local value = nil
		value = (not widget.get_value or widget.get_value()) and (widget.internal_value or "<not selected>")
		local on_value_changed = widget.on_value_changed
		local options_texts = widget.options_texts
		local options_values = widget.options_values
		local number_format = widget.number_format
		local width = widget.width

		Imgui.push_item_width(width)

		local preview_value = WidgetUtilities.dropdown_value_to_string(value, number_format)
		local is_active = Imgui.begin_combo(label, preview_value)
		local is_focused = Imgui.is_item_focused() or is_active

		if is_focused and not is_active and Imgui.is_key_pressed(Imgui.KEY_RIGHT_ARROW) then
			Imgui.activate_item(Imgui.get_id(label))
		end

		local new_value = nil

		if is_active then
			local focused_value = nil

			for i = 1, #options_values, 1 do
				local opt_text = options_texts[i]
				local opt_value = options_values[i]
				local selected = false

				if type(opt_value) == "number" then
					selected = opt_text == preview_value
				else
					selected = opt_value == value
				end

				if Imgui.selectable(opt_text, selected) then
					new_value = opt_value
				end

				if Imgui.is_item_focused() then
					focused_value = opt_value
				end
			end

			Imgui.end_combo()

			if focused_value ~= nil and Imgui.is_key_pressed(Imgui.KEY_RIGHT_ARROW) then
				new_value = focused_value

				WidgetUtilities.focus_widget(label)
			elseif Imgui.is_key_pressed(Imgui.KEY_LEFT_ARROW) then
				WidgetUtilities.focus_widget(label)
			end
		end

		Imgui.pop_item_width()

		if new_value ~= nil and new_value ~= value then
			if widget.internal_value then
				widget.internal_value = new_value
			end

			on_value_changed(new_value, value)
		end

		return is_focused, is_active
	end
}
ImguiInputWidgets.readonly = {
	new = function (display_name, get_value)
		return {
			type = "readonly",
			label = WidgetUtilities.create_unique_label(),
			display_name = display_name,
			get_value = get_value
		}
	end,
	render = function (widget)
		local value = widget.get_value()

		Imgui.text(tostring(value))

		return false, false
	end
}
ImguiInputWidgets.function_button = {
	new = function (display_name, button_text, on_activated)
		return {
			type = "function_button",
			label = WidgetUtilities.create_unique_label(button_text),
			display_name = display_name,
			on_activated = on_activated
		}
	end,
	render = function (widget)
		local label = widget.label
		local on_activated = widget.on_activated

		if Imgui.button(label) then
			on_activated()
		end

		local is_focused = Imgui.is_item_focused()
		local is_active = false

		if is_focused and Imgui.is_key_pressed(Imgui.KEY_RIGHT_ARROW) then
			WidgetUtilities.activate_widget(label)
		end

		return is_focused, is_active
	end
}
ImguiInputWidgets.number_button = {
	new = function (display_name, button_text, on_activated, optional_num_decimals, optional_width)
		return {
			value = 0,
			type = "number_button",
			label = WidgetUtilities.create_unique_label(),
			label_button = WidgetUtilities.create_unique_label(button_text),
			display_name = display_name,
			on_activated = on_activated,
			format = string.format("%%.%sf", optional_num_decimals or DEFAULT_NUM_DECIMALS),
			width = optional_width or DEFAULT_INPUT_FIELD_WIDTH
		}
	end,
	render = function (widget)
		local label = widget.label
		local label_button = widget.label_button
		local on_activated = widget.on_activated
		local width = widget.width
		local current_value = widget.value
		local format = widget.format

		Imgui.push_item_width(width)

		local new_value = Imgui.input_float(label, current_value, format)
		widget.value = new_value

		Imgui.same_line(10)

		if Imgui.button(label_button) then
			on_activated(tonumber(new_value))
		end

		local is_focused = Imgui.is_item_focused()
		local is_active = false

		if is_focused and Imgui.is_key_pressed(Imgui.KEY_RIGHT_ARROW) then
			WidgetUtilities.activate_widget(label_button)
		end

		Imgui.pop_item_width()

		return is_focused, is_active
	end
}

ImguiInputWidgets.render = function (widget)
	local is_focused, is_active = ImguiInputWidgets[widget.type].render(widget)

	if is_focused and not widget.is_focused then
		WidgetUtilities.scroll_last_item_into_view()
	end

	widget.is_focused = is_focused
	widget.is_active = is_active
end

return ImguiInputWidgets
