-- chunkname: @scripts/ui/views/vendor_interaction_view_base/vendor_interaction_view_base_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
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
	corner_top_left = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			128,
			282
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
			300,
			282
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
			242
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
			242
		},
		position = {
			0,
			0,
			62
		}
	},
	wallet_pivot = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-20,
			50,
			31
		}
	},
	info_box = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			700,
			400
		},
		position = {
			180,
			500,
			1
		}
	},
	title_text = {
		vertical_alignment = "top",
		parent = "description_text",
		horizontal_alignment = "left",
		size = {
			700,
			50
		},
		position = {
			0,
			-70,
			1
		}
	},
	description_text = {
		vertical_alignment = "top",
		parent = "info_box",
		horizontal_alignment = "left",
		size = {
			700,
			50
		},
		position = {
			0,
			0,
			1
		}
	},
	button_divider = {
		vertical_alignment = "bottom",
		parent = "description_text",
		horizontal_alignment = "left",
		size = {
			700,
			18
		},
		position = {
			0,
			10,
			1
		}
	},
	button_pivot = {
		vertical_alignment = "top",
		parent = "button_divider",
		horizontal_alignment = "left",
		size = {
			700,
			50
		},
		position = {
			0,
			50,
			1
		}
	}
}
local wallet_text_font_style = table.clone(UIFontSettings.currency_title)

wallet_text_font_style.text_horizontal_alignment = "right"
wallet_text_font_style.text_vertical_alignment = "center"
wallet_text_font_style.original_offset = {
	0,
	0,
	1
}

local title_text_font_style = table.clone(UIFontSettings.header_1)

title_text_font_style.offset = {
	0,
	0,
	3
}
title_text_font_style.text_horizontal_alignment = "left"
title_text_font_style.text_vertical_alignment = "top"
title_text_font_style.size = {
	700,
	50
}

local description_text_font_style = table.clone(UIFontSettings.body)

description_text_font_style.offset = {
	0,
	0,
	3
}
description_text_font_style.text_horizontal_alignment = "left"
description_text_font_style.text_vertical_alignment = "top"
description_text_font_style.size = {
	700,
	50
}

local widget_definitions = {
	canvas_overlay = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = {
					100,
					0,
					0,
					0
				}
			}
		}
	}, "screen"),
	corner_bottom_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/character_01_lower"
		}
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/character_01_lower",
			pass_type = "texture_uv",
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
	}, "corner_bottom_right"),
	title_text = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = title_text_font_style
		}
	}, "title_text"),
	description_text = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = description_text_font_style
		}
	}, "description_text"),
	button_divider = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_rendered_left_01"
		}
	}, "button_divider")
}
local wallet_definitions = UIWidget.create_definition({
	{
		value_id = "texture",
		style_id = "texture",
		pass_type = "texture",
		value = "content/ui/materials/icons/currencies/marks_small",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			size = {
				42,
				30
			},
			offset = {
				0,
				0,
				1
			},
			original_offset = {
				0,
				0,
				1
			}
		}
	},
	{
		value_id = "text",
		style_id = "text",
		pass_type = "text",
		value = "0",
		style = wallet_text_font_style
	}
}, "wallet_pivot")
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
local anim_start_delay = 0
local animations = {
	on_enter = {
		{
			name = "init",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				widgets.canvas_overlay.alpha_multiplier = 0
				parent._alpha_multiplier = 0
			end
		},
		{
			name = "fade_in",
			start_time = anim_start_delay + 0.5,
			end_time = anim_start_delay + 1,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				parent._alpha_multiplier = anim_progress
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end
		}
	},
	on_option_enter = {
		{
			name = "fade_in",
			end_time = 0.3,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent:_blur_fade_out(0.3, math.easeCubic)
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local alpha_multiplier = 1 - anim_progress

				for i = 1, #widgets do
					widgets[i].alpha_multiplier = alpha_multiplier
				end

				local canvas_overlay = parent._widgets_by_name.canvas_overlay

				canvas_overlay.alpha_multiplier = math.min(1 - alpha_multiplier, canvas_overlay.alpha_multiplier or 0)
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end
		}
	},
	on_option_exit = {
		{
			name = "fade_in",
			end_time = 0.3,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent:_blur_fade_out(0.3, math.easeCubic)
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeInCubic(progress)
				local alpha_multiplier = anim_progress

				for i = 1, #widgets do
					widgets[i].alpha_multiplier = alpha_multiplier
				end

				local canvas_overlay = parent._widgets_by_name.canvas_overlay

				canvas_overlay.alpha_multiplier = math.min(1 - alpha_multiplier, canvas_overlay.alpha_multiplier or 0)
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end
		}
	},
	on_option_enter_blurred = {
		{
			name = "fade_in",
			end_time = 0.3,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent:_blur_fade_in(0.3, math.easeCubic)
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local alpha_multiplier = 1 - anim_progress

				for i = 1, #widgets do
					widgets[i].alpha_multiplier = alpha_multiplier
				end

				parent._widgets_by_name.canvas_overlay.alpha_multiplier = 1 - alpha_multiplier
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end
		}
	},
	on_option_exit_blurred = {
		{
			name = "fade_in",
			end_time = 0.3,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent:_blur_fade_out(0.3, math.easeCubic)
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeInCubic(progress)
				local alpha_multiplier = anim_progress

				for i = 1, #widgets do
					widgets[i].alpha_multiplier = alpha_multiplier
				end

				parent._widgets_by_name.canvas_overlay.alpha_multiplier = 1 - alpha_multiplier
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end
		}
	}
}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	input_legend_params = input_legend_params,
	wallet_definitions = wallet_definitions
}
