local HudElementPrologueTutorialObjectivesTrackerSettings = require("scripts/ui/hud/elements/prologue_tutorial_step_tracker/hud_element_prologue_tutorial_step_tracker_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local get_hud_color = UIHudSettings.get_hud_color
local objective_tracker_settings = HudElementPrologueTutorialObjectivesTrackerSettings
local background_size = objective_tracker_settings.background_size
local entry_size = objective_tracker_settings.entry_size
local scenegraph_definition = {
	screen = {
		UIWorkspaceSettings.screen
	},
	background = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = background_size,
		position = {
			0,
			0,
			0
		}
	},
	entry_pivot = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "center",
		size = entry_size,
		position = {
			background_size[1],
			25,
			0
		}
	}
}
local description_text_style = objective_tracker_settings.description_text_style
description_text_style.text_color = objective_tracker_settings.entry_colors.description_text
description_text_style.default_text_color = objective_tracker_settings.entry_colors.description_text
local widget_definitions = {
	step_tracker = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/square_frame",
			style_id = "frame",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				size_addition = {
					0,
					0
				},
				color = get_hud_color("color_tint_main_2", 255),
				offset = {
					0,
					0,
					10
				}
			}
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
				color = get_hud_color("color_tint_main_4", 220)
			}
		},
		{
			value_id = "icon",
			style_id = "icon",
			pass_type = "texture",
			value = objective_tracker_settings.icon,
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = objective_tracker_settings.icon_size,
				offset = {
					10,
					0,
					5
				},
				color = UIHudSettings.color_tint_main_1
			}
		},
		{
			vertical_alignment = "center",
			pass_type = "text",
			style_id = "description_text",
			value = "",
			value_id = "description_text",
			horizontal_alignment = "center",
			style = description_text_style
		}
	}, "entry_pivot")
}
local animations = {
	add_entry = {
		{
			name = "add_entry_init",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				widget.alpha_multiplier = 0
				widget.offset[1] = -25
			end
		},
		{
			name = "add_entry",
			end_time = 0.6,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local scenegraph_id = widget.scenegraph_id
				local scenegraph_definition = scenegraph_definition[scenegraph_id]
				local size = scenegraph_definition.size
				local size_x = size[1]
				widget.offset[1] = -25 + -size_x * math.easeInCubic(progress)
			end
		},
		{
			name = "fade_in",
			end_time = 0.4,
			start_time = 0.2,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				widget.alpha_multiplier = 1 * math.easeOutCubic(progress)
			end
		}
	},
	remove_entry = {
		{
			name = "remove_entry",
			end_time = 0.8,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local scenegraph_id = widget.scenegraph_id
				local scenegraph_definition = scenegraph_definition[scenegraph_id]
				local size = scenegraph_definition.size
				local size_x = size[1]
				widget.offset[1] = -size_x - 25 + (25 + size_x) * math.easeInCubic(progress)
			end
		},
		{
			name = "fade_out",
			end_time = 0.8,
			start_time = 0.6,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local alpha = -1 * math.easeOutCubic(progress)
				widget.alpha_multiplier = alpha
			end
		}
	}
}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
