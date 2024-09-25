-- chunkname: @scripts/ui/views/credits_vendor_view/credits_vendor_view_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local title_height = 0
local edge_padding = 44
local grid_width = 640
local grid_height = 860
local grid_size = {
	grid_width - edge_padding,
	grid_height,
}
local mask_size = {
	grid_width + 40,
	grid_height,
}
local grid_spacing = {
	10,
	10,
}
local grid_settings = {
	scroll_start_margin = 80,
	scrollbar_horizontal_offset = -8,
	scrollbar_vertical_margin = 80,
	scrollbar_vertical_offset = 33,
	scrollbar_width = 7,
	show_loading_overlay = true,
	top_padding = 80,
	use_is_focused_for_navigation = true,
	use_item_categories = false,
	use_select_on_focused = false,
	use_terminal_background = true,
	widget_icon_load_margin = 0,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	title_height = title_height,
	edge_padding = edge_padding,
}
local weapon_stats_grid_settings = {
	resource_renderer_background = true,
	use_parent_world = true,
}
local scenegraph_definition = {
	item_grid_pivot = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			grid_width,
			grid_height,
		},
		position = {
			100,
			84,
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
			0,
			28,
			1,
		},
	},
}
local widget_definitions = {}
local animations = {}
local tab_menu_settings = {
	button_spacing = 10,
	fixed_button_size = true,
	horizontal_alignment = "center",
	layer = 80,
	button_size = {
		132,
		38,
	},
	button_template = ButtonPassTemplates.item_category_tab_menu_button,
	input_label_offset = {
		10,
		5,
	},
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
	animations = animations,
	grid_settings = grid_settings,
	weapon_stats_grid_settings = weapon_stats_grid_settings,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	item_category_tabs_content = item_category_tabs_content,
	tab_menu_settings = tab_menu_settings,
}
