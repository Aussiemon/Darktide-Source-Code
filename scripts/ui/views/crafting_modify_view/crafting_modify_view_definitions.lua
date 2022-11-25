local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local title_height = 80
local edge_padding = 44
local grid_width = 640
local grid_height = 780
local grid_size = {
	grid_width - edge_padding,
	grid_height
}
local grid_spacing = {
	10,
	10
}
local mask_size = {
	grid_width + 40,
	grid_height
}
local grid_settings = {
	scrollbar_width = 7,
	use_parent_ui_renderer = true,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	title_height = title_height,
	edge_padding = edge_padding
}
local weapon_stats_grid_settings = {
	use_parent_ui_renderer = true
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	item_grid_pivot = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "left",
		size = grid_size,
		position = {
			100,
			-100,
			1
		}
	},
	weapon_stats_pivot = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-1140,
			-100,
			3
		}
	},
	crafting_recipe_pivot = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			430,
			400
		},
		position = {
			-140,
			-100,
			1
		}
	},
	grid_tab_panel = {
		vertical_alignment = "top",
		parent = "item_grid_pivot",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0.5 * edge_padding,
			-50,
			1
		}
	},
	grid_tab_panel_background = {
		vertical_alignment = "top",
		parent = "item_grid_pivot",
		horizontal_alignment = "center",
		size = {
			640,
			80
		},
		position = {
			22,
			-65,
			1
		}
	}
}
local widget_definitions = {
	tabs_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					18,
					24
				},
				color = Color.terminal_grid_background(nil, true)
			}
		}
	}, "grid_tab_panel_background")
}
local item_category_tabs_content = {
	{
		icon = "content/ui/materials/icons/categories/melee",
		hide_display_name = true,
		slot_types = {
			"slot_primary"
		}
	},
	{
		icon = "content/ui/materials/icons/categories/ranged",
		hide_display_name = true,
		slot_types = {
			"slot_secondary"
		}
	},
	{
		icon = "content/ui/materials/icons/categories/devices",
		hide_display_name = true,
		slot_types = {
			"slot_attachment_1",
			"slot_attachment_2",
			"slot_attachment_3"
		}
	}
}

return {
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	grid_settings = grid_settings,
	weapon_stats_grid_settings = weapon_stats_grid_settings,
	item_category_tabs_content = item_category_tabs_content
}
