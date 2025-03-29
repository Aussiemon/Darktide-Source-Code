-- chunkname: @scripts/ui/views/havoc_play_view/havoc_play_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ColorUtilities = require("scripts/utilities/ui/colors")
local StepperPassTemplates = require("scripts/ui/pass_templates/stepper_pass_templates")
local column_width = 483
local column_spacing = 100
local mission_detail_background_size = {
	column_width + 200,
	554,
}
local badge_size = {
	294,
	235.2,
}
local mission_detail_grid_size = {
	mission_detail_background_size[1] - 30,
	mission_detail_background_size[2],
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
			80,
		},
		position = {
			130,
			10,
			2,
		},
	},
	page_sub_header = {
		horizontal_alignment = "left",
		parent = "page_header",
		vertical_alignment = "top",
		size = {
			1300,
			100,
		},
		position = {
			0,
			30,
			0,
		},
	},
	reward_area = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			400,
			630,
		},
		position = {
			-150,
			32,
			1,
		},
	},
	reward_title = {
		horizontal_alignment = "left",
		parent = "reward_area",
		vertical_alignment = "top",
		size = {
			400,
			30,
		},
		position = {
			0,
			0,
			1,
		},
	},
	reward_description = {
		horizontal_alignment = "left",
		parent = "reward_area",
		vertical_alignment = "top",
		size = {
			400,
			50,
		},
		position = {
			0,
			40,
			1,
		},
	},
	reward_objective_1 = {
		horizontal_alignment = "left",
		parent = "reward_area",
		vertical_alignment = "top",
		size = {
			400,
			50,
		},
		position = {
			0,
			150,
			1,
		},
	},
	reward_objective_2 = {
		horizontal_alignment = "left",
		parent = "reward_area",
		vertical_alignment = "top",
		size = {
			400,
			50,
		},
		position = {
			0,
			210,
			1,
		},
	},
	weekly_reward = {
		horizontal_alignment = "right",
		parent = "reward_area",
		vertical_alignment = "top",
		size = {
			400,
			160,
		},
		position = {
			0,
			340,
			1,
		},
	},
	reward_header = {
		horizontal_alignment = "left",
		parent = "weekly_reward",
		vertical_alignment = "top",
		size = {
			400,
			30,
		},
		position = {
			0,
			-40,
			1,
		},
	},
	mission_area = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			1040,
			544,
		},
		position = {
			130,
			160,
			1,
		},
	},
	mission_detail_grid_background = {
		horizontal_alignment = "right",
		parent = "detail",
		vertical_alignment = "top",
		size = mission_detail_background_size,
		position = {
			0,
			0,
			2,
		},
	},
	mission_detail_grid = {
		horizontal_alignment = "right",
		parent = "detail",
		vertical_alignment = "top",
		size = mission_detail_grid_size,
		position = {
			mission_detail_grid_size[1] + 10,
			-12,
			2,
		},
	},
	havoc_stepper = {
		horizontal_alignment = "center",
		parent = "play_button",
		vertical_alignment = "bottom",
		size = {
			600,
			180,
		},
		position = {
			0,
			60,
			3,
		},
	},
	detail = {
		horizontal_alignment = "left",
		parent = "mission_area",
		vertical_alignment = "top",
		size = {
			column_width,
			344,
		},
		position = {
			0,
			250,
			2,
		},
	},
	current_rank_header = {
		horizontal_alignment = "center",
		parent = "detail",
		vertical_alignment = "top",
		size = {
			column_width,
			25,
		},
		position = {
			0,
			-290,
			0,
		},
	},
	current_rank = {
		horizontal_alignment = "center",
		parent = "current_rank_header",
		vertical_alignment = "top",
		size = badge_size,
		position = {
			0,
			-10,
			5,
		},
	},
	detail_header = {
		horizontal_alignment = "right",
		parent = "detail",
		vertical_alignment = "top",
		size = {
			column_width,
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
			column_width,
			269,
		},
		position = {
			0,
			269,
			0,
		},
	},
	objective = {
		horizontal_alignment = "left",
		parent = "detail",
		vertical_alignment = "bottom",
		size = {
			column_width,
			200,
		},
		position = {
			0,
			210,
			0,
		},
	},
	objective_header = {
		horizontal_alignment = "left",
		parent = "objective",
		vertical_alignment = "top",
		size = {
			column_width,
			68,
		},
		position = {
			0,
			0,
			10,
		},
	},
	reward_timer = {
		horizontal_alignment = "left",
		parent = "objective",
		vertical_alignment = "bottom",
		size = {
			800,
			30,
		},
		position = {
			0,
			0,
			1,
		},
	},
	play_button = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = ButtonPassTemplates.default_button.size,
		position = {
			-180,
			-150,
			15,
		},
	},
	party_finder_button = {
		horizontal_alignment = "right",
		parent = "play_button",
		vertical_alignment = "bottom",
		size = ButtonPassTemplates.terminal_button.size,
		position = {
			0,
			-180,
			15,
		},
	},
	play_button_disabled_info = {
		horizontal_alignment = "center",
		parent = "play_button",
		vertical_alignment = "top",
		size = {
			380,
			80,
		},
		position = {
			0,
			80,
			3,
		},
	},
}

local function reward_objective_definition(scenegraph_id, text)
	return UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background",
			style = {
				color = {
					200,
					10,
					10,
					10,
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
					3,
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
					4,
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
				color = Color.black(255, true),
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
			style_id = "icon_background",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				color = Color.terminal_grid_background_gradient(nil, true),
				size = {
					50,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "checkmark",
			value = "",
			value_id = "checkmark",
			style = {
				drop_shadow = false,
				font_size = 46,
				font_type = "proxima_nova_bold",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				text_color = Color.black(200, true),
				complete_text_color = Color.terminal_text_key_value(255, true),
				incomplete_text_color = Color.black(200, true),
				offset = {
					0,
					0,
					2,
				},
				size = {
					50,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			value = text,
			style = {
				font_size = 16,
				font_type = "proxima_nova_bold",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					60,
					0,
					1,
				},
				size_addition = {
					-140,
					0,
				},
			},
		},
	}, scenegraph_id)
end

local function rank_objective_definition(scenegraph_id, text)
	return UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background",
			style = {
				color = {
					200,
					10,
					10,
					10,
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
					3,
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
					4,
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
				color = Color.black(255, true),
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
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			value = text,
			style = {
				font_size = 16,
				font_type = "proxima_nova_bold",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					20,
					0,
					1,
				},
				size_addition = {
					-90,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "counter",
			value = "0",
			value_id = "counter",
			style = {
				font_size = 26,
				font_type = "machine_medium",
				horizontal_alignment = "right",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				text_color = Color.terminal_text_body(255, true),
				offset = {
					40,
					0,
					1,
				},
				size = {
					150,
				},
			},
		},
	}, scenegraph_id)
end

local widget_definitions = {
	current_order_charges_remaining_description = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			style = {
				drop_shadow = true,
				font_size = 24,
				font_type = "proxima_nova_bold",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "top",
				offset = {
					0,
					-40,
					1,
				},
				size_addition = {
					0,
					0,
				},
				text_color = Color.terminal_text_body_sub_header(nil, true),
			},
			value = Localize("loc_havoc_attempts"),
		},
		{
			pass_type = "texture",
			style_id = "havoc_charge_1",
			value = "content/ui/materials/base/ui_default_base",
			value_id = "havoc_charge_1",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				color = Color.terminal_text_header(255, true),
				offset = {
					-40,
					0,
					1,
				},
				size = {
					31,
					31,
				},
				material_values = {
					texture_map = "content/ui/textures/icons/generic/havoc_strike",
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "havoc_charge_2",
			value = "content/ui/materials/base/ui_default_base",
			value_id = "havoc_charge_2",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				color = Color.terminal_text_header(255, true),
				offset = {
					0,
					0,
					1,
				},
				size = {
					31,
					31,
				},
				material_values = {
					texture_map = "content/ui/textures/icons/generic/havoc_strike",
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "havoc_charge_3",
			value = "content/ui/materials/base/ui_default_base",
			value_id = "havoc_charge_3",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				color = Color.terminal_text_header(255, true),
				offset = {
					40,
					0,
					1,
				},
				size = {
					31,
					31,
				},
				material_values = {
					texture_map = "content/ui/textures/icons/generic/havoc_strike",
				},
			},
		},
	}, "havoc_stepper"),
	mission_detail_grid_background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "screen",
			style = {
				offset = {
					0,
					0,
					1,
				},
				color = Color.terminal_frame(0, true),
			},
		},
	}, "mission_detail_grid_background"),
	reward_objective_1 = reward_objective_definition("reward_objective_1", Localize("loc_havoc_reward_objective_order")),
	reward_objective_2 = rank_objective_definition("reward_objective_2", Localize("loc_havoc_reward_objective_highest_weekly")),
	weekly_reward = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_frame(nil, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.terminal_corner(nil, true),
				offset = {
					0,
					0,
					7,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "background_gradient",
			value = "content/ui/materials/masks/gradient_horizontal_sides_02",
			value_id = "background_gradient",
			style = {
				scale_to_material = true,
				color = Color.terminal_background_gradient(nil, true),
				size_addition = {
					0,
					-40,
				},
				offset = {
					0,
					0,
					2,
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
				color = Color.terminal_frame(nil, true),
				offset = {
					0,
					0,
					6,
				},
				size_addition = {
					0,
					-40,
				},
			},
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
					-40,
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
			style_id = "outer_shadow",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.black(255, true),
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
					0,
					-20,
					7,
				},
				material_values = {
					texture_map = "content/ui/textures/icons/engrams/engram_rarity_01",
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
				color = Color.item_rarity_1(255, true),
				size = {
					165,
					165,
				},
				offset = {
					0,
					-20,
					6,
				},
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
					-20,
					-6,
					4,
				},
				default_offset = {
					-20,
					-6,
					4,
				},
				size = {
					42,
					30,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "reward_icon_2",
			value = "content/ui/materials/icons/currencies/plasteel_small",
			value_id = "reward_icon_2",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				offset = {
					-60,
					-6,
					4,
				},
				default_offset = {
					-60,
					-6,
					4,
				},
				size = {
					42,
					30,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "reward_icon_3",
			value = "content/ui/materials/icons/currencies/diamantine_small",
			value_id = "reward_icon_3",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				offset = {
					-100,
					-6,
					4,
				},
				default_offset = {
					-100,
					-6,
					4,
				},
				size = {
					42,
					30,
				},
			},
		},
	}, "weekly_reward"),
	reward_header = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			style = {
				drop_shadow = true,
				font_size = 20,
				font_type = "proxima_nova_bold",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "bottom",
				offset = {
					0,
					0,
					1,
				},
				size_addition = {
					0,
					0,
				},
				text_color = Color.terminal_text_body(nil, true),
			},
			value = Localize("loc_havoc_reset_rewards"),
		},
	}, "reward_header"),
	reward_title = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			style = {
				drop_shadow = true,
				font_size = 36,
				font_type = "machine_medium",
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
			value = Localize("loc_havoc_weekly_cache_name"),
		},
	}, "reward_title"),
	reward_description = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			style = {
				drop_shadow = true,
				font_size = 20,
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
				text_color = Color.terminal_text_body(nil, true),
			},
			value = Localize("loc_havoc_reward_objective_description"),
		},
	}, "reward_description"),
	current_rank_header = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			style = {
				drop_shadow = true,
				font_size = 36,
				font_type = "machine_medium",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				offset = {
					0,
					0,
					1,
				},
				text_color = Color.terminal_text_header(nil, true),
			},
			value = Localize("loc_havoc_order_info_overlay"),
		},
	}, "current_rank_header"),
	reward_timer_header = UIWidget.create_definition({
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
				offset = {
					0,
					30,
					1,
				},
				text_color = Color.terminal_text_body(255, true),
			},
			value = Localize("loc_havoc_time"),
		},
	}, "reward_timer"),
	play_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "play_button", {
		gamepad_action = "confirm_pressed",
		original_text = Utf8.upper(Localize("loc_story_mission_play_menu_button_start_mission")),
		hotspot = {},
	}),
	party_finder_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "party_finder_button", {
		gamepad_action = "secondary_action_pressed",
		original_text = Utf8.upper(Localize("loc_group_finder_menu_title")),
		hotspot = {},
	}),
	page_header = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			style = {
				drop_shadow = true,
				font_size = 55,
				font_type = "machine_medium",
				material = "content/ui/materials/font_gradients/slug_font_gradient_gold",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				text_color = Color.white(nil, true),
				offset = {
					0,
					0,
					1,
				},
			},
			value = Localize("loc_havoc_name"),
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
		{
			pass_type = "rect",
			scenegraph_id = "detail_location",
			style_id = "locked_background",
			style = {
				color = Color.black(150, true),
				offset = {
					0,
					0,
					6,
				},
			},
			visibility_function = function (content)
				return content.locked
			end,
		},
		{
			pass_type = "text",
			scenegraph_id = "detail_location",
			style_id = "location_lock",
			value = "",
			style = {
				drop_shadow = false,
				font_size = 160,
				font_type = "itc_novarese_bold",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				text_color = Color.black(200, true),
				offset = {
					0,
					0,
					7,
				},
			},
			visibility_function = function (content)
				return content.locked
			end,
		},
		{
			pass_type = "text",
			scenegraph_id = "detail_location",
			style_id = "participant_title",
			value_id = "participant_title",
			value = Localize("loc_main_menu_warband_count"),
			style = {
				drop_shadow = true,
				font_size = 20,
				font_type = "proxima_nova_bold",
				text_vertical_alignment = "top",
				text_color = Color.terminal_text_header(nil, true),
				offset = {
					20,
					10,
					8,
				},
			},
			visibility_function = function (content)
				return content.locked
			end,
		},
		{
			pass_type = "text",
			scenegraph_id = "detail_location",
			style_id = "participant_1",
			value = "",
			value_id = "participant_1",
			style = {
				drop_shadow = true,
				font_size = 18,
				font_type = "proxima_nova_bold",
				text_vertical_alignment = "top",
				text_color = Color.terminal_text_body(nil, true),
				offset = {
					20,
					48,
					8,
				},
				size_addition = {
					-40,
					0,
				},
			},
			visibility_function = function (content)
				return content.locked
			end,
		},
		{
			pass_type = "text",
			scenegraph_id = "detail_location",
			style_id = "participant_2",
			value = "",
			value_id = "participant_2",
			style = {
				drop_shadow = true,
				font_size = 18,
				font_type = "proxima_nova_bold",
				text_vertical_alignment = "top",
				text_color = Color.terminal_text_body(nil, true),
				offset = {
					20,
					71,
					8,
				},
				size_addition = {
					-40,
					0,
				},
			},
			visibility_function = function (content)
				return content.locked
			end,
		},
		{
			pass_type = "text",
			scenegraph_id = "detail_location",
			style_id = "participant_3",
			value = "",
			value_id = "participant_3",
			style = {
				drop_shadow = true,
				font_size = 18,
				font_type = "proxima_nova_bold",
				text_vertical_alignment = "top",
				text_color = Color.terminal_text_body(nil, true),
				offset = {
					20,
					94,
					8,
				},
				size_addition = {
					-40,
					0,
				},
			},
			visibility_function = function (content)
				return content.locked
			end,
		},
		{
			pass_type = "text",
			scenegraph_id = "detail_location",
			style_id = "participant_4",
			value = "",
			value_id = "participant_4",
			style = {
				drop_shadow = true,
				font_size = 18,
				font_type = "proxima_nova_bold",
				text_vertical_alignment = "top",
				text_color = Color.terminal_text_body(nil, true),
				offset = {
					20,
					117,
					8,
				},
				size_addition = {
					-40,
					0,
				},
			},
			visibility_function = function (content)
				return content.locked
			end,
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
	play_button_disabled_info = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background",
			style = {
				color = {
					150,
					58,
					15,
					15,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				scale_to_material = true,
				color = Color.ui_interaction_critical(255, true),
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
					10,
					0,
					2,
				},
				size_addition = {
					-20,
					0,
				},
			},
		},
	}, "play_button_disabled_info"),
}
local grid_blueprints = {
	dynamic_spacing = {
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return size and {
				size[1],
				size[2],
			} or {
				225,
				20,
			}
		end,
	},
	texture = {
		size = {
			64,
			64,
		},
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return size and {
				size[1],
				size[2],
			} or {
				64,
				64,
			}
		end,
		pass_template = {
			{
				pass_type = "texture",
				style_id = "texture",
				value_id = "texture",
				style = {
					color = {
						255,
						255,
						255,
						255,
					},
				},
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local texture = element.texture

			content.texture = texture

			local texture_color = element.color

			if texture_color then
				local color = style.texture.color

				color[1] = texture_color[1]
				color[2] = texture_color[2]
				color[3] = texture_color[3]
				color[4] = texture_color[4]
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
		end,
	},
	header = {
		size = {
			mission_detail_grid_size[1],
			100,
		},
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value = "n/a",
				value_id = "text",
				style = {
					font_size = 24,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "left",
					text_vertical_alignment = "center",
					text_color = Color.terminal_text_header(255, true),
					offset = {
						0,
						0,
						3,
					},
				},
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local text = element.text
			local new_indicator_width_offset = element.new_indicator_width_offset

			if new_indicator_width_offset then
				local offset = style.new_indicator.offset

				offset[1] = new_indicator_width_offset[1]
				offset[2] = new_indicator_width_offset[2]
				offset[3] = new_indicator_width_offset[3]
			end

			content.element = element
			content.text = text

			local size = content.size
			local text_style = style.text
			local text_options = UIFonts.get_font_options_by_style(text_style)
			local height = UIRenderer.text_height(ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)

			size[2] = height + 0
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
		end,
	},
	mutator = {
		size = {
			mission_detail_grid_size[1] / 2 - 5,
			mission_detail_grid_size[2] / 2 - 5,
		},
		pass_template = {
			{
				pass_type = "rect",
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
				pass_type = "texture",
				style_id = "background",
				value_id = "background",
				style = {
					color = {
						255,
						255,
						255,
						255,
					},
					offset = {
						0,
						0,
						1,
					},
				},
				visibility_function = function (content)
					return content.background
				end,
			},
			{
				pass_type = "rect",
				style = {
					color = Color.terminal_text_key_value(255, true),
					size = {
						5,
					},
					offset = {
						0,
						0,
						2,
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
				style_id = "outer_shadow",
				value = "content/ui/materials/frames/dropshadow_medium",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					color = Color.black(255, true),
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
				style_id = "icon",
				value = "content/ui/materials/icons/circumstances/special_waves_01",
				value_id = "icon",
				style = {
					size = {
						50,
						50,
					},
					offset = {
						25,
						10,
						3,
					},
					color = Color.terminal_text_key_value(255, true),
				},
			},
			{
				pass_type = "text",
				style_id = "header",
				value = "n/a",
				value_id = "header",
				style = {
					font_size = 22,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "left",
					text_vertical_alignment = "top",
					vertical_alignment = "center",
					text_color = Color.terminal_stat_bar_foreground(255, true),
					offset = {
						85,
						0,
						3,
					},
					size_addition = {
						-95,
						-20,
					},
				},
			},
			{
				pass_type = "text",
				style_id = "text",
				value = "n/a",
				value_id = "text",
				style = {
					font_size = 18,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "left",
					text_vertical_alignment = "top",
					vertical_alignment = "center",
					text_color = Color.terminal_text_body(255, true),
					offset = {
						85,
						0,
						3,
					},
					size_addition = {
						-95,
						-20,
					},
				},
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local optional_text_color = element.text_color

			if optional_text_color then
				ColorUtilities.color_copy(optional_text_color, style.text.text_color)
			end

			local text = element.text
			local header = element.header
			local icon = element.icon
			local background = element.background

			content.element = element
			content.text = text
			content.header = header
			content.icon = icon or "content/ui/materials/icons/circumstances/special_waves_01"
			content.background = background

			local total_text_height = 0
			local size = content.size

			if header then
				local text_style = style.header
				local text_options = UIFonts.get_font_options_by_style(text_style)
				local text_size = {
					size[1],
					size[2],
				}
				local size_addition = text_style.size_addition

				if size_addition then
					text_size[1] = text_size[1] + size_addition[1]
					text_size[2] = text_size[2] + size_addition[2]
				end

				local height = UIRenderer.text_height(ui_renderer, header, text_style.font_type, text_style.font_size, text_size, text_options)

				total_text_height = total_text_height + height
			end

			if text then
				local text_style = style.text
				local text_options = UIFonts.get_font_options_by_style(text_style)
				local text_size = {
					size[1],
					size[2],
				}
				local size_addition = text_style.size_addition

				if size_addition then
					text_size[1] = text_size[1] + size_addition[1]
					text_size[2] = text_size[2] + size_addition[2]
				end

				local height = UIRenderer.text_height(ui_renderer, text, text_style.font_type, text_style.font_size, text_size, text_options)

				text_style.offset[2] = total_text_height
				total_text_height = total_text_height + height
			end

			size[2] = math.max(total_text_height + 20, size[2])
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
		end,
	},
	body = {
		size = {
			mission_detail_grid_size[1],
			100,
		},
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value = "n/a",
				value_id = "text",
				style = {
					font_size = 20,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "left",
					text_vertical_alignment = "center",
					text_color = Color.text_default(255, true),
					offset = {
						0,
						0,
						3,
					},
				},
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local text = element.text
			local optional_text_color = element.text_color

			if optional_text_color then
				ColorUtilities.color_copy(optional_text_color, style.text.text_color)
			end

			content.element = element
			content.text = text

			local size = content.size
			local text_style = style.text
			local text_options = UIFonts.get_font_options_by_style(text_style)
			local height = UIRenderer.text_height(ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)

			size[2] = height + 0
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
		end,
	},
}
local animations = {
	on_enter = {
		{
			end_time = 0.6,
			name = "fade_in",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent.anim_alpha_multiplier = 0
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

				parent.anim_alpha_multiplier = anim_progress

				local x_anim_distance_max = 50
				local x_anim_distance = x_anim_distance_max - x_anim_distance_max * anim_progress
				local extra_amount = math.clamp(15 - 15 * (anim_progress * 1.2), 0, 15)

				parent:_set_scenegraph_position("page_header", scenegraph_definition.page_header.position[1] - x_anim_distance)
				parent:_set_scenegraph_position("play_button", scenegraph_definition.play_button.position[1] + x_anim_distance)
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

				parent.anim_alpha_multiplier = anim_progress
			end,
		},
	},
}
local rank_badges = {
	{
		level = 1,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_1",
	},
	{
		level = 5,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_2",
	},
	{
		level = 10,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_3",
	},
	{
		level = 15,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_4",
	},
	{
		level = 20,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_5",
	},
	{
		level = 25,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_6",
	},
	{
		level = 30,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_7",
	},
	{
		level = 35,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_8",
	},
}
local badge_definitions = {
	size = badge_size,
	pass_template_function = function (parent, config)
		local default_rank_texture = rank_badges[1].texture
		local circle_size = {
			100,
			100,
		}
		local letter_size = {
			60.199999999999996,
			60.199999999999996,
		}
		local letter_margin = 12.6
		local current_rank = config.rank
		local current_rank_badge = rank_badges[#rank_badges]

		for i = 1, #rank_badges do
			local rank_badge = rank_badges[i]
			local level = rank_badge.level

			if current_rank and current_rank < level then
				current_rank_badge = rank_badges[i - 1]

				break
			end
		end

		local pass_templates = {
			{
				pass_type = "circle",
				style_id = "havoc_badge_background",
				value_id = "havoc_badge_background",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					offset = {
						0,
						40,
						4,
					},
					size = {
						circle_size[1],
						circle_size[2],
					},
					color = Color.black(255, true),
				},
			},
		}

		pass_templates[#pass_templates + 1] = {
			pass_type = "texture",
			style_id = "current_havoc_rank_badge",
			value = "content/ui/materials/base/ui_default_base",
			value_id = "current_havoc_rank_badge",
			style = {
				horizontal_alignment = "center",
				color = Color.white(255, true),
				offset = {
					0,
					56,
					10,
				},
				size = {
					badge_size[1],
					badge_size[2],
				},
				material_values = {
					texture_map = current_rank_badge.texture,
				},
			},
		}

		local current_rank_to_string = tostring(current_rank)
		local current_rank_width = (letter_size[1] - letter_margin * 2) * #current_rank_to_string
		local start_next_offset = (badge_size[1] - current_rank_width) * 0.5 - letter_margin

		for i = 1, #current_rank_to_string do
			local rank_number = tonumber(string.sub(current_rank_to_string, i, i))
			local x_offset = start_next_offset + (letter_size[1] - letter_margin * 2) * (i - 1)

			pass_templates[#pass_templates + 1] = {
				pass_type = "texture",
				value = "content/ui/materials/frames/havoc_numbers",
				value_id = "current_havoc_rank_value_" .. i,
				style_id = "current_havoc_rank_value_" .. i,
				style = {
					horizontal_alignment = "left",
					start_offset_y = 125.99999999999999,
					size = {
						letter_size[1],
						letter_size[2],
					},
					color = Color.white(255, true),
					offset = {
						x_offset,
						125.99999999999999,
						6,
					},
					material_values = {
						number = rank_number,
					},
				},
			}
		end

		return pass_templates
	end,
}

return {
	animations = animations,
	grid_blueprints = grid_blueprints,
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	badge_definitions = badge_definitions,
}
