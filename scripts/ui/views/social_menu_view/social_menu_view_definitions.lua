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
			value = "content/ui/materials/frames/screen/social_01_upper",
			scenegraph_id = "corner_top_left",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/frames/screen/social_01_upper",
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
			input_action = "hotkey_menu_special_2",
			on_pressed_callback = "cb_find_player_pressed",
			display_name = "loc_social_menu_find_player",
			alignment = "right_alignment"
		}
	}
}
local background_world_params = {
	shading_environment = "content/shading_environments/ui/inventory",
	world_layer = 1,
	total_blur_duration = 0.5,
	timer_name = "ui",
	viewport_type = "default",
	register_camera_event = "event_register_inventory_default_camera_human",
	viewport_name = "ui_social_menu_view_world_viewport",
	viewport_layer = 1,
	level_name = "content/levels/ui/inventory/inventory",
	world_name = "ui_social_menu_view_world"
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	tab_bar_params = tab_bar_params,
	input_legend_params = input_legend_params,
	background_world_params = background_world_params
}
