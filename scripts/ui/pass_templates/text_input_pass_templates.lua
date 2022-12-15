local ColorUtilities = require("scripts/utilities/ui/colors")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ChatSettings = require("scripts/ui/constant_elements/elements/chat/constant_element_chat_settings")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local _math_max = math.max
local _math_min = math.min
local _math_clamp = math.clamp
local _math_floor = math.floor
local _ui_renderer_text_size = UIRenderer.text_size
local _utf8_string_length = Utf8.string_length
local _utf8_sub_string = Utf8.sub_string
local _ellipsis = "…"
local _ellipsis_length = _utf8_string_length(_ellipsis)
local TextInputPassTemplates = {}

local function _crop_text_width(ui_renderer, text, max_width, last_start_position, caret_position, font_type, font_size)
	text = text or ""
	max_width = max_width > 0 and max_width or 0
	local original_text_length = _utf8_string_length(text)
	caret_position = caret_position or original_text_length + 1
	local prefix = ""
	local suffix = ""
	local start_index = 1
	local cropped_text = text
	local scale = ui_renderer.scale or 1
	local scaled_font_size = font_size
	local _1, _2, _3, caret_offset = _ui_renderer_text_size(ui_renderer, text, font_type, scaled_font_size)
	local ellipsis_width, _2, _3, ellipsis_caret = _ui_renderer_text_size(ui_renderer, _ellipsis, font_type, scaled_font_size)
	local actual_text_width = caret_offset[1]

	if actual_text_width > 0 and max_width < actual_text_width then
		start_index = last_start_position or start_index

		if caret_position <= start_index then
			start_index = _math_max(caret_position - 1, 1)
		end

		if start_index > 1 then
			prefix = _ellipsis
		end

		repeat
			local width_percent = 1 - (1 - (max_width - ellipsis_width) / actual_text_width) * 0.5
			local num_char = _utf8_string_length(cropped_text)
			local number_of_characters_to_show = _math_floor(num_char * width_percent)
			local last_index = start_index + number_of_characters_to_show - 1

			if original_text_length < last_index then
				last_index = original_text_length
			elseif last_index < caret_position - 1 then
				last_index = caret_position - 1
				start_index = last_index - number_of_characters_to_show + 1
			end

			if start_index > 1 then
				prefix = _ellipsis
			else
				prefix = ""
			end

			if last_index < original_text_length then
				suffix = _ellipsis
			else
				suffix = ""
			end

			cropped_text = _utf8_sub_string(text, start_index, last_index)
			_1, _2, _3, caret_offset = _ui_renderer_text_size(ui_renderer, prefix .. cropped_text .. suffix, font_type, scaled_font_size)
			actual_text_width = _math_floor(caret_offset[1])
		until actual_text_width <= max_width

		cropped_text = prefix .. cropped_text .. suffix
	end

	if caret_position <= original_text_length then
		local num_chars_before_caret_pos = caret_position - start_index

		if prefix == _ellipsis then
			num_chars_before_caret_pos = num_chars_before_caret_pos + _ellipsis_length
		end

		local text_til_caret_pos = _utf8_sub_string(cropped_text, 1, num_chars_before_caret_pos)
		_1, _2, _3, caret_offset = _ui_renderer_text_size(ui_renderer, text_til_caret_pos, font_type, scaled_font_size)
	end

	return cropped_text, caret_offset[1], start_index
end

local function _find_next_word(text, caret_position)
	caret_position = Utf8.find(text, "%s", caret_position)
	caret_position = caret_position or _utf8_string_length(text)

	return caret_position + 1
end

local function _find_prev_word(text, caret_position)
	local pos = 0
	local result = 1
	local text_length = _utf8_string_length(text)

	if text_length < caret_position then
		caret_position = text_length
	end

	while pos and pos < caret_position - 1 do
		pos = pos + 1
		result = pos
		pos = Utf8.find(text, "%s", pos)
	end

	return result
end

local function _insert_text(target, caret_position, text_to_insert, max_length)
	local text_length = _utf8_string_length(text_to_insert)

	if max_length then
		local target_length = _utf8_string_length(target)

		if max_length < target_length + text_length then
			text_length = max_length - target_length
			text_to_insert = Utf8.sub_string(text_to_insert, 1, _math_max(text_length, 0))
		end
	end

	if text_length > 0 then
		target = Utf8.string_insert(target, caret_position, text_to_insert)
		caret_position = caret_position + text_length
	end

	return target, caret_position
end

local function _remove_text(input_text, selection_start, selection_end, caret_position)
	local selection_length = selection_end - selection_start
	input_text = Utf8.string_remove(input_text, selection_start, selection_length)

	if caret_position then
		if selection_end <= caret_position then
			caret_position = caret_position - selection_length
		elseif selection_start <= caret_position then
			caret_position = selection_start
		end
	end

	return input_text, caret_position
end

local function _input_active_visibility_function(content, style)
	return content.is_writing
end

local function _placeholder_text_visibility_function(content, style)
	local input_text = content.input_text
	local has_input_text = input_text and input_text ~= ""
	local placeholder_text = content.placeholder_text
	local has_placeholder_text = placeholder_text and placeholder_text ~= ""

	return not content.is_writing and not has_input_text and has_placeholder_text
end

local function _selection_visibility_function(content, style)
	local selected_text = content.selected_text

	return selected_text and selected_text ~= ""
end

local text_input_base = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		change_function = function (hotspot_content, style)
			if PLATFORM == "xbs" then
				return
			end

			local content = hotspot_content.parent

			if hotspot_content.on_pressed then
				local is_writing = not content.is_writing

				if is_writing then
					local input_text = content.input_text
					local text_length = input_text and _utf8_string_length(input_text) or 0

					if input_text and text_length > 0 and not content.selected_text then
						content.input_text = ""
						content.selected_text = input_text
					end
				end

				content.is_writing = is_writing
			end
		end
	},
	{
		pass_type = "logic",
		value = function (pass, ui_renderer, ui_style, content, position, size)
			if not content.is_writing then
				return
			end

			local input_service = ui_renderer.input_service
			local caret_position = content.caret_position or 1
			local updated_input_text = content.input_text or ""
			local is_selecting = input_service:get("select_text")
			local last_input = nil

			if input_service:get("navigate_left_continuous") then
				if input_service:get("navigate_text_modifier") then
					caret_position = _find_prev_word(updated_input_text, caret_position)
				else
					caret_position = caret_position - 1
				end
			elseif input_service:get("navigate_right_continuous") then
				if input_service:get("navigate_text_modifier") then
					caret_position = _find_next_word(updated_input_text, caret_position)
				else
					caret_position = caret_position + 1
				end
			elseif input_service:get("navigate_beginning") then
				caret_position = 1
			elseif input_service:get("navigate_end") then
				caret_position = _utf8_string_length(updated_input_text) + 1
			elseif input_service:get("clipboard_paste") then
				local clipboard_text = Clipboard.get()

				if clipboard_text then
					local max_length = content.max_length
					updated_input_text, caret_position = _insert_text(updated_input_text, caret_position, clipboard_text, max_length)
					last_input = clipboard_text
				end
			elseif input_service:get("select_all_text") then
				content.selected_text = updated_input_text
				updated_input_text = ""
			else
				local keystrokes = Keyboard.keystrokes()

				for _, keystroke in ipairs(keystrokes) do
					is_selecting = false

					if type(keystroke) == "string" then
						updated_input_text = Utf8.string_insert(updated_input_text, caret_position, keystroke)
						caret_position = caret_position + 1
						last_input = last_input and last_input .. keystroke or keystroke
					elseif type(keystroke) == "number" then
						if keystroke == Keyboard.BACKSPACE then
							if #updated_input_text == 0 and content.close_on_backspace then
								content.is_writing = false
							elseif caret_position > 1 then
								caret_position = _math_max(caret_position - 1, 1)
								updated_input_text = Utf8.string_remove(updated_input_text, caret_position)
							end

							last_input = ""
						elseif keystroke == Keyboard.DELETE then
							if caret_position <= Utf8.string_length(updated_input_text) then
								updated_input_text = Utf8.string_remove(updated_input_text, caret_position)
							end

							last_input = ""
						end
					end
				end
			end

			if caret_position ~= content.caret_position then
				content._blink_time = 0
			end

			content.input_text = updated_input_text
			content.caret_position = caret_position
			content.last_input = last_input
			content._is_selecting = is_selecting
		end
	},
	{
		pass_type = "logic",
		value = function (pass, ui_renderer, ui_style, content, position, size)
			if PLATFORM ~= "xbs" then
				return
			end

			local hotspot = content.hotspot

			if hotspot.on_pressed then
				local is_writing = not content.is_writing

				if is_writing then
					local x_game_ui = XAsyncBlock.new_block()
					local title = content.virtual_keyboard_title or content.placeholder_text
					local description = content.virtual_keyboard_description or ""
					local input_text = content.input_text
					content.input_text = ""
					content.selected_text = input_text
					local max_length = content.max_length

					XGameUI.show_text_entry_async(x_game_ui, title, description, input_text, "default", max_length)
					Managers.xasync:wrap(x_game_ui, XAsyncBlock.release_block):next(function (async_block)
						local new_input_text = XGameUI.resolve_text_entry(async_block)
						local last_char = string.sub(new_input_text, #new_input_text)

						if last_char == " " then
							new_input_text = string.sub(new_input_text, 1, #new_input_text - 1)
						end

						content.input_text = new_input_text
						content.caret_position = _utf8_string_length(new_input_text)
						content.selected_text = nil
						content._selection_start = nil
						content._selection_end = nil
						content.is_writing = false
					end, function (hr_table)
						local hr = hr_table[1]

						if hr ~= HRESULT.E_ABORT then
							Log.warning("TextInputPassTemplates", "XBox virtual keyboard closed with 0x%x", hr)
						end

						content.selected_text = nil
						content._selection_start = nil
						content._selection_end = nil
						content.is_writing = false
					end)
				end

				content.is_writing = is_writing
			end
		end
	},
	{
		pass_type = "logic",
		value = function (pass, ui_renderer, ui_style, content, position, size)
			if not content.is_writing then
				return
			end

			local input_service = ui_renderer.input_service
			local input_text = content.input_text or ""
			local old_input_text = content._input_text or input_text
			local selected_text = content.selected_text
			local caret_position = content.caret_position or 1
			local old_caret_position = content._caret_position or caret_position
			local selection_start = content._selection_start
			local selection_end = content._selection_end
			local is_selecting = content._is_selecting
			local has_selection = selection_start and selection_end

			if has_selection and not is_selecting then
				local last_input = content.last_input
				content.last_input = nil
				local deselect = false

				if input_service:get("clipboard_copy") then
					Clipboard.put(selected_text)
				elseif input_service:get("clipboard_cut") then
					if Clipboard.put(selected_text) then
						input_text, caret_position = _remove_text(input_text, selection_start, selection_end, caret_position)
						deselect = true
					end
				elseif last_input and selection_start ~= selection_end then
					input_text, caret_position = _remove_text(old_input_text, selection_start, selection_end, old_caret_position)
					input_text, caret_position = _insert_text(input_text, caret_position, last_input)
					deselect = true
				elseif caret_position ~= old_caret_position then
					deselect = true
				end

				if deselect then
					content.input_text = input_text
					content.caret_position = caret_position
					content.selected_text = nil
					content._selection_start = nil
					content._selection_end = nil
					has_selection = false
					selected_text = nil
				end
			end

			if not has_selection and not is_selecting and not selected_text then
				return
			end

			if not has_selection then
				selection_start = caret_position
				selection_end = caret_position

				if selected_text then
					local input_text_original_length = _utf8_string_length(input_text)

					if caret_position > input_text_original_length + 1 then
						caret_position = input_text_original_length + 1
						selection_start = caret_position
					end

					input_text, caret_position = _insert_text(input_text, caret_position, selected_text)
					content.input_text = input_text
					content.caret_position = caret_position
					selection_end = caret_position
				end
			elseif selection_start == selection_end and input_text ~= old_input_text then
				content.selected_text = nil
				content._selection_start = nil
				content._selection_end = nil

				return
			elseif caret_position == old_caret_position then
				return
			elseif caret_position < selection_start or caret_position <= selection_end and old_caret_position < caret_position then
				selection_start = _math_max(caret_position, 1)
			elseif selection_start < caret_position or caret_position == selection_start and caret_position < old_caret_position then
				selection_end = _math_min(caret_position, _utf8_string_length(input_text) + 1)
			end

			selected_text = _utf8_sub_string(input_text, selection_start, selection_end - 1)
			content.selected_text = selected_text
			content._selection_start = selection_start
			content._selection_end = selection_end
			content._selection_changed = true

			Log.info("TextInputPasses", "Selected text: [%s]", selected_text)
		end
	},
	{
		pass_type = "logic",
		value = function (pass, ui_renderer, ui_style, content, position, size)
			local old_input_text = content._input_text
			local new_input_text = content.input_text
			local old_active_placeholder_text = content._active_placeholder_text
			local new_active_placeholder_text = content.active_placeholder_text
			local old_caret_position = content._caret_position
			local new_caret_position = content.caret_position
			local force_caret_update = content.force_caret_update
			local text_has_changed = new_input_text ~= old_input_text
			local placeholder_text_has_changed = new_active_placeholder_text ~= old_active_placeholder_text
			local caret_position_has_changed = new_caret_position ~= old_caret_position
			local text_length = new_input_text and _utf8_string_length(new_input_text) or 0

			if not text_has_changed and not placeholder_text_has_changed and not caret_position_has_changed and not force_caret_update then
				return
			elseif content.max_length and content.max_length < text_length then
				content.input_text = old_input_text

				return
			end

			new_caret_position = new_caret_position and _math_clamp(new_caret_position, 1, text_length + 1)
			local display_text_style = ui_style.parent.display_text
			local caret_style = ui_style.parent.input_caret
			local max_text_width = size[1] - 1

			if display_text_style.size_addition then
				max_text_width = max_text_width + display_text_style.size_addition[1]
			end

			local display_text, caret_offset, first_pos = _crop_text_width(ui_renderer, new_input_text, max_text_width, content._input_text_first_visible_pos, new_caret_position, display_text_style.font_type, display_text_style.font_size)
			content.caret_position = new_caret_position
			content._input_text = new_input_text
			content.display_text = display_text
			content._caret_position = new_caret_position
			content._input_text_first_visible_pos = first_pos
			content._active_placeholder_text = new_active_placeholder_text
			content.force_caret_update = nil
			caret_style.offset[1] = display_text_style.offset[1] + caret_offset
		end
	}
}
text_input_base[6] = {
	pass_type = "logic",
	value = function (pass, ui_renderer, ui_style, content, position, size)
		if not content._selection_changed then
			return
		end

		content._selection_changed = nil
		local selection_start = content._selection_start
		local selection_end = content._selection_end
		local display_text = content.display_text
		local display_text_style = ui_style.parent.display_text
		local first_visible_character_pos = content._input_text_first_visible_pos or 1

		if first_visible_character_pos > 1 then
			local offset = first_visible_character_pos - _ellipsis_length - 1
			selection_start = _math_max(selection_start - offset, 1)
			selection_end = selection_end - offset
		end

		local text_up_to_selection_start = _utf8_sub_string(display_text, 1, selection_start - 1)
		local _1, _2, _3, select_start_offset = _ui_renderer_text_size(ui_renderer, text_up_to_selection_start, display_text_style.font_type, display_text_style.font_size)
		local last_visible_character_pos = _utf8_string_length(display_text) + first_visible_character_pos

		if selection_end > last_visible_character_pos then
			selection_end = last_visible_character_pos
		end

		local visibly_selected_text = _utf8_sub_string(display_text, selection_start, selection_end - 1)
		local _1, _2, _3, selection_width = _ui_renderer_text_size(ui_renderer, visibly_selected_text, display_text_style.font_type, display_text_style.font_size)
		local selection_style = ui_style.parent.selection
		local selection_offset = selection_style.offset or {}
		local selection_size = selection_style.size or {}
		selection_offset[1] = display_text_style.offset[1] + select_start_offset[1]
		selection_size[1] = selection_width[1]
		selection_style.offset = selection_offset
		selection_style.size = selection_size
	end,
	visibility_function = _selection_visibility_function
}
local _simple_input_field_padding = 4
local _simple_input_text_style = table.clone(UIFontSettings.body)
_simple_input_text_style.text_color = Color.white(255, true)
_simple_input_text_style.size_addition = {
	-(_simple_input_field_padding * 2),
	-(_simple_input_field_padding * 2)
}
_simple_input_text_style.offset = {
	_simple_input_field_padding,
	_simple_input_field_padding,
	1
}
_simple_input_text_style.text_vertical_alignment = "center"
local _simple_input_placeholder_text_style = table.clone(_simple_input_text_style)
_simple_input_placeholder_text_style.text_color = Color.ui_grey_medium(200, true)
local _simple_input_limit_text_style = table.clone(_simple_input_text_style)
_simple_input_limit_text_style.text_horizontal_alignment = "right"
_simple_input_limit_text_style.text_color = Color.ui_grey_light(255, true)
_simple_input_limit_text_style.font_size = 18
TextInputPassTemplates.simple_input_field = table.clone(text_input_base)

table.append(TextInputPassTemplates.simple_input_field, {
	{
		style_id = "focused",
		pass_type = "rect",
		style = {
			color = Color.ui_terminal(255, true),
			size_addition = {
				2,
				2
			},
			offset = {
				-1,
				-1,
				-1
			}
		},
		visibility_function = function (content, style)
			local hotspot = content.hotspot

			return hotspot.use_is_focused and hotspot.is_focused or hotspot.is_selected
		end
	},
	{
		style_id = "background",
		pass_type = "rect",
		style = {
			color = {
				255,
				20,
				20,
				20
			}
		}
	},
	{
		style_id = "baseline",
		pass_type = "rect",
		style = {
			vertical_alignment = "bottom",
			color = Color.white(255, true),
			size = {
				nil,
				2
			}
		}
	},
	{
		value_id = "display_text",
		style_id = "display_text",
		pass_type = "text",
		value = "",
		style = _simple_input_text_style
	},
	{
		style_id = "input_caret",
		pass_type = "rect",
		style = {
			color = Color.white(255, true),
			offset = {
				0,
				_simple_input_field_padding,
				2
			},
			size = {
				2
			},
			size_addition = {
				0,
				-(_simple_input_field_padding * 2 + 4)
			}
		},
		visibility_function = _input_active_visibility_function,
		change_function = function (pass_content, style_data, animations, dt)
			local blink_time = (pass_content._blink_time or 0) + dt

			while blink_time > 1 do
				blink_time = blink_time - 1
			end

			style_data.color[1] = blink_time < 0.5 and 255 or 0
			pass_content._blink_time = blink_time
		end
	},
	{
		style_id = "selection",
		pass_type = "rect",
		style = {
			offset = {
				_simple_input_field_padding,
				_simple_input_field_padding,
				0
			},
			size_addition = {
				0,
				-(_simple_input_field_padding * 2 + 4)
			},
			color = {
				64,
				64,
				64,
				255
			}
		},
		visibility_function = _selection_visibility_function
	},
	{
		value_id = "placeholder_text",
		style_id = "active_placeholder",
		pass_type = "text",
		value = "",
		style = _simple_input_placeholder_text_style,
		visibility_function = _placeholder_text_visibility_function
	},
	{
		style_id = "limit_text",
		pass_type = "text",
		value = "",
		value_id = "limit_text",
		style = _simple_input_limit_text_style,
		change_function = function (content, style)
			local new_input_text = content.input_text
			local text_length = new_input_text and _utf8_string_length(new_input_text) or 0
			local max_length = content.max_length or 0
			content.limit_text = string.format("%d/%d", text_length, max_length)
		end,
		visibility_function = function (content, style)
			return not not content.max_length
		end
	}
})

local _terminal_input_field_padding = 4
local _terminal_input_text_style = table.clone(UIFontSettings.body)
_terminal_input_text_style.text_color = Color.terminal_text_header_selected(255, true)
_terminal_input_text_style.size_addition = {
	-(_terminal_input_field_padding * 2),
	-(_terminal_input_field_padding * 2)
}
_terminal_input_text_style.offset = {
	_terminal_input_field_padding,
	_terminal_input_field_padding,
	1
}
_terminal_input_text_style.text_vertical_alignment = "center"
local _terminal_input_placeholder_text_style = table.clone(_terminal_input_text_style)
_terminal_input_placeholder_text_style.text_color = Color.terminal_text_body_sub_header(255, true)
local _terminal_input_limit_text_style = table.clone(_terminal_input_text_style)
_terminal_input_limit_text_style.text_horizontal_alignment = "right"
_terminal_input_limit_text_style.text_color = Color.terminal_text_body_sub_header(255, true)
_terminal_input_limit_text_style.font_size = 18
TextInputPassTemplates.terminal_input_field = table.clone(text_input_base)

table.append(TextInputPassTemplates.terminal_input_field, {
	{
		style_id = "focused",
		pass_type = "rect",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = Color.ui_terminal(255, true),
			size_addition = {
				4,
				4
			},
			offset = {
				0,
				0,
				-1
			}
		},
		visibility_function = function (content, style)
			local hotspot = content.hotspot

			return hotspot.use_is_focused and hotspot.is_focused or hotspot.is_selected
		end
	},
	{
		style_id = "background",
		pass_type = "rect",
		style = {
			color = Color.terminal_grid_background(255, true)
		}
	},
	{
		style_id = "baseline",
		pass_type = "rect",
		style = {
			vertical_alignment = "bottom",
			color = Color.terminal_text_header(255, true),
			size = {
				nil,
				2
			}
		}
	},
	{
		value_id = "display_text",
		style_id = "display_text",
		pass_type = "text",
		value = "",
		style = _terminal_input_text_style
	},
	{
		style_id = "input_caret",
		pass_type = "rect",
		style = {
			color = Color.terminal_text_header(255, true),
			offset = {
				0,
				_simple_input_field_padding,
				2
			},
			size = {
				2
			},
			size_addition = {
				0,
				-(_simple_input_field_padding * 2 + 4)
			}
		},
		visibility_function = _input_active_visibility_function,
		change_function = function (pass_content, style_data, animations, dt)
			local blink_time = (pass_content._blink_time or 0) + dt

			while blink_time > 1 do
				blink_time = blink_time - 1
			end

			style_data.color[1] = blink_time < 0.5 and 255 or 0
			pass_content._blink_time = blink_time
		end
	},
	{
		style_id = "selection",
		pass_type = "rect",
		style = {
			offset = {
				_simple_input_field_padding,
				_simple_input_field_padding,
				0
			},
			size_addition = {
				0,
				-(_simple_input_field_padding * 2 + 4)
			},
			color = Color.terminal_frame_hover(255, true)
		},
		visibility_function = _selection_visibility_function
	},
	{
		value_id = "placeholder_text",
		style_id = "active_placeholder",
		pass_type = "text",
		value = "",
		style = _terminal_input_placeholder_text_style,
		visibility_function = _placeholder_text_visibility_function
	},
	{
		style_id = "limit_text",
		pass_type = "text",
		value = "",
		value_id = "limit_text",
		style = _terminal_input_limit_text_style,
		change_function = function (content, style)
			local new_input_text = content.input_text
			local text_length = new_input_text and _utf8_string_length(new_input_text) or 0
			local max_length = content.max_length or 0
			content.limit_text = string.format("%d/%d", text_length, max_length)
		end,
		visibility_function = function (content, style)
			return not not content.max_length
		end
	}
})

local input_text_style = table.clone(UIFontSettings.chat_input)
input_text_style.offset = {
	ChatSettings.window_margins[1],
	0,
	2
}
input_text_style.size_addition = {
	0,
	0
}
local input_caret_style = {
	vertical_alignment = "center",
	offset = {
		0,
		0,
		1
	},
	color = ChatSettings.insertion_caret_color,
	size = ChatSettings.insertion_caret_size
}
local input_frame_style = {
	vertical_alignment = "bottom",
	size = {
		nil,
		2
	},
	color = ChatSettings.insertion_caret_color
}
local placeholder_text_style = table.clone(input_text_style)
placeholder_text_style.base_offset = table.clone(input_text_style.offset)
placeholder_text_style.text_color = ChatSettings.input_text_idle_color
local placeholder_fade_time = ChatSettings.placeholder_fade_time
TextInputPassTemplates.chat_input_field = table.clone(text_input_base)

table.append(TextInputPassTemplates.chat_input_field, {
	{
		style_id = "background",
		pass_type = "rect",
		content_id = "background",
		style = {
			color = ChatSettings.input_field_active_color
		}
	},
	{
		style_id = "frame",
		pass_type = "rect",
		content_id = "frame",
		style = input_frame_style
	},
	{
		value_id = "to_channel",
		style_id = "to_channel",
		pass_type = "text",
		value = "",
		style = table.clone(input_text_style)
	},
	{
		value_id = "display_text",
		style_id = "display_text",
		pass_type = "text",
		value = "",
		style = input_text_style
	},
	{
		style_id = "input_caret",
		pass_type = "rect",
		content_id = "input_caret",
		style = input_caret_style,
		change_function = function (pass_content, style_data, animations, dt)
			local widget_content = pass_content.parent or pass_content
			local blink_time = (widget_content._blink_time or 0) + dt

			if blink_time > 1 then
				blink_time = blink_time - 1
			end

			style_data.color[1] = blink_time < 0.5 and 255 or 0
			widget_content._blink_time = blink_time
		end
	},
	{
		pass_type = "text",
		style_id = "active_placeholder",
		value_id = "active_placeholder_text",
		style = table.clone(placeholder_text_style),
		change_function = function (pass_content, style_data, animations, dt)
			local alpha = style_data.text_color[1]
			local fade_step = dt * 1 / placeholder_fade_time * 255
			local input_text = pass_content.input_text

			if input_text and #input_text > 0 then
				if alpha > 0 then
					style_data.text_color[1] = _math_max(alpha - fade_step, 0)
				end
			elseif alpha < 255 then
				style_data.text_color[1] = _math_min(alpha + fade_step, 255)
			end
		end
	},
	{
		style_id = "selection",
		pass_type = "rect",
		style = {
			offset = {
				ChatSettings.input_field_margins[1],
				ChatSettings.input_field_margins[2],
				0
			},
			size_addition = {
				0,
				-(ChatSettings.input_field_margins[2] + ChatSettings.input_field_margins[4])
			},
			color = ChatSettings.selected_text_color
		},
		visibility_function = _selection_visibility_function
	}
})

return TextInputPassTemplates
