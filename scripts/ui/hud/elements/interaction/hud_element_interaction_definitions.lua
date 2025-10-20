-- chunkname: @scripts/ui/hud/elements/interaction/hud_element_interaction_definitions.lua

local HudElementInteractionSettings = require("scripts/ui/hud/elements/interaction/hud_element_interaction_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local get_hud_color = UIHudSettings.get_hud_color
local edge_spacing = HudElementInteractionSettings.edge_spacing
local input_box_height = HudElementInteractionSettings.input_box_height
local background_size = HudElementInteractionSettings.background_size
local background_size_small = HudElementInteractionSettings.background_size_small
local description_box_size = {
	background_size[1] - edge_spacing[1] * 2,
	background_size[2] - input_box_height - edge_spacing[2] * 2,
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	pivot = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			100,
		},
	},
	background = {
		horizontal_alignment = "left",
		parent = "pivot",
		vertical_alignment = "bottom",
		size = background_size,
		position = {
			0,
			0,
			1,
		},
	},
	description_box = {
		horizontal_alignment = "center",
		parent = "background",
		vertical_alignment = "bottom",
		size = description_box_size,
		position = {
			0,
			0,
			1,
		},
	},
}
local input_interact_text_style = table.clone(UIFontSettings.hud_body)

input_interact_text_style.horizontal_alignment = "left"
input_interact_text_style.vertical_alignment = "top"
input_interact_text_style.text_horizontal_alignment = "left"
input_interact_text_style.text_vertical_alignment = "center"
input_interact_text_style.text_color = get_hud_color("color_tint_main_1", 255)
input_interact_text_style.offset = {
	edge_spacing[1],
	0,
	6,
}
input_interact_text_style.size = {
	background_size[1] - edge_spacing[1] * 2,
	input_box_height,
}

local secondary_input_interact_text_style = table.clone(input_interact_text_style)

secondary_input_interact_text_style.horizontal_alignment = "right"
secondary_input_interact_text_style.vertical_alignment = "top"
secondary_input_interact_text_style.text_horizontal_alignment = "right"
secondary_input_interact_text_style.text_vertical_alignment = "center"
secondary_input_interact_text_style.offset = {
	-edge_spacing[1],
	0,
	6,
}

local input_tag_text_style = table.clone(UIFontSettings.hud_body)

input_tag_text_style.horizontal_alignment = "center"
input_tag_text_style.vertical_alignment = "top"
input_tag_text_style.text_horizontal_alignment = "right"
input_tag_text_style.text_vertical_alignment = "center"
input_tag_text_style.text_color = get_hud_color("color_tint_main_1", 255)
input_tag_text_style.offset = {
	0,
	0,
	6,
}
input_tag_text_style.size = {
	background_size[1] - edge_spacing[1] * 2,
	input_box_height,
}

local description_text_style = table.clone(UIFontSettings.hud_body)

description_text_style.horizontal_alignment = "left"
description_text_style.vertical_alignment = "bottom"
description_text_style.text_horizontal_alignment = "left"
description_text_style.text_vertical_alignment = "center"
description_text_style.font_size = 26
description_text_style.offset = {
	0,
	0,
	6,
}

local type_description_text_style = table.clone(description_text_style)

type_description_text_style.text_color = {
	255,
	226,
	199,
	126,
}
type_description_text_style.offset = {
	0,
	14,
	6,
}
type_description_text_style.font_size = 20

local event_text_style = table.clone(UIFontSettings.hud_body)

event_text_style.horizontal_alignment = "left"
event_text_style.vertical_alignment = "bottom"
event_text_style.text_horizontal_alignment = "center"
event_text_style.text_vertical_alignment = "center"
event_text_style.font_size = 20
event_text_style.offset = {
	0,
	35,
	7,
}
event_text_style.size = {
	background_size[1],
	30,
}
event_text_style.text_color = {
	255,
	70,
	38,
	0,
}
event_text_style.drop_shadow = false

local widget_definitions = {
	interact_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "<text>",
			value_id = "text",
			style = input_interact_text_style,
		},
	}, "background"),
	tag_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "<text>",
			value_id = "text",
			style = input_tag_text_style,
		},
	}, "background"),
	description_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "<text>",
			value_id = "text",
			style = description_text_style,
		},
	}, "description_box"),
	type_description_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "FORGE MATERIALS",
			value_id = "text",
			style = type_description_text_style,
		},
	}, "description_box"),
	background = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/hud/backgrounds/interaction_background",
			style = {
				horizontal_alignment = "left",
				scale_to_material = true,
				vertical_alignment = "bottom",
				offset = {
					0,
					0,
					0,
				},
				size_addition = {
					0,
					-1,
				},
				color = get_hud_color("color_tint_main_4", 230),
			},
			visibility_function = function (content)
				return not content.use_minimal_presentation
			end,
		},
		{
			pass_type = "rect",
			style_id = "input_background",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				offset = {
					0,
					0,
					1,
				},
				size = {
					[2] = input_box_height,
				},
				color = {
					180,
					121,
					136,
					109,
				},
			},
			visibility_function = function (content)
				return not content.use_minimal_presentation
			end,
		},
		{
			pass_type = "texture_uv",
			style_id = "input_background_slim",
			value = "content/ui/materials/gradients/gradient_horizontal",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				offset = {
					0,
					0,
					2,
				},
				size = {
					[2] = input_box_height,
				},
				color = Color.terminal_background(200, true),
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
			visibility_function = function (content)
				return content.use_minimal_presentation
			end,
		},
		{
			pass_type = "rect",
			style_id = "input_progress_background",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				offset = {
					0,
					0,
					5,
				},
				size = {
					0,
					10,
				},
				color = {
					255,
					226,
					199,
					126,
				},
			},
		},
		{
			pass_type = "rect",
			style_id = "input_progress_background_large",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				offset = {
					0,
					0,
					4,
				},
				size = {
					0,
				},
				size_addition = {
					0,
					-input_box_height,
				},
				color = {
					60,
					226,
					199,
					126,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "input_progress_frame",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "right",
				scale_to_material = true,
				vertical_alignment = "bottom",
				offset = {
					10,
					10,
					4,
				},
				default_offset = {
					10,
					0,
					4,
				},
				size = {
					0,
					10,
				},
				color = {
					255,
					226,
					199,
					126,
				},
				size_addition = {
					20,
					20,
				},
			},
		},
	}, "background"),
	frame = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = {
					255,
					0,
					0,
					0,
				},
				size_addition = {
					20,
					20,
				},
				offset = {
					0,
					0,
					3,
				},
			},
			visibility_function = function (content)
				return not content.use_minimal_presentation
			end,
		},
		{
			pass_type = "texture_uv",
			style_id = "frame",
			value = "content/ui/materials/frames/dropshadow_medium_gradient_fade_01",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = {
					255,
					0,
					0,
					0,
				},
				size_addition = {
					20,
					20,
				},
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
				offset = {
					0,
					0,
					3,
				},
			},
			visibility_function = function (content)
				return content.use_minimal_presentation
			end,
		},
	}, "background"),
	progress_highlight = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = {
					0,
					226,
					199,
					126,
				},
				size_addition = {
					20,
					20,
				},
				offset = {
					0,
					0,
					4,
				},
			},
		},
	}, "background"),
	event_background = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			value = Utf8.upper(Localize("loc_interaction_start_event_text")),
			style = event_text_style,
		},
		{
			pass_type = "rect",
			style_id = "background",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				offset = {
					0,
					35,
					0,
				},
				size = {
					background_size[1],
					30,
				},
				color = {
					230,
					255,
					151,
					29,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "input_progress_frame",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "bottom",
				offset = {
					0,
					45,
					0,
				},
				size = {
					background_size[1],
					30,
				},
				color = {
					255,
					0,
					0,
					0,
				},
				size_addition = {
					20,
					20,
				},
			},
		},
	}, "background"),
	secondary_interact_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "<text>",
			value_id = "text",
			style = secondary_input_interact_text_style,
		},
	}, "background"),
}
local animations = {}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
