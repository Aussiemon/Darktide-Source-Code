-- chunkname: @scripts/ui/views/havoc_background_view/havoc_background_view_definitions.lua

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
			208,
			222
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
			value = "content/ui/materials/effects/screen/havoc_01_lower_left"
		}
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/effects/screen/havoc_01_lower_right"
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
	off_cadence = {
		description_text = "loc_havoc_off_season_description",
		title_text = "loc_havoc_off_season_title"
	},
	rewarding = {
		unlocalized_description_text = "",
		unlocalized_title_text = ""
	},
	no_key = {
		description_text = "loc_havoc_pre_description",
		title_text = "loc_havoc_pre_title"
	},
	key = {
		unlocalized_description_text = "",
		unlocalized_title_text = ""
	}
}
local button_options_definitions = {
	off_cadence = {
		{
			blur_background = false,
			display_name = "loc_havoc_off_season_button_leave",
			callback = function (self)
				Managers.ui:close_view(self.view_name)
			end
		}
	},
	rewarding = {
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
							view = "havoc_reward_presentation_view",
							context = {},
							input_legend_buttons = {
								{
									on_pressed_callback = "cb_on_continue_pressed",
									input_action = "next",
									display_name = "loc_continue",
									alignment = "right_alignment"
								}
							}
						}
					}
				}

				self:_setup_tab_bar(tab_bar_params, {})
			end
		}
	},
	no_key = {
		{
			blur_background = false,
			display_name = "loc_havoc_pre_button_leave",
			callback = function (self)
				Managers.ui:close_view(self.view_name)
			end
		}
	},
	key = {
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
							view = "havoc_play_view",
							context = {
								play_fast_enter_animation = true
							},
							input_legend_buttons = {
								{
									input_action = "hotkey_help",
									display_name = "loc_action_interaction_help",
									alignment = "right_alignment",
									on_pressed_callback = "cb_on_help_pressed",
									visibility_function = function (parent)
										local active_view = parent._active_view_instance
										local tutorial_overlay = active_view and active_view._tutorial_overlay

										return tutorial_overlay and not tutorial_overlay:is_active()
									end
								},
								{
									input_action = "group_finder_refresh_groups",
									display_name = "",
									alignment = "right_alignment",
									on_pressed_callback = "_cb_on_mission_revoke_pressed",
									visibility_function = function (parent, id)
										local active_view = parent._active_view_instance
										local display_name = active_view and active_view._ongoing_mission_id and active_view:_ongoing_mission_id() and "loc_havoc_cancel_mission" or "loc_havoc_revoke_mission"

										parent._input_legend_element:set_display_name(id, display_name)

										local tutorial_overlay = active_view and active_view._tutorial_overlay
										local tutorial_overlay_active = tutorial_overlay and tutorial_overlay:is_active()
										local show = active_view and active_view._ongoing_mission_id and active_view:_ongoing_mission_id() and active_view._can_cancel_mission or active_view and (not active_view._ongoing_mission_id or active_view._ongoing_mission_id and not active_view:_ongoing_mission_id())

										return active_view and active_view.view_name == "havoc_play_view" and not active_view._revoke_popup_id and not tutorial_overlay_active and show
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
							view = "havoc_lore_view",
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
}
local background_world_params = {
	shading_environment = "content/shading_environments/ui/havoc",
	world_layer = 1,
	total_blur_duration = 0.5,
	timer_name = "ui",
	viewport_type = "default",
	register_camera_event = "event_register_camera",
	viewport_name = "ui_story_mission_background_world_viewport",
	viewport_layer = 1,
	level_name = "content/levels/ui/havoc/havoc",
	world_name = "ui_story_mission_background_world"
}

return {
	hide_option_buttons = true,
	starting_option_index = 1,
	intro_texts = intro_texts,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	button_options_definitions = button_options_definitions,
	input_legend_params = input_legend_params,
	background_world_params = background_world_params
}
