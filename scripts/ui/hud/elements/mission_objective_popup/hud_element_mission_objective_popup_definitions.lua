﻿-- chunkname: @scripts/ui/hud/elements/mission_objective_popup/hud_element_mission_objective_popup_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local get_hud_color = UIHudSettings.get_hud_color
local popup_size = {
	680,
	124,
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	mission_popup = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "top",
		size = popup_size,
		position = {
			0,
			280,
			1,
		},
	},
}
local title_text_style = table.clone(UIFontSettings.hud_body)

title_text_style.horizontal_alignment = "center"
title_text_style.vertical_alignment = "top"
title_text_style.text_horizontal_alignment = "center"
title_text_style.text_vertical_alignment = "center"
title_text_style.size = {
	450,
	50,
}
title_text_style.offset = {
	0,
	2,
	4,
}
title_text_style.drop_shadow = true
title_text_style.text_color = UIHudSettings.color_tint_main_1
title_text_style.font_type = "machine_medium"

local description_text_style = table.clone(UIFontSettings.header_2)

description_text_style.horizontal_alignment = "center"
description_text_style.vertical_alignment = "center"
description_text_style.text_horizontal_alignment = "center"
description_text_style.text_vertical_alignment = "center"
description_text_style.text_color = UIHudSettings.color_tint_main_1
description_text_style.size = {
	640,
	50,
}
description_text_style.offset = {
	0,
	12,
	4,
}
description_text_style.drop_shadow = true
description_text_style.line_spacing = 1
description_text_style.font_type = "machine_medium"
description_text_style.font_size = 30

local widget_definitions = {
	mission_popup = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "title_text",
			value = "<title_text>",
			value_id = "title_text",
			style = title_text_style,
		},
		{
			pass_type = "text",
			style_id = "description_text",
			value = "<description_text>",
			value_id = "description_text",
			style = description_text_style,
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/hud/backgrounds/objective_update_frame",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = popup_size,
				offset = {
					0,
					0,
					2,
				},
				color = get_hud_color("color_tint_main_2", 255),
			},
		},
		{
			pass_type = "texture",
			style_id = "effect",
			value = "content/ui/materials/hud/backgrounds/objective_update_effect",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					660,
					26,
				},
				offset = {
					0,
					-2,
					1,
				},
				color = {
					100,
					101,
					133,
					96,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/hud/backgrounds/objective_update_background",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size = popup_size,
				offset = {
					-2,
					0,
					0,
				},
				size_addition = {
					-14,
					-4,
				},
				color = get_hud_color("color_tint_main_3", 255),
			},
		},
	}, "mission_popup"),
}
local animations = {
	popup_start = {
		{
			end_time = 0,
			name = "reset",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				widget.alpha_multiplier = 0

				local style = widget.style
				local alpha = 0

				style.title_text.text_color[1] = alpha
				style.description_text.text_color[1] = alpha

				local scenegraph_id = widget.scenegraph_id
				local default_scenegraph = scenegraph_definition[scenegraph_id]
				local default_size = default_scenegraph.size
				local width = default_size[1] * 0.1

				style.background.size[1] = width
			end,
		},
		{
			end_time = 0.3,
			name = "fade_in",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeOutCubic(progress)

				widget.alpha_multiplier = anim_progress
			end,
		},
		{
			end_time = 0,
			name = "background_size_in",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeOutCubic(progress)
				local scenegraph_id = widget.scenegraph_id
				local default_scenegraph = scenegraph_definition[scenegraph_id]
				local default_size = default_scenegraph.size
				local width = default_size[1] * 0.1 + default_size[1] * 0.9 * anim_progress
				local style = widget.style

				style.background.size[1] = width
			end,
		},
		{
			end_time = 0.7,
			name = "text_fade_in",
			start_time = 0.3,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeInCubic(progress)
				local style = widget.style
				local alpha = anim_progress * 255

				style.title_text.text_color[1] = alpha
				style.description_text.text_color[1] = alpha
			end,
		},
		{
			end_time = 5.5,
			name = "text_fade_out",
			start_time = 5,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeOutCubic(1 - progress)
				local style = widget.style
				local alpha = anim_progress * 255

				style.title_text.text_color[1] = alpha
				style.description_text.text_color[1] = alpha
			end,
		},
		{
			end_time = 6,
			name = "fade_out",
			start_time = 5.5,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeInCubic(1 - progress)

				widget.alpha_multiplier = anim_progress
			end,
		},
		{
			end_time = 7,
			name = "delay",
			start_time = 6.5,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				return
			end,
		},
	},
}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
