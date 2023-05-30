local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ColorUtilities = require("scripts/utilities/ui/colors")
local BarPassTemplates = require("scripts/ui/pass_templates/bar_pass_templates")
local color_lerp = ColorUtilities.color_lerp
local color_copy = ColorUtilities.color_copy
local math_lerp = math.lerp
local math_max = math.max
local character_create_size = {
	560,
	110
}
local portrait_size = {
	90,
	100
}
local badge_size = {
	40,
	100
}
local icon_size = {
	120,
	120
}
local CharacterSelectPassTemplates = {
	character_create_size = character_create_size
}
local list_button_hotspot_default_style = {
	anim_select_speed = 8,
	anim_hover_speed = 8,
	anim_input_speed = 8,
	anim_focus_speed = 8,
	on_hover_sound = UISoundEvents.default_mouse_hover
}

local function list_button_selected_visibility_function(content, style)
	local hotspot = content.hotspot

	return hotspot.is_selected or hotspot.anim_select_progress > 0
end

local function list_button_all_visibility_function(content, style)
	local hotspot = content.hotspot
	local is_hovered = hotspot.is_hover or hotspot.is_focused or hotspot.is_selected
	local was_hovered = hotspot.anim_hover_progress > 0 or hotspot.anim_focus_progress > 0 or hotspot.anim_select_progress > 0

	return is_hovered or was_hovered
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
	-12,
	1
}
character_name_style.text_color = Color.terminal_text_header(255, true)
character_name_style.default_color = Color.terminal_text_header(255, true)
character_name_style.hover_color = Color.white(255, true)
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
	-1,
	1
}
character_title_style.text_color = Color.terminal_text_body_sub_header(255, true)
character_title_style.default_color = Color.terminal_text_body_sub_header(255, true)
character_title_style.hover_color = Color.terminal_text_header(255, true)

local function character_button_change_function(content, style)
	local math_max = math_max
	local hotspot = content.hotspot
	local select_progress = hotspot.anim_select_progress
	local hover_progress = math_max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
	local color = style.color
	local default_color = style.hover_color
	local focused_color = style.selected_color

	if hotspot.is_focused then
		color_copy(focused_color, color)
	else
		color_lerp(default_color, focused_color, select_progress, color)
	end

	local max_alpha = style.max_alpha or 255
	local min_alpha = style.min_alpha or 0
	color[1] = math_lerp(min_alpha, max_alpha, hover_progress) * math_max(hover_progress, select_progress)
	local selected_layer = style.selected_layer

	if selected_layer then
		if select_progress > 0 then
			style.offset[3] = selected_layer
		else
			style.offset[3] = style.hover_layer
		end
	end
end

local function character_background_change_function(content, style)
	local hotspot = content.hotspot
	local select_progress = hotspot.anim_select_progress or 0
	local hover_progress = math_max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
	local color = style.color
	local hover_alpha = style.hover_alpha
	local selected_alpha = style.selected_alpha
	local alpha = math_lerp(selected_alpha, hover_alpha, hover_progress)
	color[1] = alpha * select_progress
end

CharacterSelectPassTemplates.character_select_padding_top = {
	{
		value_id = "divider",
		style_id = "divider",
		pass_type = "texture",
		value = "content/ui/materials/dividers/divider_line_01",
		style = {
			size = {
				nil,
				2
			},
			color = Color.terminal_frame(128, true)
		}
	}
}
CharacterSelectPassTemplates.character_select = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		style = list_button_hotspot_default_style,
		content = {
			use_is_focused = false
		}
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			scale_to_material = true,
			hover_alpha = 64,
			selected_alpha = 24,
			color = Color.terminal_background_selected(nil, true),
			size_addition = {
				nil,
				-2
			},
			offset = {
				0,
				0,
				0
			}
		},
		change_function = character_background_change_function,
		visibility_function = list_button_selected_visibility_function
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/masks/gradient_horizontal_sides_dynamic_02",
		style = {
			scale_to_material = true,
			max_alpha = 255,
			min_alpha = 150,
			hover_color = Color.terminal_background_gradient(nil, true),
			selected_color = Color.terminal_background_gradient_selected(nil, true),
			size_addition = {
				nil,
				-2
			},
			offset = {
				0,
				0,
				1
			}
		},
		change_function = character_button_change_function,
		visibility_function = list_button_all_visibility_function
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			hover_layer = 4,
			vertical_alignment = "center",
			selected_layer = 6,
			horizontal_alignment = "center",
			scale_to_material = true,
			max_alpha = 255,
			min_alpha = 150,
			size_addition = {
				nil,
				2
			},
			default_color = Color.terminal_frame(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				-1,
				4
			}
		},
		change_function = character_button_change_function,
		visibility_function = list_button_all_visibility_function
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			hover_layer = 5,
			vertical_alignment = "center",
			selected_layer = 7,
			horizontal_alignment = "center",
			scale_to_material = true,
			max_alpha = 255,
			min_alpha = 150,
			size_addition = {
				nil,
				2
			},
			default_color = Color.terminal_corner(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			offset = {
				0,
				-1,
				5
			}
		},
		change_function = character_button_change_function,
		visibility_function = list_button_all_visibility_function
	},
	{
		style_id = "archetype_icon",
		pass_type = "texture",
		value = "content/ui/materials/icons/classes/veteran",
		value_id = "archetype_icon",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			max_alpha = 128,
			min_alpha = 64,
			offset = {
				0,
				0,
				1
			},
			size = icon_size,
			default_color = Color.terminal_frame(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true)
		},
		change_function = character_button_change_function
	},
	{
		value = "content/ui/materials/dividers/divider_line_01",
		pass_type = "texture",
		style = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			color = Color.terminal_frame(128, true),
			size = {
				nil,
				2
			},
			offset = {
				0,
				0,
				2
			}
		}
	},
	{
		value = "content/ui/materials/dividers/divider_line_01",
		pass_type = "texture",
		style = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			color = Color.terminal_frame(128, true),
			size = {
				nil,
				2
			},
			offset = {
				0,
				-2,
				2
			}
		}
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
				use_placeholder_texture = 1
			}
		}
	},
	{
		pass_type = "text",
		value_id = "character_name",
		value = "text",
		style = character_name_style,
		change_function = function (content, style)
			local math_max = math_max
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math_max(math_max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math_max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

			color_lerp(default_color, hover_color, progress, text_color)
		end
	},
	{
		pass_type = "text",
		value_id = "character_title",
		value = "text",
		style = character_title_style,
		change_function = function (content, style)
			local math_max = math_max
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math_max(math_max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math_max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

			color_lerp(default_color, hover_color, progress, text_color)
		end
	}
}

return CharacterSelectPassTemplates
