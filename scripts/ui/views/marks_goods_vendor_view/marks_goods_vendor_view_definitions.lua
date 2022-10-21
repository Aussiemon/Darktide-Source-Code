local UIWidget = require("scripts/managers/ui/ui_widget")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local title_height = 70
local edge_padding = 44
local grid_width = 1280
local grid_height = 660
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
	widget_icon_load_margin = 0,
	use_select_on_focused = true,
	use_is_focused_for_navigation = false,
	use_terminal_background = true,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	title_height = title_height,
	edge_padding = edge_padding
}
local scenegraph_definition = {
	item_grid_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "center",
		size = grid_size,
		position = {
			-edge_padding * 0.5,
			120,
			1
		}
	},
	purchase_button = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			374,
			76
		},
		position = {
			0,
			-120,
			1
		}
	}
}
local widget_definitions = {
	purchase_button = UIWidget.create_definition(table.clone(ButtonPassTemplates.default_button), "purchase_button", {
		text = Utf8.upper(Localize("loc_vendor_purchase_button")),
		hotspot = {
			on_pressed_sound = UISoundEvents.credits_vendor_on_purchase
		}
	})
}
local animations = {}

return {
	animations = animations,
	grid_settings = grid_settings,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
