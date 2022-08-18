local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	background_icon = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1250,
			1250
		},
		position = {
			0,
			0,
			1
		}
	},
	corner_top_left = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			112,
			230
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
			112,
			230
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
			184
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
			184
		},
		position = {
			0,
			0,
			62
		}
	}
}
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			style_id = "background",
			pass_type = "rect",
			style = {
				color = {
					255,
					32,
					32,
					32
				}
			}
		},
		{
			scenegraph_id = "background_icon",
			pass_type = "slug_icon",
			value = "content/ui/vector_textures/symbols/cog_skull_01",
			offset = {
				0,
				0,
				1
			},
			style = {
				color = {
					80,
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/frames/screen/achievements_01_upper",
			scenegraph_id = "corner_top_left",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/frames/screen/achievements_01_upper",
			pass_type = "texture_uv",
			scenegraph_id = "corner_top_right",
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
		},
		{
			value = "content/ui/materials/frames/screen/achievements_01_lower",
			scenegraph_id = "corner_bottom_left",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/frames/screen/achievements_01_lower",
			pass_type = "texture_uv",
			scenegraph_id = "corner_bottom_right",
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
	}, "screen")
}
local tab_bar_params = {
	layer = 10,
	tabs_params = {
		{
			view = "account_profile_overview_view"
		},
		{
			view = "achievements_view"
		}
	}
}
local input_legend_params = {
	layer = 10,
	buttons_params = {
		{
			input_action = "back",
			on_pressed_callback = "cb_on_close_pressed",
			display_name = "loc_settings_menu_close_menu",
			alignment = "left_alignment"
		}
	}
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	tab_bar_params = tab_bar_params,
	input_legend_params = input_legend_params
}
