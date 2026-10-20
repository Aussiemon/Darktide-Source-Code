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
local own_x = (content_width - value_width) / 2
local team_x = label_width + 2 * column_spacing + value_width
local rows_y = Settings.title_height + row_height
local header_y = Settings.header_top_padding
local header_height = rows_y - header_y
local header_icon_size = Settings.header_icon_size
local time_x = header_icon_size + 10
local terminal_color = {
	255,
	101,
	145,
	102,
}
local header_text_color = Color.terminal_text_body(255, true)
local row_text_color = {
	255,
	177,
	183,
	168,
}
local stat_name_color = {
	255,
	152,
	176,
	155,
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
	column_headers = {
		horizontal_alignment = "left",
		parent = "panel",
		vertical_alignment = "top",
		size = {
			content_width,
			header_height,
		},
		position = {
			padding,
			header_y,
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

local function _header_style(horizontal_alignment, x)
	local style = _column_style("body_small", horizontal_alignment, value_width, x, 10, header_text_color)

	style.size[2] = header_height

	return style
end

local function _row_text_style(horizontal_alignment, width, x, color)
	local style = _column_style("body", horizontal_alignment, width, x, nil, color or row_text_color)

	style.drop_shadow = true

	return style
end

local icon_style = table.clone(UIFontSettings.body)

icon_style.font_size = header_icon_size
icon_style.text_color = header_text_color
icon_style.text_horizontal_alignment = "center"
icon_style.text_vertical_alignment = "center"
icon_style.size = {
	header_icon_size + 10,
	header_height,
}
icon_style.offset = {
	label_x,
	5,
	1,
}

local time_label_style = table.clone(UIFontSettings.body_small)

time_label_style.text_color = header_text_color
time_label_style.text_horizontal_alignment = "left"
time_label_style.text_vertical_alignment = "bottom"
time_label_style.size = {
	label_width - time_x,
	header_height / 2,
}
time_label_style.offset = {
	time_x,
	2,
	1,
}

local time_style = table.clone(UIFontSettings.header_3)

time_style.text_horizontal_alignment = "left"
time_style.text_vertical_alignment = "top"
time_style.size = {
	label_width - time_x,
	header_height / 2,
}
time_style.offset = {
	time_x,
	header_height / 2,
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
	column_headers = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "icon",
			value = "",
			value_id = "icon",
			style = icon_style,
		},
		{
			pass_type = "text",
			style_id = "time_label",
			value = "",
			value_id = "time_label",
			style = time_label_style,
		},
		{
			pass_type = "text",
			style_id = "time",
			value = "",
			value_id = "time",
			style = time_style,
		},
		{
			pass_type = "text",
			style_id = "own",
			value = "",
			value_id = "own",
			style = _header_style("center", own_x),
		},
		{
			pass_type = "text",
			style_id = "team",
			value = "",
			value_id = "team",
			style = _header_style("right", team_x),
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
		style = _row_text_style("left", label_width, label_x, stat_name_color),
	},
	{
		pass_type = "text",
		style_id = "own",
		value = "",
		value_id = "own",
		style = _row_text_style("right", value_width, own_x - value_width / 2),
	},
	{
		pass_type = "text",
		style_id = "team",
		value = "",
		value_id = "team",
		style = _row_text_style("right", value_width, team_x),
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
