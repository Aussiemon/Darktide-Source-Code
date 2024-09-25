-- chunkname: @scripts/ui/views/system_view/system_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local SystemViewSettings = require("scripts/ui/views/system_view/system_view_settings")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local grid_size = SystemViewSettings.grid_size
local grid_width = grid_size[1]
local grid_height = grid_size[2]
local grid_x_offset = 100
local background_icon_size = 1250
local legend_height = 50
local scenegraph_definition = {
	screen = {
		scale = "fit",
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
	grid = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			grid_width,
			grid_height,
		},
		position = {
			grid_x_offset - background_icon_size / 2,
			-legend_height / 2,
			1,
		},
	},
	background_icon = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			background_icon_size,
			background_icon_size,
		},
		position = {
			0,
			0,
			1,
		},
	},
	grid_start = {
		horizontal_alignment = "left",
		parent = "grid",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			0,
		},
	},
	grid_content_pivot = {
		horizontal_alignment = "left",
		parent = "grid_start",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			10,
		},
	},
	scrollbar = {
		horizontal_alignment = "right",
		parent = "grid",
		vertical_alignment = "center",
		size = {
			10,
			grid_height,
		},
		position = {
			25,
			0,
			1,
		},
	},
}
local widget_definitions = {
	background = UIWidget.create_definition({
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
				color = Color.terminal_grid_background_gradient(255, true),
			},
		},
	}, "screen"),
	background_icon = UIWidget.create_definition({
		{
			pass_type = "slug_icon",
			value = "content/ui/vector_textures/symbols/cog_skull_01",
			style = {
				offset = {
					0,
					0,
					2,
				},
				color = {
					40,
					0,
					0,
					0,
				},
			},
		},
	}, "background_icon"),
	scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.default_scrollbar, "scrollbar"),
}
local legend_inputs = {
	{
		alignment = "left_alignment",
		display_name = "loc_settings_menu_close_menu",
		input_action = "back",
		on_pressed_callback = "cb_on_close_pressed",
		extra_input_actions = {
			gamepad = {
				"hotkey_system",
			},
			keyboard = {},
		},
	},
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
