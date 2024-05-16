-- chunkname: @scripts/ui/views/mission_voting_view/mission_voting_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local ViewStyles = require("scripts/ui/views/mission_voting_view/mission_voting_view_styles")
local ColorUtilities = require("scripts/utilities/ui/colors")
local outer_panel_size = {
	638,
	850,
}
local inner_panel_size = {
	600,
	600,
}
local zone_image_panel_size = {
	outer_panel_size[1] - 28,
	320,
}
local zone_image_size = {
	zone_image_panel_size[1],
	200,
}
local body_size = {
	inner_panel_size[1],
	260,
}
local mission_info_panel_size = {
	body_size[1] - 40,
	300,
}
local info_panel_size = {
	outer_panel_size[1] - 28,
	215,
}
local mission_info_size = {
	mission_info_panel_size[1],
	120,
}
local header_size = {
	inner_panel_size[1],
	zone_image_size[2] - 120 + 54,
}
local footer_size = {
	outer_panel_size[1],
	200,
}
local mission_type_size = {
	560,
	40,
}
local mission_salary_size = {
	mission_info_size[1],
	40,
}
local mission_difficulty_panel_size = {
	info_panel_size[1] / 2,
	info_panel_size[2] - 70,
}
local mission_difficulty_size = {
	200,
	mission_difficulty_panel_size[2] + 25,
}
local mission_difficulty_divider_size = {
	1,
	mission_difficulty_panel_size[2] + 25 - 4,
}
local misson_rewards_size = {
	240,
	mission_difficulty_panel_size[2] + 25,
}
local circumstance_icon_size = {
	50,
	50,
}
local zone_image_bottom_fade_size = {
	outer_panel_size[1] - 31,
	50,
}
local mission_reward_size = {
	200,
	40,
}
local details_button_size = {
	280,
	45,
}
local main_button_size = {
	320,
	50,
}
local mission_info_top_panel_size = {
	outer_panel_size[1],
	outer_panel_size[2] / 2,
}
local title_bar_size = {
	outer_panel_size[1],
	80,
}
local mission_circumstance_size = {
	mission_info_size[1],
	71,
}
local details_panel_size = {
	inner_panel_size[1],
	500,
}
local details_panel_content_size = {
	details_panel_size[1] - 60,
	details_panel_size[2],
}
local scrollbar_size = {
	10,
	details_panel_size[2] - 40,
}
local accept_button_size = {
	440,
	78,
}
local timer_bar_size = {
	310,
	10,
}
local secondary_button_size = {
	398,
	64,
}
local title_bar_bottom_size = {
	zone_image_panel_size[1],
	40,
}
local outer_panel_y_offset = -(UIWorkspaceSettings.screen.size[2] * 0.075)
local outer_panel_position = {
	0,
	outer_panel_y_offset + 50,
	0,
}
local inner_panel_position = {
	44,
	50,
	1,
}
local header_position = {
	0,
	0,
	6,
}
local title_bar_position = {
	0,
	0,
	20,
}
local title_bar_bottom_position = {
	0,
	300 - title_bar_bottom_size[2],
	30,
}
local mission_info_panel_position = {
	0,
	50,
	3,
}
local mission_type_position = {
	0,
	50,
	4,
}
local mission_summary_position = {
	0,
	20,
	4,
}
local mission_difficulty_challenge_position = {
	0,
	15,
	1,
}
local details_button_position = {
	0,
	-100,
	10,
}
local circumstance_icon_position = {
	-10,
	10,
	5,
}
local zone_image_bottom_fade_position = {
	0,
	0,
	5,
}
local reward_main_mission_position = {
	0,
	10,
	10,
}
local timer_bar_position = {
	0,
	-40,
	10,
}
local decline_button_position = {
	0,
	-70,
	0,
}
local accept_button_position = {
	0,
	16,
	1,
}
local zone_image_panel_position = {
	0,
	100,
	6,
}
local zone_image_position = {
	0,
	0,
	6,
}
local info_panel_position = {
	0,
	outer_panel_size[2] / 2,
	0,
}
local body_position = {
	0,
	100,
	3,
}
local mission_info_position = {
	0,
	0,
	4,
}
local mission_salary_position = {
	0,
	20,
	1,
}
local mission_difficulty_position = {
	0,
	0,
	4,
}
local mission_circumstance_position = {
	0,
	0,
	0,
}
local footer_position = {
	0,
	0,
	25,
}
local player_portrait_position = {
	18,
	26,
	15,
}
local mission_difficulty_extra_offset = {
	0,
	20,
	0,
}
local details_panel_position = {
	0,
	100,
	4,
}
local details_content_position = {
	40,
	0,
	5,
}
local scrollbar_position = {
	0,
	20,
	5,
}
local details_widget_spacing = {
	details_panel_size[1],
	25,
}
local details_panel_end_padding = {
	details_panel_size[1],
	10,
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	outer_panel = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = outer_panel_size,
		position = outer_panel_position,
	},
	inner_panel = {
		horizontal_alignment = "left",
		parent = "outer_panel",
		vertical_alignment = "top",
		size = inner_panel_size,
		position = inner_panel_position,
	},
	panel_header = {
		horizontal_alignment = "left",
		parent = "inner_panel",
		vertical_alignment = "top",
		size = header_size,
		position = header_position,
	},
	mission_info_top_panel = {
		horizontal_alignment = "center",
		parent = "outer_panel",
		vertical_alignment = "top",
		size = mission_info_top_panel_size,
		position = {
			0,
			0,
			10,
		},
	},
	title_bar = {
		horizontal_alignment = "left",
		parent = "outer_panel",
		vertical_alignment = "top",
		size = title_bar_size,
		position = title_bar_position,
	},
	title_bar_bottom = {
		horizontal_alignment = "center",
		parent = "outer_panel",
		vertical_alignment = "top",
		size = title_bar_bottom_size,
		position = title_bar_bottom_position,
	},
	zone_image_panel = {
		horizontal_alignment = "center",
		parent = "mission_info_top_panel",
		vertical_alignment = "top",
		size = zone_image_panel_size,
		position = zone_image_panel_position,
	},
	zone_image = {
		horizontal_alignment = "center",
		parent = "zone_image_panel",
		vertical_alignment = "top",
		size = zone_image_size,
		position = zone_image_position,
	},
	body_panel = {
		horizontal_alignment = "center",
		parent = "outer_panel",
		vertical_alignment = "top",
		size = body_size,
		position = body_position,
	},
	mission_info_panel = {
		horizontal_alignment = "center",
		parent = "outer_panel",
		vertical_alignment = "center",
		size = mission_info_panel_size,
		position = mission_info_panel_position,
	},
	info_panel = {
		horizontal_alignment = "center",
		parent = "outer_panel",
		vertical_alignment = "top",
		size = info_panel_size,
		position = info_panel_position,
	},
	mission_info = {
		horizontal_alignment = "center",
		parent = "mission_info_top_panel",
		vertical_alignment = "bottom",
		size = mission_info_size,
		position = mission_info_position,
	},
	mission_type = {
		horizontal_alignment = "center",
		parent = "mission_info_top_panel",
		vertical_alignment = "bottom",
		size = mission_type_size,
		position = {
			0,
			0,
			10,
		},
	},
	mission_salary = {
		horizontal_alignment = "center",
		parent = "info_panel",
		vertical_alignment = "top",
		size = mission_salary_size,
		position = mission_salary_position,
	},
	mission_difficulty_left = {
		horizontal_alignment = "left",
		parent = "info_panel",
		vertical_alignment = "top",
		size = mission_difficulty_panel_size,
		position = mission_difficulty_position,
	},
	mission_difficulty_right = {
		horizontal_alignment = "right",
		parent = "info_panel",
		vertical_alignment = "top",
		size = mission_difficulty_panel_size,
		position = mission_difficulty_position,
	},
	mission_danger_level = {
		horizontal_alignment = "center",
		parent = "mission_difficulty_left",
		vertical_alignment = "bottom",
		size = mission_difficulty_size,
		position = mission_summary_position,
	},
	mission_rewards_challenge = {
		horizontal_alignment = "center",
		parent = "mission_difficulty_right",
		vertical_alignment = "top",
		size = misson_rewards_size,
		position = mission_summary_position,
	},
	reward_main_mission = {
		horizontal_alignment = "center",
		parent = "mission_difficulty_right",
		vertical_alignment = "center",
		size = mission_reward_size,
		position = reward_main_mission_position,
	},
	mission_difficulty_divider = {
		horizontal_alignment = "center",
		parent = "mission_info",
		vertical_alignment = "bottom",
		size = mission_difficulty_divider_size,
		position = mission_summary_position,
	},
	details_panel = {
		horizontal_alignment = "left",
		parent = "body_panel",
		vertical_alignment = "top",
		size = details_panel_size,
		position = details_panel_position,
	},
	details_panel_content = {
		horizontal_alignment = "left",
		parent = "details_panel",
		vertical_alignment = "top",
		size = details_panel_content_size,
		position = details_content_position,
	},
	footer_panel = {
		horizontal_alignment = "center",
		parent = "outer_panel",
		vertical_alignment = "bottom",
		size = footer_size,
		position = footer_position,
	},
	accept_button = {
		horizontal_alignment = "center",
		parent = "footer_panel",
		vertical_alignment = "trop",
		size = main_button_size,
		position = accept_button_position,
	},
	timer_bar = {
		horizontal_alignment = "center",
		parent = "footer_panel",
		vertical_alignment = "bottom",
		size = timer_bar_size,
		position = timer_bar_position,
	},
	decline_button = {
		horizontal_alignment = "center",
		parent = "footer_panel",
		vertical_alignment = "bottom",
		size = main_button_size,
		position = decline_button_position,
	},
	toggle_details_button = {
		horizontal_alignment = "center",
		parent = "accept_button",
		vertical_alignment = "bottom",
		size = details_button_size,
		position = details_button_position,
	},
	details_scrollbar = {
		horizontal_alignment = "right",
		parent = "details_panel",
		vertical_alignment = "top",
		size = scrollbar_size,
		position = scrollbar_position,
	},
	details_mask = {
		horizontal_alignment = "center",
		parent = "details_panel",
		vertical_alignment = "center",
		size = details_panel_size,
		position = {
			0,
			0,
			0,
		},
	},
	details_interaction = {
		horizontal_alignment = "left",
		parent = "details_panel",
		vertical_alignment = "top",
		size = details_panel_size,
		position = {
			0,
			0,
			0,
		},
	},
	mission_icons_pivot = {
		horizontal_alignment = "center",
		parent = "zone_image_panel",
		vertical_alignment = "bottom",
		size = {
			49.6,
			49.6,
		},
		position = {
			0,
			0,
			0,
		},
	},
	circumstance_icon = {
		horizontal_alignment = "right",
		parent = "zone_image_panel",
		vertical_alignment = "top",
		size = circumstance_icon_size,
		position = circumstance_icon_position,
	},
	zone_image_bottom_fade = {
		horizontal_alignment = "center",
		parent = "zone_image",
		vertical_alignment = "bottom",
		size = zone_image_bottom_fade_size,
		position = zone_image_bottom_fade_position,
	},
}
local mission_type_font_style = ViewStyles.mission_type_font_style

mission_type_font_style.text_vertical_alignment = "top"

local decline_button_passes = table.clone(ButtonPassTemplates.secondary_button)

decline_button_passes[#decline_button_passes + 1] = {
	pass_type = "texture",
	style_id = "frame",
	value = "content/ui/materials/frames/hover",
}

local widget_definitions = {
	inner_panel_background = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				scale_to_material = true,
				color = Color.terminal_grid_background(nil, true),
			},
		},
	}, "outer_panel"),
	top_detail = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/item_info_upper",
			style = ViewStyles.mission_detail_top,
		},
	}, "title_bar"),
	title_bar = UIWidget.create_definition({
		{
			pass_type = "text",
			value = Managers.localization:localize("loc_mission_voting_view_title"),
			style = ViewStyles.title_font_style,
		},
	}, "title_bar"),
	title_bar_bottom = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = Color.black(76.5, true),
			},
		},
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = ViewStyles.flash_title_style,
		},
	}, "title_bar_bottom"),
	zone_image = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			style_id = "texture",
			value_id = "texture",
			style = {
				scale_to_material = true,
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				scale_to_material = true,
				color = Color.terminal_grid_background(120, true),
				size_addition = {
					28,
					28,
				},
				offset = {
					-14,
					-14,
					1,
				},
			},
		},
	}, "zone_image"),
	footer = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/item_info_lower",
			style = ViewStyles.mission_detail_bottom,
		},
	}, "footer_panel"),
	timer_bar = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/default_square",
			style = ViewStyles.timer_bar_background_style,
		},
		{
			pass_type = "texture",
			style_id = "timer_bar",
			value = "content/ui/materials/backgrounds/default_square",
			style = ViewStyles.timer_bar_fill_style,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = ViewStyles.timer_bar_frame_style,
		},
	}, "timer_bar"),
	accept_confirmation = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "subheader",
			value = Managers.localization:localize("loc_mission_voting_view_waiting_for_players"),
		},
	}, "accept_button", nil, nil, ViewStyles.accept_confirmation),
	toggle_details_button = UIWidget.create_definition(ButtonPassTemplates.list_button_with_background, "toggle_details_button", {
		text = Managers.localization:localize("loc_mission_voting_view_show_details"),
	}),
}
local buttons_widget_definitions = {
	accept_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "accept_button", {
		name = "accept_button",
		original_text = Managers.localization:localize("loc_mission_voting_view_accept_mission"),
	}),
	decline_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "decline_button", {
		name = "decline_button",
		original_text = Managers.localization:localize("loc_mission_voting_view_decline_mission"),
	}),
}
local mission_info_widget_definitions = {
	info_panel_bg = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				scale_to_material = true,
				color = {
					120,
					169,
					191,
					153,
				},
				offset = {
					0,
					0,
					-10,
				},
			},
		},
	}, "info_panel"),
	mission_info = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "mission_title",
			value_id = "mission_title",
			style = ViewStyles.mission_title_font_style,
		},
	}, "mission_info"),
	mission_type = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "mission_type",
			value = "",
			value_id = "mission_type",
			style = mission_type_font_style,
		},
	}, "mission_info"),
	mission_danger_info = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "danger_text",
			value = "",
			value_id = "danger_text",
			style = ViewStyles.challenge_text_font_style,
		},
		{
			pass_type = "texture",
			style_id = "danger_icon",
			value = "content/ui/materials/icons/generic/danger",
			value_id = "danger_icon",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				color = Color.terminal_text_header(255, true),
				offset = {
					-20,
					10,
					0,
				},
				size = {
					50,
					50,
				},
			},
		},
		{
			pass_type = "multi_texture",
			style_id = "diffulty_icon_background",
			value = "content/ui/materials/backgrounds/default_square",
		},
		{
			pass_type = "multi_texture",
			style_id = "difficulty_icon",
			value = "content/ui/materials/backgrounds/default_square",
		},
	}, "mission_danger_level", nil, nil, ViewStyles.difficulty),
	rewards_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "rewards_title_text",
			value_id = "rewards_title_text",
			value = Utf8.upper(Localize("loc_training_grounds_rewards_title")),
			style = ViewStyles.mission_rewards_title_text_style,
		},
	}, "mission_rewards_challenge"),
	reward_main_mission = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "reward_main_mission_text",
			value = "",
			value_id = "reward_main_mission_text",
			style = ViewStyles.rewards_text_style,
		},
	}, "reward_main_mission"),
}
local details_static_widgets_definitions = {
	details_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.default_scrollbar, "details_scrollbar"),
	details_interaction = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
		},
	}, "details_interaction"),
	details_widgets_mask = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur_02",
			style = {
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
	}, "details_mask"),
}
local animations = {
	switch_page = {
		{
			end_time = 0.25,
			name = "fade_out_old_page",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				if params.show_details_flag then
					parent:_play_sound(UISoundEvents.mission_vote_popup_show_details)
				else
					parent:_play_sound(UISoundEvents.mission_vote_popup_hide_details)
				end
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = 1 - progress
				local widgets_to_fade = parent._additional_widgets

				for i = 1, #widgets_to_fade do
					local widget = widgets_to_fade[i]

					widget.alpha_multiplier = anim_progress
				end

				local styles_to_fade = parent._additional_text_styles

				for i = 1, #styles_to_fade do
					local style = styles_to_fade[i]

					ColorUtilities.color_lerp(style.fade_out_text_color, style.text_color, anim_progress, style.text_color)
				end

				if params.show_details_flag then
					local icons_widgets = parent._mission_icons_widgets

					for i = 1, #icons_widgets do
						local widget = icons_widgets[i]

						widget.alpha_multiplier = anim_progress
					end
				end
			end,
		},
		{
			end_time = 0.4,
			name = "resize_panels",
			start_time = 0.2,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeCubic(progress)
				local source = params.source_heights
				local targets = params.target_heights
				local lerp = math.lerp
				local mission_info_panel_height = lerp(source.mission_info_panel_height, targets.mission_info_panel_height, anim_progress)
				local zone_image_height = lerp(source.zone_image_height, targets.zone_image_height, anim_progress)
				local body_height = lerp(source.body_height, targets.body_height, anim_progress)
				local body_panel_y_offset = lerp(source.body_y_offset, targets.body_y_offset, anim_progress)
				local inner_panel_height = lerp(source.inner_panel_height, targets.inner_panel_height, anim_progress)
				local outer_panel_height = lerp(source.outer_panel_height, targets.outer_panel_height, anim_progress)
				local outer_panel_y_offset = lerp(source.outer_panel_y_offset, targets.outer_panel_y_offset, anim_progress)
				local title_bar_bottom_height = lerp(source.title_bar_bottom_height, targets.title_bar_bottom_height, anim_progress)
				local bottom_fade_height = lerp(source.zone_image_bottom_fade_height, targets.zone_image_bottom_fade_height, anim_progress)
				local circumstance_icon_height = lerp(source.circumstance_icon_height, targets.circumstance_icon_height, anim_progress)
				local zone_image_panel_height = lerp(source.zone_image_panel_height, targets.zone_image_panel_height, anim_progress)

				ui_scenegraph.mission_info_panel.size[2] = mission_info_panel_height
				ui_scenegraph.body_panel.size[2] = body_height
				ui_scenegraph.body_panel.position[2] = body_panel_y_offset
				ui_scenegraph.inner_panel.size[2] = inner_panel_height
				ui_scenegraph.outer_panel.size[2] = outer_panel_height
				ui_scenegraph.outer_panel.position[2] = outer_panel_y_offset
				ui_scenegraph.zone_image.size[2] = zone_image_height
				ui_scenegraph.title_bar_bottom.size[2] = title_bar_bottom_height
				ui_scenegraph.zone_image_panel.size[2] = zone_image_panel_height
				ui_scenegraph.zone_image_bottom_fade.size[2] = bottom_fade_height
				ui_scenegraph.circumstance_icon.size[2] = circumstance_icon_height

				return true
			end,
		},
		{
			end_time = 0.55,
			name = "fade_in_widgets",
			start_time = 0.35,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent:toggle_details(params.show_details_flag, params.input_legend_id)
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = progress
				local widgets_to_fade = parent._additional_widgets

				for i = 1, #widgets_to_fade do
					local widget = widgets_to_fade[i]

					widget.alpha_multiplier = anim_progress
				end

				local styles_to_fade = parent._additional_text_styles

				for i = 1, #styles_to_fade do
					local style = styles_to_fade[i]

					ColorUtilities.color_lerp(style.fade_in_text_color, style.text_color, anim_progress, style.text_color)
				end

				if not params.show_details_flag then
					local icons_widgets = parent._mission_icons_widgets

					for i = 1, #icons_widgets do
						local widget = icons_widgets[i]

						widget.alpha_multiplier = anim_progress
					end
				end
			end,
		},
	},
}

return settings("MissionVotingViewDefinitions", {
	animations = animations,
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	mission_info_widget_definitions = mission_info_widget_definitions,
	details_static_widgets_definitions = details_static_widgets_definitions,
	details_widget_spacing = details_widget_spacing,
	details_panel_end_padding = details_panel_end_padding,
	buttons_widget_definitions = buttons_widget_definitions,
})
