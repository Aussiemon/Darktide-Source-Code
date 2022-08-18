local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local InventoryWeaponCosmeticsViewSettings = require("scripts/ui/views/inventory_weapon_cosmetics_view/inventory_weapon_cosmetics_view_settings")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scrollbar_width = InventoryWeaponCosmeticsViewSettings.scrollbar_width
local grid_size = InventoryWeaponCosmeticsViewSettings.grid_size
local grid_content_edge_margin = InventoryWeaponCosmeticsViewSettings.grid_content_edge_margin
local mask_size = InventoryWeaponCosmeticsViewSettings.mask_size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
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
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "center",
		size = grid_size,
		position = {
			0,
			-170,
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
			grid_content_edge_margin,
			0,
			1
		}
	},
	grid_scrollbar = {
		vertical_alignment = "center",
		parent = "grid_background",
		horizontal_alignment = "right",
		size = {
			scrollbar_width,
			grid_size[2] - 20
		},
		position = {
			scrollbar_width - 8,
			0,
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
		size = mask_size,
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
			grid_size[1] + 4,
			10
		},
		position = {
			0,
			6,
			12
		}
	},
	grid_divider_top = {
		vertical_alignment = "top",
		parent = "grid_background",
		horizontal_alignment = "center",
		size = {
			grid_size[1] + 4,
			10
		},
		position = {
			0,
			-6,
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
	equip_button = {
		vertical_alignment = "bottom",
		parent = "grid_divider_bottom",
		horizontal_alignment = "center",
		size = {
			374,
			76
		},
		position = {
			0,
			90,
			1
		}
	},
	title_text = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			1700,
			50
		},
		position = {
			0,
			15,
			3
		}
	},
	sub_title_text = {
		vertical_alignment = "top",
		parent = "title_text",
		horizontal_alignment = "center",
		size = {
			1700,
			50
		},
		position = {
			0,
			55,
			3
		}
	},
	title_divider = {
		vertical_alignment = "bottom",
		parent = "title_text",
		horizontal_alignment = "center",
		size = {
			800,
			10
		},
		position = {
			0,
			45,
			1
		}
	},
	title_divider_glow = {
		vertical_alignment = "bottom",
		parent = "title_text",
		horizontal_alignment = "center",
		size = {
			800,
			80
		},
		position = {
			0,
			40,
			1
		}
	},
	description_text = {
		vertical_alignment = "bottom",
		parent = "title_divider",
		horizontal_alignment = "center",
		size = {
			1000,
			150
		},
		position = {
			0,
			170,
			3
		}
	},
	back_button = {
		vertical_alignment = "center",
		parent = "title_text",
		horizontal_alignment = "left",
		size = {
			72,
			72
		},
		position = {
			-85,
			0,
			3
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
			150,
			0,
			1
		}
	},
	appearance_button = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			400,
			50
		},
		position = {
			-50,
			100,
			10
		}
	}
}
local title_text_style = table.clone(UIFontSettings.header_2)
title_text_style.text_horizontal_alignment = "center"
title_text_style.text_vertical_alignment = "bottom"
local sub_title_text_style = table.clone(UIFontSettings.header_3)
sub_title_text_style.text_horizontal_alignment = "center"
sub_title_text_style.text_vertical_alignment = "top"
sub_title_text_style.text_color = Color.ui_grey_light(255, true)
local description_text_style = table.clone(UIFontSettings.body_small)
description_text_style.text_horizontal_alignment = "center"
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
				}
			}
		}
	}, "grid_mask"),
	grid_interaction = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		}
	}, "grid_interaction"),
	description_text = UIWidget.create_definition({
		{
			value = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
			value_id = "text",
			pass_type = "text",
			style = description_text_style
		}
	}, "description_text"),
	title_text = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			value = Managers.localization:localize("loc_weapon_inventory_traits_title_text"),
			style = title_text_style
		}
	}, "title_text"),
	title_divider = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/horizontal_dynamic_lower"
		}
	}, "title_divider"),
	title_divider_glow = UIWidget.create_definition({
		{
			value = "content/ui/materials/effects/wide_upward_glow",
			style_id = "texture",
			pass_type = "texture"
		}
	}, "title_divider_glow"),
	sub_title_text = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			value = Managers.localization:localize("loc_weapon_inventory_traits_sub_title_text"),
			style = sub_title_text_style
		}
	}, "sub_title_text"),
	equip_button = UIWidget.create_definition(table.clone(ButtonPassTemplates.default_button), "equip_button", {
		text = Utf8.upper(Localize("loc_weapon_inventory_equip_button")),
		hotspot = {
			on_pressed_sound = UISoundEvents.weapons_customize_enter
		}
	})
}
local legend_inputs = {
	{
		input_action = "back",
		on_pressed_callback = "_cb_on_close_pressed",
		display_name = "loc_settings_menu_close_menu",
		alignment = "left_alignment"
	},
	{
		on_pressed_callback = "_cb_on_ui_visibility_toggled",
		input_action = "right_pressed",
		display_name = "loc_menu_toggle_ui_visibility_off",
		alignment = "right_alignment"
	}
}
local always_visible_widget_names = {
	corner_bottom_right = true,
	corner_top_left = true,
	corner_top_right = true,
	corner_bottom_left = true
}

return {
	legend_inputs = legend_inputs,
	always_visible_widget_names = always_visible_widget_names,
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions
}
