local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIResolution = require("scripts/managers/ui/ui_resolution")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ListHeaderPassTemplates = require("scripts/ui/pass_templates/list_header_templates")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local highlight_size_addition = ListHeaderPassTemplates.highlight_size_addition
local highlight_color_change_function = ListHeaderPassTemplates.list_highlight_color_change_function
local list_item_focused_visibility_function = ListHeaderPassTemplates.list_item_focused_visibility_function
local DropdownPassTemplates = {}
local DROPDOWN_BUTTON_SIZE = {
	38,
	20
}
local DROPDOWN_BUTTON_MARGIN = 30
local DROPDOWN_BUTTON_CLEARANCE = DROPDOWN_BUTTON_SIZE[1] + 2 * DROPDOWN_BUTTON_MARGIN

DropdownPassTemplates.settings_dropdown = function (width, height, settings_area_width, num_options, use_is_focused)
	local value_font_style = table.clone(UIFontSettings.list_button)
	value_font_style.size = {
		settings_area_width - (DROPDOWN_BUTTON_CLEARANCE + DROPDOWN_BUTTON_MARGIN),
		height
	}
	value_font_style.offset[1] = -DROPDOWN_BUTTON_CLEARANCE
	value_font_style.offset[3] = 8
	value_font_style.horizontal_alignment = "right"
	local scrollbar_area_width = DROPDOWN_BUTTON_MARGIN
	local scrollbar_width = 10
	local scrollbar_horizontal_offset = 0
	local scrollbar_height = height * num_options
	local header_width = width - settings_area_width
	local header_passes = ListHeaderPassTemplates.list_header(header_width, height, use_is_focused)

	for i = 1, #header_passes do
		local pass = header_passes[i]

		if pass.style_id and pass.style_id == "hotspot" then
			local style = pass.style
			style.on_pressed_fold_out_sound = UISoundEvents.default_dropdown_expand
			style.on_pressed_fold_in_sound = UISoundEvents.default_dropdown_minimize

			break
		end
	end

	local function dropdown_content_foldout_function(content, style)
		local anim_progress = content.anim_exclusive_focus_progress
		local style_height = style.size[2]
		local height_addition = -(style_height * (1 - math.easeCubic(anim_progress)))
		style.size_addition[2] = height_addition

		if content.grow_downwards then
			style.offset[2] = height
		else
			style.offset[2] = -(style_height + height_addition)
		end

		local alpha_progress = math.easeOutCubic(anim_progress)
		style.color[1] = 255 * alpha_progress
	end

	local function content_visibility_function(content)
		return content.anim_exclusive_focus_progress > 0
	end

	local drowdown_button_passes = {
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/buttons/background_selected",
			style = {
				horizontal_alignment = "right",
				size = {
					settings_area_width,
					height
				},
				color = Color.terminal_corner(255, true),
				offset = {
					0,
					0,
					1
				}
			},
			change_function = function (content, style)
				local default_alpha = 255
				local disabled_alpha = default_alpha * 0.8
				local current_alpha = content.disabled and disabled_alpha or default_alpha
				style.color[1] = current_alpha
			end
		},
		{
			pass_type = "rect",
			style = {
				horizontal_alignment = "right",
				size = {
					settings_area_width,
					height
				},
				offset = {
					0,
					0,
					0
				},
				color = Color.terminal_corner(25.5, true)
			},
			visibility_function = function (content, style)
				return not content.disabled
			end
		},
		{
			value = "content/ui/materials/buttons/dropdown_fill",
			style_id = "fill",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = DROPDOWN_BUTTON_SIZE,
				color = Color.black(255, true),
				offset = {
					-DROPDOWN_BUTTON_MARGIN,
					0,
					3
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "line",
			value = "content/ui/materials/buttons/dropdown_line",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = DROPDOWN_BUTTON_SIZE,
				default_color = Color.terminal_icon(255, true),
				disabled_color = Color.terminal_text_body_dark(255, true),
				hover_color = Color.terminal_icon_selected(255, true),
				offset = {
					-DROPDOWN_BUTTON_MARGIN,
					0,
					4
				}
			},
			change_function = highlight_color_change_function
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/hover",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				hdr = true,
				size = {
					settings_area_width,
					height
				},
				size_addition = {
					0,
					0
				},
				color = Color.terminal_corner(255, true),
				offset = {
					0,
					0,
					11
				}
			},
			change_function = function (content, style)
				local progress = content.highlight_progress or 0
				local alpha_progress = math.clamp(math.easeOutCubic(progress - content.anim_exclusive_focus_progress), 0, 1)
				style.color[1] = 255 * alpha_progress
				local size_addition = highlight_size_addition * math.easeInCubic(1 - progress)
				local style_size_addition = style.size_addition
				style_size_addition[1] = size_addition * 2
				style_size_addition[2] = size_addition * 2
				local offset = style.offset
				offset[1] = size_addition
				offset[2] = -size_addition
				style.hdr = alpha_progress == 1
			end,
			visibility_function = list_item_focused_visibility_function
		},
		{
			pass_type = "rect",
			syle_id = "dropdown_background",
			style_id = "dropdown_background",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				size = {
					settings_area_width,
					height * num_options
				},
				size_addition = {
					0,
					-height * num_options
				},
				color = Color.black(255, true),
				offset = {
					0,
					height,
					10
				}
			},
			visibility_function = content_visibility_function,
			change_function = dropdown_content_foldout_function
		},
		{
			value_id = "value_text",
			pass_type = "text",
			value = "n/a",
			style_id = "text",
			style = value_font_style,
			change_function = highlight_color_change_function
		}
	}

	local function scrollbar_visibility_function(content)
		if content.parent then
			content = content.parent
		end

		return not content.thumb_disabled and content.anim_exclusive_focus_progress > 0
	end

	local scrollbar_passes = {
		{
			style_id = "scrollbar_hotspot",
			pass_type = "hotspot",
			content_id = "scrollbar_hotspot",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				size = {
					scrollbar_width,
					scrollbar_height
				},
				offset = {
					scrollbar_horizontal_offset,
					0,
					0
				}
			},
			visibility_function = scrollbar_visibility_function
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/scrollbars/scrollbar_frame_default",
			style_id = "scrollbar_track",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				size = {
					scrollbar_width,
					scrollbar_height
				},
				size_addition = {
					0,
					-height * num_options
				},
				offset = {
					scrollbar_horizontal_offset,
					0,
					12
				},
				color = Color.terminal_frame(255, true)
			},
			visibility_function = scrollbar_visibility_function,
			change_function = dropdown_content_foldout_function
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/scrollbars/scrollbar_thumb_default",
			style_id = "thumb",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				size = {
					scrollbar_width,
					scrollbar_height
				},
				size_addition = {
					0,
					-height * num_options
				},
				offset = {
					scrollbar_horizontal_offset,
					0,
					11
				},
				color = Color.terminal_text_body(255, true)
			},
			visibility_function = scrollbar_visibility_function,
			change_function = function (content, style)
				local axis = content.axis or 2
				local parent_style = style.parent
				local hotspot_style = parent_style.scrollbar_hotspot
				local axis_offset = hotspot_style.offset[axis]
				local axis_length = hotspot_style.size[axis]
				style.size[axis] = axis_length
				style.offset[axis] = axis_offset
				local track_style = style.parent.scrollbar_track
				local track_visible_height = track_style.size[2] + track_style.size_addition[2]
				local thumb_total_height = axis_offset - height + axis_length
				local thumb_height_addition = math.clamp(track_visible_height - thumb_total_height, -axis_length, 0)
				style.size_addition[2] = thumb_height_addition
				local anim_progress = content.anim_exclusive_focus_progress
				style.color[1] = 255 * anim_progress
			end
		},
		{
			pass_type = "logic",
			visibility_function = scrollbar_visibility_function,
			value = function (pass, renderer, style, content, position, size)
				local axis = content.axis or 2
				local scroll_length = content.scroll_length or 0
				local area_length = content.area_length or 0
				local thumb_disabled = scroll_length <= 0
				content.thumb_disabled = thumb_disabled

				if thumb_disabled then
					return
				end

				local min_thumb_length = content.min_thumb_length or 0.4
				local thumb_size_fraction = math.max(math.min(area_length / scroll_length, 1), min_thumb_length)
				local thumb_length = (area_length - size[axis]) * thumb_size_fraction
				local style_parent = style.parent
				local hotspot_style = style_parent.scrollbar_hotspot
				hotspot_style.size[axis] = thumb_length
			end
		},
		{
			pass_type = "logic",
			visibility_function = scrollbar_visibility_function,
			value = function (pass, renderer, style, content, position, size)
				local scroll_length = content.scroll_length or 0

				if scroll_length <= 0 then
					return
				end

				local axis = content.axis or 2
				local style_parent = style.parent
				local scrollbar_track_style = style_parent.scrollbar_track
				local track_axis_offset = scrollbar_track_style.offset[axis]
				local scrollbar_track_height = scrollbar_track_style.size[axis]
				local scrollbar_length = scrollbar_track_height
				local hotspot = content.scrollbar_hotspot
				local on_pressed = hotspot.on_pressed

				if not content.drag_active then
					if on_pressed then
						content.drag_active = true
					else
						return
					end
				end

				local input_service = renderer.input_service
				local input_action = content.input_action or "left_hold"
				local left_hold = input_service and input_service:get(input_action)

				if not left_hold then
					content.drag_active = nil
					content.input_offset = nil

					return
				else
					content.scroll_value = nil
					content.scroll_add = nil
				end

				local hotspot_style = style_parent.scrollbar_hotspot
				local thumb_length = hotspot_style.size[axis]
				local inverse_scale = renderer.inverse_scale
				local base_cursor = input_service:get("cursor")
				local cursor = IS_XBS and base_cursor or UIResolution.inverse_scale_vector(base_cursor, inverse_scale)
				local cursor_direction = cursor[axis]
				local input_coordinate = math.clamp(cursor_direction - (position[axis] + track_axis_offset), 0, scrollbar_length)
				local input_offset = content.input_offset

				if not input_offset then
					input_offset = input_coordinate - (hotspot_style.offset[axis] - track_axis_offset)
					content.input_offset = input_offset
				end

				local start_position = 0
				local end_position = scrollbar_length - thumb_length
				local current_position = input_coordinate - input_offset
				current_position = math.clamp(current_position, start_position, end_position)
				local percentage = current_position / end_position
				content.scroll_percentage = percentage
			end
		},
		{
			pass_type = "logic",
			visibility_function = scrollbar_visibility_function,
			value = function (pass, renderer, style, content, position, size)
				local scroll_length = content.scroll_length or 0

				if scroll_length <= 0 then
					return
				end

				local axis = content.axis or 2
				local style_parent = style.parent
				local scrollbar_track_style = style_parent.scrollbar_track
				local scrollbar_track_height = scrollbar_track_style.size[axis]
				local scrollbar_length = scrollbar_track_height
				local style_parent = style.parent
				local track_style = style_parent.scrollbar_track
				local hotspot_style = style_parent.scrollbar_hotspot
				local track_axis_offset = track_style.offset[axis]
				local thumb_length = hotspot_style.size[axis]
				local hotspot_offset = hotspot_style.offset
				local end_position = scrollbar_length - thumb_length
				local scroll_percentage = content.scroll_percentage or 0
				local current_position = end_position * scroll_percentage
				hotspot_offset[2] = track_axis_offset + current_position
			end
		},
		{
			style_id = "dropdown_background",
			pass_type = "logic",
			visibility_function = scrollbar_visibility_function,
			value = function (pass, renderer, style, content, position, size)
				if content.drag_active then
					return
				end

				local scroll_length = content.scroll_length or 0

				if scroll_length <= 0 then
					return
				end

				local dt = renderer.dt
				local input_service = renderer.input_service
				local scroll_action = content.scroll_action or "scroll_axis"
				local scroll_axis = input_service:get(scroll_action)
				local axis = content.axis or 2
				local axis_input = scroll_axis[axis] * -1
				local scroll_amount = content.scroll_amount or 0.1
				local inverse_scale = renderer.inverse_scale
				local cursor = input_service:get("cursor")
				local cursor_position = IS_XBS and cursor or UIResolution.inverse_scale_vector(cursor, inverse_scale)
				local is_hover = math.point_is_inside_2d_box(cursor_position, position, size)

				if axis_input ~= 0 and is_hover then
					content.axis_input = axis_input
					local previous_scroll_add = content.scroll_add or 0
					content.scroll_add = previous_scroll_add + axis_input * scroll_amount
				end

				local scroll_add = content.scroll_add

				if scroll_add then
					local speed = content.scroll_speed or 5
					local step = scroll_add * dt * speed

					if math.abs(scroll_add) > scroll_amount / 500 then
						content.scroll_add = scroll_add - step
					else
						content.scroll_add = nil
					end

					local current_scroll_value = content.scroll_value or content.scroll_percentage or 0

					if current_scroll_value then
						content.scroll_value = math.clamp(current_scroll_value + step, 0, 1)
					end

					content.scroll_percentage = content.scroll_value or content.scroll_percentage or 0
				end
			end
		}
	}
	local option_fraction = 1 / num_options
	local options_passes = {
		{
			pass_type = "logic",
			value = function (pass, renderer, style, content, position, size)
				content.using_cursor_navigation = Managers.ui:using_cursor_navigation()
			end
		}
	}
	local default_hotspot_style = ListHeaderPassTemplates.default_hotspot_style

	for i = 1, num_options do
		local current_fraction = (i - 1) / num_options
		local hotspot_content = {
			anim_hover_progress = 0,
			anim_select_progress = 0
		}
		local hotspot_style = table.clone(default_hotspot_style)
		hotspot_style.vertical_alignment = "top"
		hotspot_style.horizontal_alignment = "right"
		hotspot_style.size = {
			settings_area_width - scrollbar_area_width,
			height
		}
		hotspot_style.offset = {
			-scrollbar_area_width,
			height * i,
			0
		}
		local option_font_style = table.clone(value_font_style)
		option_font_style.default_color = Color.terminal_text_body(255, true)
		option_font_style.offset = {
			DROPDOWN_BUTTON_MARGIN,
			height * i,
			12
		}
		option_font_style.size = {
			settings_area_width - DROPDOWN_BUTTON_MARGIN * 2,
			height
		}
		local hotspot_id = "option_hotspot_" .. i
		local text_id = "option_text_" .. i
		options_passes[#options_passes + 1] = {
			pass_type = "hotspot",
			content_id = hotspot_id,
			content = hotspot_content,
			style_id = hotspot_id,
			style = hotspot_style,
			visibility_function = function (content)
				return content.parent.anim_exclusive_focus_progress > 0
			end
		}
		options_passes[#options_passes + 1] = {
			pass_type = "texture",
			value = "content/ui/materials/frames/hover",
			style_id = "outline_" .. i,
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				hdr = true,
				size = {
					settings_area_width,
					height
				},
				size_addition = {
					0,
					0
				},
				offset = {
					header_width,
					height * i,
					13
				},
				color = Color.terminal_corner(255, true)
			},
			change_function = function (content, style)
				local hotspot = content[hotspot_id]
				local using_cursor_navigation = content.using_cursor_navigation
				local cursor_navigation_progress = using_cursor_navigation and hotspot.anim_hover_progress or 0
				local gamepad_navigation_progress = not using_cursor_navigation and hotspot.anim_select_progress or 0
				local progress = math.max(cursor_navigation_progress, gamepad_navigation_progress)
				local focus_alpha = style.parent[text_id].text_color[1]
				style.color[1] = math.min(255 * math.easeOutCubic(progress), focus_alpha)
				local size_addition = highlight_size_addition * math.easeInCubic(1 - progress)
				local style_size_addition = style.size_addition
				style_size_addition[1] = size_addition * 2
				style_size_addition[2] = size_addition * 2
				local offset_y = nil

				if content.grow_downwards then
					offset_y = i * height
				else
					offset_y = -(i * height)
				end

				local offset = style.offset
				offset[1] = header_width - size_addition
				offset[2] = offset_y - size_addition
				style.hdr = focus_alpha == 255
			end,
			visibility_function = content_visibility_function
		}
		options_passes[#options_passes + 1] = {
			pass_type = "text",
			style = option_font_style,
			style_id = text_id,
			value_id = "option_text_" .. i,
			value = "option_" .. i,
			change_function = function (content, style)
				local default_color = style.default_color
				local hover_color = style.hover_color
				local text_color = style.text_color
				local hotspot = content[hotspot_id]
				local focus_progress = math.easeCubic(content.anim_exclusive_focus_progress)
				local alpha_progress = math.clamp((focus_progress - current_fraction) / option_fraction, 0, 1)
				text_color[1] = 255 * math.easeCubic(alpha_progress)
				local highlight_progress = math.max(hotspot.anim_select_progress, hotspot.anim_hover_progress)
				local exclude_alpha = true

				ColorUtilities.color_lerp(default_color, hover_color, highlight_progress, text_color, exclude_alpha)
			end,
			visibility_function = content_visibility_function
		}
	end

	local passes = {}

	table.append(passes, header_passes)
	table.append(passes, drowdown_button_passes)
	table.append(passes, scrollbar_passes)
	table.append(passes, options_passes)

	return passes
end

return DropdownPassTemplates
