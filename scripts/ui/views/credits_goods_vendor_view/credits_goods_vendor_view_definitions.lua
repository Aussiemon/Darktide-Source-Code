-- chunkname: @scripts/ui/views/credits_goods_vendor_view/credits_goods_vendor_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local edge_padding = 44
local grid_width = 640
local grid_height = 950
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
	scroll_start_margin = 200,
	scrollbar_horizontal_offset = -8,
	scrollbar_vertical_margin = 80,
	scrollbar_vertical_offset = 33,
	scrollbar_width = 7,
	show_loading_overlay = true,
	title_height = 0,
	top_padding = 200,
	use_is_focused_for_navigation = true,
	use_item_categories = false,
	use_select_on_focused = false,
	use_terminal_background = true,
	widget_icon_load_margin = 0,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	edge_padding = edge_padding,
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
			40,
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
	title_text = {
		horizontal_alignment = "left",
		parent = "item_grid_pivot",
		vertical_alignment = "top",
		size = {
			grid_size[1] + edge_padding,
			200,
		},
		position = {
			0,
			10,
			15,
		},
	},
	divider = {
		horizontal_alignment = "left",
		parent = "title_text",
		vertical_alignment = "bottom",
		size = {
			grid_size[1] + edge_padding,
			50,
		},
		position = {
			0,
			50,
			1,
		},
	},
	description_text = {
		horizontal_alignment = "left",
		parent = "divider",
		vertical_alignment = "bottom",
		size = {
			grid_size[1] + edge_padding,
			200,
		},
		position = {
			0,
			0,
			1,
		},
	},
	info_box = {
		horizontal_alignment = "center",
		parent = "purchase_button",
		vertical_alignment = "bottom",
		size = {
			505,
			220,
		},
		position = {
			0,
			-56,
			-6,
		},
	},
	purchase_button = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			310,
			46,
		},
		position = {
			900,
			-143,
			10,
		},
	},
	price_text = {
		horizontal_alignment = "center",
		parent = "purchase_button",
		vertical_alignment = "top",
		size = {
			1000,
			50,
		},
		position = {
			0,
			47,
			10,
		},
	},
	price_icon = {
		horizontal_alignment = "center",
		parent = "price_text",
		vertical_alignment = "center",
		size = {
			28,
			20,
		},
		position = {
			0,
			0,
			1,
		},
	},
}
local price_text_style = table.clone(UIFontSettings.currency_title)

price_text_style.font_size = 18

local widget_definitions = {
	price_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "0",
			value_id = "text",
			style = price_text_style,
		},
	}, "price_text"),
	price_icon = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "texture",
			value = "content/ui/materials/icons/currencies/credits_small",
			value_id = "texture",
		},
	}, "price_icon"),
	purchase_button = UIWidget.create_definition(table.clone(ButtonPassTemplates.terminal_button), "purchase_button", {
		gamepad_action = "confirm_pressed",
		original_text = Utf8.upper(Localize("loc_vendor_purchase_button")),
		hotspot = {
			on_pressed_sound = UISoundEvents.default_click,
		},
	}),
	info_box = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_grid_background_icon(100, true),
				size_addition = {
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/item_purchase_upper",
			value_id = "upper",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "upper",
				color = Color.white(255, true),
				offset = {
					0,
					-77,
					2,
				},
				size = {
					510,
					106,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/item_purchase_lower",
			value_id = "lower",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				color = Color.white(255, true),
				offset = {
					0,
					88,
					2,
				},
				size = {
					510,
					108,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			value_id = "lower_glow",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "bottom",
				color = Color.terminal_grid_background(255, true),
				offset = {
					0,
					76,
					0,
				},
				size = {
					350,
					83,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			value_id = "background",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.terminal_grid_background(255, true),
				offset = {
					0,
					0,
					1,
				},
				size_addition = {
					24,
					24,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/pricetag",
			value_id = "currency_background",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "bottom",
				color = Color.white(255, true),
				offset = {
					0,
					100,
					5,
				},
				size = {
					200,
					36,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "header",
			value = "n/a",
			value_id = "header",
			style = {
				font_size = 32,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "top",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					0,
					30,
					3,
				},
				size_addition = {
					-40,
					0,
				},
				size = {
					nil,
					70,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/icons/weapons/hud/combat_blade_01",
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_text_body(255, true),
				offset = {
					0,
					40,
					3,
				},
				size = {
					256,
					96,
				},
			},
		},
	}, "info_box"),
	description_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			style = {
				font_size = 20,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				text_color = Color.terminal_text_body(255, true),
				offset = {
					0,
					0,
					1,
				},
				size = {
					grid_size[1],
					10,
				},
			},
			value = Localize("loc_credits_goods_vendor_description_text"),
		},
	}, "description_text"),
	divider = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_center_02",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_corner(255, true),
				size = {
					468,
					22,
				},
			},
		},
	}, "divider"),
	title_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			style = {
				font_size = 32,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					0,
					0,
					1,
				},
				size = {
					grid_size[1],
					10,
				},
			},
			value = Localize("loc_credits_goods_vendor_title_text"),
		},
	}, "title_text"),
}
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
}

return {
	animations = animations,
	grid_settings = grid_settings,
	tab_menu_settings = tab_menu_settings,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	item_category_tabs_content = item_category_tabs_content,
}
