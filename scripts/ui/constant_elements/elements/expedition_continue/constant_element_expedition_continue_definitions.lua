-- chunkname: @scripts/ui/constant_elements/elements/expedition_continue/constant_element_expedition_continue_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			3,
		},
	},
	title = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			1920,
			50,
		},
		position = {
			0,
			100,
			0,
		},
	},
	sub_title = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			1920,
			50,
		},
		position = {
			0,
			160,
			0,
		},
	},
	options_area = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			0,
		},
	},
	option = {
		horizontal_alignment = "center",
		parent = "options_area",
		vertical_alignment = "center",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			0,
		},
	},
}
local title_style = {
	font_size = 46,
	font_type = "machine_medium",
	horizontal_alignment = "center",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "top",
	vertical_alignment = "top",
	text_color = Color.terminal_text_header(0, true),
	offset = {
		0,
		0,
		0,
	},
}
local sub_title_style = table.clone(title_style)

sub_title_style.font_size = 28

local widget_definitions = {
	title = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = title_style,
		},
	}, "title"),
	sub_title = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = sub_title_style,
		},
	}, "sub_title"),
}
local animations = {
	on_option_enter = {
		{
			end_time = 0,
			name = "init",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				if params.option_widgets then
					params.start_option_height = {}
					params.end_option_height = {}
					params.start_option_offset = {}
					params.end_option_offset = {}

					for i = 1, #params.option_widgets do
						local widget = params.option_widgets[i]

						params.start_option_height[i] = 0
						params.end_option_height[i] = widget.content.size[2]
						params.start_option_offset[i] = widget.offset[2] + widget.content.size[2] * 0.5
						widget.content.size[2] = params.start_option_height[i]
						params.end_option_offset[i] = widget.offset[2]
						widget.offset[2] = params.start_option_offset[i]

						local style = widget.style

						style.title.text_color[1] = 0
						style.sub_title.text_color[1] = 0
						style.description.text_color[1] = 0
						widget.alpha_multiplier = 0
					end
				end
			end,
		},
		{
			end_time = 0.3,
			name = "open",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				if params.option_widgets then
					for i = 1, #params.option_widgets do
						local widget = params.option_widgets[i]
						local offset_diff = params.start_option_offset[i] - params.end_option_offset[i]

						widget.offset[2] = params.start_option_offset[i] - anim_progress * offset_diff

						local height_diff = params.start_option_height[i] - params.end_option_height[i]

						widget.content.size[2] = params.start_option_height[i] - anim_progress * height_diff
						widget.alpha_multiplier = anim_progress
					end
				end
			end,
		},
		{
			end_time = 0.4,
			name = "fade_in",
			start_time = 0.2,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				if params.option_widgets then
					local anim_progress = math.easeOutCubic(progress)

					for i = 1, #params.option_widgets do
						local widget = params.option_widgets[i]
						local style = widget.style

						style.title.text_color[1] = anim_progress * 255
						style.sub_title.text_color[1] = anim_progress * 255
						style.description.text_color[1] = anim_progress * 255
					end
				end
			end,
		},
	},
	on_option_exit = {
		{
			end_time = 0,
			name = "init",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				if params.option_widgets then
					params.start_option_height = {}
					params.end_option_height = {}
					params.start_option_offset = {}
					params.end_option_offset = {}

					for i = 1, #params.option_widgets do
						local widget = params.option_widgets[i]

						params.start_option_height[i] = widget.content.size[2]
						params.end_option_height[i] = 0
						params.start_option_offset[i] = widget.offset[2]
						params.end_option_offset[i] = widget.offset[2] + widget.content.size[2] * 0.5

						local style = widget.style

						style.title.text_color[1] = 255
						style.sub_title.text_color[1] = 255
						style.description.text_color[1] = 255
						widget.alpha_multiplier = 1
					end
				end
			end,
		},
		{
			end_time = 0.4,
			name = "fade_out",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				if params.option_widgets then
					for i = 1, #params.option_widgets do
						local widget = params.option_widgets[i]
						local style = widget.style

						style.title.text_color[1] = (1 - anim_progress) * 255
						style.sub_title.text_color[1] = (1 - anim_progress) * 255
						style.description.text_color[1] = (1 - anim_progress) * 255
					end
				end
			end,
		},
		{
			end_time = 0.4,
			name = "close",
			start_time = 0.2,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				if params.option_widgets then
					local anim_progress = math.easeOutCubic(progress)

					for i = 1, #params.option_widgets do
						local widget = params.option_widgets[i]
						local offset_diff = params.start_option_offset[i] - params.end_option_offset[i]

						widget.offset[2] = params.start_option_offset[i] - anim_progress * offset_diff

						local height_diff = params.start_option_height[i] - params.end_option_height[i]

						widget.content.size[2] = params.start_option_height[i] - anim_progress * height_diff
						widget.alpha_multiplier = 1 - anim_progress
					end
				end
			end,
		},
	},
	on_text_enter = {
		{
			end_time = 0,
			name = "init",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				widgets.title.style.text.text_color[1] = 0
				widgets.sub_title.style.text.text_color[1] = 0
			end,
		},
		{
			end_time = 0.3,
			name = "open",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				widgets.title.style.text.text_color[1] = anim_progress * 255
				widgets.sub_title.style.text.text_color[1] = anim_progress * 255
			end,
		},
	},
	on_text_exit = {
		{
			end_time = 0,
			name = "init",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				widgets.title.style.text.text_color[1] = 255
				widgets.sub_title.style.text.text_color[1] = 255
			end,
		},
		{
			end_time = 0.3,
			name = "open",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				widgets.title.style.text.text_color[1] = 255 * (1 - anim_progress)
				widgets.sub_title.style.text.text_color[1] = 255 * (1 - anim_progress)
			end,
		},
	},
}

return {
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	animations = animations,
}
