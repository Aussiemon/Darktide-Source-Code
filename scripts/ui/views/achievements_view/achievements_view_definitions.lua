local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ViewBlueprints = require("scripts/ui/views/achievements_view/achievements_view_blueprints")
local ViewStyles = require("scripts/ui/views/achievements_view/achievements_view_styles")
local categories_grid_style = ViewStyles.categories_grid
local achievements_grid_style = ViewStyles.achievements_grid
local visible_area_size = ViewStyles.visible_area_size
local left_column_size = ViewStyles.left_column_size
local categories_header_size = {
	left_column_size[1],
	230
}
local total_progress_size = ViewStyles.completed.size
local search_field_size = {
	left_column_size[1],
	40
}
local categories_grid_size = categories_grid_style.size
local categories_grid_margin = categories_grid_style.margin
local categories_mask_size = {
	categories_grid_size[1] + 2 * categories_grid_margin,
	categories_grid_size[2]
}
local main_column_size = ViewStyles.main_column_size
local achievements_grid_size = achievements_grid_style.size
local achievements_grid_margin = achievements_grid_style.margin
local achievements_mask_size = {
	achievements_grid_size[1] + 2 * (achievements_grid_margin + 10),
	achievements_grid_size[2]
}
local search_field_pos = {
	0,
	60,
	0
}
local categories_header_pos = {
	0,
	-10,
	0
}
local total_progress_pos = {
	0,
	-30,
	1
}
local categories_grid_pos = categories_grid_style.position
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	visible_area = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = visible_area_size,
		position = {
			0,
			15,
			0
		}
	},
	left_column = {
		vertical_alignment = "top",
		parent = "visible_area",
		horizontal_alignment = "left",
		size = left_column_size,
		position = {
			0,
			0,
			0
		}
	},
	categories_header = {
		vertical_alignment = "top",
		parent = "left_column",
		horizontal_alignment = "left",
		size = categories_header_size,
		position = categories_header_pos
	},
	total_progress = {
		vertical_alignment = "bottom",
		parent = "categories_header",
		horizontal_alignment = "center",
		size = total_progress_size,
		position = total_progress_pos
	},
	search_field = {
		vertical_alignment = "top",
		parent = "left_column",
		horizontal_alignment = "left",
		size = search_field_size,
		position = search_field_pos
	},
	categories_grid = {
		vertical_alignment = "bottom",
		parent = "left_column",
		horizontal_alignment = "left",
		size = categories_grid_size,
		position = categories_grid_pos
	},
	main_column = {
		vertical_alignment = "top",
		parent = "visible_area",
		horizontal_alignment = "right",
		size = main_column_size,
		position = {
			0,
			0,
			0
		}
	},
	achievements_grid = {
		vertical_alignment = "bottom",
		parent = "main_column",
		horizontal_alignment = "left",
		size = achievements_grid_size,
		position = {
			0,
			0,
			0
		}
	}
}
local widget_definitions = {
	categories_header = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/achievements_top",
			style_id = "background",
			pass_type = "texture",
			value_id = "background"
		}
	}, "categories_header", nil, nil, ViewStyles.completed),
	completed = UIWidget.create_definition({
		{
			style_id = "completed",
			value_id = "completed",
			pass_type = "text"
		},
		{
			style_id = "total_score",
			value_id = "total_score",
			pass_type = "text"
		},
		{
			value = "content/ui/materials/bars/medium/frame",
			style_id = "progressbar_background",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/bars/medium/fill",
			style_id = "progressbar",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/bars/medium/end",
			style_id = "progressbar_edge",
			pass_type = "texture"
		}
	}, "total_progress", nil, nil, ViewStyles.completed)
}
local categories_grid_settings = {
	scrollbar_vertical_margin = 20,
	scenegraph_id = "categories_grid",
	title_height = 0,
	grid_spacing = {
		categories_grid_size[1],
		5
	},
	grid_size = categories_grid_size,
	mask_size = categories_mask_size,
	scrollbar_width = ScrollbarPassTemplates.metal_scrollbar.default_width,
	scrollbar_pass_templates = ScrollbarPassTemplates.metal_scrollbar,
	edge_padding = categories_grid_margin * 2
}
local achievements_grid_settings = {
	scrollbar_vertical_margin = 20,
	scenegraph_id = "achievements_grid",
	title_formatting = "upper_case",
	title_height = 70,
	grid_spacing = {
		0,
		0
	},
	grid_size = achievements_grid_size,
	mask_size = achievements_mask_size,
	scrollbar_width = ScrollbarPassTemplates.metal_scrollbar.default_width,
	scrollbar_pass_templates = ScrollbarPassTemplates.metal_scrollbar,
	edge_padding = achievements_grid_margin * 2
}

return settings("AchievementsViewDefinitions", {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	blueprints = ViewBlueprints,
	grid_settings = {
		categories_grid_settings,
		achievements_grid_settings
	}
})
