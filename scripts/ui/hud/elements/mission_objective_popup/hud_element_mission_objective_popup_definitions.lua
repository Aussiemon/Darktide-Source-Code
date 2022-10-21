local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local get_hud_color = UIHudSettings.get_hud_color
local popup_size = {
	680,
	124
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	mission_popup = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = popup_size,
		position = {
			0,
			280,
			1
		}
	}
}
local title_text_style = table.clone(UIFontSettings.hud_body)
title_text_style.horizontal_alignment = "right"
title_text_style.vertical_alignment = "bottom"
title_text_style.text_horizontal_alignment = "right"
title_text_style.text_vertical_alignment = "center"
title_text_style.size = {
	450,
	50
}
title_text_style.offset = {
	-50,
	9,
	4
}
title_text_style.drop_shadow = true
title_text_style.text_color = UIHudSettings.color_tint_main_2
title_text_style.font_type = "rexlia"
local description_text_style = table.clone(UIFontSettings.header_2)
description_text_style.horizontal_alignment = "center"
description_text_style.vertical_alignment = "center"
description_text_style.text_horizontal_alignment = "center"
description_text_style.text_vertical_alignment = "center"
description_text_style.text_color = UIHudSettings.color_tint_main_1
description_text_style.size = {
	640,
	50
}
description_text_style.offset = {
	0,
	-10,
	4
}
description_text_style.drop_shadow = true
description_text_style.line_spacing = 1
description_text_style.font_type = "rexlia"
description_text_style.font_size = 30
local widget_definitions = {
	mission_popup = UIWidget.create_definition({
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
			value = "content/ui/materials/hud/backgrounds/objective_update",
			style_id = "background",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = popup_size,
				offset = {
					0,
					0,
					0
				},
				color = get_hud_color("color_tint_main_2", 255),
				default_color = get_hud_color("color_tint_main_1", 255)
			}
		},
		{
			value_id = "icon",
			style_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/icons/objectives/main",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				size = {
					30,
					30
				},
				offset = {
					-7,
					-2,
					3
				},
				color = UIHudSettings.color_tint_main_1,
				default_color = UIHudSettings.color_tint_main_1
			}
		}
	}, "mission_popup")
}
local animations = {}
animations.popup_start = {
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
			style.icon.color[1] = alpha
			local scenegraph_id = widget.scenegraph_id
			local default_scenegraph = scenegraph_definition[scenegraph_id]
			local default_size = default_scenegraph.size
			local width = default_size[1] * 0.1
			style.background.size[1] = width
		end
	},
	{
		name = "fade_in",
		end_time = 0.3,
		start_time = 0,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
			local anim_progress = math.easeOutCubic(progress)
			widget.alpha_multiplier = anim_progress
		end
	},
	{
		name = "background_size_in",
		end_time = 0,
		start_time = 0,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
			local anim_progress = math.easeOutCubic(progress)
			local scenegraph_id = widget.scenegraph_id
			local default_scenegraph = scenegraph_definition[scenegraph_id]
			local default_size = default_scenegraph.size
			local width = default_size[1] * 0.1 + default_size[1] * 0.9 * anim_progress
			local style = widget.style
			style.background.size[1] = width
		end
	},
	{
		name = "text_fade_in",
		end_time = 0.7,
		start_time = 0.3,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
			local anim_progress = math.easeInCubic(progress)
			local style = widget.style
			local alpha = anim_progress * 255
			style.title_text.text_color[1] = alpha
			style.description_text.text_color[1] = alpha
			style.icon.color[1] = alpha
		end
	},
	{
		name = "text_fade_out",
		end_time = 5.5,
		start_time = 5,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
			local anim_progress = math.easeOutCubic(1 - progress)
			local style = widget.style
			local alpha = anim_progress * 255
			style.title_text.text_color[1] = alpha
			style.description_text.text_color[1] = alpha
			style.icon.color[1] = alpha
		end
	},
	{
		name = "fade_out",
		end_time = 6,
		start_time = 5.5,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
			local anim_progress = math.easeInCubic(1 - progress)
			widget.alpha_multiplier = anim_progress
		end
	},
	{
		name = "delay",
		end_time = 7,
		start_time = 6.5,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
			return
		end
	}
}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
