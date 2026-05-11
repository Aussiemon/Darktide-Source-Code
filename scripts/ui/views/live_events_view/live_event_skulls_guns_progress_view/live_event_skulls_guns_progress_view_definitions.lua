-- chunkname: @scripts/ui/views/live_events_view/live_event_skulls_guns_progress_view/live_event_skulls_guns_progress_view_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local BarPassTemplates = require("scripts/ui/pass_templates/bar_pass_templates")
local item_header_premium_text_style = table.clone(UIFontSettings.header_1)

item_header_premium_text_style.material = "content/ui/materials/font_gradients/slug_font_gradient_gold"
item_header_premium_text_style.text_color = Color.white(255, true)
item_header_premium_text_style.text_horizontal_alignment = "center"
item_header_premium_text_style.text_vertical_alignment = "top"
item_header_premium_text_style.font_size = 48
item_header_premium_text_style.drop_shadow = true

local instruction_text_style = table.clone(UIFontSettings.body)

instruction_text_style.text_color = Color.terminal_text_body(255, true)
instruction_text_style.text_horizontal_alignment = "center"
instruction_text_style.text_vertical_alignment = "top"
instruction_text_style.horizontal_alignment = "center"
instruction_text_style.font_size = 24
instruction_text_style.drop_shadow = true

local entry_title_style = table.clone(UIFontSettings.body)

entry_title_style.font_size = 24
entry_title_style.text_color = Color.white(255, true)
entry_title_style.text_horizontal_alignment = "center"
entry_title_style.text_vertical_alignment = "top"

local entry_subtitle_style = table.clone(UIFontSettings.body_medium)

entry_subtitle_style.text_color = Color.white(255, true)
entry_subtitle_style.text_horizontal_alignment = "left"
entry_subtitle_style.text_vertical_alignment = "top"
entry_subtitle_style.font_size = 26

local entry_body_style = table.clone(UIFontSettings.body_medium)

entry_body_style.text_horizontal_alignment = "left"
entry_body_style.text_vertical_alignment = "top"
entry_body_style.font_size = 20
entry_body_style.text_color = Color.terminal_text_body(255, true)

local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
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
	canvas_bottom = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			0,
		},
	},
}

scenegraph_definition.canvas = {
	horizontal_alignment = "center",
	parent = "screen",
	vertical_alignment = "center",
	size = {
		1824,
		918,
	},
	position = {
		0,
		0,
		1,
	},
}
scenegraph_definition.left_column = {
	horizontal_alignment = "left",
	parent = "canvas",
	vertical_alignment = "center",
	size = {
		scenegraph_definition.canvas.size[1] * 0.63,
		scenegraph_definition.canvas.size[2],
	},
	position = {
		5,
		0,
		1,
	},
}
scenegraph_definition.right_column = {
	horizontal_alignment = "right",
	parent = "canvas",
	vertical_alignment = "center",
	size = {
		scenegraph_definition.canvas.size[1] * 0.33,
		scenegraph_definition.canvas.size[2],
	},
	position = {
		-5,
		0,
		1,
	},
}
scenegraph_definition.content_pivot = {
	horizontal_alignment = "left",
	parent = "left_column",
	vertical_alignment = "top",
	offset = {
		100,
		125,
		1,
	},
	size = {
		scenegraph_definition.left_column.size[1],
		scenegraph_definition.left_column.size[2],
	},
}
scenegraph_definition.right_column_first_row = {
	horizontal_alignment = "center",
	parent = "right_column",
	vertical_alignment = "top",
	size = {
		scenegraph_definition.right_column.size[1],
		scenegraph_definition.right_column.size[2] * 0.33,
	},
	offset = {
		0,
		25,
		1,
	},
}
scenegraph_definition.right_column_second_row = {
	horizontal_alignment = "center",
	parent = "right_column",
	vertical_alignment = "bottom",
	offset = {
		5,
		25,
		1,
	},
	size = {
		scenegraph_definition.right_column.size[1] * 0.95,
		scenegraph_definition.right_column.size[2] * 0.6,
	},
}

local widget_definitions = {
	background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = Color.black(191.25, true),
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				color = Color.ui_red_medium(127.5, true),
			},
		},
	}, "screen"),
	background_column_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "candles_1",
			value = "content/ui/materials/effects/achievements/panel_main_top_frame_candles_left",
			value_id = "candles_1",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				size = {
					100,
					100,
				},
				offset = {
					25,
					-100,
					3,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "candles_2",
			value = "content/ui/materials/effects/achievements/panel_main_top_frame_candles_right",
			value_id = "candles_2",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "top",
				size = {
					100,
					100,
				},
				offset = {
					-18,
					-100,
					3,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "frame_top",
			value = "content/ui/materials/frames/achievements/panel_main_top_frame",
			value_id = "frame_top",
			style = {
				horizontal_alignment = "center",
				offset = {
					0,
					-64,
					2,
				},
				size = {
					scenegraph_definition.left_column.size[1],
					76,
				},
				size_addition = {
					50,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					scenegraph_definition.left_column.size[1],
					1,
				},
				color = Color.black(200, true),
				size_addition = {
					10,
					19,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "candles_3",
			value = "content/ui/materials/effects/achievements/panel_main_lower_frame_candles_left",
			value_id = "candles_3",
			style = {
				horizontal_alignment = "left",
				scale_to_material = true,
				vertical_alignment = "bottom",
				size = {
					100,
					100,
				},
				offset = {
					-22,
					-15,
					3,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "candles_4",
			value = "content/ui/materials/effects/achievements/panel_main_lower_frame_candles_right",
			value_id = "candles_4",
			style = {
				horizontal_alignment = "right",
				scale_to_material = true,
				vertical_alignment = "bottom",
				size = {
					100,
					100,
				},
				offset = {
					20,
					-13,
					3,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "frame_bot",
			value = "content/ui/materials/frames/achievements/panel_main_lower_frame",
			value_id = "frame_bot",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				offset = {
					0,
					10,
					2,
				},
				size = {
					scenegraph_definition.left_column.size[1],
					84,
				},
				size_addition = {
					50,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					scenegraph_definition.left_column.size[1],
					1,
				},
				color = Color.black(200, true),
				size_addition = {
					0,
					32,
				},
				offset = {
					0,
					-15,
					1,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/live_events/skulls_guns/live_event_skulls_left_column_background",
			style = {
				size_addition = {
					60,
					60,
				},
				offset = {
					-28,
					-50,
					0,
				},
			},
		},
	}, "left_column"),
	background_column_right = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = Color.black(229.5, true),
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/dropshadow_heavy",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.terminal_grid_background(200, true),
				size_addition = {
					20,
					20,
				},
				offset = {
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				color = Color.terminal_grid_background(255, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "frame_top",
			value = "content/ui/materials/frames/item_info_upper_dynamic",
			value_id = "frame_top",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				offset = {
					0,
					-10,
					2,
				},
				size = {
					scenegraph_definition.right_column.size[1],
					36,
				},
				size_addition = {
					25,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					scenegraph_definition.right_column.size[1],
					1,
				},
				color = Color.black(200, true),
				size_addition = {
					0,
					22,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "frame_bot",
			value = "content/ui/materials/frames/item_info_lower_dynamic",
			value_id = "frame_bot",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				offset = {
					0,
					10,
					2,
				},
				size = {
					scenegraph_definition.right_column.size[1],
					36,
				},
				size_addition = {
					25,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					scenegraph_definition.right_column.size[1],
					5,
				},
				color = Color.black(200, true),
				size_addition = {
					5,
					30,
				},
				offset = {
					0,
					17,
					2,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size = {
					scenegraph_definition.right_column.size[1],
					scenegraph_definition.right_column.size[2],
				},
				color = Color.terminal_grid_background(255, true),
				offset = {
					0,
					0,
					1,
				},
			},
		},
	}, "right_column"),
	title_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "title",
			value_id = "title",
			style = table.add_missing({
				offset = {
					0,
					50,
					1,
				},
			}, item_header_premium_text_style),
			value = Localize("loc_skulls_guns_01_name"),
		},
	}, "left_column"),
	instruction_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "instructions",
			value_id = "instructions",
			style = table.add_missing({
				offset = {
					0,
					100,
					1,
				},
			}, instruction_text_style),
			value = Localize("loc_skulls_guns_progress_view_instruction_text"),
		},
	}, "left_column"),
	entry_title_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			style = table.add_missing({
				offset = {
					0,
					0,
					3,
				},
			}, entry_title_style),
			value = Localize("loc_skulls_guns_progress_view_entry_locked"),
		},
	}, "right_column_first_row"),
	entry_image = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = Color.black(63.75, true),
				offset = {
					0,
					50,
					1,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "missing_data_base",
			value = "content/ui/materials/live_events/skulls_guns/ui_missing_data_distorted",
			value_id = "missing_data_base",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				offset = {
					0,
					25,
					1,
				},
				size = {
					scenegraph_definition.right_column_first_row.size[1],
					scenegraph_definition.right_column_first_row.size[2],
				},
				color = Color.ui_hud_green_light(255, true),
			},
			visibility_function = function (content, style)
				return not style.parent.image.material_values.texture_map
			end,
		},
		{
			pass_type = "texture",
			style_id = "missing_data_noise",
			value = "content/ui/materials/backgrounds/scanner/scanner_noise",
			value_id = "missing_data_noise",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				offset = {
					0,
					50,
					1,
				},
				size = {
					scenegraph_definition.right_column_first_row.size[1],
					scenegraph_definition.right_column_first_row.size[2],
				},
				color = Color.ui_hud_green_light(63.75, true),
			},
			visibility_function = function (content, style)
				return not style.parent.image.material_values.texture_map
			end,
		},
		{
			pass_type = "rotated_texture",
			style_id = "loading",
			value = "content/ui/materials/loading/loading_small",
			style = {
				angle = 0,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					200,
					200,
				},
				color = {
					255,
					224,
					224,
					224,
				},
				offset = {
					0,
					50,
					2,
				},
			},
			visibility_function = function (content, style)
				return content.has_image and not style.parent.image.material_values.texture_map
			end,
			change_function = function (content, style, _, dt)
				local add = -0.5 * dt

				style.rotation_progress = ((style.rotation_progress or 0) + add) % 1
				style.angle = style.rotation_progress * math.pi * 2
			end,
		},
		{
			pass_type = "texture_uv",
			style_id = "image",
			value = "content/ui/materials/base/ui_default_base",
			value_id = "image",
			style = {
				horizontal_alignment = "left",
				scale_to_material = false,
				vertical_alignment = "top",
				size = {
					scenegraph_definition.right_column_first_row.size[1],
					scenegraph_definition.right_column_first_row.size[2],
				},
				color = Color.white(255, true),
				offset = {
					0,
					50,
					3,
				},
				material_values = {
					texture_map = nil,
				},
				uvs = {
					{
						0,
						0,
					},
					{
						1,
						1,
					},
				},
			},
			visibility_function = function (content, style)
				return not not style.material_values.texture_map
			end,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "top",
				offset = {
					0,
					50,
					4,
				},
				size = {
					scenegraph_definition.right_column_first_row.size[1],
					scenegraph_definition.right_column_first_row.size[2],
				},
				color = Color.terminal_corner_hover(255, true),
			},
		},
	}, "right_column_first_row"),
	entry_subtitle_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = table.add_missing({
				offset = {
					0,
					0,
					1,
				},
				size = {
					scenegraph_definition.right_column_second_row.size[1],
					25,
				},
				size_addition = {
					-25,
				},
			}, entry_subtitle_style),
		},
	}, "right_column_second_row"),
	entry_body_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			style = table.add_missing({
				offset = {
					0,
					0,
					1,
				},
				size = {
					scenegraph_definition.right_column_second_row.size[1],
					scenegraph_definition.right_column_second_row.size[2],
				},
				size_addition = {
					-25,
					-25,
				},
			}, entry_body_style),
			value = Localize("loc_skulls_guns_progress_view_entry_locked"),
		},
	}, "right_column_second_row"),
}
local legend_inputs = {
	{
		alignment = "left_alignment",
		display_name = "loc_settings_menu_close_menu",
		input_action = "back",
		on_pressed_callback = "_cb_on_back_pressed",
		visibility_function = nil,
	},
}
local animations = {}

return {
	animations = animations,
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
