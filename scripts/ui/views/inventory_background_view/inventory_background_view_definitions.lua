local BarPassTemplates = require("scripts/ui/pass_templates/bar_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local character_experience_bar_size = {
	280,
	10
}
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
	corner_top_left = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			128,
			282
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
			128,
			282
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
			128,
			242
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
			128,
			242
		},
		position = {
			0,
			0,
			62
		}
	},
	character_insigna = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			30,
			80
		},
		position = {
			50,
			15,
			62
		}
	},
	character_portrait = {
		vertical_alignment = "center",
		parent = "character_insigna",
		horizontal_alignment = "left",
		size = {
			70,
			80
		},
		position = {
			40,
			0,
			1
		}
	},
	character_name = {
		vertical_alignment = "top",
		parent = "character_portrait",
		horizontal_alignment = "left",
		size = {
			400,
			30
		},
		position = {
			80,
			0,
			1
		}
	},
	character_title = {
		vertical_alignment = "top",
		parent = "character_portrait",
		horizontal_alignment = "left",
		size = {
			280,
			54
		},
		position = {
			80,
			0,
			1
		}
	},
	character_level = {
		vertical_alignment = "top",
		parent = "character_title",
		horizontal_alignment = "right",
		size = {
			40,
			54
		},
		position = {
			0,
			0,
			1
		}
	},
	character_experience = {
		vertical_alignment = "bottom",
		parent = "character_portrait",
		horizontal_alignment = "left",
		size = character_experience_bar_size,
		position = {
			80,
			-10,
			1
		}
	}
}
local character_name_style = table.clone(UIFontSettings.header_3)
character_name_style.text_horizontal_alignment = "left"
character_name_style.text_vertical_alignment = "bottom"
local character_title_style = table.clone(UIFontSettings.body_small)
character_title_style.text_horizontal_alignment = "left"
character_title_style.text_vertical_alignment = "bottom"
local character_level_style = table.clone(UIFontSettings.body_small)
character_level_style.text_horizontal_alignment = "right"
character_level_style.text_vertical_alignment = "bottom"
local widget_definitions = {
	character_portrait = UIWidget.create_definition({
		{
			value = "content/ui/materials/base/ui_portrait_frame_base",
			style_id = "texture",
			pass_type = "texture",
			style = {
				material_values = {
					texture_frame = "content/ui/textures/icons/items/frames/default",
					use_placeholder_texture = 1
				}
			}
		}
	}, "character_portrait"),
	character_name = UIWidget.create_definition({
		{
			value = "text",
			value_id = "text",
			pass_type = "text",
			style = character_name_style
		}
	}, "character_name"),
	character_title = UIWidget.create_definition({
		{
			value = "text",
			value_id = "text",
			pass_type = "text",
			style = character_title_style
		}
	}, "character_title"),
	character_level = UIWidget.create_definition({
		{
			value = "text",
			value_id = "text",
			pass_type = "text",
			style = character_level_style
		}
	}, "character_level"),
	character_experience = UIWidget.create_definition(BarPassTemplates.character_menu_experience_bar, "character_experience", {
		bar_length = character_experience_bar_size[1]
	}, character_experience_bar_size),
	corner_top_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/character_01_upper"
		}
	}, "corner_top_left"),
	corner_top_right = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/character_01_upper",
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
			value = "content/ui/materials/frames/screen/character_01_lower"
		}
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/character_01_lower",
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
	}, "corner_bottom_right")
}
local legend_inputs = {
	{
		input_action = "back",
		on_pressed_callback = "cb_on_close_pressed",
		display_name = "loc_settings_menu_close_menu",
		alignment = "left_alignment"
	},
	{
		input_action = "hotkey_menu_special_1",
		on_pressed_callback = "cb_on_weapon_swap_pressed",
		display_name = "loc_inventory_menu_swap_weapon",
		alignment = "right_alignment"
	}
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
