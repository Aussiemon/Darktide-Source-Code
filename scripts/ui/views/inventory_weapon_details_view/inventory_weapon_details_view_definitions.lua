local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local InventoryWeaponDetailsViewSettings = require("scripts/ui/views/inventory_weapon_details_view/inventory_weapon_details_view_settings")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local stats_size = InventoryWeaponDetailsViewSettings.stats_size
local stats_spacing = InventoryWeaponDetailsViewSettings.stats_spacing
local trait_size = InventoryWeaponDetailsViewSettings.trait_size
local scrollbar_width = InventoryWeaponDetailsViewSettings.scrollbar_width
local grid_size = InventoryWeaponDetailsViewSettings.grid_size
local grid_content_edge_margin = InventoryWeaponDetailsViewSettings.grid_content_edge_margin
local mask_size = InventoryWeaponDetailsViewSettings.mask_size
local grid_start_offset_x = 180
local info_box_size = {
	500,
	250
}
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
	info_box = {
		vertical_alignment = "bottom",
		parent = "grid_divider_bottom",
		horizontal_alignment = "right",
		size = info_box_size,
		position = {
			info_box_size[1] + 44,
			0,
			3
		}
	},
	trait_title_text = {
		vertical_alignment = "top",
		parent = "info_box",
		horizontal_alignment = "left",
		size = {
			info_box_size[1],
			30
		},
		position = {
			0,
			-30,
			3
		}
	},
	trait_pivot = {
		vertical_alignment = "top",
		parent = "info_box",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			5
		}
	},
	title_text = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			1700,
			50
		},
		position = {
			180,
			100,
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
			60,
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
			300,
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
local title_text_style = table.clone(UIFontSettings.header_1)
title_text_style.text_horizontal_alignment = "left"
title_text_style.text_vertical_alignment = "top"
local sub_title_text_style = table.clone(UIFontSettings.header_3)
sub_title_text_style.text_horizontal_alignment = "left"
sub_title_text_style.text_vertical_alignment = "top"
sub_title_text_style.text_color = Color.ui_grey_light(255, true)
local trait_title_text_style = table.clone(UIFontSettings.header_3)
trait_title_text_style.text_horizontal_alignment = "left"
trait_title_text_style.text_vertical_alignment = "top"
trait_title_text_style.text_color = Color.ui_grey_light(255, true)
local trait_display_name_text_style = table.clone(UIFontSettings.header_3)
trait_display_name_text_style.text_horizontal_alignment = "left"
trait_display_name_text_style.text_vertical_alignment = "top"
trait_display_name_text_style.text_color = Color.ui_grey_light(255, true)
trait_display_name_text_style.offset = {
	50,
	0,
	0
}
local trait_description_text_style = table.clone(UIFontSettings.body_small)
trait_description_text_style.text_horizontal_alignment = "left"
trait_description_text_style.text_vertical_alignment = "top"
trait_description_text_style.size = {
	0,
	0
}
trait_description_text_style.offset = {
	50,
	30,
	0
}
local experience_bar_text_style = table.clone(UIFontSettings.header_3)
experience_bar_text_style.text_horizontal_alignment = "left"
experience_bar_text_style.text_vertical_alignment = "top"
experience_bar_text_style.offset = {
	0,
	-30,
	2
}
local rank_text_style = table.clone(UIFontSettings.body)
rank_text_style.text_horizontal_alignment = "left"
rank_text_style.text_vertical_alignment = "top"
rank_text_style.offset = {
	0,
	10,
	2
}
rank_text_style.font_size = 18
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
	grid_divider_top = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/horizontal_dynamic_upper"
		}
	}, "grid_divider_top"),
	grid_divider_bottom = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/horizontal_dynamic_lower"
		}
	}, "grid_divider_bottom"),
	grid_background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					100,
					0,
					0,
					0
				}
			}
		}
	}, "grid_background"),
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
	trait_title_text = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			value = Managers.localization:localize("loc_weapon_inventory_traits_title_text"),
			style = trait_title_text_style
		}
	}, "trait_title_text"),
	trait_title_line = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/default_square",
			pass_type = "texture",
			style = {
				hdr = false,
				size = {
					nil,
					1
				},
				offset = {
					0,
					30,
					0
				},
				color = Color.ui_grey_light(255, true)
			}
		}
	}, "trait_title_text")
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
local trait_widget_definition = UIWidget.create_definition({
	{
		style_id = "icon",
		value_id = "icon",
		pass_type = "texture",
		style = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			size = {
				40,
				40
			},
			color = Color.white(255, true)
		}
	},
	{
		value_id = "display_name",
		style_id = "display_name",
		pass_type = "text",
		value = "n/a",
		style = trait_display_name_text_style
	},
	{
		value_id = "description_text",
		style_id = "description_text",
		pass_type = "text",
		value = "n/a",
		style = trait_description_text_style
	}
}, "trait_pivot", nil, {
	info_box_size[1],
	10
})
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
	trait_widget_definition = trait_widget_definition,
	widget_definitions = widget_definitions
}
