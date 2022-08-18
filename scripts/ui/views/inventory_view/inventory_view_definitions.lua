local InventoryViewSettings = require("scripts/ui/views/inventory_view/inventory_view_settings")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ItemPassTemplates = require("scripts/ui/pass_templates/item_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scrollbar_width = InventoryViewSettings.scrollbar_width
local grid_size = InventoryViewSettings.grid_size
local mask_size = InventoryViewSettings.mask_size
local grid_start_offset_x = 180
local gear_icon_size = ItemPassTemplates.gear_icon_size
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
	grid_background = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = grid_size,
		position = {
			grid_start_offset_x,
			216,
			1
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
			1
		}
	},
	grid_scrollbar = {
		vertical_alignment = "top",
		parent = "grid_divider_top",
		horizontal_alignment = "right",
		size = {
			scrollbar_width,
			grid_size[2]
		},
		position = {
			0,
			38,
			1
		}
	},
	grid_mask = {
		vertical_alignment = "center",
		parent = "grid_background",
		horizontal_alignment = "center",
		size = mask_size,
		position = {
			0,
			0,
			10
		}
	},
	grid_interaction = {
		vertical_alignment = "top",
		parent = "grid_background",
		horizontal_alignment = "left",
		size = {
			1000 + scrollbar_width * 2,
			mask_size[2]
		},
		position = {
			0,
			0,
			0
		}
	},
	grid_divider_bottom = {
		vertical_alignment = "bottom",
		parent = "grid_background",
		horizontal_alignment = "center",
		size = {
			670,
			36
		},
		position = {
			0,
			36,
			12
		}
	},
	grid_divider_top = {
		vertical_alignment = "top",
		parent = "grid_background",
		horizontal_alignment = "center",
		size = {
			670,
			36
		},
		position = {
			0,
			-36,
			12
		}
	},
	grid_tab_panel = {
		vertical_alignment = "top",
		parent = "grid_divider_top",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-50,
			1
		}
	},
	tab_menu_title_text = {
		vertical_alignment = "center",
		parent = "grid_divider_top",
		horizontal_alignment = "left",
		size = {
			960,
			50
		},
		position = {
			10,
			-50,
			2
		}
	},
	tab_menu_back_button = {
		vertical_alignment = "center",
		parent = "grid_divider_top",
		horizontal_alignment = "left",
		size = {
			72,
			72
		},
		position = {
			-70,
			-50,
			3
		}
	},
	wallet_text = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			200,
			200
		},
		position = {
			-130,
			0,
			5
		}
	},
	slot_gear_head = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = gear_icon_size,
		position = {
			-400,
			-150,
			5
		}
	},
	slot_gear_upperbody = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = gear_icon_size,
		position = {
			400,
			-150,
			5
		}
	},
	slot_gear_lowerbody = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = gear_icon_size,
		position = {
			400,
			150,
			5
		}
	},
	slot_gear_extra_cosmetic = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = gear_icon_size,
		position = {
			-400,
			150,
			5
		}
	},
	button_skin_sets = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-620,
			-230,
			5
		}
	},
	button_expressions = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-620,
			-140,
			5
		}
	}
}
local tab_menu_title_text_font_style = table.clone(UIFontSettings.header_1)
tab_menu_title_text_font_style.offset = {
	0,
	0,
	3
}
tab_menu_title_text_font_style.text_horizontal_alignment = "left"
tab_menu_title_text_font_style.text_vertical_alignment = "center"
tab_menu_title_text_font_style.hover_text_color = Color.ui_brown_super_light(255, true)
local wallet_text_font_style = table.clone(UIFontSettings.body)
wallet_text_font_style.offset = {
	0,
	0,
	3
}
wallet_text_font_style.text_horizontal_alignment = "right"
wallet_text_font_style.text_vertical_alignment = "top"
local widget_definitions = {
	wallet_text = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = wallet_text_font_style
		}
	}, "wallet_text"),
	tab_menu_title_text = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style = tab_menu_title_text_font_style
		}
	}, "tab_menu_title_text"),
	tab_menu_back_button = UIWidget.create_definition(ButtonPassTemplates.title_back_button, "tab_menu_back_button"),
	grid_background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					670
				},
				size_addition = {
					-4,
					-4
				},
				color = {
					100,
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/dividers/horizontal_frame_big_upper",
			pass_type = "texture",
			style = {
				scenegraph_id = "grid_divider_top"
			}
		},
		{
			value = "content/ui/materials/dividers/horizontal_frame_big_lower",
			pass_type = "texture",
			style = {
				scenegraph_id = "grid_divider_bottom"
			}
		}
	}, "grid_mask"),
	grid_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.default_scrollbar, "grid_scrollbar"),
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
	grid_interaction = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		}
	}, "grid_interaction")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
