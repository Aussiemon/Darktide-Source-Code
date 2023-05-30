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
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
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
	corner_top_left = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			84,
			224
		},
		position = {
			0,
			0,
			62
		}
	},
	corner_top_right = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			120,
			224
		},
		position = {
			0,
			0,
			62
		}
	},
	corner_bottom_left = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			84,
			224
		},
		position = {
			0,
			0,
			62
		}
	},
	corner_bottom_right = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			84,
			224
		},
		position = {
			0,
			0,
			62
		}
	},
	left_side = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			grid_width,
			grid_height
		},
		position = {
			100,
			130,
			1
		}
	},
	item_restrictions_background = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			300,
			0
		},
		position = {
			grid_width + 100,
			-200,
			1
		}
	},
	item_restrictions = {
		vertical_alignment = "center",
		parent = "item_restrictions_background",
		horizontal_alignment = "left",
		size = {
			400,
			0
		},
		position = {
			40,
			0,
			1
		}
	},
	purchase_button_area = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			grid_width - 28,
			90
		},
		position = {
			-70,
			-100,
			0
		}
	},
	purchase_button = {
		vertical_alignment = "center",
		parent = "purchase_button_area",
		horizontal_alignment = "right",
		size = {
			360,
			50
		},
		position = {
			0,
			0,
			5
		}
	},
	price_item_text = {
		vertical_alignment = "center",
		parent = "purchase_button_area",
		horizontal_alignment = "right",
		size = {
			0,
			50
		},
		position = {
			-grid_width,
			15,
			0
		}
	},
	promo = {
		vertical_alignment = "bottom",
		parent = "left_side",
		horizontal_alignment = "right",
		size = {
			256,
			128
		},
		position = {
			14,
			125,
			1
		}
	},
	title = {
		vertical_alignment = "top",
		parent = "left_side",
		horizontal_alignment = "left",
		size = {
			grid_width - 40,
			70
		},
		position = {
			20,
			50,
			1
		}
	},
	details_pivot = {
		vertical_alignment = "top",
		parent = "left_side",
		horizontal_alignment = "center",
		size = {
			grid_width - grid_margin * 2,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	description_grid = {
		vertical_alignment = "top",
		parent = "left_side",
		horizontal_alignment = "center",
		size = {
			grid_width - grid_margin * 2,
			grid_height - 80
		},
		position = {
			0,
			40,
			1
		}
	},
	description_content_pivot = {
		vertical_alignment = "top",
		parent = "description_grid",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			2
		}
	},
	description_mask = {
		vertical_alignment = "center",
		parent = "description_grid",
		horizontal_alignment = "center",
		size = {
			grid_width,
			grid_height - 40
		},
		position = {
			0,
			0,
			2
		}
	},
	description_scrollbar = {
		vertical_alignment = "top",
		parent = "description_grid",
		horizontal_alignment = "right",
		size = {
			10,
			grid_height - 80
		},
		position = {
			0,
			0,
			2
		}
	},
	grid_divider = {
		vertical_alignment = "top",
		parent = "left_side",
		horizontal_alignment = "left",
		size = {
			grid_width,
			18
		},
		position = {
			0,
			0,
			1
		}
	},
	grid_background = {
		vertical_alignment = "top",
		parent = "left_side",
		horizontal_alignment = "left",
		size = {
			grid_width - grid_margin * 2,
			grid_height - 420
		},
		position = {
			30,
			370,
			1
		}
	},
	grid_mask = {
		vertical_alignment = "center",
		parent = "grid_background",
		horizontal_alignment = "center",
		size = {
			grid_width,
			grid_height - 420
		},
		position = {
			0,
			0,
			2
		}
	},
	grid_content_pivot = {
		vertical_alignment = "top",
		parent = "grid_background",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			2
		}
	},
	grid_scrollbar = {
		vertical_alignment = "top",
		parent = "grid_background",
		horizontal_alignment = "right",
		size = {
			10,
			grid_height - 420
		},
		position = {
			20,
			0,
			2
		}
	},
	set_pivot = {
		vertical_alignment = "top",
		parent = "left_side",
		horizontal_alignment = "left",
		size = {
			grid_width,
			50
		},
		position = {
			0,
			400,
			1
		}
	},
	wallet_pivot = {
		vertical_alignment = "top",
		parent = "corner_top_right",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-30,
			120,
			1
		}
	},
	wallet_text = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			200,
			200
		},
		position = {
			-50,
			5,
			5
		}
	},
	owned_info_text = {
		vertical_alignment = "center",
		parent = "purchase_button_area",
		horizontal_alignment = "right",
		size = {
			grid_width,
			50
		},
		position = {
			0,
			0,
			0
		}
	},
	timer_text = {
		vertical_alignment = "top",
		parent = "left_side",
		horizontal_alignment = "left",
		size = {
			grid_width,
			50
		},
		position = {
			50,
			-50,
			0
		}
	},
	weapon_viewport = {
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
			3
		}
	},
	weapon_pivot = {
		vertical_alignment = "center",
		parent = "weapon_viewport",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			300,
			0,
			1
		}
	},
	grid_aquilas_pivot = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	grid_aquilas_content = {
		vertical_alignment = "center",
		parent = "grid_aquilas_pivot",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	aquilas_required = {
		vertical_alignment = "top",
		parent = "grid_aquilas_content",
		horizontal_alignment = "center",
		size = {
			1920,
			120
		},
		position = {
			0,
			-250,
			1
		}
	},
	loading = {
		vertical_alignment = "cemter",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			50
		}
	},
	wallet_element_pivot = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-50,
			105,
			0
		}
	},
	item_name_pivot = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-66,
			-230,
			3
		}
	}
}
local wallet_text_font_style = table.clone(UIFontSettings.currency_title)
wallet_text_font_style.text_horizontal_alignment = "left"
wallet_text_font_style.text_vertical_alignment = "center"
wallet_text_font_style.original_offset = {
	0,
	0,
	1
}
wallet_text_font_style.offset = {
	0,
	0,
	1
}
wallet_text_font_style.font_size = 28
local title_style = table.clone(UIFontSettings.header_1)
title_style.font_size = 40
title_style.offset = {
	0,
	0,
	1
}
title_style.text_horizontal_alignment = "center"
title_style.text_vertical_alignment = "top"
local sub_title_style = table.clone(UIFontSettings.header_5)
sub_title_style.text_horizontal_alignment = "center"
sub_title_style.text_vertical_alignment = "top"
sub_title_style.offset = {
	0,
	0,
	0
}
sub_title_style.text_color = Color.terminal_text_body(255, true)
local grid_title_style = table.clone(UIFontSettings.header_3)
grid_title_style.text_horizontal_alignment = "left"
grid_title_style.text_vertical_alignment = "top"
grid_title_style.offset = {
	0,
	-30,
	0
}
grid_title_style.font_size = 18
grid_title_style.text_color = Color.terminal_text_body_sub_header(255, true)
local grid_sub_title_style = table.clone(UIFontSettings.header_3)
grid_sub_title_style.text_horizontal_alignment = "left"
grid_sub_title_style.text_vertical_alignment = "top"
grid_sub_title_style.offset = {
	0,
	-30,
	0
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
	255
}
timer_text_style.offset = {
	0,
	0,
	4
}
timer_text_style.horizontal_alignment = "left"
timer_text_style.vertical_alignment = "center"
local promo_text_font_style = table.clone(UIFontSettings.header_3)
promo_text_font_style.text_horizontal_alignment = "left"
promo_text_font_style.text_vertical_alignment = "center"
promo_text_font_style.offset = {
	40,
	0,
	1
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
	1
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
	3
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
	1
}
item_restrictions_title_style.font_size = 20
item_restrictions_title_style.text_color = Color.terminal_text_body_sub_header(255, true)
local item_restrictions_text_style = table.clone(item_restrictions_title_style)
item_restrictions_text_style.text_color = Color.terminal_text_body(255, true)
local set_text_font_style = table.clone(UIFontSettings.currency_title)
set_text_font_style.text_horizontal_alignment = "left"
set_text_font_style.text_vertical_alignment = "top"
set_text_font_style.offset = {
	55,
	0,
	1
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
	3
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
	4
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
	2
}
owned_item_text_style.text_color = Color.terminal_text_header(255, true)
local required_aquilas_title_style = table.clone(UIFontSettings.header_1)
required_aquilas_title_style.text_horizontal_alignment = "center"
required_aquilas_title_style.text_vertical_alignment = "top"
required_aquilas_title_style.offset = {
	0,
	123,
	2
}
required_aquilas_title_style.font_size = 40
local required_aquilas_text_style = table.clone(UIFontSettings.terminal_header_3)
required_aquilas_text_style.text_horizontal_alignment = "center"
required_aquilas_text_style.text_vertical_alignment = "bottom"
required_aquilas_text_style.horizontal_alignment = "center"
required_aquilas_text_style.vertical_alignment = "bottom"
required_aquilas_text_style.offset = {
	0,
	105,
	2
}
required_aquilas_text_style.text_color = Color.terminal_text_body(255, true)
local purchase_button_text_style = table.clone(UIFontSettings.button_primary)
purchase_button_text_style.offset = {
	0,
	0,
	4
}
purchase_button_text_style.horizontal_alignment = "center"
purchase_button_text_style.vertical_alignment = "center"
purchase_button_text_style.font_size = 24
local purchase_button_legend_text_style = table.clone(UIFontSettings.button_primary)
purchase_button_legend_text_style.offset = {
	0,
	40,
	4
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
	12
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
	20
}
local item_discount_price_style = table.clone(item_price_style)
local bundle_owned_items_text = table.clone(item_price_style)
bundle_owned_items_text.offset = {
	15,
	-5,
	12
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
	4
}
bundle_title.size_addition = {
	-30,
	0
}
local bundle_description = table.clone(UIFontSettings.terminal_header_3)
bundle_description.text_horizontal_alignment = "left"
bundle_description.text_vertical_alignment = "center"
bundle_description.font_size = 20
bundle_description.text_color = Color.terminal_text_body(255, true)
bundle_description.offset = {
	15,
	0,
	4
}
bundle_description.size_addition = {
	-30,
	0
}
local item_restrictions_pass = {
	{
		value_id = "title",
		style_id = "title",
		pass_type = "text",
		value = Utf8.upper(Localize("loc_item_equippable_on_header")),
		style = item_restrictions_title_style
	},
	{
		value_id = "text",
		style_id = "text",
		pass_type = "text",
		value = "",
		style = item_restrictions_text_style
	}
}
local widget_definitions = {
	wallet_text = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = wallet_text_font_style
		}
	}, "wallet_text"),
	background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				color = Color.terminal_frame(255, true),
				size_addition = {
					20,
					30
				},
				offset = {
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/frames/premium_store/details_upper",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size_addition = {
					52,
					0
				},
				offset = {
					0,
					-60,
					3
				},
				size = {
					nil,
					80
				}
			}
		},
		{
			value = "content/ui/materials/frames/premium_store/details_lower_basic",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size_addition = {
					52,
					0
				},
				offset = {
					0,
					34,
					3
				},
				size = {
					nil,
					108
				}
			}
		}
	}, "left_side"),
	corner_top_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/premium_upper_left"
		}
	}, "corner_top_left"),
	corner_top_right = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/premium_upper_right"
		}
	}, "corner_top_right"),
	corner_bottom_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/premium_lower_left"
		}
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/premium_lower_right"
		}
	}, "corner_bottom_right"),
	grid_divider = UIWidget.create_definition({
		{
			value_id = "divider",
			style_id = "divider",
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_center_02",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					400,
					18
				},
				offset = {
					0,
					-6,
					1
				},
				color = Color.terminal_frame(255, true)
			}
		}
	}, "grid_divider"),
	grid_title = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = grid_title_style
		}
	}, "grid_background"),
	grid_background = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		}
	}, "grid_background"),
	grid_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, "grid_scrollbar"),
	grid_mask = UIWidget.create_definition({
		{
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur",
			pass_type = "texture",
			style = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					3
				}
			}
		}
	}, "grid_mask"),
	title = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			value = "",
			style = title_style
		},
		{
			value_id = "sub_text",
			pass_type = "text",
			style_id = "sub_text",
			value = "",
			style = sub_title_style
		},
		{
			value_id = "divider",
			style_id = "divider",
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_center_02",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = {
					400,
					18
				},
				offset = {
					0,
					9,
					1
				},
				color = Color.terminal_frame(255, true)
			}
		}
	}, "title"),
	description_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, "description_scrollbar"),
	description_mask = UIWidget.create_definition({
		{
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur_viewport_2",
			pass_type = "texture",
			style = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					3
				}
			}
		}
	}, "description_mask"),
	purchase_item_button = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot",
			content = {
				use_is_focused = true
			}
		},
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				default_color = Color.terminal_background(nil, true),
				selected_color = Color.terminal_background_selected(nil, true)
			},
			change_function = ButtonPassTemplates.terminal_button_change_function
		},
		{
			pass_type = "texture",
			style_id = "background_gradient",
			value = "content/ui/materials/gradients/gradient_vertical",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				default_color = Color.terminal_background_gradient(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				disabled_color = Color.ui_grey_medium(255, true),
				offset = {
					0,
					0,
					1
				}
			},
			change_function = function (content, style)
				ButtonPassTemplates.terminal_button_change_function(content, style)
				ButtonPassTemplates.terminal_button_hover_change_function(content, style)
			end
		},
		{
			value = "content/ui/materials/frames/dropshadow_medium",
			style_id = "outer_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.black(200, true),
				size_addition = {
					20,
					20
				},
				offset = {
					0,
					0,
					3
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				default_color = Color.terminal_frame(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				disabled_color = Color.ui_grey_medium(255, true),
				offset = {
					0,
					0,
					2
				}
			},
			change_function = ButtonPassTemplates.terminal_button_change_function
		},
		{
			pass_type = "texture",
			style_id = "corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				default_color = Color.terminal_corner(nil, true),
				selected_color = Color.terminal_corner_selected(nil, true),
				disabled_color = Color.ui_grey_light(255, true),
				offset = {
					0,
					0,
					3
				}
			},
			change_function = ButtonPassTemplates.terminal_button_change_function
		},
		{
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					150,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					3
				}
			},
			visibility_function = function (content, style)
				return content.hotspot.disabled
			end
		},
		{
			style_id = "text",
			pass_type = "text",
			value_id = "text",
			value = "",
			style = purchase_button_text_style,
			change_function = function (content, style)
				local hotspot = content.hotspot
				local default_color = hotspot.disabled and style.disabled_color or style.default_color
				local hover_color = style.hover_color
				local text_color = style.text_color
				local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

				ColorUtilities.color_lerp(default_color, hover_color, progress, text_color)
			end
		},
		{
			style_id = "legend",
			pass_type = "text",
			value_id = "legend",
			value = "",
			style = purchase_button_legend_text_style
		}
	}, "purchase_button"),
	timer_widget = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = timer_text_style
		}
	}, "timer_text"),
	item_restrictions = UIWidget.create_definition(item_restrictions_pass, "item_restrictions", {
		visible = false
	}),
	price_item_text = UIWidget.create_definition({
		{
			value_id = "price_icon",
			pass_type = "texture",
			style_id = "price_icon",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = {
					40,
					28
				},
				offset = {
					0,
					-10,
					4
				}
			},
			visibility_function = function (content, style)
				if not content.element or not content.price_icon then
					return false
				end

				return not content.element.owned and not content.element.formattedPrice
			end
		},
		{
			style_id = "discount_price",
			pass_type = "text",
			value_id = "discount_price",
			value = "",
			style = item_discount_price_text_style,
			visibility_function = function (content, style)
				if not content.element then
					return false
				end

				return not content.element.owned and content.element.discount
			end
		},
		{
			style_id = "price",
			pass_type = "text",
			value_id = "price",
			value = "??? ",
			style = item_price_text_style
		}
	}, "price_item_text"),
	owned_info_text = UIWidget.create_definition({
		{
			style_id = "text",
			pass_type = "text",
			value_id = "text",
			style = owned_item_text_style,
			value = string.format("%s ", Localize("loc_premium_store_owned_note"))
		}
	}, "owned_info_text", {
		visible = false
	}),
	aquilas_required = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				scale_to_material = true,
				horizontal_alignment = "center",
				color = Color.terminal_frame(255, true),
				size = {
					700,
					120
				},
				size_addition = {
					0,
					0
				},
				offset = {
					0,
					60,
					0
				}
			}
		},
		{
			style_id = "title",
			pass_type = "text",
			value_id = "",
			style = required_aquilas_title_style,
			value = Utf8.upper(Localize("loc_premium_store_purchase_credits_storefront_button"))
		},
		{
			value_id = "top",
			style_id = "top",
			pass_type = "texture",
			value = "content/ui/materials/frames/premium_store/currency_upper",
			style = {
				horizontal_alignment = "center",
				size = {
					954,
					152
				},
				offset = {
					0,
					30,
					1
				}
			}
		},
		{
			style_id = "price",
			pass_type = "text",
			value_id = "price",
			value = "",
			style = required_aquilas_text_style
		},
		{
			value_id = "bottom",
			style_id = "bottom",
			pass_type = "texture",
			value = "content/ui/materials/frames/premium_store/currency_lower",
			style = {
				horizontal_alignment = "center",
				size = {
					354,
					78
				},
				offset = {
					0,
					670,
					1
				}
			}
		}
	}, "aquilas_required"),
	promo = UIWidget.create_definition({
		{
			value_id = "discount_percent_1",
			style_id = "discount_percent_1",
			pass_type = "texture",
			value = "content/ui/materials/frames/premium_store/sale_banner",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				offset = {
					-55,
					-47,
					4
				},
				size = {
					28,
					44
				},
				size_addition = {
					0,
					0
				}
			},
			visibility_function = function (content, style)
				return content.show_discount_percent_1
			end
		},
		{
			value_id = "discount_percent_2",
			style_id = "discount_percent_2",
			pass_type = "texture",
			value = "content/ui/materials/frames/premium_store/sale_banner",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				offset = {
					-75,
					-47,
					4
				},
				size = {
					28,
					44
				},
				size_addition = {
					0,
					0
				}
			},
			visibility_function = function (content, style)
				return content.show_discount_percent_2
			end
		},
		{
			value_id = "discount_percent_3",
			style_id = "discount_percent_3",
			pass_type = "texture",
			value = "content/ui/materials/frames/premium_store/sale_banner",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				offset = {
					-95,
					-47,
					4
				},
				size = {
					28,
					44
				},
				size_addition = {
					0,
					0
				}
			},
			visibility_function = function (content, style)
				return content.show_discount_percent_3
			end
		},
		{
			value_id = "discount_percent_background",
			style_id = "discount_percent_background",
			pass_type = "texture",
			value = "content/ui/materials/frames/premium_store/sale_banner_02",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					3
				},
				size = {
					256,
					128
				},
				size_addition = {
					0,
					0
				}
			},
			visibility_function = function (content, style)
				return content.discount_banner
			end
		}
	}, "promo"),
	bundle_background = UIWidget.create_definition({
		{
			value_id = "bundle",
			style_id = "bundle",
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/bundle_store_preview",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					0
				},
				size = {
					1200,
					1080
				},
				size_addition = {
					0,
					0
				},
				material_values = {
					gradient_map = "content/ui/textures/masks/blur_straight"
				}
			},
			visibility_function = function (content, style)
				return style.material_values.texture_map
			end
		}
	}, "canvas")
}
local price_text_definition = {
	{
		value_id = "texture",
		style_id = "texture",
		pass_type = "texture",
		value = "content/ui/materials/icons/currencies/marks_small",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			size = {
				40,
				28
			},
			offset = {
				0,
				0,
				1
			},
			original_offset = {
				0,
				0,
				1
			}
		}
	},
	{
		value_id = "price_text",
		style_id = "price_text",
		pass_type = "text",
		value = "0",
		style = wallet_text_font_style
	}
}
local bundle_button_definition = {
	{
		value = "content/ui/materials/frames/dropshadow_medium",
		style_id = "outer_shadow",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			color = Color.black(200, true),
			size_addition = {
				20,
				20
			}
		}
	},
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		content = {
			use_is_focused = true
		}
	},
	{
		pass_type = "rect",
		style = {
			offset = {
				0,
				0,
				3
			},
			color = {
				191.25,
				17,
				29,
				23
			}
		}
	},
	{
		pass_type = "texture_uv",
		style_id = "background_gradient",
		value = "content/ui/materials/gradients/gradient_diagonal_down_right",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			color = Color.terminal_background_gradient(nil, true),
			size = {},
			offset = {
				0,
				0,
				3
			},
			uvs = {
				{
					1,
					0
				},
				{
					0,
					1
				}
			}
		},
		change_function = function (content, style)
			style.color[1] = 150
		end
	},
	{
		pass_type = "texture",
		style_id = "button_gradient",
		value = "content/ui/materials/gradients/gradient_diagonal_down_right",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			default_color = Color.terminal_background_gradient(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			offset = {
				0,
				0,
				3
			}
		},
		change_function = function (content, style)
			ButtonPassTemplates.terminal_button_change_function(content, style)
			ButtonPassTemplates.terminal_button_hover_change_function(content, style)
		end
	},
	{
		value_id = "icon",
		style_id = "icon",
		pass_type = "texture_uv",
		value = "content/ui/materials/base/ui_default_base",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = Color.white(255, true),
			material_values = {},
			uvs = {
				{
					0,
					0
				},
				{
					1,
					1
				}
			}
		},
		visibility_function = function (content, style)
			return not not style.material_values.texture_map
		end
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			scale_to_material = true,
			vertical_alignment = "center",
			horizontal_alignment = "center",
			default_color = Color.terminal_frame(nil, true),
			hover_color = Color.terminal_frame_hover(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			offset = {
				0,
				0,
				5
			}
		},
		change_function = function (content, style)
			ButtonPassTemplates.terminal_button_change_function(content, style)
		end
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			scale_to_material = true,
			vertical_alignment = "center",
			horizontal_alignment = "center",
			default_color = Color.terminal_corner(nil, true),
			hover_color = Color.terminal_corner_hover(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true),
			offset = {
				0,
				0,
				6
			}
		},
		change_function = function (content, style)
			ButtonPassTemplates.terminal_button_change_function(content, style)
		end
	},
	{
		value_id = "title",
		style_id = "title",
		pass_type = "text",
		value = "",
		style = bundle_title
	},
	{
		value_id = "description",
		style_id = "description",
		pass_type = "text",
		value = "",
		style = bundle_description
	},
	{
		style_id = "price_background",
		pass_type = "rect",
		style = {
			vertical_alignment = "bottom",
			offset = {
				0,
				0,
				4
			},
			color = {
				150,
				0,
				0,
				0
			},
			size = {
				nil,
				30
			}
		},
		visibility_function = function (content, style)
			return content.has_price_tag and not content.owned and not content.sold
		end
	},
	{
		value_id = "owned_items",
		style_id = "owned_items",
		pass_type = "text",
		value = "n/a",
		style = bundle_owned_items_text,
		visibility_function = function (content, style)
			return content.has_price_tag and not content.sold and not content.owned
		end
	},
	{
		value_id = "price_text",
		style_id = "price_text",
		pass_type = "text",
		value = "n/a",
		style = item_price_style,
		visibility_function = function (content, style)
			return content.has_price_tag and not content.sold and not content.owned
		end
	},
	{
		style_id = "discount_price",
		pass_type = "text",
		value_id = "discount_price",
		value = "",
		style = item_discount_price_style,
		visibility_function = function (content, style)
			return not content.owned and content.discount_price
		end
	},
	{
		value_id = "wallet_icon",
		style_id = "wallet_icon",
		pass_type = "texture",
		value = "content/ui/materials/base/ui_default_base",
		style = {
			vertical_alignment = "bottom",
			horizontal_alignment = "right",
			size = {
				28,
				20
			},
			offset = {
				-2,
				-5,
				12
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		visibility_function = function (content, style)
			return content.has_price_tag and not content.sold and not content.owned
		end
	},
	{
		value_id = "owned",
		style_id = "owned",
		pass_type = "text",
		value = "",
		style = item_owned_text_style,
		visibility_function = function (content, style)
			return content.owned
		end
	}
}
local menu_zoom_out = "loc_inventory_menu_zoom_out"
local menu_zoom_in = "loc_inventory_menu_zoom_in"
local menu_preview_with_gear_off = "loc_inventory_menu_preview_with_gear_off"
local menu_preview_with_gear_on = "loc_inventory_menu_preview_with_gear_on"
local weapon_preview_skin_off = "loc_premium_store_preview_weapon_no_skin_button"
local weapon_preview_skin_on = "loc_premium_store_preview_weapon_with_skin_button"
local legend_inputs = {
	{
		input_action = "back",
		on_pressed_callback = "cb_on_close_pressed",
		display_name = "loc_settings_menu_close_menu",
		alignment = "left_alignment"
	},
	{
		input_action = "navigate_controller_right",
		display_name = "loc_rotate",
		alignment = "right_alignment",
		visibility_function = function (parent)
			return not parent._using_cursor_navigation and (parent._is_dummy_showing or parent._is_weapon_showing) and not parent._aquilas_showing
		end
	},
	{
		input_action = "hotkey_item_inspect",
		display_name = "loc_premium_store_inspect_item",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_inspect_pressed",
		visibility_function = function (parent)
			return not parent._aquilas_showing and parent._valid_inspect
		end
	},
	{
		input_action = "cycle_list_primary",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_weapon_skin_preview_pressed",
		display_name = weapon_preview_skin_off,
		visibility_function = function (parent, id)
			local display_name = parent._weapon_preview_show_original and weapon_preview_skin_on or weapon_preview_skin_off

			parent._input_legend_element:set_display_name(id, display_name)

			return parent._selected_element and parent._selected_element.item and parent._selected_element.item.item_type == "WEAPON_SKIN" and not parent._aquilas_showing
		end
	},
	{
		input_action = "hotkey_menu_special_2",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_preview_with_gear_toggled",
		display_name = menu_preview_with_gear_off,
		visibility_function = function (parent, id)
			local display_name = parent._previewed_with_gear and menu_preview_with_gear_off or menu_preview_with_gear_on

			parent._input_legend_element:set_display_name(id, display_name)

			return parent._can_preview_with_gear and parent._selected_element and parent._selected_element.item and not parent._aquilas_showing
		end
	},
	{
		display_name = "loc_inventory_menu_zoom_in",
		input_action = "hotkey_menu_special_1",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_camera_zoom_toggled",
		visibility_function = function (parent, id)
			if parent:_can_zoom() and not parent._aquilas_showing then
				local display_name = parent._camera_zoomed_in and menu_zoom_out or menu_zoom_in
				local input_legend = parent:_element("input_legend")

				if input_legend then
					input_legend:set_display_name(id, display_name)
				end

				return parent._on_enter_animation_triggered
			end

			return false
		end
	}
}
local text_description_pass_template = {
	{
		value_id = "text",
		style_id = "text",
		pass_type = "text",
		value = "",
		style = description_text_font_style
	}
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	price_text_definition = price_text_definition,
	scenegraph_definition = scenegraph_definition,
	text_description_pass_template = text_description_pass_template,
	bundle_button_definition = bundle_button_definition,
	item_restrictions_pass = item_restrictions_pass
}
