-- chunkname: @scripts/ui/views/marks_goods_vendor_view/marks_goods_vendor_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local title_height = 70
local edge_padding = 44
local grid_width = 1280
local grid_height = 660
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
	use_is_focused_for_navigation = false,
	use_select_on_focused = true,
	use_terminal_background = true,
	widget_icon_load_margin = 0,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	title_height = title_height,
	edge_padding = edge_padding,
}
local scenegraph_definition = {
	item_grid_pivot = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "top",
		size = grid_size,
		position = {
			-edge_padding * 0.5,
			40,
			1,
		},
	},
	purchase_button = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			374,
			76,
		},
		position = {
			0,
			-120,
			1,
		},
	},
}
local widget_definitions = {
	purchase_button = UIWidget.create_definition(table.clone(ButtonPassTemplates.default_button), "purchase_button", {
		gamepad_action = "confirm_pressed",
		original_text = Utf8.upper(Localize("loc_vendor_purchase_button")),
		purchase_sound = UISoundEvents.credits_vendor_on_purchase,
		hotspot = {
			on_pressed_sound = UISoundEvents.default_click,
		},
	}),
}
local animations = {}

return {
	animations = animations,
	grid_settings = grid_settings,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
