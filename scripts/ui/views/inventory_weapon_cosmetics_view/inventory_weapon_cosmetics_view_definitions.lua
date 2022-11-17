local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local InventoryWeaponCosmeticsViewSettings = require("scripts/ui/views/inventory_weapon_cosmetics_view/inventory_weapon_cosmetics_view_settings")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
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
			-48,
			1
		}
	},
	weapon_preview = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			800,
			800
		},
		position = {
			0,
			0,
			1
		}
	},
	description_text = {
		vertical_alignment = "bottom",
		parent = "display_name_divider",
		horizontal_alignment = "center",
		size = {
			1000,
			150
		},
		position = {
			0,
			120,
			3
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
			-40,
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
			45,
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
	}
}
local display_name_style = table.clone(UIFontSettings.header_2)
display_name_style.text_horizontal_alignment = "left"
display_name_style.text_vertical_alignment = "bottom"
local title_text_style = table.clone(UIFontSettings.header_2)
title_text_style.text_horizontal_alignment = "center"
title_text_style.text_vertical_alignment = "bottom"
local sub_display_name_style = table.clone(UIFontSettings.header_3)
sub_display_name_style.text_horizontal_alignment = "left"
sub_display_name_style.text_vertical_alignment = "top"
sub_display_name_style.text_color = Color.ui_grey_light(255, true)
local description_text_style = table.clone(UIFontSettings.body_small)
description_text_style.text_horizontal_alignment = "left"
description_text_style.text_vertical_alignment = "top"
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
	description_text = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = description_text_style
		}
	}, "description_text"),
	display_name_divider = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/horizontal_dynamic_lower"
		}
	}, "display_name_divider"),
	display_name_divider_glow = UIWidget.create_definition({
		{
			value = "content/ui/materials/effects/wide_upward_glow",
			style_id = "texture",
			pass_type = "texture"
		}
	}, "display_name_divider_glow"),
	sub_display_name = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = sub_display_name_style
		}
	}, "sub_display_name"),
	display_name = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = display_name_style
		}
	}, "display_name"),
	equip_button = UIWidget.create_definition(table.clone(ButtonPassTemplates.default_button), "equip_button", {
		text = Utf8.upper(Localize("loc_confirm")),
		hotspot = {
			on_pressed_sound = UISoundEvents.weapons_skin_confirm
		}
	})
}
local background_widget = UIWidget.create_definition({
	{
		pass_type = "rect",
		style = {
			color = {
				255,
				13,
				26,
				30
			}
		}
	}
}, "screen")
local legend_inputs = {
	{
		input_action = "back",
		on_pressed_callback = "_cb_on_close_pressed",
		display_name = "loc_settings_menu_close_menu",
		alignment = "left_alignment"
	}
}
local always_visible_widget_names = {
	corner_bottom_right = true,
	corner_top_left = true,
	corner_top_right = true,
	corner_bottom_left = true
}

return {
	grid_settings = grid_settings,
	legend_inputs = legend_inputs,
	background_widget = background_widget,
	always_visible_widget_names = always_visible_widget_names,
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions
}
