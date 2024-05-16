-- chunkname: @scripts/ui/views/story_mission_background_view/story_mission_background_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
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
			194,
			194,
		},
		position = {
			60,
			60,
			0,
		},
	},
	corner_bottom_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			200,
			268,
		},
		position = {
			0,
			0,
			62,
		},
	},
	corner_bottom_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			200,
			268,
		},
		position = {
			0,
			0,
			62,
		},
	},
	corner_top_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			540,
			224,
		},
		position = {
			0,
			-650,
			55,
		},
	},
	wallet_pivot = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			-20,
			-800,
			56,
		},
	},
}
local widget_definitions = {
	corner_bottom_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/story_mission_lower_left",
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/effects/story_mission_lower_left_candles",
		},
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/story_mission_lower_right",
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/effects/story_mission_lower_right_candles",
		},
	}, "corner_bottom_right"),
	corner_top_right = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			style_id = "texture",
			value = "content/ui/materials/frames/screen/story_mission_lower_left",
			style = {
				offset = {
					0,
					-2,
					1,
				},
			},
		},
	}, "corner_top_right"),
	background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/panel_horizontal_half",
			style = {
				offset = {
					0,
					0,
					0,
				},
				color = {
					160,
					0,
					0,
					0,
				},
			},
		},
	}, "screen"),
}
local input_legend_params = {}
local intro_texts = {
	unlocalized_description_text = "",
	unlocalized_title_text = "",
}
local button_options_definitions = {
	{
		unlocalized_name = "",
		callback = function (self)
			local tab_bar_params = {
				hide_tabs = true,
				layer = 10,
				tabs_params = {
					{
						blur_background = false,
						display_name = "",
						view = "story_mission_play_view",
						context = {},
						input_legend_buttons = {
							{
								alignment = "right_alignment",
								display_name = "loc_mission_board_view_options",
								input_action = "hotkey_menu_special_1",
								on_pressed_callback = "_callback_open_options",
								visibility_function = function (parent, id)
									local active_view = parent._active_view_instance

									return active_view._missions and #active_view._missions > 0 and not active_view._mission_board_options and not active_view._is_in_matchmaking
								end,
							},
						},
					},
				},
			}

			self:_setup_tab_bar(tab_bar_params, {})
		end,
	},
	{
		unlocalized_name = "",
		callback = function (self)
			local tab_bar_params = {
				hide_tabs = true,
				layer = 10,
				tabs_params = {
					{
						blur_background = false,
						display_name = "",
						view = "story_mission_play_view",
						context = {
							play_fast_enter_animation = true,
						},
						input_legend_buttons = {
							{
								alignment = "right_alignment",
								display_name = "loc_mission_board_view_options",
								input_action = "hotkey_menu_special_1",
								on_pressed_callback = "_callback_open_options",
								visibility_function = function (parent, id)
									local active_view = parent._active_view_instance

									return not active_view._mission_board_options and not active_view._is_in_matchmaking
								end,
							},
						},
					},
				},
			}

			self:_setup_tab_bar(tab_bar_params, {})
		end,
	},
	{
		unlocalized_name = "",
		callback = function (self)
			local tab_bar_params = {
				hide_tabs = true,
				layer = 10,
				tabs_params = {
					{
						blur_background = false,
						display_name = "",
						view = "story_mission_lore_view",
						context = {},
					},
				},
			}

			self:_setup_tab_bar(tab_bar_params, {})
		end,
	},
}
local background_world_params = {
	level_name = "content/levels/ui/story_mission_background/story_mission_background",
	register_camera_event = "event_register_camera",
	shading_environment = "content/shading_environments/ui/story_mission_background",
	timer_name = "ui",
	total_blur_duration = 0.5,
	viewport_layer = 1,
	viewport_name = "ui_story_mission_background_world_viewport",
	viewport_type = "default",
	world_layer = 1,
	world_name = "ui_story_mission_background_world",
}

return {
	starting_option_index = 1,
	intro_texts = intro_texts,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	button_options_definitions = button_options_definitions,
	input_legend_params = input_legend_params,
	background_world_params = background_world_params,
}
