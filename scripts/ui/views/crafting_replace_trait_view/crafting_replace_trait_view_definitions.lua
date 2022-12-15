local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	trait_inventory_pivot = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			0,
			800
		},
		position = {
			-1140,
			-100,
			1
		}
	},
	weapon_stats_pivot = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			100,
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
	}
}
local widget_definitions = {}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
