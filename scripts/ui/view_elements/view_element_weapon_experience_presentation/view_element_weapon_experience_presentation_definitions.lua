-- chunkname: @scripts/ui/view_elements/view_element_weapon_experience_presentation/view_element_weapon_experience_presentation_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local BarPassTemplates = require("scripts/ui/pass_templates/bar_pass_templates")
local viewport_size = {
	600,
	540
}
local canvas_size = {
	viewport_size[1],
	viewport_size[2] + 80
}
local bar_size = {
	canvas_size[1] - 200,
	18
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = canvas_size,
		position = {
			0,
			0,
			3
		}
	},
	viewport = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "center",
		size = viewport_size,
		position = {
			0,
			0,
			3
		}
	},
	progress_bar = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "center",
		size = bar_size,
		position = {
			0,
			0,
			1
		}
	},
	experience_text = {
		vertical_alignment = "top",
		parent = "progress_bar",
		horizontal_alignment = "right",
		size = {
			800,
			bar_size[2]
		},
		position = {
			0,
			bar_size[2] - 50,
			1
		}
	},
	name_text = {
		vertical_alignment = "top",
		parent = "progress_bar",
		horizontal_alignment = "left",
		size = {
			800,
			bar_size[2]
		},
		position = {
			0,
			bar_size[2] - 50,
			1
		}
	},
	current_level_text = {
		vertical_alignment = "center",
		parent = "progress_bar",
		horizontal_alignment = "left",
		size = {
			200,
			40
		},
		position = {
			-140,
			0,
			1
		}
	},
	next_level_text = {
		vertical_alignment = "center",
		parent = "progress_bar",
		horizontal_alignment = "right",
		size = {
			200,
			40
		},
		position = {
			140,
			0,
			1
		}
	}
}
local name_text_style = table.clone(UIFontSettings.header_3)

name_text_style.text_horizontal_alignment = "left"
name_text_style.text_vertical_alignment = "bottom"

local experience_text_style = table.clone(UIFontSettings.header_3)

experience_text_style.text_horizontal_alignment = "right"
experience_text_style.text_vertical_alignment = "bottom"
experience_text_style.text_color = Color.ui_brown_super_light(255, true)

local level_text_style = table.clone(UIFontSettings.header_3)

level_text_style.text_horizontal_alignment = "center"
level_text_style.text_vertical_alignment = "center"

local widget_definitions = {
	progress_bar = UIWidget.create_definition(BarPassTemplates.experience_bar, "progress_bar"),
	experience_text = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = experience_text_style
		}
	}, "experience_text"),
	name_text = UIWidget.create_definition({
		{
			value = "weapon_name",
			value_id = "text",
			pass_type = "text",
			style = name_text_style
		}
	}, "name_text"),
	current_level_text = UIWidget.create_definition({
		{
			value = "0",
			value_id = "text",
			pass_type = "text",
			style = level_text_style
		}
	}, "current_level_text"),
	next_level_text = UIWidget.create_definition({
		{
			value = "0",
			value_id = "text",
			pass_type = "text",
			style = level_text_style
		}
	}, "next_level_text")
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

				widgets.progress_bar.alpha_multiplier = anim_progress
			end
		}
	}
}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
