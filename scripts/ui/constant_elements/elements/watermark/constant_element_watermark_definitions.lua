-- chunkname: @scripts/ui/constant_elements/elements/watermark/constant_element_watermark_definitions.lua

local ConstantElementWatermarkSettings = require("scripts/ui/constant_elements/elements/watermark/constant_element_watermark_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local size = ConstantElementWatermarkSettings.size
local width_spacing = 50
local height_spacing = 30
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	watermark_canvas = {
		horizontal_alignment = "center",
		parent = "screen",
		scale = "aspect_ratio",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			1,
		},
	},
	watermark_1 = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = size,
		position = {
			width_spacing,
			height_spacing,
			990,
		},
	},
	watermark_2 = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "top",
		size = size,
		position = {
			0,
			height_spacing,
			990,
		},
	},
	watermark_3 = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = size,
		position = {
			-width_spacing,
			height_spacing,
			990,
		},
	},
	watermark_4 = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "center",
		size = size,
		position = {
			width_spacing,
			0,
			990,
		},
	},
	watermark_5 = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = size,
		position = {
			0,
			0,
			990,
		},
	},
	watermark_6 = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "center",
		size = size,
		position = {
			-width_spacing,
			0,
			990,
		},
	},
	watermark_7 = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "bottom",
		size = size,
		position = {
			width_spacing,
			-height_spacing,
			990,
		},
	},
	watermark_8 = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "bottom",
		size = size,
		position = {
			0,
			-height_spacing,
			990,
		},
	},
	watermark_9 = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "bottom",
		size = size,
		position = {
			-width_spacing,
			-height_spacing,
			990,
		},
	},
	watermark_10 = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = size,
		position = {
			-400,
			-200,
			990,
		},
	},
	watermark_11 = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = size,
		position = {
			-400,
			200,
			990,
		},
	},
	watermark_12 = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = size,
		position = {
			400,
			-200,
			990,
		},
	},
	watermark_13 = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = size,
		position = {
			400,
			200,
			990,
		},
	},
}
local widget_definitions = {
	watermarks = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/ui_watermark_target_sampling",
			style = {
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
	}, "watermark_canvas"),
}
local title_text_style = table.clone(UIFontSettings.header_3)

title_text_style.font_size = 18
title_text_style.offset = {
	0,
	-20,
	0,
}
title_text_style.text_color = {
	50,
	255,
	255,
	255,
}
title_text_style.text_horizontal_alignment = "center"

local description_text_style = table.clone(UIFontSettings.header_3)

description_text_style.font_size = 18
description_text_style.offset = {
	0,
	20,
	0,
}
description_text_style.text_color = {
	50,
	255,
	255,
	255,
}
description_text_style.text_horizontal_alignment = "center"
description_text_style.text_vertical_alignment = "bottom"

return {
	title_text_style = title_text_style,
	description_text_style = description_text_style,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
