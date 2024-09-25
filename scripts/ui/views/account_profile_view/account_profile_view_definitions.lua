-- chunkname: @scripts/ui/views/account_profile_view/account_profile_view_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	background_icon = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1250,
			1250,
		},
		position = {
			0,
			0,
			1,
		},
	},
	corner_top_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			112,
			230,
		},
		position = {
			0,
			0,
			62,
		},
	},
	corner_top_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			112,
			230,
		},
		position = {
			0,
			0,
			62,
		},
	},
	corner_bottom_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			128,
			184,
		},
		position = {
			0,
			0,
			62,
		},
	},
	corner_bottom_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			128,
			184,
		},
		position = {
			0,
			0,
			62,
		},
	},
}
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			pass_type = "texture",
			scenegraph_id = "corner_bottom_left",
			value = "content/ui/materials/frames/screen/achievements_01_lower",
		},
		{
			pass_type = "texture_uv",
			scenegraph_id = "corner_bottom_right",
			value = "content/ui/materials/frames/screen/achievements_01_lower",
			style = {
				uvs = {
					{
						1,
						0,
					},
					{
						0,
						1,
					},
				},
			},
		},
	}, "screen"),
}
local tab_bar_params = {
	hide_tabs = true,
	layer = 10,
	tabs_params = {},
}
local input_legend_params = {
	layer = 10,
	buttons_params = {
		{
			alignment = "left_alignment",
			display_name = "loc_settings_menu_close_menu",
			input_action = "back",
			on_pressed_callback = "cb_on_close_pressed",
		},
	},
}
local background_world_params = {
	level_name = "content/levels/ui/inventory/inventory",
	register_camera_event = "event_register_inventory_default_camera_human",
	shading_environment = "content/shading_environments/ui/inventory",
	timer_name = "ui",
	total_blur_duration = 0.5,
	viewport_layer = 1,
	viewport_name = "ui_account_profile_view_world_viewport",
	viewport_type = "default",
	world_layer = 1,
	world_name = "ui_account_profile_view_world",
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	tab_bar_params = tab_bar_params,
	input_legend_params = input_legend_params,
	background_world_params = background_world_params,
}
