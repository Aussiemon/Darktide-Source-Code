local OptionsViewSettings = require("scripts/ui/views/options_view/options_view_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local DropdownPassTemplates = require("scripts/ui/pass_templates/dropdown_pass_templates")
local CheckboxPassTemplates = require("scripts/ui/pass_templates/checkbox_pass_templates")
local SliderPassTemplates = require("scripts/ui/pass_templates/slider_pass_templates")
local KeybindPassTemplates = require("scripts/ui/pass_templates/keybind_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local InputUtils = require("scripts/managers/input/input_utils")
local grid_size = OptionsViewSettings.grid_size
local grid_width = grid_size[1]
local settings_grid_width = 1000
local settings_value_width = 500
local settings_value_height = 64
local group_header_height = 80
local DEFAULT_NUM_DECIMALS = 0
local value_font_style = table.clone(UIFontSettings.list_button)
value_font_style.offset = {
	settings_grid_width - settings_value_width + 25,
	0,
	8
}
local description_font_style = table.clone(UIFontSettings.list_button)
description_font_style.offset = {
	25,
	0,
	3
}
local header_font_style = table.clone(UIFontSettings.header_2)
header_font_style.text_vertical_alignment = "bottom"
local blueprints = {
	spacing_vertical = {
		size = {
			grid_width,
			20
		}
	},
	settings_button = {
		size = {
			grid_width,
			settings_value_height
		},
		pass_template = ButtonPassTemplates.list_button_with_icon,
		init = function (parent, widget, entry, callback_name, changed_callback_name)
			local content = widget.content
			local hotspot = content.hotspot

			hotspot.pressed_callback = function ()
				local is_disabled = entry.disabled or false

				if is_disabled then
					return
				end

				callback(parent, callback_name, widget, entry)()
			end

			local display_name = entry.display_name
			content.text = Managers.localization:localize(display_name)
			content.icon = entry.icon
			content.entry = entry
		end
	},
	button = {
		size = {
			settings_grid_width,
			settings_value_height
		},
		pass_template = ButtonPassTemplates.settings_button(settings_grid_width, settings_value_height, settings_value_width, true),
		init = function (parent, widget, entry, callback_name, changed_callback_name)
			local content = widget.content

			content.hotspot.pressed_callback = function ()
				local is_disabled = entry.disabled or false

				if is_disabled then
					return
				end

				callback(parent, callback_name, widget, entry)()
			end

			local display_name = entry.display_name
			content.text = Managers.localization:localize(display_name)
			content.button_text = Localize("loc_settings_change")
			content.entry = entry

			entry.changed_callback = function (changed_value)
				callback(parent, changed_callback_name, widget, entry)()
			end
		end
	},
	group_header = {
		size = {
			settings_grid_width,
			group_header_height
		},
		pass_template = {
			{
				pass_type = "text",
				value_id = "text",
				style = header_font_style,
				value = Localize("loc_settings_option_unavailable")
			}
		},
		init = function (parent, widget, entry, callback_name, changed_callback_name)
			local content = widget.content
			local display_name = entry.display_name
			content.text = Managers.localization:localize(display_name)
		end
	},
	checkbox = {
		size = {
			settings_grid_width,
			settings_value_height
		},
		pass_template_function = function (parent, config, size)
			return CheckboxPassTemplates.settings_checkbox(size[1], settings_value_height, settings_value_width, 2, true)
		end,
		init = function (parent, widget, entry, callback_name, changed_callback_name)
			local content = widget.content
			local display_name = entry.display_name or "loc_settings_option_unavailable"
			content.text = Managers.localization:localize(display_name)
			content.entry = entry

			for i = 1, 2 do
				local widget_option_id = "option_" .. i
				content[widget_option_id] = i == 1 and Managers.localization:localize("loc_setting_checkbox_on") or Managers.localization:localize("loc_setting_checkbox_off")
			end

			entry.changed_callback = function (changed_value)
				callback(parent, callback_name, widget, entry)()
				callback(parent, changed_callback_name, widget, entry)()
			end
		end,
		update = function (parent, widget, input_service, dt, t)
			local content = widget.content
			local entry = content.entry
			local value = entry:get_function()
			local on_activated = entry.on_activated
			local pass_input = true
			local hotspot = content.hotspot
			local is_disabled = entry.disabled or false
			content.disabled = is_disabled
			local new_value = nil

			if hotspot.on_pressed and not parent._navigation_column_changed_this_frame and not is_disabled then
				new_value = not value
			end

			for i = 1, 2 do
				local widget_option_id = "option_hotspot_" .. i
				local option_hotspot = content[widget_option_id]
				local is_selected = value and i == 1 or not value and i == 2
				option_hotspot.is_selected = is_selected
			end

			if new_value ~= nil and new_value ~= value then
				on_activated(new_value, entry)
			end
		end
	}
}

local function slider_init_function(parent, widget, entry, callback_name, changed_callback_name)
	local content = widget.content
	local display_name = entry.display_name or "loc_settings_option_unavailable"
	content.text = Managers.localization:localize(display_name)
	content.entry = entry
	content.area_length = settings_value_width
	content.step_size = entry.normalized_step_size

	if not entry.normalized_step_size and entry.step_size_value then
		local value_range = entry.max_value - entry.min_value
		content.step_size = entry.step_size_value / value_range
	end

	content.apply_on_drag = entry.apply_on_drag and true
	local get_function = entry.get_function
	local value = get_function(entry)
	content.previous_slider_value = value
	content.slider_value = value

	entry.pressed_callback = function ()
		local is_disabled = entry.is_disabled

		if is_disabled then
			return
		end

		callback(parent, callback_name, widget, entry)()
	end

	entry.changed_callback = function (changed_value)
		callback(parent, changed_callback_name, widget, entry)()
	end
end

blueprints.percent_slider = {
	size = {
		settings_grid_width,
		settings_value_height
	},
	pass_template_function = function (parent, config, size)
		return SliderPassTemplates.settings_percent_slider(size[1], settings_value_height, settings_value_width, true)
	end,
	init = function (parent, widget, entry, callback_name, changed_callback_name)
		slider_init_function(parent, widget, entry, callback_name, changed_callback_name)
	end,
	update = function (parent, widget, input_service, dt, t)
		local content = widget.content
		local entry = content.entry
		local pass_input = true
		local is_disabled = entry.disabled or false
		content.disabled = is_disabled
		local using_gamepad = not parent:using_cursor_navigation()
		local get_function = entry.get_function
		local value = get_function(entry) / 100
		local on_activated = entry.on_activated
		local format_value_function = entry.format_value_function
		local drag_value, new_value = nil
		local apply_on_drag = content.apply_on_drag and not is_disabled
		local drag_active = content.drag_active and not is_disabled
		local focused = using_gamepad and content.exclusive_focus and not is_disabled

		if drag_active or focused then
			if not parent._selected_settings_widget then
				parent:set_exclusive_focus_on_grid_widget(widget.name)
			end

			local slider_value = content.slider_value
			drag_value = slider_value or get_function(entry) / 100
		elseif not focused then
			local previous_slider_value = content.previous_slider_value
			local slider_value = content.slider_value

			if content.drag_previously_active then
				parent:set_exclusive_focus_on_grid_widget(nil)

				if previous_slider_value ~= slider_value then
					new_value = slider_value
					drag_value = new_value or get_function(entry) / 100
				end
			elseif value ~= slider_value then
				content.slider_value = value
				content.previous_slider_value = value
				content.scroll_add = nil
			end

			content.previous_slider_value = slider_value
		end

		content.drag_previously_active = drag_active
		local display_value = format_value_function((drag_value or value) * 100)

		if display_value then
			content.value_text = display_value
		end

		local hotspot = content.hotspot

		if hotspot.on_pressed and not is_disabled then
			if focused then
				new_value = content.slider_value
			elseif using_gamepad and entry.pressed_callback then
				entry.pressed_callback()
			end
		end

		if focused and parent:can_exit() then
			parent:set_can_exit(false)
		end

		if apply_on_drag and drag_value and not new_value and content.slider_value ~= content.previous_slider_value then
			new_value = content.slider_value
		end

		if new_value then
			on_activated(new_value * 100, entry)

			content.slider_value = new_value
			content.previous_slider_value = new_value
			content.scroll_add = nil
		end

		return pass_input
	end
}
blueprints.value_slider = {
	size = {
		settings_grid_width,
		settings_value_height
	},
	pass_template_function = function (parent, config, size)
		return SliderPassTemplates.settings_value_slider(size[1], settings_value_height, settings_value_width, true)
	end,
	init = function (parent, widget, entry, callback_name, changed_callback_name)
		slider_init_function(parent, widget, entry, callback_name, changed_callback_name)
	end,
	update = function (parent, widget, input_service, dt, t)
		local content = widget.content
		local entry = content.entry
		local pass_input = true
		local is_disabled = entry.disabled or false
		content.disabled = is_disabled
		local using_gamepad = not parent:using_cursor_navigation()
		local min_value = entry.min_value
		local max_value = entry.max_value
		local get_function = entry.get_function
		local explode_function = entry.explode_function
		local value = get_function(entry)
		local normalized_value = math.normalize_01(value, min_value, max_value)
		local on_activated = entry.on_activated
		local format_value_function = entry.format_value_function
		local drag_value, new_normalized_value = nil
		local apply_on_drag = content.apply_on_drag and not is_disabled
		local drag_active = content.drag_active and not is_disabled
		local drag_previously_active = content.drag_previously_active
		local focused = content.exclusive_focus and using_gamepad and not is_disabled

		if drag_active or focused then
			if not parent._selected_settings_widget then
				parent:set_exclusive_focus_on_grid_widget(widget.name)
			end

			local slider_value = content.slider_value
			drag_value = slider_value and explode_function(slider_value, entry) or get_function(entry)
		elseif not focused or drag_previously_active then
			local previous_slider_value = content.previous_slider_value
			local slider_value = content.slider_value

			if drag_previously_active then
				parent:set_exclusive_focus_on_grid_widget(nil)

				if previous_slider_value ~= slider_value then
					new_normalized_value = slider_value
					drag_value = slider_value and explode_function(slider_value, entry) or get_function(entry)
				end
			elseif normalized_value ~= slider_value then
				content.slider_value = normalized_value
				content.previous_slider_value = normalized_value
				content.scroll_add = nil
			end

			content.previous_slider_value = slider_value
		end

		content.drag_previously_active = drag_active
		local display_value = format_value_function(drag_value or value)

		if display_value then
			content.value_text = display_value
		end

		local hotspot = content.hotspot

		if hotspot.on_pressed then
			if focused then
				new_normalized_value = content.slider_value
			elseif using_gamepad and entry.pressed_callback then
				entry.pressed_callback()
			end
		end

		if focused and parent:can_exit() then
			parent:set_can_exit(false)
		end

		if apply_on_drag and drag_value and not new_normalized_value and content.slider_value ~= content.previous_slider_value then
			new_normalized_value = content.slider_value
		end

		if new_normalized_value then
			local new_value = explode_function(new_normalized_value, entry)

			on_activated(new_value, entry)

			content.slider_value = new_normalized_value
			content.previous_slider_value = new_normalized_value
			content.scroll_add = nil
		end

		return pass_input
	end
}
blueprints.slider = {
	size = {
		settings_grid_width,
		settings_value_height
	},
	pass_template_function = function (parent, config, size)
		return SliderPassTemplates.settings_value_slider(size[1], settings_value_height, settings_value_width, true)
	end,
	init = function (parent, widget, entry, callback_name, changed_callback_name)
		local content = widget.content
		local display_name = entry.display_name or "loc_settings_option_unavailable"
		content.text = Managers.localization:localize(display_name)
		content.entry = entry
		content.area_length = settings_value_width
		content.step_size = entry.step_size_fraction
		content.apply_on_drag = entry.apply_on_drag and true
		local get_function = entry.get_function
		local value, value_fraction = get_function(entry)
		content.previous_slider_value = value_fraction
		content.slider_value = value_fraction
		entry.pressed_callback = callback(parent, callback_name, widget, entry)

		entry.changed_callback = function (changed_value)
			callback(parent, changed_callback_name, widget, entry)()
		end
	end,
	update = function (parent, widget, input_service, dt, t)
		local content = widget.content
		local entry = content.entry
		local pass_input = true
		local is_disabled = entry.disabled or false
		content.disabled = is_disabled
		local using_gamepad = not parent:using_cursor_navigation()
		local get_function = entry.get_function
		local value, value_fraction = get_function(entry)
		local on_activated = entry.on_activated
		local format_value_function = entry.format_value_function
		local num_decimals = entry.num_decimals
		local drag_value, new_value_fraction = nil
		local apply_on_drag = entry.apply_on_drag and not is_disabled
		local drag_active = content.drag_active and not is_disabled
		local drag_previously_active = content.drag_previously_active
		local focused = content.exclusive_focus and using_gamepad and not is_disabled

		if drag_active or focused then
			drag_value = math.lerp(entry.min_value, entry.max_value, content.slider_value)
		elseif not focused or drag_previously_active then
			local previous_slider_value = content.previous_slider_value
			local slider_value = content.slider_value

			if drag_previously_active then
				if previous_slider_value ~= slider_value then
					new_value_fraction = slider_value
					drag_value = math.lerp(entry.min_value, entry.max_value, new_value_fraction)
				end
			elseif value_fraction ~= slider_value then
				content.slider_value = value_fraction
				content.previous_slider_value = value_fraction
				content.scroll_add = nil
			end

			content.previous_slider_value = slider_value
		end

		content.drag_previously_active = drag_active
		local display_value = nil

		if format_value_function then
			display_value = format_value_function(entry, drag_value or value)
		else
			local number_format = string.format("%%.%sf", num_decimals or DEFAULT_NUM_DECIMALS)
			display_value = string.format(number_format, drag_value or value)
		end

		if display_value then
			content.value_text = display_value
		end

		local hotspot = content.hotspot

		if hotspot.on_pressed and not is_disabled then
			if focused then
				new_value_fraction = content.slider_value
			elseif not hotspot.is_hover then
				entry.pressed_callback()
			end
		end

		if focused and parent:can_exit() then
			parent:set_can_exit(false)
		end

		if apply_on_drag and drag_value and not new_value_fraction and content.slider_value ~= content.previous_slider_value then
			new_value_fraction = content.slider_value
		end

		if new_value_fraction then
			local new_value = math.lerp(entry.min_value, entry.max_value, new_value_fraction)

			on_activated(new_value, entry)

			content.slider_value = new_value_fraction
			content.previous_slider_value = new_value_fraction
			content.scroll_add = nil
		end

		return pass_input
	end
}
local max_visible_options = OptionsViewSettings.max_visible_dropdown_options or 5
blueprints.dropdown = {
	size = {
		settings_grid_width,
		settings_value_height
	},
	pass_template_function = function (parent, entry, size)
		local has_options_function = entry.options_function ~= nil
		local has_dynamic_contents = entry.has_dynamic_contents
		local display_name = entry.display_name or "loc_settings_option_unavailable"
		local options = entry.options_function and entry.options_function() or entry.options
		local num_visible_options = math.min(#options, max_visible_options)

		return DropdownPassTemplates.settings_dropdown(size[1], settings_value_height, settings_value_width, num_visible_options, true)
	end,
	init = function (parent, widget, entry, callback_name, changed_callback_name)
		local content = widget.content
		local display_name = entry.display_name or "loc_settings_option_unavailable"
		content.text = Managers.localization:localize(display_name)
		content.entry = entry
		local has_options_function = entry.options_function ~= nil
		local has_dynamic_contents = entry.has_dynamic_contents
		local options = entry.options or entry.options_function and entry.options_function()
		local num_options = #options
		local num_visible_options = math.min(num_options, max_visible_options)
		content.num_visible_options = num_visible_options
		local optional_num_decimals = entry.optional_num_decimals
		local number_format = string.format("%%.%sf", optional_num_decimals or DEFAULT_NUM_DECIMALS)
		local options_by_id = {}

		for i = 1, num_options do
			local option = options[i]
			options_by_id[option.id] = option
		end

		content.number_format = number_format
		content.options_by_id = options_by_id
		content.options = options

		content.hotspot.pressed_callback = function ()
			local is_disabled = entry.disabled or false

			if is_disabled then
				return
			end

			callback(parent, callback_name, widget, entry)()
		end

		local widget_type = widget.type
		local template = blueprints[widget_type]
		local size = template.size
		content.area_length = size[2] * num_visible_options
		local scroll_length = math.max(size[2] * num_options - content.area_length, 0)
		content.scroll_length = scroll_length
		local spacing = 0
		local scroll_amount = scroll_length > 0 and (size[2] + spacing) / scroll_length or 0
		content.scroll_amount = scroll_amount
		local value = entry.get_function and entry:get_function() or entry.default_value

		entry.changed_callback = function (changed_value)
			callback(parent, changed_callback_name, widget, entry, changed_value)()
		end
	end,
	update = function (parent, widget, input_service, dt, t)
		local content = widget.content
		local entry = content.entry
		local pass_input = true
		local is_disabled = entry.disabled or false
		content.disabled = is_disabled
		local using_gamepad = not parent:using_cursor_navigation()
		local offset = widget.offset
		local style = widget.style
		local options = content.options
		local options_by_id = content.options_by_id
		local num_visible_options = content.num_visible_options
		local num_options = #options
		local focused = content.exclusive_focus and not is_disabled

		if focused and parent:can_exit() then
			content.selected_index = nil

			parent:set_can_exit(false)
		end

		local selected_index = content.selected_index
		local value, new_value = nil
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

		value = entry.get_function and entry:get_function() or content.internal_value or "<not selected>"
		local localization_manager = Managers.localization
		local preview_option = options_by_id[value]
		local preview_option_id = preview_option and preview_option.id
		local preview_value = preview_option and preview_option.display_name or "loc_settings_option_unavailable"
		local ignore_localization = preview_option and preview_option.ignore_localization
		content.value_text = ignore_localization and preview_value or localization_manager:localize(preview_value)
		local widget_type = widget.type
		local template = blueprints[widget_type]
		local size = template.size
		local scroll_amount = parent:settings_scroll_amount()
		local scroll_area_height = parent:settings_grid_length()
		local dropdown_length = size[2] * (num_visible_options + 1)
		local grow_downwards = true

		if scroll_area_height <= offset[2] - scroll_amount + dropdown_length then
			grow_downwards = false
		end

		content.grow_downwards = grow_downwards
		local new_selection_index = nil

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
				if grow_downwards then
					new_selection_index = math.max(selected_index - 1, 1)
				else
					new_selection_index = math.min(selected_index + 1, num_options)
				end
			elseif input_service:get("navigate_down_continuous") then
				if grow_downwards then
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
			local option_text_id = "option_text_" .. option_index
			local option_hotspot_id = "option_hotspot_" .. option_index
			local outline_style_id = "outline_" .. option_index
			local option_hotspot = content[option_hotspot_id]
			option_hovered = option_hovered or option_hotspot.is_hover
			option_hotspot.is_selected = i == selected_index
			local option = options[i]

			if not new_value and focused and not using_gamepad and option_hotspot.on_pressed then
				option_hotspot.on_pressed = nil
				new_value = option.id
				content.selected_index = i
			end

			local option_display_name = option.display_name
			local option_ignore_localization = option.ignore_localization
			content[option_text_id] = option_ignore_localization and option_display_name or localization_manager:localize(option_display_name)
			local options_y = size[2] * option_index
			style[option_hotspot_id].offset[2] = grow_downwards and options_y or -options_y
			style[option_text_id].offset[2] = grow_downwards and options_y or -options_y
			local entry_length = using_scrollbar and settings_value_width - style.scrollbar_hotspot.size[1] or settings_value_width
			style[outline_style_id].size[1] = entry_length
			style[option_text_id].size[1] = settings_value_width
			option_index = option_index + 1
		end

		local value_changed = new_value ~= nil

		if value_changed and new_value ~= value then
			local on_activated = entry.on_activated

			on_activated(new_value, entry)
		end

		local scrollbar_hotspot = content.scrollbar_hotspot
		local scrollbar_hovered = scrollbar_hotspot.is_hover
		pass_input = using_gamepad or value_changed or not option_hovered and not scrollbar_hovered

		return pass_input
	end
}
blueprints.keybind = {
	size = {
		settings_grid_width,
		settings_value_height
	},
	pass_template = KeybindPassTemplates.settings_keybind(settings_grid_width, settings_value_height, settings_value_width),
	init = function (parent, widget, entry, callback_name, changed_callback_name)
		local content = widget.content
		local display_name = entry.display_name or "loc_settings_option_unavailable"
		content.text = parent:_localize(display_name)
		content.entry = entry
		content.key_unassigned_string = Managers.localization:localize("loc_keybind_unassigned")
	end,
	update = function (parent, widget, input_service, dt, t)
		local content = widget.content
		local entry = content.entry
		local value = entry:get_function()
		local preview_value = value and InputUtils.localized_string_from_key_info(value) or content.key_unassigned_string
		content.value_text = preview_value
		local hotspot = content.hotspot

		if hotspot.on_released then
			parent:show_keybind_popup(widget, entry, content.entry.cancel_keys)
		end
	end
}
local description_font_style = table.clone(UIFontSettings.body_small)
description_font_style.offset = {
	25,
	0,
	3
}
description_font_style.text_horizontal_alignment = "left"
description_font_style.text_vertical_alignment = "center"
description_font_style.hover_text_color = Color.ui_brown_super_light(255, true)
blueprints.description = {
	size = {
		settings_grid_width - 225,
		settings_value_height
	},
	pass_template = {
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			style = description_font_style,
			value = Localize("loc_settings_option_unavailable")
		}
	},
	init = function (parent, widget, entry, callback_name)
		local content = widget.content
		local style = widget.style
		local text_style = style.text
		local display_name = entry.display_name
		local localized_text = Managers.localization:localize(display_name)
		local ui_renderer = parent._ui_renderer
		local size = content.size
		local text_options = UIFonts.get_font_options_by_style(text_style)
		local _, height = UIRenderer.text_size(ui_renderer, localized_text, text_style.font_type, text_style.font_size, size, text_options)
		size[2] = math.ceil(height)
		content.text = localized_text
	end,
	update = function (parent, widget, input_service, dt, t)
		return
	end
}

return settings("OptionsViewContentBlueprints", blueprints)
