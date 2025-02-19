-- chunkname: @scripts/ui/views/havoc_background_view/havoc_background_view_definitions.lua

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
			208,
			222,
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
			value = "content/ui/materials/effects/screen/havoc_01_lower_left",
		},
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/effects/screen/havoc_01_lower_right",
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
	off_cadence = {
		description_text = "loc_havoc_off_season_description",
		title_text = "loc_havoc_off_season_title",
	},
	rewarding = {
		unlocalized_description_text = "",
		unlocalized_title_text = "",
	},
	no_key = {
		description_text = "loc_havoc_pre_description",
		title_text = "loc_havoc_pre_title",
	},
	key = {
		unlocalized_description_text = "",
		unlocalized_title_text = "",
	},
}
local button_options_definitions = {
	off_cadence = {
		{
			blur_background = false,
			display_name = "loc_havoc_off_season_button_leave",
			callback = function (self)
				Managers.ui:close_view(self.view_name)
			end,
		},
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
							blur_background = false,
							display_name = "",
							view = "havoc_reward_presentation_view",
							context = {},
							input_legend_buttons = {
								{
									alignment = "right_alignment",
									display_name = "loc_continue",
									input_action = "next",
									on_pressed_callback = "cb_on_continue_pressed",
								},
							},
						},
					},
				}

				self:_setup_tab_bar(tab_bar_params, {})
			end,
		},
	},
	no_key = {
		{
			blur_background = false,
			display_name = "loc_havoc_pre_button_leave",
			callback = function (self)
				Managers.ui:close_view(self.view_name)
			end,
		},
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
							blur_background = false,
							display_name = "",
							view = "havoc_play_view",
							context = {
								play_fast_enter_animation = true,
							},
							input_legend_buttons = {
								{
									alignment = "right_alignment",
									display_name = "loc_action_interaction_help",
									input_action = "hotkey_help",
									on_pressed_callback = "cb_on_help_pressed",
									visibility_function = function (parent)
										local active_view = parent._active_view_instance
										local tutorial_overlay = active_view and active_view._tutorial_overlay

										return tutorial_overlay and not tutorial_overlay:is_active()
									end,
								},
								{
									alignment = "right_alignment",
									display_name = "",
									input_action = "group_finder_refresh_groups",
									on_pressed_callback = "_cb_on_mission_revoke_pressed",
									visibility_function = function (parent, id)
										local active_view = parent._active_view_instance
										local display_name = active_view and active_view._ongoing_mission_id and active_view:_ongoing_mission_id() and "loc_havoc_cancel_mission" or "loc_havoc_revoke_mission"

										parent._input_legend_element:set_display_name(id, display_name)

										local tutorial_overlay = active_view and active_view._tutorial_overlay
										local tutorial_overlay_active = tutorial_overlay and tutorial_overlay:is_active()
										local show = active_view and active_view._ongoing_mission_id and active_view:_ongoing_mission_id() and active_view._can_cancel_mission or active_view and (not active_view._ongoing_mission_id or active_view._ongoing_mission_id and not active_view:_ongoing_mission_id())

										return active_view and active_view.view_name == "havoc_play_view" and not active_view._revoke_popup_id and not tutorial_overlay_active and show
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
							view = "havoc_lore_view",
							context = {},
						},
					},
				}

				self:_setup_tab_bar(tab_bar_params, {})
			end,
		},
	},
}
local background_world_params = {
	level_name = "content/levels/ui/havoc/havoc",
	register_camera_event = "event_register_camera",
	shading_environment = "content/shading_environments/ui/havoc",
	timer_name = "ui",
	total_blur_duration = 0.5,
	viewport_layer = 1,
	viewport_name = "ui_story_mission_background_world_viewport",
	viewport_type = "default",
	world_layer = 1,
	world_name = "ui_story_mission_background_world",
}

return {
	hide_option_buttons = true,
	starting_option_index = 1,
	intro_texts = intro_texts,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	button_options_definitions = button_options_definitions,
	input_legend_params = input_legend_params,
	background_world_params = background_world_params,
}
