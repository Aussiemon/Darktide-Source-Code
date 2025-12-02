-- chunkname: @scripts/ui/views/social_menu_view/social_menu_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	background_icon = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1920,
			1920,
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
			132,
			234,
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
			132,
			234,
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
			72,
			212,
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
			72,
			212,
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
			pass_type = "slug_icon",
			value = "content/ui/vector_textures/symbols/cog_skull_01",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					1,
				},
				color = {
					40,
					0,
					0,
					0,
				},
				size = {
					1250,
					1250,
				},
			},
		},
		{
			pass_type = "rect",
			style = {
				color = Color.black(255, true),
			},
			offset = {
				0,
				0,
				0,
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				horizontal_alignemt = "center",
				scale_to_material = true,
				vertical_alignemnt = "center",
				size_addition = {
					40,
					40,
				},
				offset = {
					-20,
					-20,
					0,
				},
				color = Color.terminal_grid_background_gradient(204, true),
			},
		},
		{
			pass_type = "texture",
			scenegraph_id = "corner_bottom_left",
			value = "content/ui/materials/frames/screen/social_01_lower",
		},
		{
			pass_type = "texture_uv",
			scenegraph_id = "corner_bottom_right",
			value = "content/ui/materials/frames/screen/social_01_lower",
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
	tabs_params = {
		{
			view = "social_menu_roster_view",
		},
	},
}
local input_legend_params = {
	layer = 10,
	buttons_params = {
		{
			alignment = "left_alignment",
			display_name = "loc_settings_menu_close_menu",
			input_action = "back",
			on_pressed_callback = "cb_on_close_pressed",
			visibility_function = nil,
		},
		{
			alignment = "right_alignment",
			display_name = "loc_social_menu_find_player",
			input_action = "hotkey_menu_special_1",
			on_pressed_callback = "cb_find_player_pressed",
			visibility_function = function (parent)
				return not parent._active_view_instance or not parent._active_view_instance._popup_menu
			end,
		},
	},
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	tab_bar_params = tab_bar_params,
	input_legend_params = input_legend_params,
}
