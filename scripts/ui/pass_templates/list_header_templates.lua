-- chunkname: @scripts/ui/pass_templates/list_header_templates.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIResolution = require("scripts/managers/ui/ui_resolution")
local ColorUtilities = require("scripts/utilities/ui/colors")
local highlight_size_addition = 10
local TAB_SIZE = 20

local function list_item_focused_visibility_function(content, style)
	local hotspot = content.hotspot or content.parent and content.parent.hotspot

	return hotspot and ((hotspot.is_hover or hotspot.is_selected) and not content.disabled or hotspot.is_focused)
end

local function list_item_highight_focused_visibility_function(content, style)
	local hotspot = content.hotspot or content.parent.hotspot

	return (hotspot.is_hover or hotspot.is_selected or hotspot.is_focused) and not content.disabled
end

local function highlight_color_change_function(content, style)
	local default_color = content.disabled and style.disabled_color or style.default_color
	local hover_color = content.disabled and style.disabled_color or style.hover_color
	local color = style.color or style.text_color
	local progress = content.highlight_progress or 0

	ColorUtilities.color_lerp(default_color, hover_color, progress, color)

	style.hdr = progress == 1
end

local ListHeaderPassTemplates = {}

ListHeaderPassTemplates.default_hotspot_style = {
	anim_hover_speed = 8,
	anim_input_speed = 8,
	anim_select_speed = 8,
	anim_focus_speed = 8,
	on_hover_sound = UISoundEvents.default_mouse_hover,
	on_pressed_sound = UISoundEvents.default_click
}
ListHeaderPassTemplates.highlight_size_addition = highlight_size_addition
ListHeaderPassTemplates.list_highlight_color_change_function = highlight_color_change_function
ListHeaderPassTemplates.list_item_focused_visibility_function = list_item_focused_visibility_function
ListHeaderPassTemplates.list_item_highight_focused_visibility_function = list_item_highight_focused_visibility_function

ListHeaderPassTemplates.list_header = function (header_width, height, use_is_focused, is_sub_setting)
	local header_font_style = table.clone(UIFontSettings.header_4)
	local default_offset = table.shallow_copy(header_font_style.offset)

	header_font_style.size = {
		header_width,
		height
	}
	header_font_style.size_addition = {
		-60 + (is_sub_setting and TAB_SIZE or 0),
		0,
		1
	}
	header_font_style.offset[1] = default_offset[1] + (is_sub_setting and TAB_SIZE or 0)
	header_font_style.default_color = Color.terminal_text_body(255, true)
	header_font_style.text_color = Color.terminal_text_body(255, true)
	header_font_style.hover_color = Color.terminal_text_header_selected(255, true)
	header_font_style.disabled_color = Color.terminal_text_body_dark(255, true)

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

	if header_width > 0 then
		passes[#passes + 1] = {
			pass_type = "texture",
			style_id = "background_selected",
			value = "content/ui/materials/buttons/background_selected_faded",
			style = {
				color = Color.terminal_corner_hover(0, true),
				offset = {
					0,
					0,
					0
				},
				size = {
					header_width,
					height
				}
			},
			change_function = function (content, style)
				style.color[1] = 255 * content.highlight_progress
			end,
			visibility_function = list_item_focused_visibility_function
		}
		passes[#passes + 1] = {
			pass_type = "texture",
			style_id = "frame_highlight",
			value = "content/ui/materials/buttons/background_selected_edge",
			style = {
				hdr = true,
				color = Color.terminal_corner_hover(255, true),
				offset = {
					0,
					0,
					11
				},
				size_addition = {
					0,
					0
				},
				size = {
					4,
					height
				}
			},
			change_function = function (content, style)
				local hotspot = content.hotspot
				local use_is_focused = hotspot.use_is_focused
				local focus_progress = use_is_focused and hotspot.anim_focus_progress or not use_is_focused and hotspot.anim_select_progress
				local progress = math.max(hotspot.anim_hover_progress, focus_progress)

				style.color[1] = 255 * math.easeOutCubic(progress)

				local size_addition = highlight_size_addition * math.easeInCubic(1 - progress)

				style.size_addition[2] = size_addition * 2
				style.offset[2] = -size_addition
				style.hdr = progress == 1
			end,
			visibility_function = list_item_focused_visibility_function
		}
		passes[#passes + 1] = {
			style_id = "list_header",
			pass_type = "text",
			value = "n/a",
			value_id = "text",
			style = header_font_style,
			change_function = highlight_color_change_function
		}
	end

	return passes
end

return settings("ListHeaderPassTemplates", ListHeaderPassTemplates)
