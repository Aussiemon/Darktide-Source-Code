local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local SystemViewSettings = require("scripts/ui/views/system_view/system_view_settings")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local grid_size = SystemViewSettings.grid_size
local grid_width = grid_size[1]
local grid_height = grid_size[2]
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
	background = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			grid_width,
			grid_height
		},
		position = {
			180,
			240,
			1
		}
	},
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
			0
		}
	},
	grid_start = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	grid_content_pivot = {
		vertical_alignment = "top",
		parent = "grid_start",
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
	button = {
		vertical_alignment = "left",
		parent = "grid_content_pivot",
		horizontal_alignment = "top",
		size = {
			400,
			50
		},
		position = {
			0,
			0,
			0
		}
	},
	scrollbar = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "right",
		size = {
			10,
			grid_height
		},
		position = {
			50,
			0,
			1
		}
	},
	title_divider = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			335,
			18
		},
		position = {
			180,
			145,
			1
		}
	},
	title_text = {
		vertical_alignment = "bottom",
		parent = "title_divider",
		horizontal_alignment = "left",
		size = {
			1000,
			50
		},
		position = {
			0,
			-35,
			1
		}
	}
}
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				vertical_alignment = "bottom",
				size = {
					nil,
					60
				},
				offset = {
					0,
					0,
					2
				},
				color = {
					160,
					0,
					0,
					0
				}
			}
		}
	}, "screen"),
	bottom_panel = UIWidget.create_definition({
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
	}, "screen"),
	background_icon = UIWidget.create_definition({
		{
			value = "content/ui/vector_textures/symbols/cog_skull_01",
			pass_type = "slug_icon",
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
		}
	}, "background_icon"),
	scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.default_scrollbar, "scrollbar")
}
local legend_inputs = {
	{
		input_action = "back",
		on_pressed_callback = "cb_on_close_pressed",
		display_name = "loc_settings_menu_close_menu",
		alignment = "left_alignment"
	}
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
