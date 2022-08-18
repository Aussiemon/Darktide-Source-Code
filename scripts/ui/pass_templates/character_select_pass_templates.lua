local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ColorUtilities = require("scripts/utilities/ui/colors")
local BarPassTemplates = require("scripts/ui/pass_templates/bar_pass_templates")
local character_create_size = {
	580,
	130
}
local portrait_size = {
	90,
	100
}
local badge_size = {
	40,
	100
}
local CharacterSelectPassTemplates = {
	character_create_size = character_create_size
}
local list_button_hotspot_default_style = {
	anim_hover_speed = 8,
	anim_input_speed = 8,
	anim_select_speed = 8,
	anim_focus_speed = 8,
	on_hover_sound = UISoundEvents.default_mouse_hover,
	on_pressed_sound = UISoundEvents.default_click
}
local list_button_highlight_size_addition = 10

local function list_button_focused_visibility_function(content, style)
	local hotspot = content.hotspot

	return hotspot.is_hover or hotspot.is_selected or hotspot.is_focused
end

local function list_button_highlight_change_function(content, style)
	local hotspot = content.hotspot
	local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
	style.color[1] = 255 * math.easeOutCubic(progress)
	local size_addition = list_button_highlight_size_addition * math.easeInCubic(1 - progress)
	local style_size_additon = style.size_addition
	style_size_additon[1] = size_addition * 2
	style.size_addition[2] = size_addition * 2
	local offset = style.offset
	offset[1] = -size_addition
	offset[2] = -size_addition
	style.hdr = progress == 1
end

local character_info_margin = {
	20,
	10
}
local character_text_margin = {
	20,
	0
}
local text_margin = portrait_size[1] + badge_size[1] + character_info_margin[1] + character_text_margin[1]
local text_width = character_create_size[1] - text_margin
local character_name_style = table.clone(UIFontSettings.header_3)
character_name_style.text_horizontal_alignment = "left"
character_name_style.text_vertical_alignment = "top"
character_name_style.horizontal_alignment = "left"
character_name_style.vertical_alignment = "center"
character_name_style.size = {
	text_width,
	30
}
character_name_style.offset = {
	text_margin,
	-8,
	1
}
character_name_style.text_color = Color.white(255, true)
character_name_style.material = "content/ui/materials/font_gradients/slug_font_gradient_header"
local character_name_hover_style = table.clone(UIFontSettings.header_3)
character_name_hover_style.text_horizontal_alignment = "left"
character_name_hover_style.text_vertical_alignment = "top"
character_name_hover_style.horizontal_alignment = "left"
character_name_hover_style.vertical_alignment = "center"
character_name_hover_style.size = {
	text_width,
	30
}
character_name_hover_style.offset = {
	text_margin,
	-8,
	2
}
character_name_hover_style.hover_color = Color.white(255, true)
character_name_hover_style.default_color = Color.white(0, true)
character_name_hover_style.hover_color = Color.white(255, true)
local character_title_style = table.clone(UIFontSettings.body_small)
character_title_style.text_horizontal_alignment = "left"
character_title_style.text_vertical_alignment = "bottom"
character_title_style.horizontal_alignment = "left"
character_title_style.vertical_alignment = "center"
character_title_style.size = {
	text_width,
	54
}
character_title_style.offset = {
	text_margin,
	-3,
	1
}
CharacterSelectPassTemplates.character_select = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		style = list_button_hotspot_default_style
	},
	{
		pass_type = "texture",
		style_id = "background_selected",
		value = "content/ui/materials/buttons/background_selected",
		style = {
			color = Color.ui_terminal(0, true),
			offset = {
				0,
				0,
				0
			}
		},
		change_function = function (content, style)
			style.color[1] = 255 * content.hotspot.anim_select_progress
		end,
		visibility_function = list_button_focused_visibility_function
	},
	{
		pass_type = "texture",
		style_id = "highlight",
		value = "content/ui/materials/frames/hover",
		style = {
			hdr = true,
			color = Color.ui_terminal(255, true),
			offset = {
				0,
				0,
				2
			},
			size_addition = {
				0,
				0
			}
		},
		change_function = list_button_highlight_change_function,
		visibility_function = list_button_focused_visibility_function
	},
	{
		value_id = "character_insignia",
		style_id = "character_insignia",
		pass_type = "texture",
		value = "content/ui/materials/base/ui_default_base",
		style = {
			vertical_alignment = "center",
			size = badge_size,
			offset = {
				character_info_margin[1],
				0,
				62
			},
			material_values = {}
		},
		visibility_function = function (content, style)
			return not not style.material_values.texture_map
		end
	},
	{
		value_id = "character_portrait",
		style_id = "character_portrait",
		pass_type = "texture",
		value = "content/ui/materials/base/ui_portrait_frame_base",
		style = {
			vertical_alignment = "center",
			size = portrait_size,
			offset = {
				badge_size[1] + character_info_margin[1],
				0,
				1
			},
			material_values = {
				texture_frame = "content/ui/textures/icons/items/frames/default",
				use_placeholder_texture = 1
			}
		}
	},
	{
		value = "text",
		value_id = "character_name",
		pass_type = "text",
		style = character_name_style
	},
	{
		pass_type = "text",
		value_id = "character_name",
		value = "text",
		style = character_name_hover_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_color = (hotspot.disabled and style.disabled_color) or style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

			ColorUtilities.color_lerp(default_color, hover_color, progress, text_color)
		end
	},
	{
		value = "text",
		value_id = "character_title",
		pass_type = "text",
		style = character_title_style
	}
}

return CharacterSelectPassTemplates
