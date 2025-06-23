-- chunkname: @scripts/ui/views/debug_view/debug_view_definitions.lua

local DefaultPassTemplates = require("scripts/ui/pass_templates/default_pass_templates")
local UIWidget = require("scripts/managers/ui/ui_widget")
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
	background_left = {
		scale = "fit_height",
		horizontal_alignment = "left",
		size = {
			960,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	background_right = {
		scale = "fit_height",
		horizontal_alignment = "right",
		size = {
			960,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	texture_center = {
		vertical_alignment = "center",
		parent = "background_left",
		horizontal_alignment = "right",
		size = {
			400,
			400
		},
		position = {
			200,
			0,
			2
		}
	},
	texture_left = {
		vertical_alignment = "center",
		parent = "background_left",
		horizontal_alignment = "left",
		size = {
			400,
			400
		},
		position = {
			100,
			0,
			2
		}
	},
	texture_right = {
		vertical_alignment = "center",
		parent = "background_right",
		horizontal_alignment = "right",
		size = {
			400,
			400
		},
		position = {
			-100,
			0,
			2
		}
	}
}
local widget_definitions = {
	background_left = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = {
					255,
					0,
					0,
					0
				}
			}
		}
	}, "background_left"),
	background_right = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = {
					255,
					255,
					255,
					255
				}
			}
		}
	}, "background_right")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
