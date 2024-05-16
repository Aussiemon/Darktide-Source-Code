-- chunkname: @scripts/ui/views/story_mission_play_view/story_mission_play_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local option_size = {
	400,
	100,
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
			3,
		},
	},
	page_header = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			1300,
			194,
		},
		position = {
			110,
			60,
			2,
		},
	},
	detail = {
		horizontal_alignment = "left",
		parent = "page_header",
		vertical_alignment = "top",
		size = {
			483,
			344,
		},
		position = {
			0,
			200,
			2,
		},
	},
	detail_header = {
		horizontal_alignment = "right",
		parent = "detail",
		vertical_alignment = "top",
		size = {
			483,
			75,
		},
		position = {
			0,
			0,
			0,
		},
	},
	detail_location = {
		horizontal_alignment = "right",
		parent = "detail_header",
		vertical_alignment = "bottom",
		size = {
			483,
			269,
		},
		position = {
			0,
			269,
			0,
		},
	},
	objective = {
		horizontal_alignment = "center",
		parent = "detail",
		vertical_alignment = "top",
		size = {
			483,
			200,
		},
		position = {
			0,
			354,
			0,
		},
	},
	objective_header = {
		horizontal_alignment = "left",
		parent = "objective",
		vertical_alignment = "top",
		size = {
			483,
			68,
		},
		position = {
			0,
			0,
			10,
		},
	},
	objective_credits = {
		horizontal_alignment = "left",
		parent = "objective",
		vertical_alignment = "bottom",
		size = {
			110,
			33,
		},
		position = {
			-10,
			10,
			10,
		},
	},
	objective_xp = {
		horizontal_alignment = "left",
		parent = "objective_credits",
		vertical_alignment = "bottom",
		size = {
			110,
			33,
		},
		position = {
			115,
			0,
			0,
		},
	},
	objective_speaker = {
		horizontal_alignment = "right",
		parent = "objective",
		vertical_alignment = "bottom",
		size = {
			40,
			48,
		},
		position = {
			10,
			10,
			10,
		},
	},
	option_header = {
		horizontal_alignment = "right",
		parent = "detail",
		vertical_alignment = "top",
		size = {
			option_size[1],
			45,
		},
		position = {
			option_size[1] + 40,
			0,
			0,
		},
	},
	option_1 = {
		horizontal_alignment = "right",
		parent = "detail",
		vertical_alignment = "top",
		size = option_size,
		position = {
			option_size[1] + 40,
			44,
			0,
		},
	},
	option_2 = {
		horizontal_alignment = "left",
		parent = "option_1",
		vertical_alignment = "top",
		size = option_size,
		position = {
			0,
			option_size[2] + 20,
			0,
		},
	},
	option_3 = {
		horizontal_alignment = "left",
		parent = "option_2",
		vertical_alignment = "top",
		size = option_size,
		position = {
			0,
			option_size[2] + 20,
			0,
		},
	},
	option_4 = {
		horizontal_alignment = "right",
		parent = "objective",
		vertical_alignment = "bottom",
		size = option_size,
		position = {
			option_size[1] + 40,
			0,
			0,
		},
	},
	reward_1 = {
		horizontal_alignment = "right",
		parent = "option_2",
		vertical_alignment = "center",
		size = {
			178,
			370,
		},
		position = {
			180,
			0,
			0,
		},
	},
	reward_2 = {
		horizontal_alignment = "right",
		parent = "option_4",
		vertical_alignment = "center",
		size = {
			178,
			125,
		},
		position = {
			180,
			0,
			0,
		},
	},
	play_button = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = ButtonPassTemplates.default_button.size,
		position = {
			-165,
			-150,
			1,
		},
	},
	info_box = {
		horizontal_alignment = "center",
		parent = "play_button",
		vertical_alignment = "center",
		size = {
			380,
			60,
		},
		position = {
			0,
			0,
			0,
		},
	},
	info_button = {
		horizontal_alignment = "left",
		parent = "objective",
		vertical_alignment = "bottom",
		size = {
			option_size[1],
			40,
		},
		position = {
			0,
			55,
			1,
		},
	},
	bonus_reward_claimer = {
		horizontal_alignment = "left",
		parent = "option_4",
		vertical_alignment = "bottom",
		size = {
			800,
			40,
		},
		position = {
			0,
			50,
			4,
		},
	},
}

local function create_option_widget(scenegraph_id)
	return UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			content = {
				on_hover_sound = UISoundEvents.story_mission_option_mouse_hover,
			},
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				default_color = Color.terminal_frame(nil, true),
				hover_color = Color.terminal_frame_hover(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				offset = {
					0,
					0,
					6,
				},
			},
			change_function = ButtonPassTemplates.terminal_button_change_function,
		},
		{
			pass_type = "texture",
			style_id = "corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				default_color = Color.terminal_corner(nil, true),
				hover_color = Color.terminal_corner_hover(nil, true),
				selected_color = Color.terminal_corner_selected(nil, true),
				offset = {
					0,
					0,
					7,
				},
			},
			change_function = ButtonPassTemplates.terminal_button_change_function,
		},
		{
			pass_type = "texture",
			style_id = "background_gradient",
			value = "content/ui/materials/masks/gradient_horizontal_sides_02",
			value_id = "background_gradient",
			style = {
				max_alpha = 255,
				min_alpha = 150,
				scale_to_material = true,
				color = Color.terminal_background_gradient(nil, true),
				default_color = Color.terminal_background_gradient(nil, true),
				hover_color = Color.terminal_background_gradient(nil, true),
				selected_color = Color.terminal_background_selected(nil, true),
				size_addition = {
					0,
					-30,
				},
				offset = {
					0,
					0,
					2,
				},
			},
			change_function = ButtonPassTemplates.terminal_list_button_frame_hover_change_function,
			visibility_function = ButtonPassTemplates.list_button_focused_visibility_function,
		},
		{
			pass_type = "texture",
			style_id = "outer_shadow",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				default_color = Color.black(200, true),
				hover_color = Color.black(200, true),
				selected_color = Color.terminal_corner_selected(nil, true),
				color = Color.black(200, true),
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
			change_function = ButtonPassTemplates.terminal_button_change_function,
		},
		{
			pass_type = "texture",
			style_id = "outer_shadow",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.black(200, true),
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
		},
		{
			pass_type = "texture",
			style_id = "header_frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "top",
				default_color = Color.terminal_frame(nil, true),
				hover_color = Color.terminal_frame_hover(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				offset = {
					0,
					0,
					6,
				},
				size_addition = {
					0,
					-30,
				},
			},
			change_function = ButtonPassTemplates.terminal_button_change_function,
		},
		{
			pass_type = "rect",
			style_id = "background_top",
			value_id = "content/ui/materials/backgrounds/default_square",
			style = {
				color = Color.terminal_grid_background_gradient(nil, true),
				offset = {
					0,
					0,
					1,
				},
				size_addition = {
					0,
					-30,
				},
			},
		},
		{
			pass_type = "rect",
			style_id = "background",
			value_id = "content/ui/materials/backgrounds/default_square",
			style = {
				color = Color.black(150, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "reward_icon_1",
			value = "content/ui/materials/icons/currencies/credits_small",
			value_id = "reward_icon_1",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				offset = {
					-22,
					-6,
					4,
				},
				default_offset = {
					-22,
					-6,
					4,
				},
				size = {
					28,
					20,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "reward_icon_2",
			value = "content/ui/materials/icons/currencies/experience_small",
			value_id = "reward_icon_2",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				offset = {
					-22,
					-6,
					4,
				},
				default_offset = {
					-22,
					-6,
					4,
				},
				size = {
					28,
					20,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "reward_text_1",
			value = "0",
			value_id = "reward_text_1",
			style = {
				font_size = 20,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "right",
				line_spacing = 1.2,
				text_horizontal_alignment = "right",
				text_vertical_alignment = "center",
				vertical_alignment = "bottom",
				text_color = Color.terminal_text_body(nil, true),
				offset = {
					-52,
					-1,
					4,
				},
				default_offset = {
					-52,
					-1,
					4,
				},
				size = {
					nil,
					30,
				},
				size_addition = {
					-100,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "reward_text_2",
			value = "0",
			value_id = "reward_text_2",
			style = {
				font_size = 20,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "right",
				line_spacing = 1.2,
				text_horizontal_alignment = "right",
				text_vertical_alignment = "center",
				vertical_alignment = "bottom",
				text_color = Color.terminal_text_body(nil, true),
				offset = {
					-52,
					-1,
					4,
				},
				default_offset = {
					-52,
					-1,
					4,
				},
				size = {
					nil,
					30,
				},
				size_addition = {
					-100,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "title_text",
			value = "title_text",
			value_id = "title_text",
			style = {
				font_size = 24,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "left",
				line_spacing = 1.2,
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				text_color = Color.terminal_text_header(nil, true),
				offset = {
					30,
					-12,
					4,
				},
				size_addition = {
					-100,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "reward_header",
			value_id = "reward_header",
			value = Localize("loc_story_mission_play_menu_difficulty_option_reward_title"),
			style = {
				font_size = 18,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "left",
				line_spacing = 1.2,
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				vertical_alignment = "bottom",
				text_color = Color.terminal_text_body_sub_header(nil, true),
				offset = {
					30,
					-2,
					5,
				},
				size = {
					nil,
					30,
				},
				size_addition = {
					-100,
					0,
				},
			},
		},
		{
			pass_type = "rect",
			style_id = "difficulty_box_5",
			style = {
				horizontal_alignment = "right",
				offset = {
					-30,
					20,
					2,
				},
				size = {
					10,
					30,
				},
				color = Color.terminal_text_body_dark(nil, true),
			},
		},
		{
			pass_type = "rect",
			style_id = "difficulty_box_4",
			style = {
				horizontal_alignment = "right",
				offset = {
					-48,
					20,
					2,
				},
				size = {
					10,
					30,
				},
				color = Color.terminal_text_body_dark(nil, true),
			},
		},
		{
			pass_type = "rect",
			style_id = "difficulty_box_3",
			style = {
				horizontal_alignment = "right",
				offset = {
					-66,
					20,
					2,
				},
				size = {
					10,
					30,
				},
				color = Color.terminal_text_body_dark(nil, true),
			},
		},
		{
			pass_type = "rect",
			style_id = "difficulty_box_2",
			style = {
				horizontal_alignment = "right",
				offset = {
					-84,
					20,
					2,
				},
				size = {
					10,
					30,
				},
				color = Color.terminal_text_body_dark(nil, true),
			},
		},
		{
			pass_type = "rect",
			style_id = "difficulty_box_1",
			style = {
				horizontal_alignment = "right",
				offset = {
					-102,
					20,
					2,
				},
				size = {
					10,
					30,
				},
				color = Color.terminal_text_body_dark(nil, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "difficulty_icon",
			value = "content/ui/materials/icons/generic/danger",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "top",
				color = Color.terminal_icon(nil, true),
				offset = {
					-118,
					15,
					2,
				},
				size = {
					40,
					40,
				},
			},
		},
	}, scenegraph_id)
end

local function create_reward_widget(scenegraph_id)
	return UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "vertical_divider",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				color = Color.terminal_corner_hover(255, true),
				offset = {
					10,
					0,
					4,
				},
				size = {
					2,
				},
			},
		},
		{
			pass_type = "rect",
			style_id = "top_divider",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				color = Color.terminal_corner_hover(255, true),
				offset = {
					0,
					0,
					4,
				},
				size = {
					10,
					2,
				},
			},
		},
		{
			pass_type = "rect",
			style_id = "bottom_divider",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				color = Color.terminal_corner_hover(255, true),
				offset = {
					0,
					0,
					4,
				},
				size = {
					10,
					2,
				},
			},
		},
		{
			pass_type = "rect",
			style_id = "center_divider",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				color = Color.terminal_corner_hover(255, true),
				offset = {
					12,
					0,
					4,
				},
				size = {
					nil,
					2,
				},
				size_addition = {
					-156,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "reward_box_frame",
			value = "content/ui/materials/frames/line_light",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				color = Color.terminal_corner_hover(nil, true),
				offset = {
					0,
					0,
					5,
				},
				size = {
					144,
					144,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "reward_icon_ui",
			value = "content/ui/materials/icons/items/containers/item_container_square",
			value_id = "reward_icon_ui",
			style = {
				horizontal_alignment = "right",
				scale_to_material = true,
				vertical_alignment = "center",
				offset = {
					-8,
					0,
					5,
				},
				size = {
					128,
					128,
				},
				material_values = {},
			},
			visibility_function = function (content, style)
				local parent_style = style.parent

				return parent_style.reward_icon_ui.material_values.texture_icon
			end,
		},
		{
			pass_type = "texture",
			style_id = "reward_icon",
			value = "content/ui/materials/icons/items/containers/item_container_landscape",
			value_id = "reward_icon",
			style = {
				horizontal_alignment = "right",
				scale_to_material = true,
				vertical_alignment = "center",
				offset = {
					-8,
					0,
					5,
				},
				size = {
					128,
					128,
				},
				material_values = {},
			},
			visibility_function = function (content, style)
				local parent_style = style.parent

				return parent_style.reward_icon.material_values.use_render_target
			end,
		},
		{
			pass_type = "rect",
			style_id = "reward_box_overlay",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				color = Color.black(130, true),
				offset = {
					-8,
					0,
					7,
				},
				size = {
					128,
					128,
				},
			},
			visibility_function = function (content, style)
				return content.claimed
			end,
		},
		{
			pass_type = "text",
			style_id = "reward_box_complete",
			value = "",
			style = {
				font_size = 72,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "right",
				line_spacing = 1.2,
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				text_color = Color.terminal_text_body(nil, true),
				offset = {
					-8,
					0,
					9,
				},
				size = {
					128,
					128,
				},
			},
			visibility_function = function (content, style)
				return content.claimed
			end,
		},
		{
			pass_type = "texture",
			style_id = "loot_icon",
			value = "content/ui/materials/icons/generic/loot",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				color = Color.terminal_corner_hover(nil, true),
				offset = {
					-3,
					45,
					6,
				},
				size = {
					42,
					42,
				},
			},
		},
		{
			pass_type = "rect",
			style_id = "reward_box_background",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				color = Color.black(200, true),
				offset = {
					-8,
					0,
					0,
				},
				size = {
					128,
					128,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "background_gradient",
			value = "content/ui/materials/gradients/gradient_vertical",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				default_color = {
					100,
					33,
					35,
					37,
				},
				color = {
					100,
					33,
					35,
					37,
				},
				offset = {
					-8,
					0,
					2,
				},
				size = {
					128,
					128,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "button_gradient",
			value = "content/ui/materials/gradients/gradient_diagonal_down_right",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				color = Color.terminal_background_gradient(nil, true),
				default_color = Color.terminal_background_gradient(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				offset = {
					-8,
					0,
					1,
				},
				size = {
					128,
					128,
				},
			},
			change_function = function (content, style)
				return
			end,
		},
		{
			pass_type = "texture",
			style_id = "reward_box",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				color = Color.terminal_frame(nil, true),
				offset = {
					-8,
					0,
					9,
				},
				size = {
					128,
					128,
				},
			},
		},
	}, scenegraph_id)
end

local widget_definitions = {
	info_box = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background",
			style = {
				color = {
					75,
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				scale_to_material = true,
				color = {
					0,
					0,
					0,
					0,
				},
				color_info = Color.golden_rod(nil, true),
				color_warning = Color.ui_interaction_critical(255, true),
				offset = {
					0,
					0,
					1,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = {
				font_size = 18,
				font_type = "proxima_nova_bold",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				text_color = Color.ui_interaction_critical(255, true),
				offset = {
					0,
					0,
					2,
				},
				size_addition = {
					-10,
					0,
				},
			},
		},
	}, "info_box"),
	play_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "play_button", {
		gamepad_action = "confirm_pressed",
		original_text = Utf8.upper(Localize("loc_story_mission_play_menu_button_start_mission")),
		hotspot = {},
	}),
	play_button_legend = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = {
				font_size = 18,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				text_color = Color.terminal_text_body(nil, true),
				offset = {
					0,
					50,
					2,
				},
			},
		},
	}, "play_button"),
	info_button = UIWidget.create_definition(ButtonPassTemplates.input_legend_button, "info_button", {
		text = "",
		visible = true,
	}),
	option_header = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			style = {
				drop_shadow = true,
				font_size = 26,
				font_type = "proxima_nova_bold",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "top",
				offset = {
					0,
					0,
					1,
				},
				size_addition = {
					0,
					0,
				},
				text_color = Color.terminal_text_header(nil, true),
			},
			value = Localize("loc_story_mission_play_menu_difficulty_options_header"),
		},
	}, "option_header"),
	option_1 = create_option_widget("option_1"),
	option_2 = create_option_widget("option_2"),
	option_3 = create_option_widget("option_3"),
	option_4 = create_option_widget("option_4"),
	reward_1 = create_reward_widget("reward_1"),
	reward_2 = create_reward_widget("reward_2"),
	bonus_reward_claimer = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			style = {
				drop_shadow = true,
				font_size = 18,
				font_type = "proxima_nova_bold",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				text_color = Color.terminal_corner_hover(nil, true),
				offset = {
					35,
					0,
					1,
				},
			},
			value = Localize("loc_story_mission_play_menu_bonus_reward_disclaimer_description"),
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/icons/generic/loot",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				color = Color.terminal_corner_hover(nil, true),
				offset = {
					0,
					0,
					0,
				},
				size = {
					32,
					32,
				},
			},
		},
	}, "bonus_reward_claimer"),
	page_header = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			style = {
				drop_shadow = true,
				font_size = 55,
				font_type = "machine_medium",
				material = "content/ui/materials/font_gradients/slug_font_gradient_header",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				text_color = Color.white(nil, true),
				offset = {
					0,
					0,
					1,
				},
			},
			value = Localize("loc_story_mission_play_menu_title"),
		},
	}, "page_header"),
	detail = UIWidget.create_definition({
		{
			pass_type = "rect",
			scenegraph_id = "detail_header",
			style_id = "background",
			style = {
				color = {
					200,
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "header_title",
			value = "",
			value_id = "header_title",
			style = {
				drop_shadow = true,
				font_size = 28,
				font_type = "proxima_nova_bold",
				scenegraph_id = "detail_header",
				text_vertical_alignment = "center",
				text_color = Color.terminal_text_header(nil, true),
				offset = {
					20,
					-10,
					2,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "header_subtitle",
			value = "",
			value_id = "header_subtitle",
			style = {
				drop_shadow = true,
				font_size = 18,
				font_type = "proxima_nova_bold",
				scenegraph_id = "detail_header",
				text_vertical_alignment = "center",
				text_color = Color.terminal_text_body(nil, true),
				offset = {
					20,
					16,
					3,
				},
			},
		},
		{
			pass_type = "texture",
			scenegraph_id = "detail_header",
			style_id = "header_frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "center",
				color = Color.terminal_frame(nil, true),
				offset = {
					0,
					0,
					5,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "outer_shadow",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.black(200, true),
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
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_frame(nil, true),
				offset = {
					0,
					0,
					5,
				},
			},
		},
		{
			pass_type = "texture",
			scenegraph_id = "detail_location",
			style_id = "location_image",
			value = "content/ui/materials/mission_board/texture_with_grid_effect",
			value_id = "location_image",
			style = {
				material_values = {
					texture_map = "content/ui/textures/missions/quickplay",
				},
			},
		},
	}, "detail"),
	objective = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "header_gradient",
			value = "content/ui/materials/gradients/gradient_horizontal",
			style = {
				scenegraph_id = "objective_header",
				color = {
					128,
					169,
					211,
					158,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "header_title",
			value = "",
			value_id = "header_title",
			style = {
				drop_shadow = true,
				font_size = 16,
				font_type = "proxima_nova_bold",
				scenegraph_id = "objective_header",
				text_color = Color.terminal_text_body_sub_header(nil, true),
				offset = {
					70,
					13,
					3,
				},
				size_addition = {
					-90,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "header_subtitle",
			value = "",
			value_id = "header_subtitle",
			style = {
				drop_shadow = true,
				font_size = 20,
				font_type = "proxima_nova_bold",
				scenegraph_id = "objective_header",
				offset = {
					70,
					33,
					4,
				},
				size_addition = {
					-90,
					0,
				},
				text_color = Color.terminal_text_header(nil, true),
			},
		},
		{
			pass_type = "texture",
			scenegraph_id = "objective_header",
			style_id = "header_icon",
			value = "content/ui/materials/icons/mission_types/mission_type_01",
			value_id = "header_icon",
			style = {
				color = Color.terminal_text_header(nil, true),
				offset = {
					20,
					16,
					2,
				},
				size = {
					36,
					36,
				},
			},
		},
		{
			pass_type = "text",
			scenegraph_id = "detail_location",
			style_id = "location_lock",
			value = "",
			style = {
				drop_shadow = false,
				font_size = 100,
				font_type = "proxima_nova_bold",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				text_color = Color.black(220, true),
				offset = {
					0,
					0,
					1,
				},
			},
			visibility_function = function (content)
				return content.is_locked
			end,
		},
		{
			pass_type = "texture",
			scenegraph_id = "objective_header",
			style_id = "header_frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "center",
				color = Color.terminal_frame(nil, true),
				offset = {
					0,
					0,
					5,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "outer_shadow",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.black(200, true),
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
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_frame(nil, true),
				offset = {
					0,
					0,
					5,
				},
			},
		},
		{
			pass_type = "rect",
			scenegraph_id = "objective",
			style_id = "background",
			style = {
				color = {
					200,
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "body_text",
			value = "body_text",
			value_id = "body_text",
			style = {
				font_size = 18,
				font_type = "proxima_nova_bold",
				line_spacing = 1.2,
				text_color = Color.terminal_text_body(nil, true),
				offset = {
					20,
					80,
					1,
				},
				size_addition = {
					-40,
					0,
				},
			},
		},
	}, "objective"),
}
local animations = {
	on_enter = {
		{
			end_time = 0.6,
			name = "fade_in",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				for _, widget in pairs(widgets) do
					widget.alpha_multiplier = 0
				end
			end,
		},
		{
			end_time = 0.8,
			name = "move",
			start_time = 0.35,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				for _, widget in pairs(widgets) do
					widget.alpha_multiplier = anim_progress
				end

				local x_anim_distance_max = 50
				local x_anim_distance = x_anim_distance_max - x_anim_distance_max * anim_progress
				local extra_amount = math.clamp(15 - 15 * (anim_progress * 1.2), 0, 15)

				parent:_set_scenegraph_position("page_header", scenegraph_definition.page_header.position[1] - x_anim_distance)
				parent:_set_scenegraph_position("play_button", scenegraph_definition.play_button.position[1] + x_anim_distance)
				parent:_set_scenegraph_position("option_1", scenegraph_definition.option_1.position[1] - x_anim_distance)
				parent:_set_scenegraph_position("option_4", scenegraph_definition.option_4.position[1] - x_anim_distance)
			end,
		},
	},
	on_enter_fast = {
		{
			end_time = 0.45,
			name = "fade_in",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				for _, widget in pairs(widgets) do
					widget.alpha_multiplier = anim_progress
				end
			end,
		},
	},
}

return {
	animations = animations,
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
}
