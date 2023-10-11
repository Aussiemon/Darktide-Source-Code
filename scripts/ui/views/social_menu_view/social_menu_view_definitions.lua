local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	background_icon = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1920
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
			132,
			234
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
			132,
			234
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
			72,
			212
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
			72,
			212
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
			value = "content/ui/vector_textures/symbols/cog_skull_01",
			pass_type = "slug_icon",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					1
				},
				color = {
					40,
					0,
					0,
					0
				},
				size = {
					1250,
					1250
				}
			}
		},
		{
			pass_type = "rect",
			style = {
				color = Color.black(255, true)
			},
			offset = {
				0,
				0,
				0
			}
		},
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			pass_type = "texture",
			style = {
				horizontal_alignemt = "center",
				scale_to_material = true,
				vertical_alignemnt = "center",
				size_addition = {
					40,
					40
				},
				offset = {
					-20,
					-20,
					0
				},
				color = Color.terminal_grid_background_gradient(204, true)
			}
		},
		{
			value = "content/ui/materials/frames/screen/social_01_lower",
			scenegraph_id = "corner_bottom_left",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/frames/screen/social_01_lower",
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
	hide_tabs = true,
	layer = 10,
	tabs_params = {
		{
			view = "social_menu_roster_view"
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
		},
		{
			input_action = "hotkey_menu_special_1",
			display_name = "loc_social_menu_find_player",
			alignment = "right_alignment",
			on_pressed_callback = "cb_find_player_pressed",
			visibility_function = function (parent)
				return not parent._active_view_instance or not parent._active_view_instance._popup_menu
			end
		}
	}
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	tab_bar_params = tab_bar_params,
	input_legend_params = input_legend_params
}
