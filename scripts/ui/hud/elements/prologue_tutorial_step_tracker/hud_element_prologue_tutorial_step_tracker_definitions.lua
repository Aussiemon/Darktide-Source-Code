-- chunkname: @scripts/ui/hud/elements/prologue_tutorial_step_tracker/hud_element_prologue_tutorial_step_tracker_definitions.lua

local HudElementPrologueTutorialObjectivesTrackerSettings = require("scripts/ui/hud/elements/prologue_tutorial_step_tracker/hud_element_prologue_tutorial_step_tracker_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local get_hud_color = UIHudSettings.get_hud_color
local objective_tracker_settings = HudElementPrologueTutorialObjectivesTrackerSettings
local background_size = objective_tracker_settings.background_size
local entry_size = objective_tracker_settings.entry_size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	background = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = background_size,
		position = {
			0,
			0,
			0,
		},
	},
	entry_pivot = {
		horizontal_alignment = "center",
		parent = "background",
		vertical_alignment = "top",
		size = entry_size,
		position = {
			background_size[1],
			25,
			0,
		},
	},
}
local description_text_style = objective_tracker_settings.description_text_style

description_text_style.text_color = objective_tracker_settings.entry_colors.description_text
description_text_style.default_text_color = objective_tracker_settings.entry_colors.description_text

local widget_definitions = {
	step_tracker = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			style_id = "frame",
			value = "content/ui/materials/frames/square_frame",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				uvs = {
					{
						1,
						0,
					},
					{
						0,
						1,
					},
				},
				size_addition = {
					0,
					0,
				},
				color = get_hud_color("color_tint_main_2", 255),
				offset = {
					0,
					0,
					10,
				},
			},
		},
		{
			pass_type = "rect",
			style_id = "background",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					0,
				},
				color = get_hud_color("color_tint_main_4", 220),
			},
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value_id = "icon",
			value = objective_tracker_settings.icon,
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = objective_tracker_settings.icon_size,
				offset = {
					10,
					0,
					5,
				},
				color = UIHudSettings.color_tint_main_1,
			},
		},
		{
			pass_type = "text",
			style_id = "description_text",
			value = "",
			value_id = "description_text",
			style = description_text_style,
		},
	}, "entry_pivot"),
}
local animations = {
	add_entry = {
		{
			end_time = 0,
			name = "add_entry_init",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				widget.alpha_multiplier = 0
				widget.offset[1] = -25
			end,
		},
		{
			end_time = 0.6,
			name = "add_entry",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local scenegraph_id = widget.scenegraph_id
				local scenegraph_definition = scenegraph_definition[scenegraph_id]
				local size = scenegraph_definition.size
				local size_x = size[1]

				widget.offset[1] = -25 + -size_x * math.easeInCubic(progress)
			end,
		},
		{
			end_time = 0.4,
			name = "fade_in",
			start_time = 0.2,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				widget.alpha_multiplier = 1 * math.easeOutCubic(progress)
			end,
		},
	},
	remove_entry = {
		{
			end_time = 0.8,
			name = "remove_entry",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local scenegraph_id = widget.scenegraph_id
				local scenegraph_definition = scenegraph_definition[scenegraph_id]
				local size = scenegraph_definition.size
				local size_x = size[1]

				widget.offset[1] = -size_x - 25 + (25 + size_x) * math.easeInCubic(progress)
			end,
		},
		{
			end_time = 0.8,
			name = "fade_out",
			start_time = 0.6,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local alpha = -1 * math.easeOutCubic(progress)

				widget.alpha_multiplier = alpha
			end,
		},
	},
}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
