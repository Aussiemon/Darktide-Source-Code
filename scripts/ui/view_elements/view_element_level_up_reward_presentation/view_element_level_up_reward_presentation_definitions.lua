-- chunkname: @scripts/ui/view_elements/view_element_level_up_reward_presentation/view_element_level_up_reward_presentation_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	pivot = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			3
		}
	},
	title_text = {
		vertical_alignment = "center",
		parent = "pivot",
		horizontal_alignment = "center",
		size = {
			900,
			50
		},
		position = {
			0,
			200,
			3
		}
	},
	name_text = {
		vertical_alignment = "center",
		parent = "title_text",
		horizontal_alignment = "center",
		size = {
			900,
			50
		},
		position = {
			0,
			50,
			3
		}
	},
	texture = {
		vertical_alignment = "center",
		parent = "pivot",
		horizontal_alignment = "center",
		size = {
			400,
			320
		},
		position = {
			0,
			0,
			0
		}
	}
}
local title_text_style = table.clone(UIFontSettings.header_1)

title_text_style.text_horizontal_alignment = "center"
title_text_style.text_vertical_alignment = "center"

local name_text_style = table.clone(UIFontSettings.header_2)

name_text_style.text_horizontal_alignment = "center"
name_text_style.text_vertical_alignment = "center"

local widget_definitions = {
	title_text = UIWidget.create_definition({
		{
			value = "loc_item_level_up_reward_title",
			value_id = "text",
			pass_type = "text",
			style = title_text_style
		}
	}, "title_text"),
	name_text = UIWidget.create_definition({
		{
			value = "n/a",
			value_id = "text",
			pass_type = "text",
			style = name_text_style
		}
	}, "name_text"),
	texture = UIWidget.create_definition({
		{
			pass_type = "texture",
			value_id = "texture"
		}
	}, "texture")
}
local anim_start_delay = 0
local animations = {
	on_enter = {
		{
			name = "init",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent._alpha_multiplier = 0
			end
		},
		{
			name = "fade_in",
			start_time = anim_start_delay + 0,
			end_time = anim_start_delay + 0.5,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				parent._alpha_multiplier = anim_progress
			end
		},
		{
			name = "experience_bar",
			start_time = anim_start_delay + 0,
			end_time = anim_start_delay + 0.7,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeCubic(progress)
			end
		}
	}
}

return {
	animations = animations,
	background_widget_definition = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				offset = {
					0,
					0,
					0
				},
				color = Color.black(30, true)
			}
		}
	}, "screen"),
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
