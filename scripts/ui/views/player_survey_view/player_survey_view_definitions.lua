-- chunkname: @scripts/ui/views/player_survey_view/player_survey_view_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local _offwhite_green = {
	255,
	241,
	255,
	230,
}
local _light_green = {
	255,
	166,
	192,
	147,
}
local question_title_text_style = table.clone(UIFontSettings.header_2)

question_title_text_style.text_horizontal_alignment = "center"
question_title_text_style.text_vertical_alignment = "top"
question_title_text_style.font_size = 40

local question_subtitle_text_style = table.clone(UIFontSettings.header_3)

question_subtitle_text_style.text_horizontal_alignment = "center"
question_subtitle_text_style.text_vertical_alignment = "top"
question_subtitle_text_style.text_color = _light_green
question_subtitle_text_style.font_size = 24

local question_info_text_style = table.clone(UIFontSettings.header_4)

question_info_text_style.text_horizontal_alignment = "center"
question_info_text_style.text_vertical_alignment = "top"
question_info_text_style.text_color = Color.white(255, true)
question_info_text_style.font_size = 32
question_info_text_style.offset = {
	0,
	0,
	0,
}

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
			1,
		},
	},
	corner_top_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			84,
			224,
		},
		position = {
			0,
			0,
			4,
		},
	},
	corner_top_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			120,
			224,
		},
		position = {
			0,
			0,
			4,
		},
	},
	corner_bottom_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			84,
			224,
		},
		position = {
			0,
			0,
			4,
		},
	},
	corner_bottom_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			84,
			224,
		},
		position = {
			0,
			0,
			4,
		},
	},
}

scenegraph_definition.content_pivot = {
	horizontal_alignment = "center",
	parent = "canvas",
	vertical_alignment = "center",
	offset = {
		0,
		0,
		0,
	},
	size = {
		scenegraph_definition.canvas.size[1] * 0.75,
		0,
	},
}
scenegraph_definition.question_title_text = {
	horizontal_alignment = "center",
	parent = "content_pivot",
	vertical_alignment = "top",
	offset = {
		0,
		-100,
		0,
	},
}
scenegraph_definition.question_subtitle_text = {
	horizontal_alignment = "center",
	parent = "question_title_text",
	vertical_alignment = "top",
	offset = {
		0,
		50,
		0,
	},
}
scenegraph_definition.question_info_text = {
	horizontal_alignment = "center",
	parent = "question_subtitle_text",
	vertical_alignment = "top",
	offset = {
		0,
		30,
		0,
	},
}
scenegraph_definition.submit_button = {
	horizontal_alignment = "center",
	parent = "content_pivot",
	vertical_alignment = "bottom",
	size = ButtonPassTemplates.default_button.size,
	offset = {
		0,
		90,
		1,
	},
}
scenegraph_definition.progress_indicator_container = {
	horizontal_alignment = "center",
	parent = "submit_button",
	vertical_alignment = "bottom",
	size = {
		0,
		0,
	},
	offset = {
		0,
		16,
		1,
	},
}

local widget_definitions = {
	background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = Color.black(153, true),
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				color = Color.terminal_corner(229.5, true),
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				scale_to_material = true,
				color = Color.terminal_frame(255, true),
			},
		},
	}, "screen"),
	question_title_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "<<THIS IS A QUESTION!>>",
			value_id = "text",
			style = question_title_text_style,
		},
	}, "question_title_text"),
	question_subtitle_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "<<THIS IS A SUBTITLE!>>",
			value_id = "text",
			style = question_subtitle_text_style,
		},
	}, "question_subtitle_text"),
	question_info_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "<<EXTRA INFO GOES HERE!>>",
			value_id = "text",
			style = question_info_text_style,
		},
	}, "question_info_text"),
	submit_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "submit_button", {
		gamepad_action = "secondary_action_pressed",
		original_text = Utf8.upper(Localize("loc_character_creator_continue")),
		hotspot = {
			on_pressed_sound = UISoundEvents.default_click,
		},
	}),
}
local legend_inputs = {
	{
		alignment = "left_alignment",
		display_name = "loc_settings_menu_close_menu",
		input_action = "back",
		on_pressed_callback = "_cb_on_back_pressed",
	},
}
local animations = {}

function _progress_widget_definition_factory(widget_size)
	return UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.gray(nil, true),
				size = widget_size,
				offset = {
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "rect",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.white(255, true),
				size = widget_size,
				offset = {
					0,
					0,
					1,
				},
			},
			visibility_function = function (content, style)
				return content.active
			end,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/frame_glow_01",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.white(32, true),
				size = widget_size,
				offset = {
					0,
					0,
					1,
				},
				size_addition = {
					24,
					24,
				},
			},
			visibility_function = function (content, style)
				return content.active
			end,
		},
	}, "progress_indicator_container")
end

return {
	animations = animations,
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	colors = {
		offwhite_green = _offwhite_green,
		light_green = _light_green,
	},
	progress_widget_definition_factory = _progress_widget_definition_factory,
	progress_widget_full_size = {
		scenegraph_definition.submit_button.size[1],
		8,
	},
}
