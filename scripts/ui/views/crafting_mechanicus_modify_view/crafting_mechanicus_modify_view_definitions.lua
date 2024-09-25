-- chunkname: @scripts/ui/views/crafting_mechanicus_modify_view/crafting_mechanicus_modify_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local CraftingSettings = require("scripts/settings/item/crafting_mechanicus_settings")
local weapon_stats_context = CraftingSettings.weapon_stats_context
local weapon_stats_grid_size = weapon_stats_context.grid_size
local title_height = 80
local edge_padding = 44
local grid_width = 640
local grid_height = 780
local grid_size = {
	grid_width - edge_padding,
	grid_height,
}
local grid_spacing = {
	10,
	10,
}
local mask_size = {
	grid_width + 40,
	grid_height,
}
local grid_settings = {
	scrollbar_width = 7,
	use_parent_ui_renderer = true,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	title_height = title_height,
	edge_padding = edge_padding,
}
local weapon_stats_grid_settings = {
	use_parent_ui_renderer = true,
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	item_grid_pivot = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = grid_size,
		position = {
			100,
			-110,
			1,
		},
	},
	crafting_recipe_pivot = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			430,
			400,
		},
		position = {
			-150,
			-102,
			3,
		},
	},
	weapon_stats_pivot = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			0,
			0,
		},
		position = {
			grid_size[1] + 150 + 20,
			-110,
			1,
		},
	},
	grid_tab_panel = {
		horizontal_alignment = "center",
		parent = "item_grid_pivot",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0.5 * edge_padding,
			-42,
			1,
		},
	},
	grid_tab_panel_background = {
		horizontal_alignment = "center",
		parent = "item_grid_pivot",
		vertical_alignment = "top",
		size = {
			640,
			70,
		},
		position = {
			22,
			-57,
			1,
		},
	},
}
local widget_definitions = {
	tabs_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					18,
					24,
				},
				color = Color.terminal_grid_background(nil, true),
			},
		},
	}, "grid_tab_panel_background"),
}
local item_category_tabs_content = {
	{
		hide_display_name = true,
		icon = "content/ui/materials/icons/categories/melee",
		slot_types = {
			"slot_primary",
		},
	},
	{
		hide_display_name = true,
		icon = "content/ui/materials/icons/categories/ranged",
		slot_types = {
			"slot_secondary",
		},
	},
	{
		hide_display_name = true,
		icon = "content/ui/materials/icons/categories/devices",
		slot_types = {
			"slot_attachment_1",
			"slot_attachment_2",
			"slot_attachment_3",
		},
	},
}

return {
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	grid_settings = grid_settings,
	weapon_stats_grid_settings = weapon_stats_grid_settings,
	item_category_tabs_content = item_category_tabs_content,
}
