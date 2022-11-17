local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local get_hud_color = UIHudSettings.get_hud_color
local background_size = {
	800,
	120
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	background = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = background_size,
		position = {
			-50,
			-50,
			1
		}
	},
	popup = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "right",
		size = background_size,
		position = {
			0,
			0,
			1
		}
	}
}
local text_style = table.clone(UIFontSettings.header_3)
text_style.horizontal_alignment = "center"
text_style.vertical_alignment = "center"
text_style.text_horizontal_alignment = "center"
text_style.text_vertical_alignment = "center"
text_style.offset = {
	0,
	0,
	2
}
text_style.text_color = get_hud_color("color_tint_main_1", 255)
local input_text_style = {
	font_size = 20,
	text_vertical_alignment = "bottom",
	horizontal_alignment = "center",
	text_horizontal_alignment = "center",
	vertical_alignment = "bottom",
	drop_shadow = true,
	line_spacing = 1.2,
	font_type = "proxima_nova_bold",
	text_color = Color.ui_hud_green_super_light(255, true)
}
local widget_definitions = {
	popup = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "<text>",
			style = text_style
		},
		{
			style_id = "timer_bg",
			pass_type = "rect",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				offset = {
					-15,
					-5,
					1
				},
				size = {
					background_size[1] - 10,
					10
				},
				size_addition = {
					40,
					0
				},
				color = Color.ui_hud_green_dark(180, true)
			},
			visibility_function = function (content, style)
				return content.duration ~= nil
			end
		},
		{
			style_id = "timer_fill",
			pass_type = "rect",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				offset = {
					-15,
					-5,
					2
				},
				size = {
					background_size[1] - 10,
					10
				},
				color = get_hud_color("color_tint_main_2", 180)
			},
			visibility_function = function (content, style)
				return content.duration ~= nil
			end,
			change_function = function (content, style)
				local progress = content.progress or 0
				style.size[1] = (background_size[1] + 40) * progress
			end
		},
		{
			value_id = "background",
			style_id = "background",
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size = {
					background_size[1],
					10
				},
				size_addition = {
					60,
					20
				},
				color = Color.terminal_grid_background(255, true),
				offset = {
					0,
					0,
					0
				}
			}
		}
	}, "popup")
}
local animations = {
	popup_enter = {
		{
			name = "reset",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				widget.alpha_multiplier = 0
				local style = widget.style
				local alpha = 0
				style.text.text_color[1] = alpha
				style.timer_bg.color[1] = alpha
				style.timer_fill.color[1] = alpha
			end
		},
		{
			name = "fade_in",
			end_time = 0.8,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeOutCubic(progress)
				widget.alpha_multiplier = anim_progress
			end
		},
		{
			name = "size_increase",
			end_time = 0.8,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.ease_exp(progress)
				widget.alpha_multiplier = anim_progress
				local scenegraph_id = widget.scenegraph_id
				local default_scenegraph = scenegraph_definition[scenegraph_id]
				local resize_size = widget.content.resize_size
				local default_size = resize_size and resize_size or default_scenegraph.size
				local width = default_size[1] * 0.1 + default_size[1] * 0.9 * anim_progress
				local height = default_size[2] * 0.1 + default_size[2] * 0.9 * anim_progress
				local style = widget.style
				local background_style_size = style.background.size
				background_style_size[1] = width
				background_style_size[2] = height
			end
		},
		{
			name = "text_fade_in",
			end_time = 0.8,
			start_time = 0.3,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeOutCubic(progress)
				local style = widget.style
				local alpha = anim_progress * 255
				style.text.text_color[1] = alpha
				style.timer_bg.color[1] = alpha
				style.timer_fill.color[1] = alpha
			end
		},
		{
			name = "delay",
			end_time = 1.3,
			start_time = 0.8,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				return
			end
		}
	},
	popup_exit = {
		{
			name = "size_decrease",
			end_time = 0.8,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.ease_exp(1 - progress)
				widget.alpha_multiplier = anim_progress
				local scenegraph_id = widget.scenegraph_id
				local default_scenegraph = scenegraph_definition[scenegraph_id]
				local resize_size = widget.content.resize_size
				local default_size = resize_size and resize_size or default_scenegraph.size
				local width = default_size[1] * 0.1 + default_size[1] * 0.9 * anim_progress
				local height = default_size[2] * 0.1 + default_size[2] * 0.9 * anim_progress
				local style = widget.style
				local background_style_size = style.background.size
				background_style_size[1] = width
				background_style_size[2] = height
			end
		},
		{
			name = "bar_fade_out",
			end_time = 0.3,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeInCubic(1 - progress)
				local style = widget.style
				local alpha = anim_progress * 255
				style.timer_bg.color[1] = alpha
				style.timer_fill.color[1] = alpha
			end
		},
		{
			name = "text_fade_out",
			end_time = 0.5,
			start_time = 0.3,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeInCubic(1 - progress)
				local style = widget.style
				local alpha = anim_progress * 255
				style.text.text_color[1] = alpha
			end
		},
		{
			name = "fade_out",
			end_time = 0.5,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeOutCubic(1 - progress)
				widget.alpha_multiplier = anim_progress
			end
		},
		{
			name = "delay",
			end_time = 1.5,
			start_time = 0.5,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				return
			end
		}
	}
}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
