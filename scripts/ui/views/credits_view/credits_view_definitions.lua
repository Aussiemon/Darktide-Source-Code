local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")

require("scripts/foundation/utilities/color")

local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen
}
local credits_text_style = {
	text_horizontal_alignment = "center",
	font_size = 24,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	line_spacing = 1.2,
	font_type = "proxima_nova_bold",
	text_color = Color.text_default(255, true),
	default_color = Color.text_default(255, true),
	offset = {
		0,
		0,
		15
	},
	size = {
		1920,
		60
	}
}
local credits_image_style = {
	vertical_alignment = "bottom",
	horizontal_alignment = "center",
	offset = {
		0,
		0,
		15
	},
	color = {
		255,
		255,
		255,
		255
	}
}
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/default_square",
			pass_type = "rect",
			style = {
				color = {
					120,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					10
				}
			}
		},
		{
			value_id = "texture",
			style_id = "texture",
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/backstory/childhood",
			style = {
				offset = {
					0,
					0,
					5
				}
			}
		}
	}, "screen")
}
local text_widgets_definitions = {
	credits_text = UIWidget.create_definition({
		{
			value_id = "credits_text",
			style_id = "credits_text",
			pass_type = "text",
			value = "",
			style = credits_text_style
		}
	}, "screen"),
	credits_image = UIWidget.create_definition({
		{
			style_id = "credits_image",
			value_id = "credits_image",
			pass_type = "texture",
			style = credits_image_style
		}
	}, "screen")
}
local legend_inputs = {
	{
		input_action = "back",
		on_pressed_callback = "cb_on_close_pressed",
		display_name = "loc_settings_menu_close_menu",
		alignment = "left_alignment"
	},
	{
		on_pressed_callback = "cb_credits_speed",
		input_action = "next_hold",
		display_name = "loc_settings_menu_credits_fast_forward",
		alignment = "right_alignment",
		use_mouse_hold = true
	},
	{
		on_pressed_callback = "cb_credits_pause",
		input_action = "credits_pause",
		display_name = "loc_settings_menu_credits_pause",
		alignment = "right_alignment",
		use_mouse_hold = true
	}
}
local animations = {
	backgorund_transition = {
		{
			name = "fade_out_old_image",
			end_time = 0.5,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = 255 * (1 - progress)
				widget.style.texture.color[1] = anim_progress
			end
		},
		{
			name = "fade_in_new_image",
			end_time = 1,
			start_time = 0.5,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				widget.content.texture = params.new_image
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = 255 * progress
				widget.style.texture.color[1] = anim_progress
			end
		}
	}
}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	text_widgets_definitions = text_widgets_definitions,
	legend_inputs = legend_inputs
}
