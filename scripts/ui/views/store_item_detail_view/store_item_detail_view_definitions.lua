-- chunkname: @scripts/ui/views/store_item_detail_view/store_item_detail_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local ColorUtilities = require("scripts/utilities/ui/colors")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local grid_height = 840
local grid_margin = 30
local item_grid_width = 542
local grid_width = item_grid_width + grid_margin * 2
local scenegraph_definition = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			0,
		},
	},
	canvas = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			0,
		},
	},
	corner_top_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			84,
			224,
		},
		position = {
			0,
			0,
			62,
		},
	},
	corner_top_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			120,
			224,
		},
		position = {
			0,
			0,
			62,
		},
	},
	corner_bottom_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			84,
			224,
		},
		position = {
			0,
			0,
			62,
		},
	},
	corner_bottom_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			84,
			224,
		},
		position = {
			0,
			0,
			62,
		},
	},
	left_side = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			grid_width,
			grid_height,
		},
		position = {
			100,
			130,
			1,
		},
	},
	item_restrictions_background = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			300,
			0,
		},
		position = {
			grid_width + 100,
			-200,
			1,
		},
	},
	item_restrictions = {
		horizontal_alignment = "left",
		parent = "item_restrictions_background",
		vertical_alignment = "center",
		size = {
			400,
			0,
		},
		position = {
			40,
			0,
			1,
		},
	},
	side_panel_area = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			300,
			0,
		},
		position = {
			grid_width + 100,
			-200,
			1,
		},
	},
	purchase_button_area = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			grid_width - 28,
			90,
		},
		position = {
			-70,
			-100,
			0,
		},
	},
	purchase_button = {
		horizontal_alignment = "right",
		parent = "purchase_button_area",
		vertical_alignment = "center",
		size = ButtonPassTemplates.default_button.size,
		position = {
			0,
			0,
			5,
		},
	},
	price_item_text = {
		horizontal_alignment = "right",
		parent = "purchase_button_area",
		vertical_alignment = "center",
		size = {
			0,
			50,
		},
		position = {
			-grid_width,
			15,
			0,
		},
	},
	promo = {
		horizontal_alignment = "right",
		parent = "left_side",
		vertical_alignment = "bottom",
		size = {
			256,
			128,
		},
		position = {
			14,
			125,
			1,
		},
	},
	title = {
		horizontal_alignment = "left",
		parent = "left_side",
		vertical_alignment = "top",
		size = {
			grid_width - 40,
			70,
		},
		position = {
			20,
			50,
			1,
		},
	},
	details_pivot = {
		horizontal_alignment = "center",
		parent = "left_side",
		vertical_alignment = "top",
		size = {
			grid_width - grid_margin * 2,
			0,
		},
		position = {
			0,
			0,
			1,
		},
	},
	description_grid = {
		horizontal_alignment = "center",
		parent = "left_side",
		vertical_alignment = "top",
		size = {
			grid_width - grid_margin * 2,
			grid_height - 80,
		},
		position = {
			0,
			40,
			1,
		},
	},
	description_content_pivot = {
		horizontal_alignment = "left",
		parent = "description_grid",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			2,
		},
	},
	description_mask = {
		horizontal_alignment = "center",
		parent = "description_grid",
		vertical_alignment = "center",
		size = {
			grid_width,
			grid_height - 40,
		},
		position = {
			0,
			0,
			2,
		},
	},
	description_scrollbar = {
		horizontal_alignment = "right",
		parent = "description_grid",
		vertical_alignment = "top",
		size = {
			10,
			grid_height - 80,
		},
		position = {
			0,
			0,
			2,
		},
	},
	grid_divider = {
		horizontal_alignment = "left",
		parent = "left_side",
		vertical_alignment = "top",
		size = {
			grid_width,
			18,
		},
		position = {
			0,
			0,
			1,
		},
	},
	grid_background = {
		horizontal_alignment = "left",
		parent = "left_side",
		vertical_alignment = "top",
		size = {
			grid_width - grid_margin * 2,
			grid_height - 420,
		},
		position = {
			30,
			370,
			1,
		},
	},
	grid_mask = {
		horizontal_alignment = "center",
		parent = "grid_background",
		vertical_alignment = "center",
		size = {
			grid_width,
			grid_height - 420,
		},
		position = {
			0,
			0,
			2,
		},
	},
	grid_content_pivot = {
		horizontal_alignment = "left",
		parent = "grid_background",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			2,
		},
	},
	grid_scrollbar = {
		horizontal_alignment = "right",
		parent = "grid_background",
		vertical_alignment = "top",
		size = {
			10,
			grid_height - 420,
		},
		position = {
			20,
			0,
			2,
		},
	},
	set_pivot = {
		horizontal_alignment = "left",
		parent = "left_side",
		vertical_alignment = "top",
		size = {
			grid_width,
			50,
		},
		position = {
			0,
			400,
			1,
		},
	},
	wallet_pivot = {
		horizontal_alignment = "right",
		parent = "corner_top_right",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			-30,
			120,
			1,
		},
	},
	wallet_text = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			200,
			200,
		},
		position = {
			-50,
			5,
			5,
		},
	},
	owned_info_text = {
		horizontal_alignment = "right",
		parent = "purchase_button_area",
		vertical_alignment = "center",
		size = {
			grid_width,
			50,
		},
		position = {
			-70,
			0,
			0,
		},
	},
	timer_text = {
		horizontal_alignment = "left",
		parent = "left_side",
		vertical_alignment = "top",
		size = {
			grid_width,
			50,
		},
		position = {
			50,
			-50,
			0,
		},
	},
	weapon_viewport = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			3,
		},
	},
	weapon_pivot = {
		horizontal_alignment = "center",
		parent = "weapon_viewport",
		vertical_alignment = "center",
		size = {
			0,
			0,
		},
		position = {
			300,
			0,
			1,
		},
	},
	grid_aquilas_pivot = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			0,
			0,
		},
		position = {
			0,
			30,
			1,
		},
	},
	aquilas_background = {
		horizontal_alignment = "center",
		parent = "grid_aquilas_pivot",
		vertical_alignment = "center",
		size = {
			1920,
			0,
		},
		position = {
			0,
			0,
			1,
		},
	},
	grid_aquilas_content = {
		horizontal_alignment = "center",
		parent = "grid_aquilas_pivot",
		vertical_alignment = "center",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			1,
		},
	},
	loading = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "cemter",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			50,
		},
	},
	wallet_element_pivot = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			-50,
			105,
			0,
		},
	},
	item_name_pivot = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			0,
			0,
		},
		position = {
			-66,
			-230,
			3,
		},
	},
}
local wallet_text_font_style = table.clone(UIFontSettings.currency_title)

wallet_text_font_style.text_horizontal_alignment = "left"
wallet_text_font_style.text_vertical_alignment = "center"
wallet_text_font_style.original_offset = {
	0,
	0,
	1,
}
wallet_text_font_style.offset = {
	0,
	0,
	1,
}
wallet_text_font_style.font_size = 28

local title_style = table.clone(UIFontSettings.header_1)

title_style.font_size = 40
title_style.offset = {
	0,
	0,
	1,
}
title_style.text_horizontal_alignment = "center"
title_style.text_vertical_alignment = "top"

local sub_title_style = table.clone(UIFontSettings.header_5)

sub_title_style.text_horizontal_alignment = "center"
sub_title_style.text_vertical_alignment = "top"
sub_title_style.offset = {
	0,
	0,
	0,
}
sub_title_style.text_color = Color.terminal_text_body(255, true)

local grid_title_style = table.clone(UIFontSettings.header_3)

grid_title_style.text_horizontal_alignment = "left"
grid_title_style.text_vertical_alignment = "top"
grid_title_style.offset = {
	0,
	-30,
	0,
}
grid_title_style.font_size = 18
grid_title_style.text_color = Color.terminal_text_body_sub_header(255, true)

local grid_sub_title_style = table.clone(UIFontSettings.header_3)

grid_sub_title_style.text_horizontal_alignment = "left"
grid_sub_title_style.text_vertical_alignment = "top"
grid_sub_title_style.offset = {
	0,
	-30,
	0,
}

local timer_text_style = table.clone(UIFontSettings.body_small)

timer_text_style.text_horizontal_alignment = "left"
timer_text_style.text_vertical_alignment = "top"
timer_text_style.text_color = Color.ui_grey_light(255, true)
timer_text_style.default_text_color = Color.ui_grey_light(255, true)
timer_text_style.hover_color = {
	255,
	255,
	255,
	255,
}
timer_text_style.offset = {
	0,
	0,
	4,
}
timer_text_style.horizontal_alignment = "left"
timer_text_style.vertical_alignment = "center"

local promo_text_font_style = table.clone(UIFontSettings.header_3)

promo_text_font_style.text_horizontal_alignment = "left"
promo_text_font_style.text_vertical_alignment = "center"
promo_text_font_style.offset = {
	40,
	0,
	1,
}

local description_text_font_style = table.clone(UIFontSettings.terminal_header_3)

description_text_font_style.text_horizontal_alignment = "left"
description_text_font_style.text_vertical_alignment = "top"
description_text_font_style.font_size = 20
description_text_font_style.text_color = Color.terminal_text_body(255, true)

local item_title_style = table.clone(title_style)

item_title_style.text_horizontal_alignment = "right"
item_title_style.horizontal_alignment = "right"
item_title_style.text_vertical_alignment = "top"
item_title_style.vertical_alignment = "bottom"

local item_sub_title_style = table.clone(UIFontSettings.terminal_header_3)

item_sub_title_style.text_horizontal_alignment = "right"
item_sub_title_style.horizontal_alignment = "right"
item_sub_title_style.text_vertical_alignment = "top"
item_sub_title_style.vertical_alignment = "bottom"
item_sub_title_style.offset = {
	0,
	10,
	1,
}
item_sub_title_style.font_size = 20

local owned_title_style = table.clone(UIFontSettings.terminal_header_3)

owned_title_style.text_horizontal_alignment = "right"
owned_title_style.text_vertical_alignment = "top"
owned_title_style.horizontal_alignment = "right"
owned_title_style.vertical_alignment = "top"
owned_title_style.offset = {
	0,
	-35,
	3,
}
owned_title_style.font_size = 20

local item_restrictions_title_style = table.clone(UIFontSettings.terminal_header_3)

item_restrictions_title_style.text_horizontal_alignment = "left"
item_restrictions_title_style.horizontal_alignment = "left"
item_restrictions_title_style.text_vertical_alignment = "top"
item_restrictions_title_style.vertical_alignment = "top"
item_restrictions_title_style.offset = {
	0,
	0,
	1,
}
item_restrictions_title_style.font_size = 20
item_restrictions_title_style.text_color = Color.terminal_text_body_sub_header(255, true)

local item_restrictions_text_style = table.clone(item_restrictions_title_style)

item_restrictions_text_style.text_color = Color.terminal_text_body(255, true)

local premium_sub_title_style = table.clone(item_restrictions_title_style)

premium_sub_title_style.text_color = Color.terminal_text_header(255, true)

local premium_text_style = table.clone(item_restrictions_title_style)

premium_text_style.material = "content/ui/materials/font_gradients/slug_font_gradient_gold"
premium_text_style.text_color = Color.white(255, true)

local set_text_font_style = table.clone(UIFontSettings.currency_title)

set_text_font_style.text_horizontal_alignment = "left"
set_text_font_style.text_vertical_alignment = "top"
set_text_font_style.offset = {
	55,
	0,
	1,
}
set_text_font_style.font_size = 24

local owned_set_text_font_style = table.clone(UIFontSettings.body_small)

owned_set_text_font_style.text_horizontal_alignment = "left"
owned_set_text_font_style.text_vertical_alignment = "top"
owned_set_text_font_style.horizontal_alignment = "left"
owned_set_text_font_style.vertical_alignment = "top"
owned_set_text_font_style.offset = {
	55,
	25,
	3,
}
owned_set_text_font_style.text_color = Color.ui_orange_medium(255, true)

local item_price_text_style = table.clone(UIFontSettings.body)

item_price_text_style.text_horizontal_alignment = "right"
item_price_text_style.text_vertical_alignment = "top"
item_price_text_style.horizontal_alignment = "right"
item_price_text_style.vertical_alignment = "center"
item_price_text_style.offset = {
	0,
	0,
	4,
}

local item_discount_price_text_style = table.clone(item_price_text_style)

item_discount_price_text_style.text_color = Color.white(255, true)
item_discount_price_text_style.text_horizontal_alignment = "left"

local owned_item_text_style = table.clone(UIFontSettings.body)

owned_item_text_style.text_horizontal_alignment = "right"
owned_item_text_style.text_vertical_alignment = "center"
owned_item_text_style.horizontal_alignment = "right"
owned_item_text_style.vertical_alignment = "center"
owned_item_text_style.offset = {
	0,
	0,
	2,
}
owned_item_text_style.text_color = Color.terminal_text_header(255, true)

local required_aquilas_title_style = table.clone(UIFontSettings.header_1)

required_aquilas_title_style.font_size = 40
required_aquilas_title_style.offset = {
	0,
	0,
	1,
}
required_aquilas_title_style.text_horizontal_alignment = "center"
required_aquilas_title_style.text_vertical_alignment = "top"
required_aquilas_title_style.offset = {
	0,
	-55,
	2,
}

local required_aquilas_text_style = table.clone(UIFontSettings.terminal_header_3)

required_aquilas_text_style.text_horizontal_alignment = "center"
required_aquilas_text_style.text_vertical_alignment = "top"
required_aquilas_text_style.horizontal_alignment = "center"
required_aquilas_text_style.vertical_alignment = "top"
required_aquilas_text_style.offset = {
	0,
	25,
	2,
}
required_aquilas_text_style.text_color = Color.terminal_text_body(255, true)

local purchase_button_text_style = table.clone(UIFontSettings.button_primary)

purchase_button_text_style.offset = {
	0,
	0,
	4,
}
purchase_button_text_style.horizontal_alignment = "center"
purchase_button_text_style.vertical_alignment = "center"
purchase_button_text_style.font_size = 24

local purchase_button_legend_text_style = table.clone(UIFontSettings.button_primary)

purchase_button_legend_text_style.offset = {
	0,
	40,
	4,
}
purchase_button_legend_text_style.horizontal_alignment = "center"
purchase_button_legend_text_style.vertical_alignment = "bottom"
purchase_button_legend_text_style.font_size = 14

local item_price_style = table.clone(UIFontSettings.body)

item_price_style.text_horizontal_alignment = "right"
item_price_style.text_vertical_alignment = "bottom"
item_price_style.horizontal_alignment = "right"
item_price_style.vertical_alignment = "center"
item_price_style.offset = {
	0,
	-3,
	12,
}
item_price_style.font_size = 20
item_price_style.text_color = Color.white(255, true)
item_price_style.default_color = Color.white(255, true)
item_price_style.hover_color = Color.white(255, true)

local item_owned_text_style = table.clone(UIFontSettings.header_2)

item_owned_text_style.text_horizontal_alignment = "right"
item_owned_text_style.text_vertical_alignment = "bottom"
item_owned_text_style.horizontal_alignment = "right"
item_owned_text_style.font_size = 36
item_owned_text_style.text_color = Color.terminal_text_body(255, true)
item_owned_text_style.vertical_alignment = "bottom"
item_owned_text_style.offset = {
	0,
	5,
	20,
}

local item_discount_price_style = table.clone(item_price_style)
local bundle_owned_items_text = table.clone(item_price_style)

bundle_owned_items_text.offset = {
	15,
	-5,
	12,
}
bundle_owned_items_text.text_horizontal_alignment = "left"
bundle_owned_items_text.text_color = Color.terminal_text_body(255, true)
bundle_owned_items_text.font_size = 16

local bundle_title = table.clone(UIFontSettings.terminal_header_3)

bundle_title.text_horizontal_alignment = "left"
bundle_title.text_vertical_alignment = "center"
bundle_title.font_size = 24
bundle_title.text_color = Color.terminal_text_header(255, true)
bundle_title.offset = {
	15,
	0,
	4,
}
bundle_title.size_addition = {
	-30,
	0,
}

local bundle_description = table.clone(UIFontSettings.terminal_header_3)

bundle_description.text_horizontal_alignment = "left"
bundle_description.text_vertical_alignment = "center"
bundle_description.font_size = 20
bundle_description.text_color = Color.terminal_text_body(255, true)
bundle_description.offset = {
	15,
	0,
	4,
}
bundle_description.size_addition = {
	-30,
	0,
}

local widget_definitions = {
	wallet_text = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "",
			value_id = "text",
			style = wallet_text_font_style,
		},
	}, "wallet_text"),
	background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.terminal_frame(255, true),
				size_addition = {
					20,
					30,
				},
				offset = {
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/premium_store/details_upper",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size_addition = {
					52,
					0,
				},
				offset = {
					0,
					-60,
					3,
				},
				size = {
					nil,
					80,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/premium_store/details_lower_basic",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size_addition = {
					52,
					0,
				},
				offset = {
					0,
					34,
					3,
				},
				size = {
					nil,
					108,
				},
			},
		},
	}, "left_side"),
	corner_top_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/premium_upper_left",
		},
	}, "corner_top_left"),
	corner_top_right = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/premium_upper_right",
		},
	}, "corner_top_right"),
	corner_bottom_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/premium_lower_left",
		},
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/premium_lower_right",
		},
	}, "corner_bottom_right"),
	grid_divider = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "divider",
			value = "content/ui/materials/dividers/skull_center_02",
			value_id = "divider",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					400,
					18,
				},
				offset = {
					0,
					-6,
					1,
				},
				color = Color.terminal_frame(255, true),
			},
		},
	}, "grid_divider"),
	grid_title = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = grid_title_style,
		},
	}, "grid_background"),
	grid_background = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
		},
	}, "grid_background"),
	grid_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, "grid_scrollbar"),
	grid_mask = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur",
			style = {
				color = {
					255,
					255,
					255,
					255,
				},
				offset = {
					0,
					0,
					3,
				},
			},
		},
	}, "grid_mask"),
	title = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = title_style,
		},
		{
			pass_type = "text",
			style_id = "sub_text",
			value = "",
			value_id = "sub_text",
			style = sub_title_style,
		},
		{
			pass_type = "texture",
			style_id = "divider",
			value = "content/ui/materials/dividers/skull_center_02",
			value_id = "divider",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					400,
					18,
				},
				offset = {
					0,
					9,
					1,
				},
				color = Color.terminal_frame(255, true),
			},
		},
	}, "title"),
	description_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, "description_scrollbar", {
		enable_gamepad_scrolling = true,
		focused = true,
		gamepad_axis_name = "navigate_controller",
		hotspot = {
			is_focused = true,
		},
	}),
	description_mask = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur_viewport_2",
			style = {
				color = {
					255,
					255,
					255,
					255,
				},
				offset = {
					0,
					0,
					3,
				},
			},
		},
	}, "description_mask"),
	purchase_item_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "purchase_button", {
		gamepad_action = "confirm_pressed",
		original_text = "",
	}),
	timer_widget = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "",
			value_id = "text",
			style = timer_text_style,
		},
	}, "timer_text"),
	price_item_text = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "price_icon",
			value_id = "price_icon",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				size = {
					40,
					28,
				},
				offset = {
					0,
					-10,
					4,
				},
			},
			visibility_function = function (content, style)
				if not content.element or not content.price_icon then
					return false
				end

				return not content.element.owned and not content.element.formattedPrice
			end,
		},
		{
			pass_type = "text",
			style_id = "discount_price",
			value = "",
			value_id = "discount_price",
			style = item_discount_price_text_style,
			visibility_function = function (content, style)
				if not content.element then
					return false
				end

				return not content.element.owned and content.element.discount
			end,
		},
		{
			pass_type = "text",
			style_id = "price",
			value = "??? ",
			value_id = "price",
			style = item_price_text_style,
		},
	}, "price_item_text"),
	owned_info_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			style = owned_item_text_style,
			value = string.format("%s ", Localize("loc_premium_store_owned_note")),
		},
	}, "owned_info_text", {
		visible = false,
	}),
	promo = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "discount_percent_1",
			value = "content/ui/materials/frames/premium_store/sale_banner",
			value_id = "discount_percent_1",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				offset = {
					-55,
					-47,
					4,
				},
				size = {
					28,
					44,
				},
				size_addition = {
					0,
					0,
				},
			},
			visibility_function = function (content, style)
				return content.show_discount_percent_1
			end,
		},
		{
			pass_type = "texture",
			style_id = "discount_percent_2",
			value = "content/ui/materials/frames/premium_store/sale_banner",
			value_id = "discount_percent_2",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				offset = {
					-75,
					-47,
					4,
				},
				size = {
					28,
					44,
				},
				size_addition = {
					0,
					0,
				},
			},
			visibility_function = function (content, style)
				return content.show_discount_percent_2
			end,
		},
		{
			pass_type = "texture",
			style_id = "discount_percent_3",
			value = "content/ui/materials/frames/premium_store/sale_banner",
			value_id = "discount_percent_3",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				offset = {
					-95,
					-47,
					4,
				},
				size = {
					28,
					44,
				},
				size_addition = {
					0,
					0,
				},
			},
			visibility_function = function (content, style)
				return content.show_discount_percent_3
			end,
		},
		{
			pass_type = "texture",
			style_id = "discount_percent_background",
			value = "content/ui/materials/frames/premium_store/sale_banner_02",
			value_id = "discount_percent_background",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				offset = {
					0,
					0,
					3,
				},
				size = {
					256,
					128,
				},
				size_addition = {
					0,
					0,
				},
			},
			visibility_function = function (content, style)
				return content.discount_banner
			end,
		},
	}, "promo"),
	bundle_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "bundle",
			value = "content/ui/materials/backgrounds/bundle_store_preview",
			value_id = "bundle",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					0,
				},
				size = {
					1200,
					1080,
				},
				size_addition = {
					0,
					0,
				},
				material_values = {
					gradient_map = "content/ui/textures/masks/blur_straight",
				},
			},
			visibility_function = function (content, style)
				return style.material_values.texture_map
			end,
		},
	}, "canvas"),
	aquilas_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				color = Color.terminal_frame(255, true),
				size = {
					700,
					120,
				},
				size_addition = {
					0,
					0,
				},
				offset = {
					0,
					-120,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "title",
			value_id = "",
			style = required_aquilas_title_style,
			value = Utf8.upper(Localize("loc_premium_store_purchase_credits_storefront_button")),
		},
		{
			pass_type = "texture",
			style_id = "top",
			value = "content/ui/materials/frames/premium_store/currency_upper",
			value_id = "top",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					954,
					152,
				},
				offset = {
					0,
					-152,
					1,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "bottom",
			value = "content/ui/materials/frames/premium_store/currency_lower",
			value_id = "bottom",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					354,
					78,
				},
				offset = {
					0,
					78,
					1,
				},
			},
		},
	}, "aquilas_background", {
		visible = false,
	}),
	required_aquilas_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = required_aquilas_text_style,
		},
	}, "screen", {
		visible = false,
	}),
}
local price_text_definition = {
	{
		pass_type = "texture",
		style_id = "texture",
		value = "content/ui/materials/icons/currencies/marks_small",
		value_id = "texture",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			size = {
				40,
				28,
			},
			offset = {
				0,
				0,
				1,
			},
			original_offset = {
				0,
				0,
				1,
			},
		},
	},
	{
		pass_type = "text",
		style_id = "price_text",
		value = "0",
		value_id = "price_text",
		style = wallet_text_font_style,
	},
}
local bundle_button_definition = {
	{
		pass_type = "texture",
		style_id = "outer_shadow",
		value = "content/ui/materials/frames/dropshadow_medium",
		style = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "center",
			color = Color.black(200, true),
			size_addition = {
				20,
				20,
			},
		},
	},
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		content = {
			use_is_focused = true,
		},
	},
	{
		pass_type = "rect",
		style = {
			offset = {
				0,
				0,
				3,
			},
			color = {
				191.25,
				17,
				29,
				23,
			},
		},
	},
	{
		pass_type = "texture_uv",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_diagonal_down_right",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "center",
			color = Color.terminal_background_gradient(nil, true),
			size = {},
			offset = {
				0,
				0,
				3,
			},
			uvs = {
				{
					1,
					0,
				},
				{
					0,
					1,
				},
			},
		},
		change_function = function (content, style)
			style.color[1] = 150
		end,
	},
	{
		pass_type = "texture",
		style_id = "button_gradient",
		value = "content/ui/materials/gradients/gradient_diagonal_down_right",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			default_color = Color.terminal_background_gradient(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			offset = {
				0,
				0,
				3,
			},
		},
		change_function = function (content, style)
			ButtonPassTemplates.terminal_button_change_function(content, style)
			ButtonPassTemplates.terminal_button_hover_change_function(content, style)
		end,
	},
	{
		pass_type = "texture_uv",
		style_id = "icon",
		value = "content/ui/materials/base/ui_default_base",
		value_id = "icon",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.white(255, true),
			material_values = {},
			uvs = {
				{
					0,
					0,
				},
				{
					1,
					1,
				},
			},
		},
		visibility_function = function (content, style)
			return not not style.material_values.texture_map
		end,
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "center",
			default_color = Color.terminal_frame(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				5,
			},
		},
		change_function = function (content, style)
			ButtonPassTemplates.terminal_button_change_function(content, style)
		end,
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "center",
			default_color = Color.terminal_corner(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			offset = {
				0,
				0,
				6,
			},
		},
		change_function = function (content, style)
			ButtonPassTemplates.terminal_button_change_function(content, style)
		end,
	},
	{
		pass_type = "text",
		style_id = "title",
		value = "",
		value_id = "title",
		style = bundle_title,
	},
	{
		pass_type = "text",
		style_id = "description",
		value = "",
		value_id = "description",
		style = bundle_description,
	},
	{
		pass_type = "rect",
		style_id = "price_background",
		style = {
			vertical_alignment = "bottom",
			offset = {
				0,
				0,
				4,
			},
			color = {
				150,
				0,
				0,
				0,
			},
			size = {
				nil,
				30,
			},
		},
		visibility_function = function (content, style)
			return content.has_price_tag and not content.owned and not content.sold
		end,
	},
	{
		pass_type = "text",
		style_id = "owned_items",
		value = "n/a",
		value_id = "owned_items",
		style = bundle_owned_items_text,
		visibility_function = function (content, style)
			return content.has_price_tag and not content.sold and not content.owned
		end,
	},
	{
		pass_type = "text",
		style_id = "price_text",
		value = "n/a",
		value_id = "price_text",
		style = item_price_style,
		visibility_function = function (content, style)
			return content.has_price_tag and not content.sold and not content.owned
		end,
	},
	{
		pass_type = "text",
		style_id = "discount_price",
		value = "",
		value_id = "discount_price",
		style = item_discount_price_style,
		visibility_function = function (content, style)
			return not content.owned and content.discount_price
		end,
	},
	{
		pass_type = "texture",
		style_id = "wallet_icon",
		value = "content/ui/materials/base/ui_default_base",
		value_id = "wallet_icon",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "bottom",
			size = {
				28,
				20,
			},
			offset = {
				-2,
				-5,
				12,
			},
			color = {
				255,
				255,
				255,
				255,
			},
		},
		visibility_function = function (content, style)
			return content.has_price_tag and not content.sold and not content.owned
		end,
	},
	{
		pass_type = "text",
		style_id = "owned",
		value = "",
		value_id = "owned",
		style = item_owned_text_style,
		visibility_function = function (content, style)
			return content.owned
		end,
	},
}
local menu_preview_with_gear_off = "loc_inventory_menu_preview_with_gear_off"
local menu_preview_with_gear_on = "loc_inventory_menu_preview_with_gear_on"
local weapon_preview_skin_off = "loc_premium_store_preview_weapon_no_skin_button"
local weapon_preview_skin_on = "loc_premium_store_preview_weapon_with_skin_button"
local legend_inputs = {
	{
		alignment = "left_alignment",
		display_name = "loc_settings_menu_close_menu",
		input_action = "back",
		on_pressed_callback = "cb_on_close_pressed",
	},
	{
		alignment = "right_alignment",
		display_name = "loc_rotate",
		input_action = "navigate_controller_right",
		visibility_function = function (parent)
			return not parent._using_cursor_navigation and (parent._is_dummy_showing or parent._is_weapon_showing) and not parent._aquilas_showing
		end,
	},
	{
		alignment = "right_alignment",
		display_name = "loc_premium_store_inspect_item",
		input_action = "hotkey_item_inspect",
		on_pressed_callback = "cb_on_inspect_pressed",
		visibility_function = function (parent)
			return not parent._aquilas_showing and parent._valid_inspect
		end,
	},
	{
		alignment = "right_alignment",
		input_action = "hotkey_menu_special_1",
		on_pressed_callback = "cb_on_weapon_skin_preview_pressed",
		display_name = weapon_preview_skin_off,
		visibility_function = function (parent, id)
			local display_name = parent._weapon_preview_show_original and weapon_preview_skin_on or weapon_preview_skin_off

			parent._input_legend_element:set_display_name(id, display_name)

			return parent._selected_element and parent._selected_element.item and parent._selected_element.item.item_type == "WEAPON_SKIN" and not parent._aquilas_showing
		end,
	},
	{
		alignment = "right_alignment",
		input_action = "hotkey_menu_special_1",
		on_pressed_callback = "cb_on_preview_with_gear_toggled",
		display_name = menu_preview_with_gear_off,
		visibility_function = function (parent, id)
			local display_name = parent._previewed_with_gear and menu_preview_with_gear_off or menu_preview_with_gear_on

			parent._input_legend_element:set_display_name(id, display_name)

			return parent._can_preview_with_gear and parent._selected_element and parent._selected_element.item and not parent._aquilas_showing
		end,
	},
	{
		alignment = "right_alignment",
		display_name = "loc_inventory_menu_zoom_in",
		input_action = "hotkey_menu_special_2",
		on_pressed_callback = "cb_on_camera_zoom_toggled",
		visibility_function = function (parent, id)
			local display_name = parent._zoom_level >= 0.5 and "loc_inventory_menu_zoom_out" or "loc_inventory_menu_zoom_in"

			parent._input_legend_element:set_display_name(id, display_name)

			return parent:_can_zoom()
		end,
	},
}
local text_description_pass_template = {
	{
		pass_type = "text",
		style_id = "text",
		value = "",
		value_id = "text",
		style = description_text_font_style,
	},
}
local item_sub_title_pass = {
	{
		pass_type = "text",
		style_id = "text",
		value = "",
		value_id = "text",
		style = item_restrictions_title_style,
	},
}
local item_text_pass = {
	{
		pass_type = "text",
		style_id = "text",
		value = "",
		value_id = "text",
		style = item_restrictions_text_style,
	},
}
local premium_sub_title_pass = {
	{
		pass_type = "text",
		style_id = "text",
		value = "",
		value_id = "text",
		style = premium_sub_title_style,
	},
}
local premium_text_pass = {
	{
		pass_type = "text",
		style_id = "text",
		value = "",
		value_id = "text",
		style = premium_text_style,
	},
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	price_text_definition = price_text_definition,
	scenegraph_definition = scenegraph_definition,
	bundle_button_definition = bundle_button_definition,
	premium_sub_title_pass = premium_sub_title_pass,
	premium_text_pass = premium_text_pass,
	text_description_pass_template = text_description_pass_template,
	item_sub_title_pass = item_sub_title_pass,
	item_text_pass = item_text_pass,
}
