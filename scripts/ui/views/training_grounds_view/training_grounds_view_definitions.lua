-- chunkname: @scripts/ui/views/training_grounds_view/training_grounds_view_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local WalletSettings = require("scripts/settings/wallet_settings")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local SINGLEPLAY_TYPES = MatchmakingConstants.SINGLEPLAY_TYPES
local scenegraph_definition = {
	corner_top_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			128,
			282,
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
			128,
			282,
		},
		position = {
			0,
			0,
			62,
		},
	},
	corner_bottom_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			128,
			242,
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
			128,
			242,
		},
		position = {
			0,
			0,
			62,
		},
	},
}
local widget_definitions = {
	corner_bottom_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/character_01_lower",
		},
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/character_01_lower",
			style = {
				uvs = {
					{
						1,
						0,
					},
					{
						0,
						1,
					},
				},
			},
		},
	}, "corner_bottom_right"),
}
local input_legend_params = {}
local intro_texts = {
	description_text = "loc_training_grounds_view_intro_description",
	title_text = "loc_training_grounds_view_intro_title",
}
local button_options_definitions = {
	{
		display_name = "loc_basic_training_title",
		callback = function (self)
			local tab_bar_params = {
				hide_tabs = true,
				layer = 10,
				tabs_params = {
					{
						display_name = "loc_training_grounds_view_display_name",
						view = "training_grounds_options_view",
						context = {
							training_grounds_settings = "basic",
							mechanism_context = {
								mission_name = "om_basic_combat_01",
								init_scenario = {
									alias = "training_grounds",
									name = "basic_training",
								},
								singleplay_type = SINGLEPLAY_TYPES.training_grounds,
							},
						},
					},
				},
			}

			self:_setup_tab_bar(tab_bar_params)
		end,
	},
	{
		display_name = "loc_advanced_training_title",
		callback = function (self)
			local tab_bar_params = {
				hide_tabs = true,
				layer = 10,
				tabs_params = {
					{
						display_name = "loc_training_grounds_view_display_name",
						view = "training_grounds_options_view",
						context = {
							training_grounds_settings = "advanced",
							mechanism_context = {
								mission_name = "om_basic_combat_01",
								init_scenario = {
									alias = "training_grounds",
									name = "advanced_training",
								},
								singleplay_type = SINGLEPLAY_TYPES.training_grounds,
							},
						},
					},
				},
			}

			self:_setup_tab_bar(tab_bar_params)
		end,
	},
	{
		display_name = "loc_training_grounds_view_shooting_range_text",
		callback = function (self)
			local tab_bar_params = {
				hide_tabs = true,
				layer = 10,
				tabs_params = {
					{
						display_name = "loc_training_grounds_view_display_name",
						view = "training_grounds_options_view",
						context = {
							training_grounds_settings = "shooting_range",
							mechanism_context = {
								mission_name = "tg_shooting_range",
								singleplay_type = SINGLEPLAY_TYPES.training_grounds,
							},
						},
					},
				},
			}

			self:_setup_tab_bar(tab_bar_params)
		end,
	},
}
local background_world_params = {
	level_name = "content/levels/ui/training_grounds/training_grounds",
	register_camera_event = "event_register_training_grounds_camera",
	shading_environment = "content/shading_environments/ui/training_grounds",
	timer_name = "ui",
	total_blur_duration = 0.5,
	viewport_layer = 1,
	viewport_name = "ui_training_grounds_world_viewport",
	viewport_type = "default",
	world_layer = 1,
	world_name = "ui_training_grounds_world",
}

return {
	intro_texts = intro_texts,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	button_options_definitions = button_options_definitions,
	input_legend_params = input_legend_params,
	background_world_params = background_world_params,
}
