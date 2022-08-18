local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")

local function _get_hud_color(key, alpha)
	local color = table.clone(UIHudSettings[key])

	if alpha then
		color[1] = alpha
	end

	return color
end

local background_size = {
	600,
	120
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	background = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "left",
		size = background_size,
		position = {
			70,
			0,
			1
		}
	},
	popup = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = background_size,
		position = {
			0,
			0,
			1
		}
	}
}
local title_text_style = table.clone(UIFontSettings.header_3)
title_text_style.horizontal_alignment = "center"
title_text_style.vertical_alignment = "top"
title_text_style.text_horizontal_alignment = "center"
title_text_style.text_vertical_alignment = "top"
title_text_style.offset = {
	0,
	20,
	2
}
title_text_style.text_color = _get_hud_color("color_tint_main_1", 255)
local description_text_style = table.clone(UIFontSettings.hud_body)
description_text_style.horizontal_alignment = "center"
description_text_style.vertical_alignment = "top"
description_text_style.text_horizontal_alignment = "center"
description_text_style.text_vertical_alignment = "top"
description_text_style.text_color = _get_hud_color("color_tint_main_2", 255)
description_text_style.offset = {
	0,
	70,
	2
}
local widget_definitions = {
	popup = UIWidget.create_definition({
		{
			value_id = "title_text",
			style_id = "title_text",
			pass_type = "text",
			value = "<title_text>",
			style = title_text_style
		},
		{
			value_id = "description_text",
			style_id = "description_text",
			pass_type = "text",
			value = "<description_text>",
			style = description_text_style
		},
		{
			style_id = "background",
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					0
				},
				size = background_size,
				size_addition = {
					40,
					40
				},
				color = _get_hud_color("color_tint_main_4", 180)
			}
		},
		{
			value = "content/ui/materials/frames/hover",
			style_id = "frame",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = _get_hud_color("color_tint_main_1", 255),
				size = background_size,
				size_addition = {
					40,
					40
				},
				offset = {
					0,
					0,
					0
				}
			}
		}
	}, "popup")
}
local animations = {
	popup_enter = {
		{
			name = "reset",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				widget.alpha_multiplier = 0
				local style = widget.style
				local alpha = 0
				style.title_text.text_color[1] = alpha
				style.description_text.text_color[1] = alpha
			end
		},
		{
			name = "fade_in",
			end_time = 0.8,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeOutCubic(progress)
				widget.alpha_multiplier = anim_progress
			end
		},
		{
			name = "size_increase",
			end_time = 0.8,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.ease_exp(progress)
				widget.alpha_multiplier = anim_progress
				local scenegraph_id = widget.scenegraph_id
				local default_scenegraph = scenegraph_definition[scenegraph_id]
				local default_size = default_scenegraph.size
				local width = default_size[1] * 0.1 + default_size[1] * 0.9 * anim_progress
				local height = default_size[2] * 0.1 + default_size[2] * 0.9 * anim_progress
				local style = widget.style
				local background_style_size = style.background.size
				background_style_size[1] = width
				background_style_size[2] = height
				local frame_style_size = style.frame.size
				frame_style_size[1] = width
				frame_style_size[2] = height
			end
		},
		{
			name = "text_fade_in",
			end_time = 0.8,
			start_time = 0.3,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeOutCubic(progress)
				local style = widget.style
				local alpha = anim_progress * 255
				style.title_text.text_color[1] = alpha
				style.description_text.text_color[1] = alpha
			end
		},
		{
			name = "delay",
			end_time = 1.3,
			start_time = 0.8,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				return
			end
		}
	},
	popup_exit = {
		{
			name = "size_decrease",
			end_time = 0.8,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.ease_exp(1 - progress)
				widget.alpha_multiplier = anim_progress
				local scenegraph_id = widget.scenegraph_id
				local default_scenegraph = scenegraph_definition[scenegraph_id]
				local default_size = default_scenegraph.size
				local width = default_size[1] * 0.1 + default_size[1] * 0.9 * anim_progress
				local height = default_size[2] * 0.1 + default_size[2] * 0.9 * anim_progress
				local style = widget.style
				local background_style_size = style.background.size
				background_style_size[1] = width
				background_style_size[2] = height
				local frame_style_size = style.frame.size
				frame_style_size[1] = width
				frame_style_size[2] = height
			end
		},
		{
			name = "text_fade_out",
			end_time = 0.5,
			start_time = 0.3,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeInCubic(1 - progress)
				local style = widget.style
				local alpha = anim_progress * 255
				style.title_text.text_color[1] = alpha
				style.description_text.text_color[1] = alpha
			end
		},
		{
			name = "fade_out",
			end_time = 0.5,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeOutCubic(1 - progress)
				widget.alpha_multiplier = anim_progress
			end
		},
		{
			name = "delay",
			end_time = 1.5,
			start_time = 0.5,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				return
			end
		}
	}
}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
