-- chunkname: @scripts/ui/views/credits_view/credits_view_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")

require("scripts/foundation/utilities/color")

local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
}
local credits_text_style = {
	font_size = 24,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "center",
	line_spacing = 1.2,
	text_horizontal_alignment = "center",
	vertical_alignment = "bottom",
	text_color = Color.text_default(255, true),
	default_color = Color.text_default(255, true),
	offset = {
		0,
		0,
		15,
	},
	size = {
		1920,
		60,
	},
}
local credits_image_style = {
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	offset = {
		0,
		0,
		15,
	},
	color = {
		255,
		255,
		255,
		255,
	},
}
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			pass_type = "rect",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				color = {
					120,
					0,
					0,
					0,
				},
				offset = {
					0,
					0,
					10,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "texture",
			value = "content/ui/materials/backgrounds/backstory/childhood",
			value_id = "texture",
			style = {
				offset = {
					0,
					0,
					5,
				},
			},
		},
	}, "screen"),
}
local text_widgets_definitions = {
	credits_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "credits_text",
			value = "",
			value_id = "credits_text",
			style = credits_text_style,
		},
	}, "screen"),
	credits_image = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "credits_image",
			value_id = "credits_image",
			style = credits_image_style,
		},
	}, "screen"),
}
local legend_inputs = {
	{
		alignment = "left_alignment",
		display_name = "loc_settings_menu_close_menu",
		input_action = "back",
		on_pressed_callback = "cb_on_close_pressed",
	},
	{
		alignment = "right_alignment",
		display_name = "loc_settings_menu_credits_fast_forward",
		input_action = "next_hold",
		on_pressed_callback = "cb_credits_speed",
		use_mouse_hold = true,
	},
	{
		alignment = "right_alignment",
		display_name = "loc_settings_menu_credits_pause",
		input_action = "credits_pause",
		on_pressed_callback = "cb_credits_pause",
		use_mouse_hold = true,
	},
}
local animations = {
	backgorund_transition = {
		{
			end_time = 0.5,
			name = "fade_out_old_image",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = 255 * (1 - progress)

				widget.style.texture.color[1] = anim_progress
			end,
		},
		{
			end_time = 1,
			name = "fade_in_new_image",
			start_time = 0.5,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				widget.content.texture = params.new_image
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = 255 * progress

				widget.style.texture.color[1] = anim_progress
			end,
		},
	},
}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	text_widgets_definitions = text_widgets_definitions,
	legend_inputs = legend_inputs,
}
