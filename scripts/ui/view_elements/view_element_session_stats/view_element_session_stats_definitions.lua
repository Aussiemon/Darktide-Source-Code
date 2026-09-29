-- chunkname: @scripts/ui/view_elements/view_element_session_stats/view_element_session_stats_definitions.lua

local Settings = require("scripts/ui/view_elements/view_element_session_stats/view_element_session_stats_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ColorUtilities = require("scripts/utilities/ui/colors")
local panel_width = Settings.panel_width
local padding = Settings.panel_padding
local row_height = Settings.row_height
local column_spacing = Settings.column_spacing
local value_width = Settings.value_column_width
local label_width = Settings.label_column_width
local content_width = panel_width - 2 * padding
local label_x = 0
local own_x = label_width + column_spacing - 75
local team_x = label_width + 2 * column_spacing + value_width
local rows_y = Settings.title_height + row_height
local terminal_color = {
	255,
	101,
	145,
	102,
}
local background_color = {
	64,
	0,
	0,
	0,
}
local row_shade_alpha = 64
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	pivot = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
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
	panel = {
		horizontal_alignment = "center",
		parent = "pivot",
		vertical_alignment = "top",
		size = {
			panel_width,
			0,
		},
		position = {
			0,
			0,
			1,
		},
	},
	title = {
		horizontal_alignment = "left",
		parent = "panel",
		vertical_alignment = "top",
		size = {
			content_width,
			Settings.title_height,
		},
		position = {
			padding,
			Settings.title_height - 5,
			10,
		},
	},
	column_headers = {
		horizontal_alignment = "left",
		parent = "panel",
		vertical_alignment = "top",
		size = {
			content_width,
			row_height,
		},
		position = {
			padding,
			Settings.title_height,
			10,
		},
	},
	row = {
		horizontal_alignment = "left",
		parent = "panel",
		vertical_alignment = "top",
		size = {
			content_width,
			row_height,
		},
		position = {
			padding,
			rows_y,
			10,
		},
	},
}

local function _column_style(font_settings_name, horizontal_alignment, width, x, font_size_addition, color)
	local style = table.clone(UIFontSettings[font_settings_name])

	style.font_size = style.font_size + (font_size_addition or 0)
	style.text_horizontal_alignment = horizontal_alignment
	style.text_vertical_alignment = "center"
	style.size = {
		width,
		row_height,
	}
	style.offset = {
		x,
		0,
		1,
	}

	if color then
		style.text_color = color
		style.default_color = color
	end

	return style
end

local title_style = table.clone(UIFontSettings.header_3)

title_style.text_horizontal_alignment = "left"
title_style.text_vertical_alignment = "center"

local own_header_style = table.clone(UIFontSettings.body_small)

own_header_style.font_size = own_header_style.font_size + 10
own_header_style.text_horizontal_alignment = "right"
own_header_style.text_vertical_alignment = "center"
own_header_style.size = {
	value_width,
	row_height,
}
own_header_style.offset = {
	own_x,
	0,
	1,
}

local row_shade_style = {
	color = {
		0,
		0,
		0,
		0,
	},
	default_color = {
		0,
		0,
		0,
		0,
	},
	hover_color = Color.terminal_background_selected(nil, true),
	size = {
		panel_width,
		row_height,
	},
	offset = {
		-padding,
		0,
		0,
	},
}
local row_hotspot_style = {
	size = {
		panel_width,
		row_height,
	},
	offset = {
		-padding,
		0,
		0,
	},
}
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = background_color,
				offset = {
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				color = terminal_color,
				offset = {
					0,
					0,
					1,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				color = terminal_color,
				offset = {
					0,
					0,
					3,
				},
				size_addition = {
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				color = terminal_color,
				offset = {
					0,
					0,
					4,
				},
				size_addition = {
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/end_of_round/end_of_round_session_stats_upper",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				offset = {
					0,
					-18,
					5,
				},
				size = {
					nil,
					36,
				},
				size_addition = {
					20,
					20,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/premium_store/offer_card_lower_regular",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				offset = {
					0,
					30,
					5,
				},
				size = {
					nil,
					48,
				},
				size_addition = {
					50,
					20,
				},
			},
		},
	}, "panel"),
	title = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = title_style,
		},
	}, "title"),
	column_headers = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "label",
			value = "",
			value_id = "label",
			style = _column_style("body_small", "left", label_width, label_x, 10),
		},
		{
			pass_type = "text",
			style_id = "own",
			value = "",
			value_id = "own",
			style = own_header_style,
		},
		{
			pass_type = "text",
			style_id = "team",
			value = "",
			value_id = "team",
			style = _column_style("body_small", "right", value_width, team_x, 10),
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/divider_line_01",
			style = {
				vertical_alignment = "bottom",
				color = terminal_color,
				size = {
					content_width,
					2,
				},
				offset = {
					0,
					0,
					2,
				},
			},
		},
	}, "column_headers"),
}
local row_definition = UIWidget.create_definition({
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style_id = "hotspot",
		style = row_hotspot_style,
	},
	{
		pass_type = "rect",
		style_id = "shade",
		style = row_shade_style,
		change_function = function (content, style, animations, dt)
			local hotspot = content.hotspot
			local anim_hover_progress = hotspot and hotspot.anim_hover_progress or 0
			local default_color = style.default_color

			if anim_hover_progress > 0 then
				ColorUtilities.color_lerp(default_color, style.hover_color, anim_hover_progress, style.color)
			elseif style.color[1] ~= default_color[1] or style.color[2] ~= default_color[2] or style.color[3] ~= default_color[3] or style.color[4] ~= default_color[4] then
				ColorUtilities.color_copy(default_color, style.color)
			end
		end,
	},
	{
		pass_type = "text",
		style_id = "label",
		value = "",
		value_id = "label",
		style = _column_style("body", "left", label_width, label_x, nil, terminal_color),
	},
	{
		pass_type = "text",
		style_id = "own",
		value = "",
		value_id = "own",
		style = _column_style("body", "right", value_width, own_x),
	},
	{
		pass_type = "text",
		style_id = "team",
		value = "",
		value_id = "team",
		style = _column_style("body", "right", value_width, team_x),
	},
}, "row")
local num_padding_rows = Settings.num_padding_rows
local padding_prompt_style = table.clone(UIFontSettings.input_legend_button)

padding_prompt_style.text_horizontal_alignment = "center"
padding_prompt_style.text_vertical_alignment = "center"
padding_prompt_style.normal_color = Color.ui_grey_light(255, true)
padding_prompt_style.hover_color = Color.white(255, true)
padding_prompt_style.text_color = Color.ui_grey_light(255, true)
padding_prompt_style.size = {
	panel_width,
	num_padding_rows * row_height,
}
padding_prompt_style.offset = {
	-padding,
	-(num_padding_rows - 1) * row_height,
	2,
}

local padding_prompt_hotspot_style = {
	horizontal_alignment = "center",
	size = {
		400,
		row_height,
	},
	offset = {
		0,
		row_height * (1 - num_padding_rows) / 2,
		1,
	},
}
local padding_definition = UIWidget.create_definition({
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style_id = "hotspot",
		style = padding_prompt_hotspot_style,
	},
	{
		pass_type = "rect",
		style_id = "shade",
		style = row_shade_style,
	},
	{
		pass_type = "text",
		style_id = "text",
		value = "",
		value_id = "text",
		style = padding_prompt_style,
		change_function = function (content, style)
			local hover_progress = content.hotspot and content.hotspot.anim_hover_progress or 0

			ColorUtilities.color_lerp(style.normal_color, style.hover_color, hover_progress, style.text_color)
		end,
	},
}, "row")

return {
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	row_definition = row_definition,
	padding_definition = padding_definition,
	row_shade_alpha = row_shade_alpha,
}
