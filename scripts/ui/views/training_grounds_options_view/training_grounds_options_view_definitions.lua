-- chunkname: @scripts/ui/views/training_grounds_options_view/training_grounds_options_view_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local StepperPassTemplates = require("scripts/ui/pass_templates/stepper_pass_templates")
local TrainingGroundsOptionsViewStyles = require("scripts/ui/views/training_grounds_options_view/training_grounds_options_view_styles")
local TrainingGroundsOptionsViewSettings = require("scripts/ui/views/training_grounds_options_view/training_grounds_options_view_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local get_hud_color = UIHudSettings.get_hud_color
local view_styles = TrainingGroundsOptionsViewStyles
local left_panel_size = TrainingGroundsOptionsViewSettings.panel_size.default
local reward_size = TrainingGroundsOptionsViewSettings.reward_size
local weapon_size = TrainingGroundsOptionsViewSettings.weapon_size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	left_panel = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "center",
		size = left_panel_size,
		position = {
			100,
			-60,
			10,
		},
	},
	header = {
		horizontal_alignment = "center",
		parent = "left_panel",
		vertical_alignment = "top",
		size = {
			600,
			50,
		},
		position = {
			0,
			40,
			10,
		},
	},
	sub_header = {
		horizontal_alignment = "center",
		parent = "left_panel",
		vertical_alignment = "top",
		size = {
			600,
			50,
		},
		position = {
			0,
			70,
			10,
		},
	},
	header_separator = {
		horizontal_alignment = "center",
		parent = "left_panel",
		vertical_alignment = "top",
		size = {
			600,
			50,
		},
		position = {
			0,
			125,
			10,
		},
	},
	body = {
		horizontal_alignment = "center",
		parent = "left_panel",
		vertical_alignment = "top",
		size = {
			600,
			250,
		},
		position = {
			0,
			155,
			10,
		},
	},
	separator = {
		horizontal_alignment = "center",
		parent = "body",
		vertical_alignment = "bottom",
		size = {
			600,
			3,
		},
		position = {
			0,
			-100,
			10,
		},
	},
	rewards_header = {
		horizontal_alignment = "center",
		parent = "body",
		vertical_alignment = "bottom",
		size = {
			600,
			40,
		},
		position = {
			0,
			-40,
			10,
		},
	},
	reward_one = {
		horizontal_alignment = "center",
		parent = "left_panel",
		vertical_alignment = "bottom",
		size = reward_size,
		position = {
			-160,
			-120,
			10,
		},
	},
	reward_two = {
		horizontal_alignment = "center",
		parent = "left_panel",
		vertical_alignment = "bottom",
		size = reward_size,
		position = {
			160,
			-120,
			10,
		},
	},
	play_button = {
		horizontal_alignment = "center",
		parent = "left_panel",
		vertical_alignment = "bottom",
		size = {
			300,
			60,
		},
		position = {
			0,
			60,
			10,
		},
	},
	difficulty_stepper = {
		horizontal_alignment = "center",
		parent = "separator",
		vertical_alignment = "bottom",
		size = {
			336,
			94,
		},
		position = {
			0,
			150,
			10,
		},
	},
	difficulty_stepper_indicators = {
		horizontal_alignment = "left",
		parent = "difficulty_stepper",
		vertical_alignment = "top",
		size = {
			280,
			0,
		},
		position = {
			0,
			0,
			1,
		},
	},
}
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/terminal_basic",
			value_id = "background",
			style = {
				scale_to_material = true,
				size = {
					left_panel_size[1] - 40,
					left_panel_size[2] + 135,
				},
				offset = {
					-10,
					0,
					0,
				},
				size_addition = {
					60,
					6,
				},
				color = Color.terminal_grid_background(nil, true),
			},
		},
	}, "left_panel", nil, nil),
	header = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "header",
			value_id = "header",
			style = view_styles.header_font_style,
		},
		{
			pass_type = "text",
			style_id = "sub_header",
			value_id = "sub_header",
			style = view_styles.sub_header_font_style,
		},
	}, "header"),
	header_separator = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "divider",
			value = "content/ui/materials/dividers/skull_center_02",
			value_id = "divider",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					400,
					18,
				},
				offset = {
					0,
					-6,
					1,
				},
				color = Color.terminal_frame(255, true),
			},
		},
	}, "header_separator"),
	body = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "body_text",
			value_id = "body_text",
			style = view_styles.body_font_style,
		},
	}, "body"),
	separator = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "separator",
			value = "content/ui/materials/backgrounds/default_square",
			value_id = "separator",
			style = {
				color = {
					50,
					255,
					255,
					255,
				},
			},
		},
	}, "separator"),
	rewards_header = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			style = view_styles.rewards_header_font_style,
		},
	}, "rewards_header"),
	reward_1 = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/icons/items/containers/item_container_landscape_no_rarity",
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				size = weapon_size,
				default_size = weapon_size,
				offset = {
					0,
					0,
					2,
				},
				color = {
					255,
					255,
					255,
					255,
				},
				material_values = {
					use_placeholder_texture = 1,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "reward_1",
			value = "content/ui/materials/backgrounds/default_square",
			value_id = "reward_1",
			style = {
				color = Color.black(60, true),
			},
		},
		{
			pass_type = "text",
			style_id = "text",
			value = "text",
			value_id = "text",
			style = view_styles.reward_font_style,
		},
		{
			pass_type = "texture",
			style_id = "diffulty_icon_background_frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				offset = {
					0,
					0,
					10,
				},
				color = Color.terminal_text_body_dark(255, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "diffulty_icon_background_frame_corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				offset = {
					0,
					0,
					11,
				},
				color = Color.terminal_text_body(255, true),
			},
		},
	}, "reward_one"),
	reward_2 = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "reward_2",
			value = "content/ui/materials/backgrounds/default_square",
			value_id = "reward_2",
			style = {
				color = Color.black(60, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/icons/items/containers/item_container_landscape_no_rarity",
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				size = weapon_size,
				default_size = weapon_size,
				offset = {
					0,
					0,
					2,
				},
				color = {
					255,
					255,
					255,
					255,
				},
				material_values = {
					use_placeholder_texture = 1,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "text",
			value = "text",
			value_id = "text",
			style = view_styles.reward_font_style,
		},
		{
			pass_type = "texture",
			style_id = "diffulty_icon_background_frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				offset = {
					0,
					0,
					10,
				},
				color = Color.terminal_text_body_dark(255, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "diffulty_icon_background_frame_corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				offset = {
					0,
					0,
					11,
				},
				color = Color.terminal_text_body(255, true),
			},
		},
	}, "reward_two"),
	play_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "play_button", {
		original_text = "PLAY BASIC",
	}),
	edge_top = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			style_id = "texture",
			value = "content/ui/materials/frames/training_grounds_upper",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size_addition = {
					0,
					0,
				},
				offset = {
					0,
					-116,
					11,
				},
				size = {
					840,
					200,
				},
			},
		},
	}, "left_panel"),
	edge_bottom = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			style_id = "texture",
			value = "content/ui/materials/frames/training_grounds_lower",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size_addition = {
					0,
					0,
				},
				offset = {
					0,
					185,
					11,
				},
				size = {
					740,
					120,
				},
			},
		},
	}, "left_panel"),
	select_difficulty_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = view_styles.select_difficulty_text_style,
		},
	}, "difficulty_stepper"),
	difficulty_stepper = UIWidget.create_definition(StepperPassTemplates.mission_board_stepper, "difficulty_stepper", {
		next_page_unlocked = true,
	}),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
