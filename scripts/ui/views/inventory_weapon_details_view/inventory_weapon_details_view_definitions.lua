-- chunkname: @scripts/ui/views/inventory_weapon_details_view/inventory_weapon_details_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			0,
		},
	},
	corner_top_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			180,
			310,
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
			180,
			310,
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
			180,
			120,
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
			180,
			120,
		},
		position = {
			0,
			0,
			62,
		},
	},
	weapon_info_pivot = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			100,
			50,
			3,
		},
	},
	weapon_actions_extended_pivot = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			-560,
			50,
			3,
		},
	},
	attack_patterns_pivot = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			-950,
			50,
			3,
		},
	},
	weapon_viewport = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			3,
		},
	},
	weapon_pivot = {
		horizontal_alignment = "center",
		parent = "weapon_viewport",
		vertical_alignment = "center",
		size = {
			0,
			0,
		},
		position = {
			300,
			0,
			1,
		},
	},
}
local widget_definitions = {
	corner_top_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/metal_01_upper",
		},
	}, "corner_top_left"),
	corner_top_right = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/metal_01_upper",
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
	}, "corner_top_right"),
	corner_bottom_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/metal_01_lower",
		},
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/metal_01_lower",
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
	}, "corner_bottom_right"),
	background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/weapon_views_background",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					1,
				},
				size = {
					1920,
					1080,
				},
			},
		},
		{
			pass_type = "rect",
			style = {
				color = Color.black(255, true),
			},
		},
	}, "screen"),
}
local legend_inputs = {
	{
		alignment = "left_alignment",
		display_name = "loc_settings_menu_close_menu",
		input_action = "back",
		on_pressed_callback = "_cb_on_close_pressed",
	},
	{
		alignment = "right_alignment",
		display_name = "loc_menu_show_attack_patterns",
		input_action = "hotkey_menu_special_1",
		on_pressed_callback = "_toggle_view",
		visibility_function = function (parent, id)
			return parent._visibility_toggled_on
		end,
	},
	{
		alignment = "right_alignment",
		display_name = "loc_menu_toggle_ui_visibility_off",
		input_action = "hotkey_menu_special_2",
		on_pressed_callback = "_cb_on_ui_visibility_toggled",
	},
}
local always_visible_widget_names = {
	background = true,
	corner_bottom_left = true,
	corner_bottom_right = true,
	corner_top_left = true,
	corner_top_right = true,
}

return {
	legend_inputs = legend_inputs,
	always_visible_widget_names = always_visible_widget_names,
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
}
