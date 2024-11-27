-- chunkname: @scripts/ui/views/report_player_view/report_player_view_blueprints.lua

local DropdownPassTemplates = require("scripts/ui/pass_templates/dropdown_pass_templates")
local ReportPlayerViewSettings = require("scripts/ui/views/report_player_view/report_player_view_settings")
local TextInputPassTemplates = require("scripts/ui/pass_templates/text_input_pass_templates")
local blueprints = {
	dropdown = {
		size = ReportPlayerViewSettings.dropdown_size,
		pass_template_function = function (size, num_options)
			size = size or ReportPlayerViewSettings.dropdown_size

			return DropdownPassTemplates.settings_dropdown(size[1], size[2], size[1] - 400, num_options, false)
		end,
		init = function (parent, widget, element)
			local max_visible_options = 5
			local DEFAULT_NUM_DECIMALS = 0
			local size = ReportPlayerViewSettings.dropdown_size
			local options = element.options or element.options_function and element.options_function()
			local num_options = #options
			local num_visible_options = math.min(num_options, max_visible_options)
			local content = widget.content
			local display_name = element.display_name or "loc_settings_option_unavailable"

			content.text = Localize(display_name)
			content.entry = element

			local has_options_function = element.options_function ~= nil
			local has_dynamic_contents = element.has_dynamic_contents

			content.num_visible_options = num_visible_options

			local optional_num_decimals = element.optional_num_decimals
			local number_format = string.format("%%.%sf", optional_num_decimals or DEFAULT_NUM_DECIMALS)
			local options_by_id = {}

			for index, option in pairs(options) do
				options_by_id[option.id] = option
			end

			content.number_format = number_format
			content.options_by_id = options_by_id
			content.options = options

			content.hotspot.pressed_callback = function ()
				local is_disabled = element.disabled or false

				if is_disabled then
					return
				end

				local selected_widget
				local selected = true

				content.exclusive_focus = selected

				local hotspot = content.hotspot or content.button_hotspot

				if hotspot then
					hotspot.is_selected = selected
				end

				if not element.ignore_focus and parent._set_exclusive_focus_on_grid_widget then
					local widget_name = widget.name

					selected_widget = parent:_set_exclusive_focus_on_grid_widget(widget_name)
					selected_widget.offset[3] = selected_widget and 90 or 0
				end
			end

			content.area_length = size[2] * num_visible_options

			local scroll_length = math.max(size[2] * num_options - content.area_length, 0)

			content.scroll_length = scroll_length

			local spacing = 0
			local scroll_amount = scroll_length > 0 and (size[2] + spacing) / scroll_length or 0

			content.scroll_amount = scroll_amount

			element.changed_callback = function (changed_value)
				element:on_changed(changed_value, element)
			end
		end,
		update = function (parent, widget, input_service)
			local content = widget.content
			local entry = content.entry

			if content.close_setting then
				content.close_setting = nil
				content.exclusive_focus = false

				local hotspot = content.hotspot or content.button_hotspot

				if hotspot then
					hotspot.is_selected = false
				end

				return
			end

			local is_disabled = entry.disabled or false

			content.disabled = is_disabled

			local size = {
				400,
				50,
			}
			local using_gamepad = not Managers.ui:using_cursor_navigation()
			local offset = widget.offset
			local style = widget.style
			local options = content.options
			local options_by_id = content.options_by_id
			local num_visible_options = content.num_visible_options
			local num_options = #options
			local focused = content.exclusive_focus and not is_disabled

			if focused then
				offset[3] = 90
			else
				offset[3] = 0
			end

			local selected_index = content.selected_index
			local value, new_value
			local hotspot = content.hotspot
			local hotspot_style = style.hotspot

			if selected_index and focused then
				if using_gamepad and hotspot.on_pressed then
					new_value = options[selected_index].id
				end

				hotspot_style.on_pressed_sound = hotspot_style.on_pressed_fold_in_sound
			else
				hotspot_style.on_pressed_sound = hotspot_style.on_pressed_fold_out_sound
			end

			if entry.get_function then
				value = entry.get_function(entry)
			else
				value = content.internal_value or "<not selected>"
			end

			local localization_manager = Managers.localization
			local preview_option = options_by_id[value]
			local preview_option_id = preview_option and preview_option.id
			local preview_value = preview_option and preview_option.display_name or "loc_settings_option_unavailable"
			local ignore_localization = preview_option and preview_option.ignore_localization

			content.value_text = ignore_localization and preview_value or localization_manager:localize(preview_value)

			local always_keep_order = true
			local grow_downwards = true

			content.grow_downwards = grow_downwards

			local new_selection_index

			if not selected_index or not focused then
				for i = 1, #options do
					local option = options[i]

					if option.id == preview_option_id then
						selected_index = i

						break
					end
				end

				selected_index = selected_index or 1
			end

			if selected_index and focused then
				if input_service:get("navigate_up_continuous") then
					if grow_downwards or not grow_downwards and always_keep_order then
						new_selection_index = math.max(selected_index - 1, 1)
					else
						new_selection_index = math.min(selected_index + 1, num_options)
					end
				elseif input_service:get("navigate_down_continuous") then
					if grow_downwards or not grow_downwards and always_keep_order then
						new_selection_index = math.min(selected_index + 1, num_options)
					else
						new_selection_index = math.max(selected_index - 1, 1)
					end
				end
			end

			if new_selection_index or not content.selected_index then
				if new_selection_index then
					selected_index = new_selection_index
				end

				if num_visible_options < num_options then
					local step_size = 1 / num_options
					local new_scroll_percentage = math.min(selected_index - 1, num_options) * step_size

					content.scroll_percentage = new_scroll_percentage
					content.scroll_add = nil
				end

				content.selected_index = selected_index
			end

			local scroll_percentage = content.scroll_percentage

			if scroll_percentage then
				local step_size = 1 / (num_options - (num_visible_options - 1))

				content.start_index = math.max(1, math.ceil(scroll_percentage / step_size))
			end

			local option_hovered = false
			local option_index = 1
			local start_index = content.start_index or 1
			local end_index = math.min(start_index + num_visible_options - 1, num_options)
			local using_scrollbar = num_visible_options < num_options

			for i = start_index, end_index do
				local actual_i = i

				if not grow_downwards and always_keep_order then
					actual_i = end_index - i + start_index
				end

				local option_text_id = "option_text_" .. option_index
				local option_hotspot_id = "option_hotspot_" .. option_index
				local outline_style_id = "outline_" .. option_index
				local option_hotspot = content[option_hotspot_id]

				option_hovered = option_hovered or option_hotspot.is_hover
				option_hotspot.is_selected = actual_i == selected_index

				local option = options[actual_i]

				if option_hotspot.on_pressed then
					option_hotspot.on_pressed = nil
					new_value = option.id
					content.selected_index = actual_i
				end

				local option_display_name = option.display_name
				local option_ignore_localization = option.ignore_localization

				content[option_text_id] = option_ignore_localization and option_display_name or localization_manager:localize(option_display_name)

				local options_y = size[2] * option_index

				style[option_hotspot_id].offset[2] = grow_downwards and options_y or -options_y
				style[option_text_id].offset[2] = grow_downwards and options_y or -options_y

				local entry_length = using_scrollbar and size[1] - style.scrollbar_hotspot.size[1] or size[1]

				style[outline_style_id].size[1] = entry_length
				style[option_text_id].size[1] = size[1]
				option_index = option_index + 1
			end

			local value_changed = new_value ~= nil

			if value_changed and new_value ~= value then
				local on_activated = entry.on_activated

				on_activated(new_value, entry)
			end

			local scrollbar_hotspot = content.scrollbar_hotspot
			local scrollbar_hovered = scrollbar_hotspot.is_hover

			if (input_service:get("left_pressed") or input_service:get("confirm_pressed") or input_service:get("back")) and content.exclusive_focus and not content.wait_next_frame then
				content.wait_next_frame = true

				return
			end

			if content.wait_next_frame then
				content.wait_next_frame = nil
				content.close_setting = true

				return
			end
		end,
	},
	comment_input_text = {
		size = ReportPlayerViewSettings.comment_input_size,
		pass_template_function = function (size)
			local pass_template = TextInputPassTemplates.terminal_input_field

			return pass_template
		end,
		init = function (parent, widget, initial_text, element)
			local content = widget.content

			content.input_text = ""
			content.max_length = 256
			content.virtual_keyboard_title = initial_text

			local hotspot = content.hotspot

			content.entry = element
		end,
		update = function (parent, widget)
			local content = widget.content

			parent._report_details = content.input_text

			if content.selected_text and not content.is_writing then
				content.selected_text = nil
				content._selection_start = nil
				content._selection_end = nil
			end
		end,
	},
}

return blueprints
