-- chunkname: @scripts/ui/view_elements/view_element_player_stats/view_element_player_stats_blueprints.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local ItemUtils = require("scripts/utilities/items")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local Text = require("scripts/utilities/ui/text")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ViewElementTabMenuSettings = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu_settings")
local Text = require("scripts/utilities/ui/text")
local header_text = table.clone(UIFontSettings.header_3)

header_text.text_vertical_alignment = "center"
header_text.offset = {
	0,
	0,
	1,
}
header_text.font_size = 22

local category_text = table.clone(UIFontSettings.header_3)

category_text.offset = {
	0,
	0,
	1,
}
category_text.font_size = 18
category_text.text_horizontal_alignment = "left"
category_text.horizontal_alignment = "left"
category_text.text_color = Color.terminal_text_header(255, true)

local category_value = table.clone(category_text)

category_value.text_horizontal_alignment = "right"
category_value.horizontal_alignment = "right"
category_value.offset = {
	-10,
	0,
	0,
}

local sub_category_text = table.clone(category_text)

sub_category_text.text_color = Color.terminal_text_body(255, true)

local sub_category_value = table.clone(sub_category_text)

sub_category_value.text_horizontal_alignment = "right"
sub_category_value.horizontal_alignment = "right"
sub_category_value.offset = {
	-10,
	0,
	0,
}

local arrow_size = {
	32,
	32,
}
local DEFAULT_TEXT_WIDTH = 50
local VALUE_SPACING = 10

local function _format_number(num)
	local rounded = math.round(num * 10) / 10

	if rounded % 1 == 0 then
		return string.format("%d", rounded)
	end

	return string.format("%.1f", rounded)
end

local function _format_to_percentage(num)
	return string.format("%s%s", _format_number(num * 100), "%")
end

local function _format_to_seconds(num)
	return string.format("%s%s", _format_number(num), "s")
end

local function _format_to_num_per_seconds(num)
	return string.format("%s%s", _format_number(num), "/s")
end

local function _format_to_meters(num)
	return string.format("%s%s", _format_number(num), "m")
end

local function _format_to_meters_per_second(num)
	return string.format("%s%s", _format_number(num), "m/s")
end

local function format_data_by_type(value, data_type)
	if type(value) ~= "number" then
		return value
	end

	if data_type == "format_to_percentage" then
		return _format_to_percentage(value)
	elseif data_type == "format_to_seconds" then
		return _format_to_seconds(value)
	elseif data_type == "format_to_num_per_seconds" then
		return _format_to_num_per_seconds(value)
	elseif data_type == "format_to_meters" then
		return _format_to_meters(value)
	elseif data_type == "format_to_meters_per_second" then
		return _format_to_meters_per_second(value)
	else
		return _format_number(value)
	end
end

local function _apply_stat_text_layout(widget, ui_renderer)
	if not ui_renderer then
		return
	end

	local content = widget.content
	local style = widget.style
	local widget_width = content.size[1]
	local title_start_offset = style.title.offset[1] or 0
	local value_right_inset = -(style.value.offset[1] or 0)
	local value_width, value_height = Text.text_size(ui_renderer, content.value, style.value, {
		widget_width,
	}, true)
	local title_max_width = widget_width - title_start_offset - DEFAULT_TEXT_WIDTH - VALUE_SPACING - value_right_inset

	if value_width + VALUE_SPACING > DEFAULT_TEXT_WIDTH then
		title_max_width = widget_width - title_start_offset - value_width - VALUE_SPACING - value_right_inset
	end

	title_max_width = math.max(title_max_width, 0)

	local _, title_height = Text.text_size(ui_renderer, content.title, style.title, {
		title_max_width,
	}, true)
	local widget_height = math.max(title_height, value_height)

	content.size[2] = widget_height

	if content.active_size then
		content.active_size[2] = widget_height
	end

	style.title.size = {
		title_max_width,
		widget_height,
	}
	style.value.size = {
		widget_width,
		widget_height,
	}
end

local function init_func(parent, widget, element, ui_renderer)
	local content = widget.content
	local style = widget.style
	local level = element.level - 1
	local margin_left = arrow_size[1]
	local start_offset_x = level * margin_left
	local scenegraph_width = parent:_scenegraph_size(widget.scenegraph_id)
	local widget_width = scenegraph_width - start_offset_x

	content.stat_id = element.id
	content.title = Localize(element.title)
	content.value = format_data_by_type(element.data, element.data_type)
	content.has_childs = not not element.childs
	content.element = element
	content.inactive_offset_height = -10
	content.active_offset_height = 0
	content.inactive_alpha = 0
	content.active_alpha = 1
	content.is_parent_breakdown = element.is_parent_breakdown

	local title_start_offset = (level > 0 and element.has_childs or level == 0) and margin_left or 0
	local size = {
		widget_width,
		0,
	}

	content.inactive_size = {
		widget_width,
		0,
	}
	content.size = size
	content.active_size = table.clone(size)
	style.title.offset[1] = title_start_offset
	widget.offset = {
		start_offset_x,
		0,
		1,
	}

	_apply_stat_text_layout(widget, ui_renderer)
end

local blueprints = {
	category = {
		passes = {
			{
				content_id = "hotspot",
				pass_type = "hotspot",
			},
			{
				pass_type = "rotated_texture",
				style_id = "arrow",
				value = "content/ui/materials/hud/interactions/frames/arrow",
				value_id = "arrow",
				visibility_function = function (content, style)
					return not not content.has_childs
				end,
				style = {
					size = arrow_size,
					color = category_text.text_color,
					offset = {
						0,
						-5,
						0,
					},
				},
				change_function = function (content, style, _, dt)
					local rotation_time = 0.5
					local inactive_rotation = math.pi * 0.5
					local active_rotation = 0

					style.angle = style.angle or 0

					local is_animating = content.active and style.angle ~= active_rotation or not content.active and style.angle ~= inactive_rotation

					if is_animating then
						style.rotation_progress = style.rotation_progress and math.lerp(style.rotation_progress + dt, 0, rotation_time) or 0

						local rotation

						if content.active then
							rotation = math.lerp(active_rotation, inactive_rotation, style.rotation_progress)
						else
							rotation = math.lerp(inactive_rotation, active_rotation, style.rotation_progress)
						end

						style.angle = rotation
					elseif style.rotation_progress then
						style.rotation_progress = nil
					end
				end,
			},
			{
				pass_type = "rect",
				style_id = "selection",
				style = {
					color = Color.terminal_text_header(63.75, true),
				},
				visibility_function = function (content, style)
					return not not content.hotspot.pressed_callback
				end,
				change_function = function (content, style)
					local hotspot = content.hotspot
					local is_selected = hotspot.is_selected
					local is_focused = hotspot.is_focused
					local is_hover = hotspot.is_hover
					local disabled = hotspot.disabled
					local anim_hover_progress = hotspot.anim_hover_progress or 0
					local anim_select_progress = hotspot.anim_select_progress or 0
					local anim_focus_progress = hotspot.anim_focus_progres or 0
					local progress = math.max(math.max(anim_hover_progress, anim_select_progress), anim_focus_progress)

					style.color[1] = 63.75 * progress
				end,
			},
			{
				pass_type = "rect",
				style_id = "parent_breakdown",
				style = {
					color = Color.terminal_text_header(255, true),
					size = {
						5,
					},
				},
				visibility_function = function (content, style)
					return content.is_parent_breakdown
				end,
			},
			{
				pass_type = "text",
				style_id = "title",
				value = "Title",
				value_id = "title",
				style = category_text,
			},
			{
				pass_type = "text",
				style_id = "value",
				value = "0",
				value_id = "value",
				style = category_value,
			},
			{
				pass_type = "logic",
				value = function (pass, ui_renderer, ui_style, content, position, size)
					local styles = ui_style.parent

					styles.parent_breakdown.color = styles.title.text_color
				end,
			},
		},
		init = function (parent, widget, element, pressed_callback_name, ui_renderer)
			init_func(parent, widget, element, ui_renderer)

			local content = widget.content

			content.active = false

			if content.has_childs then
				content.hotspot.pressed_callback = pressed_callback_name and callback(parent, pressed_callback_name, widget, element)
			end
		end,
		update = function (parent, widget, element, ui_renderer)
			local content = widget.content

			content.value = format_data_by_type(element.data, element.data_type)

			_apply_stat_text_layout(widget, ui_renderer)
		end,
	},
	sub_category = {
		passes = {
			{
				pass_type = "text",
				style_id = "title",
				value = "Sub title",
				value_id = "title",
				style = sub_category_text,
			},
			{
				pass_type = "text",
				style_id = "value",
				value = "0",
				value_id = "value",
				style = sub_category_value,
			},
			{
				pass_type = "rect",
				style_id = "parent_breakdown",
				style = {
					color = Color.terminal_text_header(255, true),
					size = {
						2,
					},
					offset = {
						-16,
						-5,
						1,
					},
					size_addition = {
						0,
						10,
					},
				},
				visibility_function = function (content, style)
					return content.is_parent_breakdown
				end,
			},
			{
				pass_type = "logic",
				value = function (pass, ui_renderer, ui_style, content, position, size)
					local styles = ui_style.parent

					styles.parent_breakdown.color = styles.title.text_color
				end,
			},
		},
		init = function (parent, widget, element, pressed_callback_name, ui_renderer)
			init_func(parent, widget, element, ui_renderer)
		end,
		update = function (parent, widget, element, ui_renderer)
			local content = widget.content

			content.value = format_data_by_type(element.data, element.data_type)

			_apply_stat_text_layout(widget, ui_renderer)
		end,
	},
}

return blueprints
