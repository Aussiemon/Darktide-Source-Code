local BarPassTemplates = require("scripts/ui/pass_templates/bar_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local character_experience_bar_size = {
	188,
	16
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
			462,
			272
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
			130,
			272
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
			70,
			202
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
			70,
			202
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
			52,
			15,
			64
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
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			400,
			30
		},
		position = {
			200,
			25,
			63
		}
	},
	character_title = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			280,
			54
		},
		position = {
			200,
			63,
			63
		}
	},
	character_level = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			40,
			54
		},
		position = {
			113,
			97,
			63
		}
	},
	character_level_next = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			40,
			54
		},
		position = {
			381,
			97,
			63
		}
	},
	character_experience = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = character_experience_bar_size,
		position = {
			175,
			116,
			63
		}
	}
}
local character_name_style = table.clone(UIFontSettings.header_2)
character_name_style.text_horizontal_alignment = "left"
character_name_style.text_vertical_alignment = "top"
character_name_style.text_color = Color.ui_brown_super_light(255, true)
character_name_style.material = "content/ui/materials/font_gradients/slug_font_gradient_header_highlighted"
local character_title_style = table.clone(UIFontSettings.body_small)
character_title_style.text_horizontal_alignment = "left"
character_title_style.text_vertical_alignment = "top"
local character_level_style = table.clone(UIFontSettings.body_small)
character_level_style.text_horizontal_alignment = "center"
character_level_style.text_vertical_alignment = "center"
character_level_style.text_color = Color.ui_brown_super_light(255, true)
character_level_style.material = "content/ui/materials/font_gradients/slug_font_gradient_header_highlighted"
local character_level_next_style = table.clone(UIFontSettings.body_small)
character_level_next_style.text_horizontal_alignment = "center"
character_level_next_style.text_vertical_alignment = "center"
character_level_next_style.text_color = Color.ui_brown_super_light(255, true)
character_level_next_style.material = "content/ui/materials/font_gradients/slug_font_gradient_header_highlighted"
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
	character_insigna = UIWidget.create_definition({
		{
			value = "content/ui/materials/base/ui_default_base",
			style_id = "texture",
			pass_type = "texture",
			style = {
				material_values = {
					use_placeholder_texture = 1
				}
			}
		}
	}, "character_insigna"),
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
	character_level_next = UIWidget.create_definition({
		{
			value = "text",
			value_id = "text",
			pass_type = "text",
			style = character_level_next_style
		}
	}, "character_level_next"),
	character_experience = UIWidget.create_definition(BarPassTemplates.character_menu_experience_bar, "character_experience", {
		bar_length = character_experience_bar_size[1]
	}, character_experience_bar_size),
	corner_top_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value_id = "texture"
		}
	}, "corner_top_left"),
	corner_top_right = UIWidget.create_definition({
		{
			pass_type = "texture",
			value_id = "texture"
		}
	}, "corner_top_right"),
	corner_bottom_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value_id = "texture"
		}
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidget.create_definition({
		{
			pass_type = "texture",
			value_id = "texture"
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
