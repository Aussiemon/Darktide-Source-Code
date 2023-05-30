local BarPassTemplates = require("scripts/ui/pass_templates/bar_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ViewElementPlayerPanelSettings = require("scripts/ui/view_elements/view_element_player_panel/view_element_player_panel_settings")
local character_experience_bar_size = {
	280,
	10
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	pivot = {
		vertical_alignment = "top",
		parent = "screen",
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
	character_panel = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "left",
		size = {
			420,
			100
		},
		position = {
			0,
			0,
			0
		}
	},
	character_insigna = {
		vertical_alignment = "top",
		parent = "character_panel",
		horizontal_alignment = "left",
		size = {
			30,
			80
		},
		position = {
			10,
			10,
			1
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
	character_panel = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = {
					160,
					0,
					0,
					0
				}
			}
		}
	}, "character_panel"),
	character_portrait = UIWidget.create_definition({
		{
			style_id = "texture",
			value_id = "texture",
			pass_type = "texture",
			value = "content/ui/materials/base/ui_portrait_frame_base",
			style = {
				material_values = {
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
				material_values = {}
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
	character_experience = UIWidget.create_definition(BarPassTemplates.character_menu_experience_bar, "character_experience", {
		bar_length = character_experience_bar_size[1]
	}, character_experience_bar_size)
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
