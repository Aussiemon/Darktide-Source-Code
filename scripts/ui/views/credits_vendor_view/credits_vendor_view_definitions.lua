-- chunkname: @scripts/ui/views/credits_vendor_view/credits_vendor_view_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local title_height = 0
local edge_padding = 44
local grid_width = 640
local grid_height = 860
local grid_size = {
	grid_width - edge_padding,
	grid_height
}
local mask_size = {
	grid_width + 40,
	grid_height
}
local grid_spacing = {
	10,
	10
}
local grid_settings = {
	scrollbar_width = 7,
	use_item_categories = false,
	scrollbar_horizontal_offset = -8,
	scroll_start_margin = 80,
	top_padding = 80,
	scrollbar_vertical_offset = 33,
	show_loading_overlay = true,
	scrollbar_vertical_margin = 80,
	widget_icon_load_margin = 0,
	use_select_on_focused = false,
	use_is_focused_for_navigation = true,
	use_terminal_background = true,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	title_height = title_height,
	edge_padding = edge_padding
}
local weapon_stats_grid_settings = {
	use_parent_world = true,
	resource_renderer_background = true
}
local scenegraph_definition = {
	item_grid_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			grid_width,
			grid_height
		},
		position = {
			100,
			84,
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
			0,
			28,
			1
		}
	}
}
local widget_definitions = {}
local animations = {}
local tab_menu_settings = {
	layer = 80,
	button_spacing = 10,
	fixed_button_size = true,
	horizontal_alignment = "center",
	button_size = {
		132,
		38
	},
	button_template = ButtonPassTemplates.item_category_tab_menu_button,
	input_label_offset = {
		10,
		5
	}
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
	animations = animations,
	grid_settings = grid_settings,
	weapon_stats_grid_settings = weapon_stats_grid_settings,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	item_category_tabs_content = item_category_tabs_content,
	tab_menu_settings = tab_menu_settings
}
