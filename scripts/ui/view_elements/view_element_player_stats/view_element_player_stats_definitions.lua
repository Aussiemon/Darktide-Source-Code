-- chunkname: @scripts/ui/view_elements/view_element_player_stats/view_element_player_stats_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local total_width = 350
local text_width = total_width - 60
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	entry_pivot = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			-30,
			150,
			1,
		},
	},
	header = {
		horizontal_alignment = "right",
		parent = "entry_pivot",
		vertical_alignment = "top",
		size = {
			total_width,
			56,
		},
		position = {
			0,
			0,
			3,
		},
	},
	stats_background = {
		horizontal_alignment = "left",
		parent = "header",
		vertical_alignment = "top",
		size = {
			text_width,
			300,
		},
		position = {
			30,
			40,
			-1,
		},
	},
	stats = {
		horizontal_alignment = "left",
		parent = "stats_background",
		vertical_alignment = "top",
		size = {
			text_width,
			0,
		},
		position = {
			0,
			20,
			1,
		},
	},
	stats_key_shortcuts = {
		horizontal_alignment = "left",
		parent = "stats_background",
		vertical_alignment = "bottom",
		size = {
			text_width,
			40,
		},
		position = {
			0,
			55,
			1,
		},
	},
}
local header_text = table.clone(UIFontSettings.header_3)

header_text.text_vertical_alignment = "center"
header_text.offset = {
	40,
	0,
	1,
}
header_text.font_size = 22

local category_text = table.clone(UIFontSettings.header_3)

category_text.offset = {
	40,
	0,
	1,
}
category_text.font_size = 22

local category_value = table.clone(UIFontSettings.header_3)

category_value.offset = {
	0,
	0,
	1,
}
category_value.font_size = 22
category_value.text_horizontal_alignment = "right"

local sub_category_text = table.clone(UIFontSettings.header_3)

sub_category_text.offset = {
	40,
	0,
	1,
}
sub_category_text.font_size = 22

local sub_category_value = table.clone(UIFontSettings.header_3)

sub_category_value.offset = {
	0,
	0,
	1,
}
sub_category_value.font_size = 22
sub_category_value.text_horizontal_alignment = "right"

local widget_definitions = {
	stats_background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background",
			value_id = "background",
			style = {
				color = Color.black(127.5, true),
			},
		},
	}, "stats_background"),
	header = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/presets/main",
			value_id = "texture",
		},
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			value = Localize("loc_player_stats_element_title"),
			style = header_text,
		},
	}, "header"),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
