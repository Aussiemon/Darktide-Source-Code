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
	background_size[2] - input_box_height - edge_spacing[2] * 2
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	pivot = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			100
		}
	},
	background = {
		vertical_alignment = "bottom",
		parent = "pivot",
		horizontal_alignment = "left",
		size = background_size,
		position = {
			0,
			0,
			1
		}
	},
	description_box = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "center",
		size = description_box_size,
		position = {
			0,
			-edge_spacing[2],
			1
		}
	}
}
local input_interact_text_style = table.clone(UIFontSettings.hud_body)
input_interact_text_style.horizontal_alignment = "center"
input_interact_text_style.vertical_alignment = "top"
input_interact_text_style.text_horizontal_alignment = "left"
input_interact_text_style.text_vertical_alignment = "top"
input_interact_text_style.text_color = get_hud_color("color_tint_main_1", 255)
input_interact_text_style.offset = {
	0,
	input_box_height * 0.25 - 2,
	6
}
input_interact_text_style.size = {
	background_size[1] - edge_spacing[1] * 2,
	input_box_height
}
local input_tag_text_style = table.clone(UIFontSettings.hud_body)
input_tag_text_style.horizontal_alignment = "center"
input_tag_text_style.vertical_alignment = "top"
input_tag_text_style.text_horizontal_alignment = "right"
input_tag_text_style.text_vertical_alignment = "top"
input_tag_text_style.text_color = get_hud_color("color_tint_main_1", 255)
input_tag_text_style.offset = {
	0,
	input_box_height * 0.25,
	6
}
input_tag_text_style.size = {
	background_size[1] - edge_spacing[1] * 2,
	input_box_height
}
local description_text_style = table.clone(UIFontSettings.hud_body)
description_text_style.horizontal_alignment = "left"
description_text_style.vertical_alignment = "bottom"
description_text_style.text_horizontal_alignment = "left"
description_text_style.text_vertical_alignment = "center"
description_text_style.font_size = 26
description_text_style.offset = {
	0,
	-10,
	6
}
local type_description_text_style = table.clone(description_text_style)
type_description_text_style.text_color = {
	255,
	226,
	199,
	126
}
type_description_text_style.offset = {
	0,
	14,
	6
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
	7
}
event_text_style.size = {
	background_size[1],
	30
}
event_text_style.text_color = {
	255,
	70,
	38,
	0
}
event_text_style.drop_shadow = false
local widget_definitions = {
	interact_text = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "<text>",
			style = input_interact_text_style
		}
	}, "background"),
	tag_text = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "<text>",
			style = input_tag_text_style
		}
	}, "background"),
	description_text = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "<text>",
			style = description_text_style
		}
	}, "description_box"),
	type_description_text = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "FORGE MATERIALS",
			style = type_description_text_style
		}
	}, "description_box"),
	background = UIWidget.create_definition({
		{
			style_id = "background",
			pass_type = "texture",
			value = "content/ui/materials/hud/backgrounds/interaction_background",
			style = {
				vertical_alignment = "bottom",
				scale_to_material = true,
				horizontal_alignment = "left",
				offset = {
					0,
					0,
					0
				},
				size_addition = {
					0,
					-1
				},
				color = get_hud_color("color_tint_main_4", 230)
			},
			visibility_function = function (content)
				return not content.use_minimal_presentation
			end
		},
		{
			style_id = "input_background",
			pass_type = "rect",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				offset = {
					0,
					0,
					1
				},
				size = {
					[2] = input_box_height
				},
				color = {
					180,
					121,
					136,
					109
				}
			},
			visibility_function = function (content)
				return not content.use_minimal_presentation
			end
		},
		{
			style_id = "input_background_slim",
			pass_type = "texture_uv",
			value = "content/ui/materials/gradients/gradient_horizontal",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				offset = {
					0,
					0,
					2
				},
				size = {
					[2] = input_box_height
				},
				color = Color.terminal_background(200, true),
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
			},
			visibility_function = function (content)
				return content.use_minimal_presentation
			end
		},
		{
			style_id = "input_progress_background",
			pass_type = "rect",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				offset = {
					0,
					0,
					5
				},
				size = {
					0,
					10
				},
				color = {
					255,
					226,
					199,
					126
				}
			}
		},
		{
			style_id = "input_progress_background_large",
			pass_type = "rect",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				offset = {
					0,
					0,
					4
				},
				size = {
					0
				},
				size_addition = {
					0,
					-input_box_height
				},
				color = {
					60,
					226,
					199,
					126
				}
			}
		},
		{
			value = "content/ui/materials/frames/dropshadow_medium",
			style_id = "input_progress_frame",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				scale_to_material = true,
				horizontal_alignment = "right",
				offset = {
					10,
					10,
					4
				},
				default_offset = {
					10,
					0,
					4
				},
				size = {
					0,
					10
				},
				color = {
					255,
					226,
					199,
					126
				},
				size_addition = {
					20,
					20
				}
			}
		}
	}, "background"),
	frame = UIWidget.create_definition({
		{
			style_id = "frame",
			pass_type = "texture",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				color = {
					255,
					0,
					0,
					0
				},
				size_addition = {
					20,
					20
				},
				offset = {
					0,
					0,
					3
				}
			},
			visibility_function = function (content)
				return not content.use_minimal_presentation
			end
		},
		{
			style_id = "frame",
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/dropshadow_medium_gradient_fade_01",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				color = {
					255,
					0,
					0,
					0
				},
				size_addition = {
					20,
					20
				},
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				offset = {
					0,
					0,
					3
				}
			},
			visibility_function = function (content)
				return content.use_minimal_presentation
			end
		}
	}, "background"),
	progress_highlight = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/dropshadow_medium",
			style_id = "frame",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				color = {
					0,
					226,
					199,
					126
				},
				size_addition = {
					20,
					20
				},
				offset = {
					0,
					0,
					4
				}
			}
		}
	}, "background"),
	event_background = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = Utf8.upper(Localize("loc_interaction_start_event_text")),
			style = event_text_style
		},
		{
			style_id = "background",
			pass_type = "rect",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				offset = {
					0,
					35,
					0
				},
				size = {
					background_size[1],
					30
				},
				color = {
					230,
					255,
					151,
					29
				}
			}
		},
		{
			value = "content/ui/materials/frames/dropshadow_medium",
			style_id = "input_progress_frame",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				scale_to_material = true,
				horizontal_alignment = "center",
				offset = {
					0,
					45,
					0
				},
				size = {
					background_size[1],
					30
				},
				color = {
					255,
					0,
					0,
					0
				},
				size_addition = {
					20,
					20
				}
			}
		}
	}, "background")
}
local animations = {}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
