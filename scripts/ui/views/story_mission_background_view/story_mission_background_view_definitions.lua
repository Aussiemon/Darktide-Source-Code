local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			3
		}
	},
	page_header = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			194,
			194
		},
		position = {
			60,
			60,
			0
		}
	},
	corner_bottom_left = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			200,
			268
		},
		position = {
			0,
			0,
			62
		}
	},
	corner_bottom_right = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			200,
			268
		},
		position = {
			0,
			0,
			62
		}
	},
	corner_top_right = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			540,
			224
		},
		position = {
			0,
			-650,
			55
		}
	},
	wallet_pivot = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-20,
			-800,
			56
		}
	}
}
local widget_definitions = {
	corner_bottom_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/story_mission_lower_left"
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/effects/story_mission_lower_left_candles"
		}
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/story_mission_lower_right"
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/effects/story_mission_lower_right_candles"
		}
	}, "corner_bottom_right"),
	corner_top_right = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/story_mission_lower_left",
			style_id = "texture",
			pass_type = "texture_uv",
			style = {
				offset = {
					0,
					-2,
					1
				}
			}
		}
	}, "corner_top_right"),
	background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/panel_horizontal_half",
			pass_type = "texture",
			style = {
				offset = {
					0,
					0,
					0
				},
				color = {
					160,
					0,
					0,
					0
				}
			}
		}
	}, "screen")
}
local input_legend_params = {}
local intro_texts = {
	unlocalized_description_text = "",
	unlocalized_title_text = ""
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
						display_name = "",
						blur_background = false,
						view = "story_mission_play_view",
						context = {},
						input_legend_buttons = {
							{
								input_action = "hotkey_menu_special_1",
								display_name = "loc_mission_board_view_options",
								alignment = "right_alignment",
								on_pressed_callback = "_callback_open_options",
								visibility_function = function (parent, id)
									local active_view = parent._active_view_instance

									return active_view._missions and #active_view._missions > 0 and not active_view._mission_board_options and not active_view._is_in_matchmaking
								end
							}
						}
					}
				}
			}

			self:_setup_tab_bar(tab_bar_params, {})
		end
	},
	{
		unlocalized_name = "",
		callback = function (self)
			local tab_bar_params = {
				hide_tabs = true,
				layer = 10,
				tabs_params = {
					{
						display_name = "",
						blur_background = false,
						view = "story_mission_play_view",
						context = {
							play_fast_enter_animation = true
						},
						input_legend_buttons = {
							{
								input_action = "hotkey_menu_special_1",
								display_name = "loc_mission_board_view_options",
								alignment = "right_alignment",
								on_pressed_callback = "_callback_open_options",
								visibility_function = function (parent, id)
									local active_view = parent._active_view_instance

									return not active_view._mission_board_options and not active_view._is_in_matchmaking
								end
							}
						}
					}
				}
			}

			self:_setup_tab_bar(tab_bar_params, {})
		end
	},
	{
		unlocalized_name = "",
		callback = function (self)
			local tab_bar_params = {
				hide_tabs = true,
				layer = 10,
				tabs_params = {
					{
						view = "story_mission_lore_view",
						display_name = "",
						blur_background = false,
						context = {}
					}
				}
			}

			self:_setup_tab_bar(tab_bar_params, {})
		end
	}
}
local background_world_params = {
	shading_environment = "content/shading_environments/ui/story_mission_background",
	world_layer = 1,
	total_blur_duration = 0.5,
	timer_name = "ui",
	viewport_type = "default",
	register_camera_event = "event_register_camera",
	viewport_name = "ui_story_mission_background_world_viewport",
	viewport_layer = 1,
	level_name = "content/levels/ui/story_mission_background/story_mission_background",
	world_name = "ui_story_mission_background_world"
}

return {
	starting_option_index = 1,
	intro_texts = intro_texts,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	button_options_definitions = button_options_definitions,
	input_legend_params = input_legend_params,
	background_world_params = background_world_params
}
