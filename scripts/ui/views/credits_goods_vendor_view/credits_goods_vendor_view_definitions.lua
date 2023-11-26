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
	use_item_categories = false,
	use_select_on_focused = false,
	scrollbar_horizontal_offset = -8,
	scroll_start_margin = 200,
	top_padding = 200,
	scrollbar_vertical_offset = 33,
	show_loading_overlay = true,
	scrollbar_vertical_margin = 80,
	widget_icon_load_margin = 0,
	use_is_focused_for_navigation = true,
	use_terminal_background = true,
	title_height = 0,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	edge_padding = edge_padding
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
			40,
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
	},
	title_text = {
		vertical_alignment = "top",
		parent = "item_grid_pivot",
		horizontal_alignment = "left",
		size = {
			grid_size[1] + edge_padding,
			200
		},
		position = {
			0,
			10,
			15
		}
	},
	divider = {
		vertical_alignment = "bottom",
		parent = "title_text",
		horizontal_alignment = "left",
		size = {
			grid_size[1] + edge_padding,
			50
		},
		position = {
			0,
			50,
			1
		}
	},
	description_text = {
		vertical_alignment = "bottom",
		parent = "divider",
		horizontal_alignment = "left",
		size = {
			grid_size[1] + edge_padding,
			200
		},
		position = {
			0,
			0,
			1
		}
	},
	info_box = {
		vertical_alignment = "bottom",
		parent = "purchase_button",
		horizontal_alignment = "center",
		size = {
			505,
			220
		},
		position = {
			0,
			-56,
			-6
		}
	},
	purchase_button = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			310,
			46
		},
		position = {
			900,
			-143,
			10
		}
	},
	price_text = {
		vertical_alignment = "top",
		parent = "purchase_button",
		horizontal_alignment = "center",
		size = {
			1000,
			50
		},
		position = {
			0,
			47,
			10
		}
	},
	price_icon = {
		vertical_alignment = "center",
		parent = "price_text",
		horizontal_alignment = "center",
		size = {
			28,
			20
		},
		position = {
			0,
			0,
			1
		}
	}
}
local price_text_style = table.clone(UIFontSettings.currency_title)

price_text_style.font_size = 18

local widget_definitions = {
	price_text = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "0",
			style = price_text_style
		}
	}, "price_text"),
	price_icon = UIWidget.create_definition({
		{
			value = "content/ui/materials/icons/currencies/credits_small",
			style_id = "texture",
			pass_type = "texture",
			value_id = "texture"
		}
	}, "price_icon"),
	purchase_button = UIWidget.create_definition(table.clone(ButtonPassTemplates.terminal_button), "purchase_button", {
		gamepad_action = "confirm_pressed",
		original_text = Utf8.upper(Localize("loc_vendor_purchase_button")),
		hotspot = {
			on_pressed_sound = UISoundEvents.default_click
		}
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
					0
				}
			}
		},
		{
			value = "content/ui/materials/frames/item_purchase_upper",
			value_id = "upper",
			pass_type = "texture",
			style = {
				vertical_alignment = "upper",
				horizontal_alignment = "center",
				color = Color.white(255, true),
				offset = {
					0,
					-77,
					2
				},
				size = {
					510,
					106
				}
			}
		},
		{
			value = "content/ui/materials/frames/item_purchase_lower",
			value_id = "lower",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				color = Color.white(255, true),
				offset = {
					0,
					88,
					2
				},
				size = {
					510,
					108
				}
			}
		},
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			value_id = "lower_glow",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.terminal_grid_background(255, true),
				offset = {
					0,
					76,
					0
				},
				size = {
					350,
					83
				}
			}
		},
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			value_id = "background",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				color = Color.terminal_grid_background(255, true),
				offset = {
					0,
					0,
					1
				},
				size_addition = {
					24,
					24
				}
			}
		},
		{
			value = "content/ui/materials/frames/pricetag",
			value_id = "currency_background",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.white(255, true),
				offset = {
					0,
					100,
					5
				},
				size = {
					200,
					36
				}
			}
		},
		{
			style_id = "header",
			value_id = "header",
			pass_type = "text",
			value = "n/a",
			style = {
				text_vertical_alignment = "center",
				font_size = 32,
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				vertical_alignment = "top",
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					0,
					30,
					3
				},
				size_addition = {
					-40,
					0
				},
				size = {
					nil,
					70
				}
			}
		},
		{
			value = "content/ui/materials/icons/weapons/hud/combat_blade_01",
			value_id = "icon",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.terminal_text_body(255, true),
				offset = {
					0,
					40,
					3
				},
				size = {
					256,
					96
				}
			}
		}
	}, "info_box"),
	description_text = UIWidget.create_definition({
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text",
			style = {
				horizontal_alignment = "center",
				font_size = 20,
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_body(255, true),
				offset = {
					0,
					0,
					1
				},
				size = {
					grid_size[1],
					10
				}
			},
			value = Localize("loc_credits_goods_vendor_description_text")
		}
	}, "description_text"),
	divider = UIWidget.create_definition({
		{
			value = "content/ui/materials/dividers/skull_center_02",
			pass_type = "texture",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_corner(255, true),
				size = {
					468,
					22
				}
			}
		}
	}, "divider"),
	title_text = UIWidget.create_definition({
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text",
			style = {
				horizontal_alignment = "center",
				font_size = 32,
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					0,
					0,
					1
				},
				size = {
					grid_size[1],
					10
				}
			},
			value = Localize("loc_credits_goods_vendor_title_text")
		}
	}, "title_text")
}
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
	}
}

return {
	animations = animations,
	grid_settings = grid_settings,
	tab_menu_settings = tab_menu_settings,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	item_category_tabs_content = item_category_tabs_content
}
