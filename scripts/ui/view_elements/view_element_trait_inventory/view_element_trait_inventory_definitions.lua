local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local title_height = 0
local edge_padding = 100
local grid_width = 430
local grid_height = 800
local grid_size = {
	grid_width - edge_padding,
	grid_height
}
local grid_spacing = {
	0,
	0
}
local mask_width = grid_width + 44
local mask_size = {
	mask_width,
	grid_height
}
local menu_settings = {
	scrollbar_width = 7,
	widget_icon_load_margin = 0,
	use_select_on_focused = true,
	use_is_focused_for_navigation = false,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	title_height = title_height,
	edge_padding = edge_padding
}
local scenegraph_definition = {
	trait_info_box = {
		vertical_alignment = "bottom",
		parent = "grid_background",
		horizontal_alignment = "center",
		size = {
			grid_width,
			150
		},
		position = {
			0,
			0,
			20
		}
	},
	trait_info_box_contents = {
		vertical_alignment = "top",
		parent = "trait_info_box",
		horizontal_alignment = "center",
		size = {
			grid_width,
			150
		},
		position = {
			0,
			20,
			1
		}
	},
	grid_divider_middle = {
		vertical_alignment = "top",
		parent = "trait_info_box",
		horizontal_alignment = "center",
		size = {
			430,
			44
		},
		position = {
			0,
			-22,
			1
		}
	}
}
local weapon_traits_style = table.clone(UIFontSettings.header_3)
weapon_traits_style.offset = {
	98,
	0,
	3
}
weapon_traits_style.size = {
	324
}
weapon_traits_style.font_size = 18
weapon_traits_style.text_horizontal_alignment = "left"
weapon_traits_style.text_vertical_alignment = "top"
weapon_traits_style.text_color = Color.terminal_text_header(255, true)
local weapon_traits_description_style = table.clone(UIFontSettings.body)
weapon_traits_description_style.offset = {
	98,
	20,
	3
}
weapon_traits_description_style.size = {
	324,
	500
}
weapon_traits_description_style.font_size = 18
weapon_traits_description_style.text_horizontal_alignment = "left"
weapon_traits_description_style.text_vertical_alignment = "top"
weapon_traits_description_style.text_color = Color.terminal_text_body(255, true)
local widget_definitions = {
	grid_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					18,
					16
				},
				color = Color.terminal_grid_background(255, true)
			}
		}
	}, "grid_background"),
	grid_divider_top = UIWidget.create_definition({
		{
			value_id = "texture",
			style_id = "texture",
			pass_type = "texture",
			value = "content/ui/materials/frames/item_info_upper",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top"
			}
		}
	}, "grid_divider_top"),
	grid_divider_bottom = UIWidget.create_definition({
		{
			value_id = "texture",
			style_id = "texture",
			pass_type = "texture",
			value = "content/ui/materials/frames/item_info_lower",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center"
			}
		}
	}, "grid_divider_bottom"),
	trait_info_box = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			pass_type = "texture",
			style = {
				color = Color.ui_zealot(nil, true)
			}
		}
	}, "trait_info_box"),
	trait_info_box_contents = UIWidget.create_definition({
		{
			value = "content/ui/materials/icons/traits/traits_container",
			style_id = "icon",
			pass_type = "texture",
			style = {
				material_values = {},
				size = {
					64,
					64
				},
				offset = {
					20,
					0,
					0
				},
				color = Color.terminal_icon(255, true)
			}
		},
		{
			value_id = "display_name",
			pass_type = "text",
			style = weapon_traits_style
		},
		{
			value_id = "description",
			pass_type = "text",
			style = weapon_traits_description_style
		}
	}, "trait_info_box_contents"),
	grid_divider_middle = UIWidget.create_definition({
		{
			value_id = "texture",
			style_id = "texture",
			pass_type = "texture",
			value = "content/ui/materials/dividers/horizontal_frame_big_middle",
			style = {
				horizontal_alignment = "center"
			}
		}
	}, "grid_divider_middle")
}

return {
	menu_settings = menu_settings,
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions
}
