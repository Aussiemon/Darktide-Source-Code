local UIResolution = require("scripts/managers/ui/ui_resolution")
local ColorUtilities = require("scripts/utilities/ui/colors")
local ScrollbarPassTemplates = {}

local function scrollbar_visibility_function(content)
	return not content.thumb_disabled
end

local scrollbar_base = {
	{
		pass_type = "logic",
		value = function (pass, renderer, style, content, position, size)
			local axis = content.axis or 2
			local scroll_length = content.scroll_length or 0
			local area_length = content.area_length or 0
			local scrollbar_length = size[axis]
			local thumb_disabled = scroll_length <= 0
			content.thumb_disabled = thumb_disabled

			if thumb_disabled then
				return
			end

			local min_thumb_length = content.min_thumb_length or 0.2
			local thumb_size_fraction = math.max(math.min(1 - scroll_length / area_length, 1), min_thumb_length)
			local thumb_length = scrollbar_length * thumb_size_fraction
			local style_parent = style.parent
			local hotspot_style = style_parent.hotspot
			hotspot_style.size[axis] = thumb_length
		end
	},
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		content = {
			is_focused = true
		},
		style = {
			size = {
				nil,
				100
			}
		}
	}
}
scrollbar_base[3] = {
	pass_type = "logic",
	value = function (pass, renderer, style, content, position, size)
		local scroll_length = content.scroll_length or 0

		if scroll_length <= 0 then
			return
		end

		local axis = content.axis or 2
		local scrollbar_length = size[axis]
		local hotspot = content.hotspot
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

		local style_parent = style.parent
		local hotspot_style = style_parent.hotspot
		local thumb_length = hotspot_style.size[axis]
		local inverse_scale = renderer.inverse_scale
		local base_cursor = input_service:get("cursor")
		local cursor = IS_XBS and base_cursor or UIResolution.inverse_scale_vector(base_cursor, inverse_scale)
		local cursor_direction = cursor[axis]
		local input_coordinate = math.clamp(cursor_direction - position[axis], 0, scrollbar_length)
		local input_offset = content.input_offset

		if not input_offset then
			input_offset = input_coordinate - hotspot_style.offset[axis]
			content.input_offset = input_offset
		end

		local start_position = 0
		local end_position = scrollbar_length - thumb_length
		local current_position = input_coordinate - input_offset
		current_position = math.clamp(current_position, start_position, end_position)
		local percentage = current_position / end_position
		content.value = percentage
	end
}
scrollbar_base[4] = {
	style_id = "mouse_scroll",
	pass_type = "logic",
	visibility_function = function (content, style)
		return style.scenegraph_id
	end,
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
		local hotspot = content.hotspot
		local axis = content.axis or 2
		local scroll_action_negative = axis == 2 and "scroll_up_continuous" or "scroll_left_continuous"
		local scroll_action_positive = axis == 2 and "scroll_down_continuous" or "scroll_right_continuous"
		local is_hover = nil
		local using_cursor_navigation = Managers.ui:using_cursor_navigation()

		if using_cursor_navigation then
			local inverse_scale = renderer.inverse_scale
			local cursor = input_service:get("cursor")
			local cursor_position = IS_XBS and cursor or UIResolution.inverse_scale_vector(cursor, inverse_scale)
			is_hover = hotspot.is_hover or math.point_is_inside_2d_box(cursor_position, position, size)
		else
			is_hover = hotspot.is_selected or content.focused
			scroll_action_negative = content.scroll_action_negative or scroll_action_negative
			scroll_action_positive = content.scroll_action_positive or scroll_action_positive
		end

		local scroll_axis_negative = input_service:get(scroll_action_negative)
		local scroll_axis_positive = input_service:get(scroll_action_positive)
		local axis_input = scroll_axis_negative and 1 or scroll_axis_positive and 1 or 0
		local scroll_amount = content.scroll_amount or 0.1

		if axis_input ~= 0 and is_hover then
			content.axis_input = axis_input
			local current_scroll_direction = scroll_axis_negative and -1 or 1
			local previous_scroll_add = content.scroll_add or 0

			if content.current_scroll_direction and content.current_scroll_direction ~= current_scroll_direction then
				previous_scroll_add = 0
			end

			content.current_scroll_direction = current_scroll_direction
			content.scroll_add = previous_scroll_add * 1.1 + scroll_amount
		end

		local scroll_add = content.scroll_add

		if scroll_add then
			local speed = content.scroll_speed or 10
			local step = scroll_add * dt * speed

			if math.abs(scroll_add) > scroll_amount / 500 then
				content.scroll_add = math.max(scroll_add - step, 0)
			else
				content.scroll_add = nil
			end

			local current_scroll_direction = content.current_scroll_direction or 0
			local current_scroll_value = content.scroll_value or content.value or 0
			content.scroll_value = math.clamp(current_scroll_value + step * current_scroll_direction, 0, 1)
			content.value = content.scroll_value
		end
	end
}
scrollbar_base[5] = {
	pass_type = "logic",
	value = function (pass, renderer, style, content, position, size)
		local scroll_length = content.scroll_length or 0

		if scroll_length <= 0 then
			return
		end

		local axis = content.axis or 2
		local scrollbar_length = size[axis]
		local style_parent = style.parent
		local hotspot_style = style_parent.hotspot
		local thumb_length = hotspot_style.size[axis]
		local hotspot_offset = hotspot_style.offset
		local end_position = scrollbar_length - thumb_length
		local value = content.value or 0
		local current_position = end_position * value
		hotspot_offset[2] = current_position
	end
}
ScrollbarPassTemplates.simple_scrollbar = table.clone(scrollbar_base)

table.append(ScrollbarPassTemplates.simple_scrollbar, {
	{
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
		style_id = "thumb",
		pass_type = "rect",
		style = {
			color = {
				255,
				119,
				78,
				45
			},
			size = {
				nil,
				100
			}
		},
		visibility_function = scrollbar_visibility_function,
		change_function = function (content, style)
			style.color[1] = 100 + content.hotspot.anim_hover_progress * 155
			local axis = content.axis or 2
			local parent_style = style.parent
			local hotspot_style = parent_style.hotspot
			local axis_offset = hotspot_style.offset[axis]
			local axis_length = hotspot_style.size[axis]
			style.size[axis] = axis_length
			style.offset[axis] = axis_offset
		end
	}
})

ScrollbarPassTemplates.default_scrollbar = table.clone(scrollbar_base)

table.append(ScrollbarPassTemplates.default_scrollbar, {
	{
		style_id = "track_background",
		pass_type = "texture",
		value = "content/ui/materials/scrollbars/scrollbar_thumb_default",
		style = {
			color = Color.black(255, true)
		},
		visibility_function = scrollbar_visibility_function
	},
	{
		style_id = "track_frame",
		pass_type = "texture",
		value = "content/ui/materials/scrollbars/scrollbar_frame_default",
		style = {
			offset = {
				0,
				0,
				3
			},
			color = Color.black(255, true)
		},
		visibility_function = scrollbar_visibility_function
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/scrollbars/scrollbar_thumb_default",
		style_id = "thumb",
		style = {
			offset = {
				0,
				0,
				2
			},
			idle_color = Color.ui_grey_medium(255, true),
			highlight_color = Color.ui_brown_super_light(255, true),
			size = {
				nil,
				100
			}
		},
		visibility_function = scrollbar_visibility_function,
		change_function = function (content, style)
			local axis = content.axis or 2
			local parent_style = style.parent
			local hotspot_style = parent_style.hotspot
			local axis_offset = hotspot_style.offset[axis]
			local axis_length = hotspot_style.size[axis]
			style.size[axis] = axis_length
			style.offset[axis] = axis_offset
			local hover_progress = content.hotspot.anim_hover_progress

			ColorUtilities.color_lerp(style.idle_color, style.highlight_color, hover_progress, style.color, true)
		end
	}
}, scrollbar_base)

ScrollbarPassTemplates.default_scrollbar.default_width = 10
ScrollbarPassTemplates.metal_scrollbar = table.clone(scrollbar_base)

table.append(ScrollbarPassTemplates.metal_scrollbar, {
	{
		value = "content/ui/materials/scrollbars/scrollbar_metal_background",
		style_id = "track_background",
		pass_type = "texture",
		visibility_function = scrollbar_visibility_function
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/scrollbars/scrollbar_metal_handle",
		style_id = "thumb",
		style = {
			offset = {
				0,
				0,
				2
			},
			size = {
				nil,
				100
			}
		},
		visibility_function = scrollbar_visibility_function,
		change_function = function (content, style)
			local axis = content.axis or 2
			local parent_style = style.parent
			local hotspot_style = parent_style.hotspot
			local axis_offset = hotspot_style.offset[axis]
			local axis_length = hotspot_style.size[axis]
			style.size[axis] = axis_length
			style.offset[axis] = axis_offset
		end
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/scrollbars/scrollbar_metal_highlight",
		style_id = "highlight",
		style = {
			offset = {
				0,
				0,
				2
			},
			size = {
				nil,
				100
			}
		},
		visibility_function = scrollbar_visibility_function,
		change_function = function (content, style)
			local axis = content.axis or 2
			local parent_style = style.parent
			local hotspot_style = parent_style.hotspot
			local axis_offset = hotspot_style.offset[axis]
			local axis_length = hotspot_style.size[axis]
			style.size[axis] = axis_length
			style.offset[axis] = axis_offset
			local hover_progress = content.hotspot.anim_hover_progress
			style.color[1] = 255 * hover_progress
		end
	}
})

ScrollbarPassTemplates.metal_scrollbar.default_width = 8

return ScrollbarPassTemplates
