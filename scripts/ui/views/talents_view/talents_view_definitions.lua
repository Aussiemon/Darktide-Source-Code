local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ViewStyles = require("scripts/ui/views/talents_view/talents_view_styles")
local top_panel_size = UIWorkspaceSettings.top_panel.size
local bottom_panel_size = UIWorkspaceSettings.bottom_panel.size
local visible_area_width = UIWorkspaceSettings.screen.size[1]
local visible_area_height = UIWorkspaceSettings.screen.size[2] - (top_panel_size[2] + bottom_panel_size[2])
local class_icon_size = ViewStyles.class_header.class_icon.size[2]
local class_header_width = 490
local class_headline_height = class_icon_size
local class_header_height = 225
local scenegraph = {
	screen = UIWorkspaceSettings.screen,
	visible_area = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			visible_area_width,
			visible_area_height
		},
		position = {
			0,
			top_panel_size[2],
			1
		}
	},
	class_header = {
		vertical_alignment = "top",
		parent = "visible_area",
		horizontal_alignment = "left",
		size = {
			class_header_width,
			class_header_height
		},
		position = {
			180,
			50,
			5
		}
	},
	class_headline = {
		vertical_alignment = "top",
		parent = "class_header",
		horizontal_alignment = "left",
		size = {
			class_header_width,
			class_headline_height
		},
		position = {
			0,
			0,
			1
		}
	},
	class_header_text = {
		vertical_alignment = "top",
		parent = "class_header",
		horizontal_alignment = "left",
		size = {
			class_header_width,
			class_header_height - class_headline_height
		},
		position = {
			0,
			class_headline_height,
			1
		}
	},
	details_panel = {
		vertical_alignment = "bottom",
		parent = "visible_area",
		horizontal_alignment = "right",
		size = {
			class_header_width,
			140
		},
		position = {
			-80,
			-100,
			5
		}
	},
	details_panel_headline = {
		vertical_alignment = "top",
		parent = "details_panel",
		horizontal_alignment = "left",
		size = {
			class_header_width,
			22
		},
		position = {
			0,
			0,
			1
		}
	},
	details_panel_body = {
		vertical_alignment = "top",
		parent = "details_panel",
		horizontal_alignment = "left",
		size = {
			class_header_width,
			110
		},
		position = {
			2,
			31,
			1
		}
	},
	grid_area = {
		vertical_alignment = "top",
		parent = "visible_area",
		horizontal_alignment = "left",
		size = {
			1705,
			760
		},
		position = {
			130,
			100,
			5
		}
	}
}
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			style_id = "specialization_background",
			value_id = "specialization_background",
			pass_type = "texture",
			scenegraph_id = "screen"
		},
		{
			style_id = "class_icon",
			value_id = "class_icon",
			pass_type = "texture"
		}
	}, "visible_area", nil, nil, ViewStyles.background),
	class_header = UIWidget.create_definition({
		{
			style_id = "class_icon",
			value_id = "class_icon",
			pass_type = "texture"
		},
		{
			style_id = "class_name",
			value_id = "class_name",
			pass_type = "text"
		},
		{
			style_id = "specialization_name",
			value_id = "specialization_name",
			pass_type = "text"
		},
		{
			value = "content/ui/materials/dividers/skull_rendered_left_01",
			style_id = "divider",
			pass_type = "texture"
		},
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text",
			scenegraph_id = "class_header_text"
		}
	}, "class_headline", nil, nil, ViewStyles.class_header),
	highlight_ring = UIWidget.create_definition({
		{
			value = "content/ui/materials/icons/abilities/frames/menu/generic_highlight",
			pass_type = "texture",
			style = ViewStyles.highlight_ring
		}
	}, "screen", nil, ViewStyles.talent_icon.size),
	details = UIWidget.create_definition({
		{
			value_id = "talent_name",
			pass_type = "text",
			style_id = "talent_name",
			change_function = ViewStyles.icon_change_function
		},
		{
			value_id = "talent_description",
			pass_type = "text",
			style_id = "talent_description",
			change_function = ViewStyles.icon_change_function
		}
	}, "details_panel", {
		fade_time = ViewStyles.details.fade_time
	}, nil, ViewStyles.details)
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph
}
