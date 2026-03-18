-- chunkname: @scripts/ui/views/expedition_play_view/expedition_play_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ExpeditionPlayViewSettings = require("scripts/ui/views/expedition_play_view/expedition_play_view_settings")
local option_size = {
	400,
	100,
}
local tutorial_window_size = ExpeditionPlayViewSettings.tutorial_window_size
local tutorial_grid_size = ExpeditionPlayViewSettings.tutorial_grid_size
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
	reward_area = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			664,
			130,
		},
		position = {
			-105,
			60,
			4,
		},
	},
	reward_progress_bar = {
		horizontal_alignment = "left",
		parent = "reward_area",
		vertical_alignment = "center",
		size = {
			510,
			56,
		},
		position = {
			93,
			0,
			1,
		},
	},
	reward_change_button = {
		horizontal_alignment = "right",
		parent = "reward_area",
		vertical_alignment = "bottom",
		size = {
			option_size[1],
			30,
		},
		position = {
			-65,
			0,
			1,
		},
	},
	node_map = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "top",
		size = ExpeditionPlayViewSettings.node_map_size,
		position = {
			-70,
			197,
			0,
		},
	},
	tutorial_window = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = tutorial_window_size,
		position = {
			0,
			30,
			170,
		},
	},
	tutorial_grid = {
		horizontal_alignment = "right",
		parent = "tutorial_window",
		vertical_alignment = "bottom",
		size = tutorial_grid_size,
		position = {
			-60,
			-120,
			2,
		},
	},
	tutorial_button_1 = {
		horizontal_alignment = "center",
		parent = "tutorial_window",
		vertical_alignment = "bottom",
		size = {
			300,
			40,
		},
		position = {
			-170,
			-40,
			3,
		},
	},
	tutorial_button_2 = {
		horizontal_alignment = "center",
		parent = "tutorial_window",
		vertical_alignment = "bottom",
		size = {
			300,
			40,
		},
		position = {
			170,
			-40,
			3,
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

local widget_definitions = {
	node_map = UIWidget.create_definition({
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
					2,
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
			offset = {
				0,
				0,
				1,
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
					0,
				},
			},
		},
	}, "node_map"),
	reward_progress_bar = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			style_id = "bar",
			value = "content/ui/materials/bars/heavy/fill_electric",
			style = {
				horizontal_alignment = "left",
				size = {},
				material_values = {
					progression = 0,
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
				offset = {
					0,
					0,
					1,
				},
				color = {
					255,
					255,
					255,
					255,
				},
			},
			change_function = function (content, style)
				local progress = content.progress or 0
				local bar_length = content.bar_length or 0

				style.material_values.progression = progress
				style.uvs[2][1] = progress
				style.size[1] = bar_length * progress
			end,
		},
		{
			pass_type = "texture",
			style_id = "frame_smoke",
			value = "content/ui/materials/bars/heavy/frame_effect_smoke",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size_addition = {
					122,
					110,
				},
				offset = {
					0,
					0,
					3,
				},
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "frame_effect",
			value = "content/ui/materials/bars/heavy/frame_effect_electric",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size_addition = {
					122,
					110,
				},
				offset = {
					0,
					0,
					4,
				},
				color = {
					255,
					255,
					255,
					255,
				},
				material_values = {
					progression = 0,
				},
			},
			change_function = function (content, style)
				style.material_values.progression = content.progress or 0
			end,
		},
		{
			pass_type = "texture",
			style_id = "end",
			value = "content/ui/materials/bars/heavy/fill_end",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size_addition = {
					0,
					30,
				},
				size = {
					96,
				},
				offset = {
					0,
					0,
					6,
				},
				color = {
					255,
					255,
					255,
					255,
				},
			},
			change_function = function (content, style)
				local progress = content.progress or 0
				local bar_length = content.bar_length or 0

				style.offset[1] = bar_length * progress - 49

				local alpha_multiplier = math.clamp(progress / 0.2, 0, 1)

				style.color[1] = 255 * alpha_multiplier
			end,
		},
	}, "reward_progress_bar", {
		bar_length = 510,
		progress = 0,
	}),
	reward_change_button = UIWidget.create_definition(ButtonPassTemplates.input_legend_button, "reward_change_button", {
		text = "",
		visible = true,
	}),
	reward_area = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "bar_background",
			value = "content/ui/materials/frames/expeditions/progress_bar_background",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					0,
				},
				color = Color.white(nil, true),
				size = {
					664,
					112,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "bar_background_2",
			value = "content/ui/materials/frames/expeditions/progress_bar_background_2",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					6,
				},
				color = Color.white(nil, true),
				size = {
					664,
					112,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "bar_frame",
			value = "content/ui/materials/frames/expeditions/progress_bar_frame",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					10,
				},
				color = Color.white(nil, true),
				size = {
					664,
					112,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "currency_icon",
			value = "content/ui/materials/icons/currencies/premium_big",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = {
					255,
					255,
					255,
					255,
				},
				size = {
					41.6,
					35.2,
				},
				offset = {
					-275,
					0,
					12,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/icons/engrams/engram_rarity_04",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = {
					255,
					255,
					255,
					255,
				},
				size = {
					192,
					128,
				},
				offset = {
					315,
					0,
					12,
				},
				material_values = {
					texture_map = "content/ui/textures/icons/engrams/engram_rarity_04",
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "icon_glow",
			value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_background_glow",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.item_rarity_4(255, true),
				size = {
					165,
					165,
				},
				offset = {
					315,
					0,
					11,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "header_title",
			value = "ENCRYPTED DRIVE",
			value_id = "header_title",
			style = {
				drop_shadow = true,
				font_size = 32,
				font_type = "machine_medium",
				material = "content/ui/materials/font_gradients/slug_font_gradient_header",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "top",
				vertical_alignment = "top",
				text_color = Color.white(nil, true),
				offset = {
					85,
					0,
					3,
				},
				size_addition = {
					0,
					0,
				},
				size = {
					nil,
					30,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "counter_title",
			value = "9999 / 9999 Collected",
			value_id = "counter_title",
			style = {
				drop_shadow = true,
				font_size = 20,
				font_type = "proxima_nova_bold",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "bottom",
				vertical_alignment = "bottom",
				text_color = Color.terminal_text_header(nil, true),
				offset = {
					85,
					0,
					3,
				},
				size_addition = {
					0,
					0,
				},
				size = {
					nil,
					30,
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
	}, "reward_area"),
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
		hotspot = {
			on_pressed_sound = nil,
		},
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
			value = "Expeditions",
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
local tutorial_widgets_definitions = {
	tutorial_window = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size_addition = {
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
			style_id = "image",
			value = "content/ui/materials/backgrounds/default_square",
			value_id = "image",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				size = {
					tutorial_window_size[1] - (tutorial_grid_size[1] + 60),
					tutorial_window_size[2],
				},
				color = {
					255,
					255,
					255,
					255,
				},
				offset = {
					0,
					0,
					2,
				},
			},
		},
		{
			pass_type = "rect",
			style_id = "screen_background",
			style = {
				horizontal_alignment = "center",
				scenegraph_id = "screen",
				vertical_alignment = "center",
				color = {
					100,
					0,
					0,
					0,
				},
				offset = {
					0,
					0,
					169,
				},
				size_addition = {
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "screen_background_vignette",
			value = "content/ui/materials/masks/gradient_vignette",
			style = {
				scenegraph_id = "screen",
				color = {
					100,
					0,
					0,
					0,
				},
				offset = {
					0,
					0,
					168,
				},
			},
		},
		{
			pass_type = "rect",
			style_id = "window_background",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = {
					100,
					0,
					0,
					0,
				},
				offset = {
					0,
					0,
					-1,
				},
				size_addition = {
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					24,
					24,
				},
				color = Color.terminal_grid_background(nil, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "background_gradient",
			value = "content/ui/materials/gradients/gradient_vertical",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.black(200, true),
				offset = {
					0,
					0,
					3,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "outer_shadow",
			value = "content/ui/materials/frames/dropshadow_large",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.black(200, true),
				size_addition = {
					96,
					96,
				},
				offset = {
					0,
					0,
					5,
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
					4,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_corner(nil, true),
				offset = {
					0,
					0,
					5,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "title",
			value_id = "title",
			style = {
				font_size = 28,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "right",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "top",
				vertical_alignment = "top",
				text_color = Color.terminal_text_header(255, true),
				size = {
					tutorial_grid_size[1],
					0,
				},
				offset = {
					-60,
					35,
					7,
				},
				size_addition = {
					0,
					0,
				},
			},
			value = Localize("loc_alias_talent_builder_view_popup_title_summary"),
		},
		{
			pass_type = "text",
			style_id = "page_counter",
			value = "0/0",
			value_id = "page_counter",
			style = {
				font_size = 20,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "right",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "top",
				vertical_alignment = "top",
				text_color = Color.terminal_text_body_sub_header(255, true),
				size = {
					tutorial_grid_size[1],
					0,
				},
				offset = {
					-60,
					70,
					7,
				},
				size_addition = {
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "edge_top",
			value = "content/ui/materials/dividers/horizontal_dynamic_upper",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					nil,
					10,
				},
				size_addition = {
					10,
					0,
				},
				color = Color.terminal_text_header(255, true),
				offset = {
					0,
					-4,
					14,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "edge_bottom",
			value = "content/ui/materials/dividers/horizontal_dynamic_lower",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					nil,
					10,
				},
				size_addition = {
					10,
					0,
				},
				color = Color.terminal_text_header(255, true),
				offset = {
					0,
					4,
					14,
				},
			},
		},
	}, "tutorial_window"),
	tutorial_button_1 = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "tutorial_button_1", {
		text = "tutorial_button_1",
		visible = true,
	}),
	tutorial_button_2 = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "tutorial_button_2", {
		text = "tutorial_button_2",
		visible = true,
	}),
}
local tutorial_window_open_delay = 0.5
local animations = {
	tutorial_window_open = {
		{
			name = "init",
			start_time = 0,
			end_time = tutorial_window_open_delay,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				local tutorial_window = widgets.tutorial_window

				for _, pass_style in pairs(tutorial_window.style) do
					local color = pass_style.text_color or pass_style.color

					if color then
						color[1] = 0
					end
				end

				widgets.tutorial_button_1.alpha_multiplier = 0
				widgets.tutorial_button_2.alpha_multiplier = 0

				local tutorial_grid = parent._tutorial_grid
				local grid_widgets = tutorial_grid and tutorial_grid:widgets()

				if grid_widgets then
					for i = 1, #grid_widgets do
						grid_widgets[i].alpha_multiplier = 0
					end
				end
			end,
		},
		{
			end_time = 1.2,
			name = "fade_in_background",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeCubic(progress)
				local tutorial_window = widgets.tutorial_window
				local alpha = 100 * anim_progress

				tutorial_window.style.screen_background.color[1] = alpha
				tutorial_window.style.screen_background_vignette.color[1] = alpha
			end,
		},
		{
			name = "fade_in_window",
			start_time = tutorial_window_open_delay,
			end_time = tutorial_window_open_delay + 0.2,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeOutCubic(progress)
				local tutorial_window = widgets.tutorial_window
				local alpha = 255 * anim_progress
				local window_style = tutorial_window.style

				window_style.background.color[1] = alpha
				window_style.background_gradient.color[1] = 200 * anim_progress
				window_style.outer_shadow.color[1] = 200 * anim_progress
				window_style.frame.color[1] = alpha
				window_style.corner.color[1] = alpha
				window_style.edge_top.color[1] = alpha
				window_style.edge_bottom.color[1] = alpha
				window_style.window_background.color[1] = alpha
			end,
		},
		{
			name = "fade_in_content",
			start_time = tutorial_window_open_delay + 0.4,
			end_time = tutorial_window_open_delay + 0.7,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeOutCubic(progress)
				local tutorial_grid = parent._tutorial_grid
				local grid_widgets = tutorial_grid and tutorial_grid:widgets()

				if grid_widgets then
					for i = 1, #grid_widgets do
						grid_widgets[i].alpha_multiplier = anim_progress
					end
				end

				widgets.tutorial_button_1.alpha_multiplier = anim_progress
				widgets.tutorial_button_2.alpha_multiplier = anim_progress

				local alpha = 255 * anim_progress
				local tutorial_window = widgets.tutorial_window

				tutorial_window.style.title.text_color[1] = alpha
				tutorial_window.style.page_counter.text_color[1] = alpha
				tutorial_window.style.image.color[1] = alpha
			end,
		},
		{
			name = "move",
			start_time = tutorial_window_open_delay + 0,
			end_time = tutorial_window_open_delay + 0.4,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				parent:_set_scenegraph_size("tutorial_window", nil, 100)
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeCubic(progress)
				local y_anim_distance_max = 50
				local y_anim_distance = y_anim_distance_max - y_anim_distance_max * anim_progress

				parent:_set_scenegraph_size("tutorial_window", nil, 100 + (scenegraph_definition.tutorial_window.size[2] - 100) * anim_progress)
			end,
		},
	},
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
local input_legend_params = {
	layer = 10,
	buttons_params = {
		{
			alignment = "left_alignment",
			display_name = "loc_settings_menu_close_menu",
			input_action = "back",
			on_pressed_callback = "cb_on_close_pressed",
			visibility_function = function (parent)
				return parent._regions_latency ~= nil
			end,
		},
	},
}

return {
	input_legend_params = input_legend_params,
	animations = animations,
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	tutorial_widgets_definitions = tutorial_widgets_definitions,
}
