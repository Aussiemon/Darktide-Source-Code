local PremiumVendorViewSettings = require("scripts/ui/views/premium_vendor_view/premium_vendor_view_settings")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local stats_size = PremiumVendorViewSettings.stats_size
local stats_spacing = PremiumVendorViewSettings.stats_spacing
local scrollbar_width = PremiumVendorViewSettings.scrollbar_width
local grid_size = PremiumVendorViewSettings.grid_size
local mask_size = PremiumVendorViewSettings.mask_size
local grid_start_offset_x = 180
local info_box_size = {
	850,
	stats_size[2] * 7 + stats_spacing * 6
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
			0,
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
			scrollbar_width + 8,
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
	title_text = {
		vertical_alignment = "center",
		parent = "grid_divider_top",
		horizontal_alignment = "center",
		size = {
			960,
			50
		},
		position = {
			0,
			-60,
			2
		}
	},
	weapon_viewport = {
		vertical_alignment = "center",
		parent = "canvas",
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
			400,
			100,
			1
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
	info_box_divider = {
		vertical_alignment = "top",
		parent = "info_box",
		horizontal_alignment = "center",
		size = {
			info_box_size[1],
			10
		},
		position = {
			0,
			-6,
			1
		}
	},
	info_divider_glow = {
		vertical_alignment = "top",
		parent = "info_box",
		horizontal_alignment = "center",
		size = {
			info_box_size[1],
			80
		},
		position = {
			0,
			-80,
			1
		}
	},
	display_name = {
		vertical_alignment = "top",
		parent = "info_box",
		horizontal_alignment = "left",
		size = {
			1700,
			50
		},
		position = {
			0,
			-90,
			3
		}
	},
	sub_display_name = {
		vertical_alignment = "top",
		parent = "display_name",
		horizontal_alignment = "center",
		size = {
			1700,
			50
		},
		position = {
			0,
			35,
			3
		}
	},
	price_text = {
		vertical_alignment = "top",
		parent = "info_box",
		horizontal_alignment = "right",
		size = {
			1700,
			50
		},
		position = {
			-10,
			-60,
			3
		}
	},
	stat_pivot = {
		vertical_alignment = "top",
		parent = "info_box",
		horizontal_alignment = "left",
		size = stats_size,
		position = {
			0,
			25,
			0
		}
	},
	purchase_button = {
		vertical_alignment = "bottom",
		parent = "info_box",
		horizontal_alignment = "right",
		size = {
			374,
			76
		},
		position = {
			0,
			0,
			1
		}
	},
	inspect_button = {
		vertical_alignment = "bottom",
		parent = "info_box",
		horizontal_alignment = "right",
		size = {
			374,
			50
		},
		position = {
			0,
			-80,
			1
		}
	},
	wallet_text = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			200,
			200
		},
		position = {
			-180,
			150,
			5
		}
	}
}
local title_text_font_style = table.clone(UIFontSettings.header_2)
title_text_font_style.offset = {
	0,
	0,
	3
}
title_text_font_style.text_horizontal_alignment = "center"
title_text_font_style.text_vertical_alignment = "center"
local wallet_text_font_style = table.clone(UIFontSettings.body)
wallet_text_font_style.offset = {
	0,
	0,
	3
}
wallet_text_font_style.text_horizontal_alignment = "right"
wallet_text_font_style.text_vertical_alignment = "top"
local display_name_style = table.clone(UIFontSettings.header_2)
display_name_style.text_horizontal_alignment = "left"
display_name_style.text_vertical_alignment = "center"
local sub_display_name_style = table.clone(UIFontSettings.body)
sub_display_name_style.text_horizontal_alignment = "left"
sub_display_name_style.text_vertical_alignment = "center"
local price_text_style = table.clone(UIFontSettings.body)
price_text_style.text_horizontal_alignment = "right"
price_text_style.text_vertical_alignment = "bottom"
local widget_definitions = {
	wallet_text = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = wallet_text_font_style
		}
	}, "wallet_text"),
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
	info_box_divider = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/horizontal_dynamic_lower"
		}
	}, "info_box_divider"),
	info_divider_glow = UIWidget.create_definition({
		{
			value = "content/ui/materials/effects/wide_upward_glow",
			style_id = "texture",
			pass_type = "texture"
		}
	}, "info_divider_glow"),
	title_text = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style = title_text_font_style
		}
	}, "title_text"),
	grid_divider_top = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/horizontal_frame_big_upper"
		}
	}, "grid_divider_top"),
	grid_divider_bottom = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/horizontal_frame_big_lower"
		}
	}, "grid_divider_bottom"),
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
	display_name = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = display_name_style
		}
	}, "display_name"),
	sub_display_name = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = sub_display_name_style
		}
	}, "sub_display_name"),
	price_text = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "n/a",
			style = price_text_style
		}
	}, "price_text"),
	inspect_button = UIWidget.create_definition(table.clone(ButtonPassTemplates.default_button_small), "inspect_button", {
		text = Utf8.upper(Localize("loc_vendor_inspect_button")),
		hotspot = {
			on_pressed_sound = UISoundEvents.weapons_customize_enter
		}
	}),
	purchase_button = UIWidget.create_definition(table.clone(ButtonPassTemplates.default_button), "purchase_button", {
		text = Utf8.upper(Localize("loc_vendor_purchase_button")),
		hotspot = {
			on_pressed_sound = UISoundEvents.weapons_customize_enter
		}
	})
}
local legend_inputs = {
	{
		input_action = "back",
		on_pressed_callback = "cb_on_close_pressed",
		display_name = "loc_settings_menu_close_menu",
		alignment = "left_alignment"
	}
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
