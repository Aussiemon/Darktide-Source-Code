-- chunkname: @scripts/ui/hud/elements/area_notification_popup/hud_element_area_notification_popup_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local get_hud_color = UIHudSettings.get_hud_color
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	area_popup = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			650,
			90,
		},
		position = {
			0,
			160,
			1,
		},
	},
}
local title_text_style = table.clone(UIFontSettings.hud_body)

title_text_style.horizontal_alignment = "center"
title_text_style.vertical_alignment = "center"
title_text_style.text_horizontal_alignment = "center"
title_text_style.text_vertical_alignment = "center"
title_text_style.size = {
	650,
	40,
}
title_text_style.offset = {
	0,
	-20,
	2,
}
title_text_style.text_color = UIHudSettings.color_tint_main_1
title_text_style.font_type = "machine_medium"

local description_text_style = table.clone(UIFontSettings.header_2)

description_text_style.horizontal_alignment = "center"
description_text_style.vertical_alignment = "center"
description_text_style.text_horizontal_alignment = "center"
description_text_style.text_vertical_alignment = "center"
description_text_style.text_color = UIHudSettings.color_tint_main_1
description_text_style.size = {
	650,
	50,
}
description_text_style.offset = {
	0,
	10,
	2,
}
description_text_style.font_type = "machine_medium"
description_text_style.font_size = 30

local widget_definitions = {
	area_popup = UIWidget.create_definition({
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
	}, "area_popup"),
	background = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "texture",
			value = "content/ui/materials/hud/backgrounds/location_update",
			style = {
				hdr = false,
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size = {
					650,
				},
				offset = {
					0,
					0,
					0,
				},
				color = get_hud_color("color_tint_main_2", 255),
				material_values = {
					distortion = 1,
				},
			},
		},
	}, "area_popup"),
}
local animations = {
	popup_enter = {
		{
			end_time = 0,
			name = "hide everything",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets)
				for key, widget in pairs(widgets) do
					widget.alpha_multiplier = 0
				end

				widgets.background.style.texture.material_values.distortion = 1
			end,
		},
		{
			end_time = 2,
			name = "background_distortion_in",
			start_time = 0.3,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress)
				local anim_progress = math.clamp(math.ease_out_exp(math.bounce(progress)), 0, 1)
				local widget = widgets.background

				widget.style.texture.material_values.distortion = 0.1 + (1 - progress) * 0.9
			end,
		},
		{
			end_time = 0.5,
			name = "icon_fade_in",
			start_time = 0.1,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress)
				local anim_progress = math.easeOutCubic(progress)
				local background_widget = widgets.background

				background_widget.alpha_multiplier = anim_progress
				background_widget.offset[2] = 50 - 50 * anim_progress
			end,
		},
		{
			end_time = 1,
			name = "text_fade_in",
			start_time = 0.6,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress)
				local anim_progress = math.easeCubic(progress)

				for key, widget in pairs(widgets) do
					if key ~= "background" then
						widget.alpha_multiplier = anim_progress
					end
				end
			end,
		},
		{
			end_time = 7.5,
			name = "text_fade_out",
			start_time = 6.5,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress)
				local anim_progress = math.easeOutCubic(progress)

				for key, widget in pairs(widgets) do
					if key ~= "background" then
						widget.alpha_multiplier = 1 - anim_progress
					end
				end
			end,
		},
		{
			end_time = 6.5,
			name = "background_distortion_out",
			start_time = 6,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress)
				local anim_progress = math.easeCubic(progress)
				local widget = widgets.background

				widget.style.texture.material_values.distortion = 0.1 + progress * 0.9
			end,
		},
		{
			end_time = 7.5,
			name = "background_out",
			start_time = 6.5,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress)
				local anim_progress = math.easeOutCubic(progress)
				local background_widget = widgets.background

				background_widget.alpha_multiplier = 1 - anim_progress
			end,
		},
	},
}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
