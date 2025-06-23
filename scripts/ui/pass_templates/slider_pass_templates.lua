-- chunkname: @scripts/ui/pass_templates/slider_pass_templates.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIResolution = require("scripts/managers/ui/ui_resolution")
local ListHeaderPassTemplates = require("scripts/ui/pass_templates/list_header_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local InputUtils = require("scripts/managers/input/input_utils")
local SliderPassTemplates = {}
local SLIDER_TRACK_HEIGHT = 20
local SLIDER_ENDPLATE_WIDTH = 4
local SLIDER_THUMB_SIZE = 38
local THUMB_HIGHLIGHT_SIZE = 58
local LABEL_WIDTH = 80
local EXTRA_SLIDER_TRACK_SIZE = 5

local function thumb_position_change_function(content, style)
	if content.parent then
		content = content.parent
	end

	local slider_horizontal_offset = content.slider_horizontal_offset or 0

	style.offset[1] = slider_horizontal_offset
end

local function highlight_color_change_function(content, style)
	local default_color = content.disabled and style.disabled_color or style.default_color
	local hover_color = content.disabled and style.disabled_color or style.hover_color
	local color = style.color or style.text_color
	local hotspot = content.hotspot
	local is_highlighted = hotspot.is_hover or hotspot.is_selected or hotspot.is_focused
	local progress = is_highlighted and content.highlight_progress or 0

	ColorUtilities.color_lerp(default_color, hover_color, progress, color)

	style.hdr = progress == 1
end

SliderPassTemplates.settings_percent_slider = function (width, height, settings_area_width, use_is_focused, is_sub_setting)
	return SliderPassTemplates._settings_slider(width, height, settings_area_width, use_is_focused, true, is_sub_setting)
end

SliderPassTemplates.settings_value_slider = function (width, height, settings_area_width, use_is_focused, is_sub_setting)
	return SliderPassTemplates._settings_slider(width, height, settings_area_width, use_is_focused, false, is_sub_setting)
end

SliderPassTemplates.value_slider = function (width, height, value_width, use_is_focused, is_sub_setting)
	return SliderPassTemplates._slider(width, height, value_width, use_is_focused, false, is_sub_setting)
end

SliderPassTemplates._settings_slider = function (width, height, settings_area_width, use_is_focused, is_percent_slider, is_sub_setting)
	local track_thickness = is_percent_slider and 10 or SLIDER_ENDPLATE_WIDTH
	local slider_area_width = settings_area_width - (SLIDER_ENDPLATE_WIDTH * 2 + SLIDER_THUMB_SIZE)
	local header_width = width - settings_area_width
	local slider_horizontal_offset = header_width + SLIDER_ENDPLATE_WIDTH
	local thumb_highlight_expanded_size = THUMB_HIGHLIGHT_SIZE + ListHeaderPassTemplates.highlight_size_addition
	local value_font_style = table.clone(UIFontSettings.list_button)

	value_font_style.size = {
		LABEL_WIDTH,
		height
	}
	value_font_style.offset = {
		slider_horizontal_offset - (LABEL_WIDTH + 10),
		0,
		8
	}
	value_font_style.text_horizontal_alignment = "right"

	local passes = ListHeaderPassTemplates.list_header(header_width - LABEL_WIDTH, height, use_is_focused, is_sub_setting)
	local slider_passes = {
		{
			value_id = "value_text",
			pass_type = "text",
			value = "n/a",
			style = value_font_style,
			change_function = highlight_color_change_function
		},
		{
			value = "content/ui/materials/buttons/background_selected",
			style_id = "slider_track_background",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = {
					settings_area_width,
					SLIDER_TRACK_HEIGHT
				},
				color = Color.terminal_corner_hover(255, true),
				offset = {
					0,
					0,
					0
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "slider_track_endplate_left",
			value = "content/ui/materials/buttons/background_selected_edge",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = {
					SLIDER_ENDPLATE_WIDTH,
					SLIDER_TRACK_HEIGHT
				},
				disabled_color = Color.terminal_text_body_dark(255, true),
				default_color = Color.terminal_corner(255, true),
				hover_color = Color.terminal_corner_hover(255, true),
				offset = {
					slider_horizontal_offset - SLIDER_ENDPLATE_WIDTH,
					0,
					2
				}
			},
			change_function = highlight_color_change_function
		},
		{
			pass_type = "texture",
			style_id = "slider_track_endplate_right",
			value = "content/ui/materials/buttons/background_selected_edge",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = {
					SLIDER_ENDPLATE_WIDTH,
					SLIDER_TRACK_HEIGHT
				},
				disabled_color = Color.terminal_text_body_dark(255, true),
				default_color = Color.terminal_corner(255, true),
				hover_color = Color.terminal_corner_hover(255, true),
				offset = {
					0,
					0,
					2
				}
			},
			change_function = highlight_color_change_function
		},
		{
			pass_type = "texture",
			style_id = "slider_track_left",
			value = "content/ui/materials/buttons/background_selected_edge",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = {
					slider_area_width,
					track_thickness
				},
				disabled_color = Color.terminal_text_body_dark(255, true),
				default_color = Color.terminal_corner(255, true),
				hover_color = Color.terminal_corner_hover(255, true),
				offset = {
					slider_horizontal_offset,
					0,
					2
				}
			},
			change_function = function (content, style)
				style.size[1] = content.slider_value * slider_area_width + EXTRA_SLIDER_TRACK_SIZE

				highlight_color_change_function(content, style)
			end
		},
		{
			style_id = "slider_action_gamepad",
			pass_type = "text",
			value = "",
			value_id = "slider_action_gamepad",
			style = {
				vertical_alignment = "center",
				text_vertical_alignment = "center",
				horizontal_alignment = "right",
				text_horizontal_alignment = "right",
				text_color = {
					255,
					226,
					199,
					126
				},
				offset = {
					30,
					0,
					2
				}
			},
			change_function = function (content, style)
				local gamepad_action = "confirm_pressed"
				local service_type = "View"
				local alias_key = Managers.ui:get_input_alias_key(gamepad_action, service_type)
				local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_key)

				content.slider_action_gamepad = input_text
			end,
			visibility_function = function (content, style)
				local is_highlighted = content.hotspot.is_selected or content.hotspot.is_focused

				return content.is_gamepad_active and not content.exclusive_focus and is_highlighted
			end
		}
	}

	if not is_percent_slider then
		slider_passes[#slider_passes + 1] = {
			pass_type = "texture",
			style_id = "slider_track",
			value = "content/ui/materials/buttons/background_selected_edge",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = {
					slider_area_width,
					track_thickness
				},
				disabled_color = Color.terminal_text_body_dark(255, true),
				default_color = Color.terminal_corner(255, true),
				hover_color = Color.terminal_corner_hover(255, true),
				offset = {
					-SLIDER_ENDPLATE_WIDTH,
					0,
					2
				}
			},
			change_function = function (content, style)
				style.size[1] = (1 - content.slider_value) * slider_area_width + EXTRA_SLIDER_TRACK_SIZE

				highlight_color_change_function(content, style)
			end
		}
	end

	local thumb_logic_passes = {
		{
			pass_type = "logic",
			value = function (pass, renderer, style, content, position, size)
				local axis = content.axis or 1
				local hotspot = content.track_hotspot
				local on_pressed = hotspot.on_pressed
				local is_disabled = content.entry and content.entry.disabled or false

				if not content.drag_active then
					if on_pressed then
						content.drag_active = not is_disabled

						if content.drag_active and IS_WINDOWS then
							Window.set_clip_cursor(true)
						end
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

					if IS_WINDOWS then
						Window.set_clip_cursor(false)
					end

					return
				else
					content.scroll_add = nil
				end

				local inverse_scale = renderer.inverse_scale
				local base_cursor = input_service:get("cursor")
				local cursor = (IS_XBS or IS_PLAYSTATION) and base_cursor or UIResolution.inverse_scale_vector(base_cursor, inverse_scale)
				local cursor_direction = cursor[axis]
				local input_coordinate = cursor_direction - (position[axis] + slider_horizontal_offset)
				local input_offset = content.input_offset

				if not input_offset then
					local current_thumb_position = content.slider_value * slider_area_width

					input_offset = input_coordinate - current_thumb_position

					if input_offset < 0 or input_offset > SLIDER_THUMB_SIZE then
						input_offset = SLIDER_THUMB_SIZE * 0.5
					end

					content.input_offset = input_offset
				end

				input_coordinate = math.clamp(input_coordinate - input_offset, 0, slider_area_width)

				local slider_value = input_coordinate / slider_area_width
				local step_size = content.step_size

				if step_size then
					slider_value = math.round(slider_value / step_size) * step_size
				end

				content.slider_value = slider_value
			end
		},
		{
			style_id = "mouse_scroll",
			pass_type = "logic",
			visibility_function = function (content, style)
				return content.exclusive_focus or content.hotspot.is_hover
			end,
			value = function (pass, renderer, style, content, position, size)
				local is_disabled = content.entry and content.entry.disabled or false

				if content.drag_active or not content.is_gamepad_active or is_disabled then
					return
				end

				local dt = renderer.dt
				local input_service = renderer.input_service
				local left_axis = input_service:get("navigate_left_continuous_fast")
				local right_axis = input_service:get("navigate_right_continuous_fast")
				local scroll_axis = left_axis and -1 or right_axis and 1 or 0
				local step_size = content.step_size
				local scroll_amount = content.scroll_amount or 0.01

				if scroll_axis ~= 0 then
					content.scroll_axis = scroll_axis

					local previous_scroll_add = content.scroll_add or 0

					content.scroll_add = previous_scroll_add + (step_size or scroll_amount) * scroll_axis
				end

				local scroll_add = content.scroll_add

				if scroll_add then
					local step = 0

					if step_size then
						step = content.scroll_add
						content.scroll_add = nil
					else
						local speed = content.scroll_speed or 8

						step = scroll_add * (dt * speed)

						if math.abs(scroll_add) > scroll_amount / 10 then
							content.scroll_add = scroll_add - step
						else
							content.scroll_add = nil
						end
					end

					local input_slider_value = content.slider_value or 0

					content.slider_value = math.clamp(input_slider_value + step, 0, 1)
				end
			end
		},
		{
			style_id = "track_hotspot",
			pass_type = "hotspot",
			content_id = "track_hotspot",
			style = {
				vertical_alignment = "center",
				anim_input_speed = 8,
				anim_hover_speed = 8,
				anim_focus_speed = 8,
				anim_select_speed = 8,
				horizontal_alignment = "right",
				size = {
					settings_area_width,
					SLIDER_THUMB_SIZE
				},
				offset = {
					0,
					0,
					3
				}
			},
			visibility_function = function (content, style)
				return not content.parent.hotspot.disabled
			end,
			change_function = function (content, style)
				local slider_value = content.parent.slider_value or 0

				content.parent.slider_horizontal_offset = slider_horizontal_offset + slider_value * slider_area_width
			end
		}
	}
	local thumb_visual_passes = {
		{
			value = "content/ui/materials/buttons/slider_handle_line",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				offset = {
					0,
					0,
					7
				},
				size = {
					SLIDER_THUMB_SIZE,
					SLIDER_THUMB_SIZE
				},
				disabled_color = Color.terminal_text_body_dark(255, true),
				default_color = Color.terminal_corner(255, true),
				hover_color = Color.terminal_corner_hover(255, true)
			},
			change_function = function (content, style)
				thumb_position_change_function(content, style)
				highlight_color_change_function(content, style)
			end
		},
		{
			value = "content/ui/materials/buttons/slider_handle_fill",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				offset = {
					0,
					0,
					6
				},
				size = {
					SLIDER_THUMB_SIZE,
					SLIDER_THUMB_SIZE
				},
				color = Color.black(255, true)
			},
			change_function = function (content, style)
				thumb_position_change_function(content, style)
			end
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/buttons/slider_handle_highlight",
			style = {
				vertical_alignment = "center",
				hdr = true,
				offset = {
					0,
					0,
					9
				},
				size = {
					SLIDER_THUMB_SIZE,
					SLIDER_THUMB_SIZE
				},
				color = Color.terminal_corner_hover(255, true)
			},
			visibility_function = function (content, style)
				local highlight_progress = content.highlight_progress or 0

				return highlight_progress > 0
			end,
			change_function = function (content, style)
				thumb_position_change_function(content, style)

				local is_disabled = content.entry and content.entry.disabled or false
				local active = content.drag_active or content.focused
				local progress = is_disabled and 0 or active and 1 or content.track_hotspot.anim_hover_progress

				style.color[1] = 255 * math.easeOutCubic(progress)

				local new_size = math.lerp(thumb_highlight_expanded_size, THUMB_HIGHLIGHT_SIZE, math.easeInCubic(progress))
				local size = style.size

				size[1] = new_size
				size[2] = new_size

				local offset_addition = (new_size - SLIDER_THUMB_SIZE) * 0.5
				local axis = content.axis or 1

				style.offset[axis] = style.offset[axis] - offset_addition
			end
		}
	}

	table.append(passes, thumb_logic_passes)
	table.append(passes, slider_passes)
	table.append(passes, thumb_visual_passes)

	return passes
end

SliderPassTemplates._slider = function (width, height, value_width, use_is_focused, is_percent_slider)
	local track_thickness = is_percent_slider and 10 or SLIDER_ENDPLATE_WIDTH
	local label_width = value_width or LABEL_WIDTH
	local thumb_highlight_expanded_size = THUMB_HIGHLIGHT_SIZE + ListHeaderPassTemplates.highlight_size_addition
	local slider_horizontal_offset = label_width + SLIDER_ENDPLATE_WIDTH
	local settings_area_width = width - slider_horizontal_offset
	local slider_area_width = settings_area_width - (SLIDER_ENDPLATE_WIDTH * 2 + SLIDER_THUMB_SIZE)
	local value_font_style = table.clone(UIFontSettings.list_button)

	value_font_style.size = {
		label_width - SLIDER_ENDPLATE_WIDTH - 4,
		height
	}
	value_font_style.offset = {
		0,
		0,
		8
	}
	value_font_style.text_horizontal_alignment = "right"

	local passes = {
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot",
			content = {
				use_is_focused = use_is_focused
			},
			style = ListHeaderPassTemplates.default_hotspot_style
		},
		{
			style_id = "hotspot",
			pass_type = "logic",
			value = function (pass, renderer, style, content, position, size)
				local hotspot = content.hotspot
				local highlight_progress = math.max(hotspot.anim_select_progress, hotspot.anim_hover_progress, hotspot.anim_focus_progress)

				content.highlight_progress = highlight_progress

				local dt = renderer.dt
				local exclusive_focus = content.exclusive_focus
				local anim_exclusive_focus_progress = content.anim_exclusive_focus_progress or 0
				local anim_focus_speed = style.anim_focus_speed
				local anim_delta = dt * anim_focus_speed

				if exclusive_focus then
					anim_exclusive_focus_progress = math.min(anim_exclusive_focus_progress + anim_delta, 1)
				else
					anim_exclusive_focus_progress = math.max(anim_exclusive_focus_progress - anim_delta, 0)
				end

				content.anim_exclusive_focus_progress = anim_exclusive_focus_progress
			end
		}
	}
	local slider_passes = {
		{
			value_id = "value_text",
			pass_type = "text",
			value = "n/a",
			style = value_font_style,
			change_function = highlight_color_change_function
		},
		{
			value = "content/ui/materials/buttons/background_selected",
			style_id = "slider_track_background",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = {
					settings_area_width,
					SLIDER_TRACK_HEIGHT
				},
				color = Color.terminal_corner_hover(255, true),
				offset = {
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/buttons/background_selected_edge",
			style_id = "slider_track_endplate_left",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = {
					SLIDER_ENDPLATE_WIDTH,
					SLIDER_TRACK_HEIGHT
				},
				color = Color.terminal_corner(255, true),
				offset = {
					slider_horizontal_offset - SLIDER_ENDPLATE_WIDTH,
					0,
					2
				}
			}
		},
		{
			value = "content/ui/materials/buttons/background_selected_edge",
			style_id = "slider_track_endplate_right",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = {
					SLIDER_ENDPLATE_WIDTH,
					SLIDER_TRACK_HEIGHT
				},
				color = Color.terminal_corner(255, true),
				offset = {
					0,
					0,
					2
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "slider_track_left",
			value = "content/ui/materials/buttons/background_selected_edge",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = {
					settings_area_width,
					track_thickness
				},
				disabled_color = Color.terminal_text_body_dark(255, true),
				default_color = Color.terminal_corner(255, true),
				hover_color = Color.terminal_corner_hover(255, true),
				offset = {
					slider_horizontal_offset,
					0,
					2
				}
			},
			change_function = function (content, style)
				style.size[1] = content.slider_value * slider_area_width

				highlight_color_change_function(content, style)
			end
		},
		{
			style_id = "slider_action_gamepad",
			pass_type = "text",
			value = "",
			value_id = "slider_action_gamepad",
			style = {
				vertical_alignment = "center",
				text_vertical_alignment = "center",
				horizontal_alignment = "right",
				text_horizontal_alignment = "right",
				text_color = {
					255,
					226,
					199,
					126
				},
				offset = {
					30,
					0,
					2
				}
			},
			change_function = function (content, style)
				local gamepad_action = "confirm_pressed"
				local service_type = "View"
				local alias_key = Managers.ui:get_input_alias_key(gamepad_action, service_type)
				local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_key)

				content.slider_action_gamepad = input_text
			end,
			visibility_function = function (content, style)
				local is_highlighted = content.hotspot.is_selected or content.hotspot.is_focused

				return content.is_gamepad_active and not content.exclusive_focus and is_highlighted
			end
		}
	}

	if not is_percent_slider then
		slider_passes[#slider_passes + 1] = {
			pass_type = "texture",
			style_id = "slider_track",
			value = "content/ui/materials/buttons/background_selected_edge",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = {
					slider_area_width,
					track_thickness
				},
				disabled_color = Color.terminal_text_body_dark(255, true),
				default_color = Color.terminal_corner(255, true),
				hover_color = Color.terminal_corner_hover(255, true),
				offset = {
					-SLIDER_ENDPLATE_WIDTH,
					0,
					2
				}
			},
			change_function = function (content, style)
				style.size[1] = (1 - content.slider_value) * slider_area_width + EXTRA_SLIDER_TRACK_SIZE

				highlight_color_change_function(content, style)
			end
		}
	end

	local thumb_logic_passes = {
		{
			pass_type = "logic",
			value = function (pass, renderer, style, content, position, size)
				local axis = content.axis or 1
				local hotspot = content.track_hotspot
				local on_pressed = hotspot.on_pressed
				local is_disabled = content.entry and content.entry.disabled or false

				if not content.drag_active then
					if on_pressed then
						content.drag_active = not is_disabled

						if content.drag_active and IS_WINDOWS then
							Window.set_clip_cursor(true)
						end
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

					if IS_WINDOWS then
						Window.set_clip_cursor(false)
					end

					return
				else
					content.scroll_add = nil
				end

				local inverse_scale = renderer.inverse_scale
				local base_cursor = input_service:get("cursor")
				local cursor = (IS_XBS or IS_PLAYSTATION) and base_cursor or UIResolution.inverse_scale_vector(base_cursor, inverse_scale)
				local cursor_direction = cursor[axis]
				local input_coordinate = cursor_direction - (position[axis] + slider_horizontal_offset)
				local input_offset = content.input_offset

				if not input_offset then
					local current_thumb_position = content.slider_value * slider_area_width

					input_offset = input_coordinate - current_thumb_position

					if input_offset < 0 or input_offset > SLIDER_THUMB_SIZE then
						input_offset = SLIDER_THUMB_SIZE * 0.5
					end

					content.input_offset = input_offset
				end

				input_coordinate = math.clamp(input_coordinate - input_offset, 0, slider_area_width)

				local slider_value = input_coordinate / slider_area_width
				local step_size = content.step_size

				if step_size then
					slider_value = math.round(slider_value / step_size) * step_size
				end

				content.slider_value = slider_value
			end
		},
		{
			style_id = "mouse_scroll",
			pass_type = "logic",
			visibility_function = function (content, style)
				return content.exclusive_focus or content.hotspot.is_hover
			end,
			value = function (pass, renderer, style, content, position, size)
				local is_disabled = content.entry and content.entry.disabled or false

				if content.drag_active or is_disabled then
					return
				end

				local dt = renderer.dt
				local input_service = renderer.input_service
				local left_axis = input_service:get("navigate_left_continuous_fast")
				local right_axis = input_service:get("navigate_right_continuous_fast")
				local scroll_axis = left_axis and -1 or right_axis and 1 or 0
				local step_size = content.step_size
				local scroll_amount = content.scroll_amount or 0.01

				if scroll_axis ~= 0 then
					content.scroll_axis = scroll_axis

					local previous_scroll_add = content.scroll_add or 0

					content.scroll_add = previous_scroll_add + (step_size or scroll_amount) * scroll_axis
				end

				local scroll_add = content.scroll_add

				if scroll_add then
					local step = 0

					if step_size then
						step = content.scroll_add
						content.scroll_add = nil
					else
						local speed = content.scroll_speed or 8

						step = scroll_add * (dt * speed)

						if math.abs(scroll_add) > scroll_amount / 10 then
							content.scroll_add = scroll_add - step
						else
							content.scroll_add = nil
						end
					end

					local input_slider_value = content.slider_value or 0

					content.slider_value = math.clamp(input_slider_value + step, 0, 1)
				end
			end
		},
		{
			style_id = "track_hotspot",
			pass_type = "hotspot",
			content_id = "track_hotspot",
			style = {
				vertical_alignment = "center",
				anim_input_speed = 16,
				anim_hover_speed = 16,
				anim_focus_speed = 16,
				anim_select_speed = 16,
				horizontal_alignment = "right",
				size = {
					settings_area_width,
					SLIDER_THUMB_SIZE
				},
				offset = {
					0,
					0,
					3
				}
			},
			visibility_function = function (content, style)
				return not content.parent.hotspot.disabled
			end,
			change_function = function (content, style)
				local slider_value = content.parent.slider_value or 0

				content.parent.slider_horizontal_offset = slider_horizontal_offset + slider_value * slider_area_width
			end
		}
	}
	local thumb_visual_passes = {
		{
			value = "content/ui/materials/buttons/slider_handle_line",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				offset = {
					0,
					0,
					7
				},
				size = {
					SLIDER_THUMB_SIZE,
					SLIDER_THUMB_SIZE
				},
				disabled_color = Color.terminal_text_body_dark(255, true),
				default_color = Color.terminal_corner(255, true),
				hover_color = Color.terminal_corner_hover(255, true)
			},
			change_function = function (content, style)
				thumb_position_change_function(content, style)
				highlight_color_change_function(content, style)
			end
		},
		{
			value = "content/ui/materials/buttons/slider_handle_fill",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				offset = {
					0,
					0,
					6
				},
				size = {
					SLIDER_THUMB_SIZE,
					SLIDER_THUMB_SIZE
				},
				color = Color.black(255, true)
			},
			change_function = function (content, style)
				thumb_position_change_function(content, style)
			end
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/buttons/slider_handle_highlight",
			style = {
				vertical_alignment = "center",
				hdr = true,
				offset = {
					0,
					0,
					9
				},
				size = {
					SLIDER_THUMB_SIZE,
					SLIDER_THUMB_SIZE
				},
				color = Color.terminal_corner_hover(255, true)
			},
			visibility_function = function (content, style)
				local highlight_progress = content.highlight_progress or 0

				return highlight_progress > 0
			end,
			change_function = function (content, style)
				thumb_position_change_function(content, style)

				local is_disabled = content.entry and content.entry.disabled or false
				local active = content.drag_active or content.focused
				local progress = is_disabled and 0 or active and 1 or content.track_hotspot.anim_hover_progress

				style.color[1] = 255 * math.easeOutCubic(progress)

				local new_size = math.lerp(thumb_highlight_expanded_size, THUMB_HIGHLIGHT_SIZE, math.easeInCubic(progress))
				local size = style.size

				size[1] = new_size
				size[2] = new_size

				local offset_addition = (new_size - SLIDER_THUMB_SIZE) * 0.5
				local axis = content.axis or 1

				style.offset[axis] = style.offset[axis] - offset_addition
			end
		}
	}

	table.append(passes, thumb_logic_passes)
	table.append(passes, slider_passes)
	table.append(passes, thumb_visual_passes)

	return passes
end

return settings("SliderPassTemplates", SliderPassTemplates)
