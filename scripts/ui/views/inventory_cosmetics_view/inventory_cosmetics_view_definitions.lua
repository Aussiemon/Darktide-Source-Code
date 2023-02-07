local InventoryCosmeticsViewSettings = require("scripts/ui/views/inventory_cosmetics_view/inventory_cosmetics_view_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local info_box_size = {
	1250,
	200
}
local equip_button_size = {
	374,
	76
}
local title_height = 70
local edge_padding = 44
local grid_width = 440
local grid_height = 860
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
	widget_icon_load_margin = 400,
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
	corner_top_left = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			180,
			310
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
			180,
			310
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
			180,
			120
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
			180,
			120
		},
		position = {
			0,
			0,
			62
		}
	},
	item_grid_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			100,
			100,
			1
		}
	},
	player_panel_pivot = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			100,
			-50,
			1
		}
	},
	info_box = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = info_box_size,
		position = {
			-100,
			-125,
			3
		}
	},
	display_name_divider = {
		vertical_alignment = "bottom",
		parent = "info_box",
		horizontal_alignment = "left",
		size = {
			info_box_size[1] - (equip_button_size[1] + 30),
			20
		},
		position = {
			0,
			0,
			1
		}
	},
	display_name_divider_glow = {
		vertical_alignment = "bottom",
		parent = "info_box",
		horizontal_alignment = "left",
		size = {
			info_box_size[1] - (equip_button_size[1] + 30),
			80
		},
		position = {
			0,
			-6,
			1
		}
	},
	display_name = {
		vertical_alignment = "bottom",
		parent = "info_box",
		horizontal_alignment = "left",
		size = {
			info_box_size[1] - (equip_button_size[1] + 30 + 20),
			50
		},
		position = {
			10,
			-30,
			3
		}
	},
	sub_display_name = {
		vertical_alignment = "top",
		parent = "display_name",
		horizontal_alignment = "center",
		size = {
			info_box_size[1] - (equip_button_size[1] + 30 + 20),
			50
		},
		position = {
			0,
			35,
			3
		}
	},
	equip_button = {
		vertical_alignment = "bottom",
		parent = "info_box",
		horizontal_alignment = "right",
		size = equip_button_size,
		position = {
			0,
			-8,
			1
		}
	},
	weapon_stats_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-1340,
			110,
			3
		}
	}
}
local display_name_style = table.clone(UIFontSettings.header_2)
display_name_style.text_horizontal_alignment = "left"
display_name_style.text_vertical_alignment = "bottom"
local widget_definitions = {
	corner_top_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/metal_01_upper"
		}
	}, "corner_top_left"),
	corner_top_right = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/metal_01_upper",
			pass_type = "texture_uv",
			style = {
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
			}
		}
	}, "corner_top_right"),
	corner_bottom_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/metal_01_lower"
		}
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/metal_01_lower",
			pass_type = "texture_uv",
			style = {
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
			}
		}
	}, "corner_bottom_right"),
	display_name = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = display_name_style
		}
	}, "display_name"),
	display_name_divider2 = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_rendered_left_01"
		}
	}, "display_name_divider"),
	equip_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "equip_button", {
		gamepad_action = "confirm_pressed",
		text = Utf8.upper(Localize("loc_weapon_inventory_equip_button")),
		hotspot = {}
	})
}
local menu_zoom_out = "loc_inventory_menu_zoom_out"
local menu_zoom_in = "loc_inventory_menu_zoom_in"
local legend_inputs = {
	{
		input_action = "back",
		on_pressed_callback = "cb_on_close_pressed",
		display_name = "loc_settings_menu_close_menu",
		alignment = "left_alignment"
	},
	{
		display_name = "loc_inventory_menu_zoom_in",
		input_action = "hotkey_menu_special_1",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_camera_zoom_toggled",
		visibility_function = function (parent, id)
			local display_name = parent._camera_zoomed_in and menu_zoom_out or menu_zoom_in

			parent._input_legend_element:set_display_name(id, display_name)

			return true
		end
	}
}

return {
	grid_settings = grid_settings,
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
