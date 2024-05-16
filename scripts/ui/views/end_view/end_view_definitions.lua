-- chunkname: @scripts/ui/views/end_view/end_view_definitions.lua

local ColorUtilities = require("scripts/utilities/ui/colors")
local DefaultPassTemplates = require("scripts/ui/pass_templates/default_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewStyles = require("scripts/ui/views/end_view/end_view_styles")
local _color_lerp = ColorUtilities.color_lerp
local _math_floor = math.floor
local _math_max = math.max
local _math_min = math.min
local panel_size = ViewStyles.panel_size
local scenegraph_definition = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			0,
		},
	},
	corner_top_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			306,
			520,
		},
		position = {
			0,
			0,
			0,
		},
	},
	corner_top_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			306,
			520,
		},
		position = {
			0,
			0,
			0,
		},
	},
	corner_bottom_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			320,
			200,
		},
		position = {
			0,
			0,
			0,
		},
	},
	corner_bottom_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			320,
			190,
		},
		position = {
			0,
			0,
			0,
		},
	},
	bottom_center = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			470,
			112,
		},
		position = {
			0,
			0,
			0,
		},
	},
	title_background = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			1200,
			200,
		},
		position = {
			0,
			0,
			1,
		},
	},
	title_text = {
		horizontal_alignment = "center",
		parent = "title_background",
		vertical_alignment = "top",
		size = {
			1200,
			40,
		},
		position = {
			0,
			20,
			60,
		},
	},
	panel_pivot = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			0,
			0,
		},
		position = {
			0,
			-120,
			1,
		},
	},
	panel = {
		horizontal_alignment = "center",
		parent = "panel_pivot",
		vertical_alignment = "bottom",
		size = panel_size,
		position = {
			0,
			0,
			1,
		},
	},
	continue_button = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			550,
			55,
		},
		position = {
			-300,
			-15,
			2,
		},
	},
	vote_count_text = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			72,
			64,
		},
		position = {
			290,
			-10,
			2,
		},
	},
	vote_text = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			550,
			55,
		},
		position = {
			380,
			-15,
			2,
		},
	},
}
local widget_definitions = {
	continue_button = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			style_id = "hotspot",
		},
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			change_function = function (content, style, _, dt)
				local color_lerp = _color_lerp
				local math_max = _math_max
				local math_min = _math_min
				local hotspot = content.hotspot
				local disabled_progress = content.disabled_progress or 0

				if hotspot.disabled then
					disabled_progress = math_min(disabled_progress + dt / style.disabled_fade_time, 1)
				else
					disabled_progress = math_max(disabled_progress - dt / style.disabled_fade_time, 0)
				end

				content.disabled_progress = disabled_progress

				local normal_color = style.normal_color
				local disabled_color = style.disabled_color
				local default_color = style.default_color

				color_lerp(default_color, disabled_color, disabled_progress, normal_color)

				local hover_progress = hotspot.anim_hover_progress
				local hover_color = style.hover_color
				local color = style.text_color or style.color

				color_lerp(normal_color, hover_color, hover_progress, color)
			end,
		},
		{
			pass_type = "text",
			style_id = "tooltip",
			value_id = "tooltip",
			value = Localize("loc_eor_stay_in_party_continue_tooltip"),
			change_function = function (content, style)
				local disabled_progress = content.disabled_progress or 0

				style.text_color[1] = _math_floor(disabled_progress * 255)
			end,
			visibility_function = function (content, style)
				return content.hotspot.disabled or style.text_color[1] > 0
			end,
		},
		{
			pass_type = "text",
			style_id = "vote_done_tooltip",
			value_id = "vote_done_tooltip",
			value = Localize("loc_eor_stay_in_party_vote_done_tooltip"),
			change_function = function (content, style)
				local visibility_progress = 1 - (content.disabled_progress or 1)

				style.text_color[1] = _math_floor(visibility_progress * 255)
			end,
			visibility_function = function (content, style)
				return content.vote_completed
			end,
		},
	}, "continue_button", {
		loc_string = "loc_settings_menu_continue",
		time = 0,
	}, nil, ViewStyles.continue_button),
	stay_in_party_vote = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			style_id = "hotspot",
		},
		{
			pass_type = "text",
			style_id = "vote_text",
			value = "",
			value_id = "vote_text",
			change_function = function (content, style, _, dt)
				local color_lerp = _color_lerp
				local math_max = _math_max
				local math_min = _math_min
				local yes_vote_progress = content.yes_vote_progress or 0

				if content.voted_yes then
					yes_vote_progress = math_min(yes_vote_progress + dt / style.fade_time, 1)
				else
					yes_vote_progress = math_max(yes_vote_progress - dt / style.fade_time, 0)
				end

				content.yes_vote_progress = yes_vote_progress

				local normal_color = style.normal_color
				local voted_yes_color = style.voted_yes_color
				local default_color = style.default_color

				color_lerp(default_color, voted_yes_color, yes_vote_progress, normal_color)

				local hover_progress = content.hotspot.anim_hover_progress or 0
				local hover_color = style.hover_color
				local text_color = style.text_color
				local ignore_alpha = true

				_color_lerp(normal_color, hover_color, hover_progress, text_color, ignore_alpha)
			end,
		},
		{
			pass_type = "text",
			scenegraph_id = "vote_count_text",
			style_id = "vote_count_text",
			value = "0/4",
			value_id = "vote_count_text",
		},
		{
			pass_type = "text",
			style_id = "tooltip",
			value_id = "tooltip",
			value = Localize("loc_eor_stay_in_party_vote_tooltip"),
			change_function = function (content, style)
				local yes_vote_progress = content.yes_vote_progress or 0

				style.text_color[1] = _math_floor(yes_vote_progress * 255)
			end,
			visibility_function = function (content, style)
				return content.voted_yes and content.already_in_party or style.text_color[1] > 0
			end,
		},
	}, "vote_text", nil, nil, ViewStyles.stay_in_party_vote),
}
local player_panel_pass_template = {
	{
		pass_type = "texture",
		style_id = "character_portrait",
		value = "content/ui/materials/base/ui_portrait_frame_base",
		value_id = "character_portrait",
	},
	{
		pass_type = "text",
		style_id = "checkmark",
		value = "",
		value_id = "checkmark",
	},
	{
		pass_type = "texture",
		style_id = "character_insignia",
		value = "content/ui/materials/nameplates/insignias/default",
		value_id = "character_insignia",
	},
	{
		pass_type = "text",
		style_id = "character_name",
		value_id = "character_name",
	},
	{
		pass_type = "text",
		style_id = "character_archetype_title",
		value_id = "character_archetype_title",
	},
	{
		pass_type = "text",
		style_id = "character_title",
		value = "",
		value_id = "character_title",
	},
	{
		pass_type = "text",
		style_id = "party_status",
		value = "",
		value_id = "party_status",
	},
	{
		pass_type = "texture",
		style_id = "account_divider",
		value = "content/ui/materials/dividers/faded_line_01",
		value_id = "account_divider",
	},
	{
		pass_type = "text",
		style_id = "account_name",
		value_id = "account_name",
	},
}
local game_mode_condition_widget_definitions = {
	victory = {
		static = {
			upper_left = UIWidget.create_definition({
				{
					pass_type = "texture",
					style_id = "corner_decoration",
					value = "content/ui/materials/frames/end_of_round/victory_upper_left",
				},
			}, "corner_top_left", nil, nil, ViewStyles.page_corner_decoration),
			upper_right = UIWidget.create_definition({
				{
					pass_type = "texture",
					style_id = "corner_decoration",
					value = "content/ui/materials/frames/end_of_round/victory_upper_right",
				},
			}, "corner_top_right", nil, nil, ViewStyles.page_corner_decoration),
			lower_back = UIWidget.create_definition({
				{
					pass_type = "texture",
					style_id = "bottom_decoration",
					value = "content/ui/materials/frames/end_of_round/victory_lower_back",
				},
			}, "screen", nil, nil, ViewStyles.page_bottom_decoration),
			lower_center = UIWidget.create_definition({
				{
					pass_type = "texture",
					style_id = "bottom_center_decoration",
					value = "content/ui/materials/frames/end_of_round/victory_lower_center",
				},
			}, "bottom_center", nil, nil, ViewStyles.page_bottom_center_decoration),
			lower_left = UIWidget.create_definition({
				{
					pass_type = "texture",
					style_id = "corner_decoration",
					value = "content/ui/materials/frames/end_of_round/victory_lower_left",
				},
				{
					pass_type = "texture",
					style_id = "candles",
					value = "content/ui/materials/effects/end_of_round/victory_lower_left_candles",
				},
			}, "corner_bottom_left", nil, nil, ViewStyles.page_corner_decoration),
			lower_right = UIWidget.create_definition({
				{
					pass_type = "texture",
					style_id = "corner_decoration",
					value = "content/ui/materials/frames/end_of_round/victory_lower_right",
				},
				{
					pass_type = "texture",
					style_id = "candles",
					value = "content/ui/materials/effects/end_of_round/victory_lower_right_candles",
				},
			}, "corner_bottom_right", nil, nil, ViewStyles.page_corner_decoration),
		},
		dynamic = {
			title_text = UIWidget.create_definition({
				{
					pass_type = "text",
					style_id = "mission_header",
					value = "Test title here",
					value_id = "mission_header",
				},
				{
					pass_type = "text",
					style_id = "mission_sub_header",
					value = "",
					value_id = "mission_sub_header",
				},
			}, "title_text", nil, nil, ViewStyles.mission_header_victory),
			player_panel = UIWidget.create_definition(player_panel_pass_template, "panel", nil, nil, ViewStyles.player_panel_victory),
		},
	},
	defeat = {
		static = {
			upper_left = UIWidget.create_definition({
				{
					pass_type = "texture",
					style_id = "corner_decoration",
					value = "content/ui/materials/frames/end_of_round/defeat_upper_left",
				},
			}, "corner_top_left", nil, nil, ViewStyles.page_corner_decoration),
			upper_right = UIWidget.create_definition({
				{
					pass_type = "texture",
					style_id = "corner_decoration",
					value = "content/ui/materials/frames/end_of_round/defeat_upper_right",
				},
			}, "corner_top_right", nil, nil, ViewStyles.page_corner_decoration),
			lower_back = UIWidget.create_definition({
				{
					pass_type = "texture",
					style_id = "bottom_decoration",
					value = "content/ui/materials/frames/end_of_round/defeat_lower_back",
				},
			}, "screen", nil, nil, ViewStyles.page_bottom_decoration),
			lower_center = UIWidget.create_definition({
				{
					pass_type = "texture",
					style_id = "bottom_center_decoration",
					value = "content/ui/materials/frames/end_of_round/defeat_lower_center",
				},
			}, "bottom_center", nil, nil, ViewStyles.page_bottom_center_decoration),
			lower_left = UIWidget.create_definition({
				{
					pass_type = "texture",
					style_id = "corner_decoration",
					value = "content/ui/materials/frames/end_of_round/defeat_lower_left",
				},
			}, "corner_bottom_left", nil, nil, ViewStyles.page_corner_decoration),
			lower_right = UIWidget.create_definition({
				{
					pass_type = "texture",
					style_id = "corner_decoration",
					value = "content/ui/materials/frames/end_of_round/defeat_lower_right",
				},
			}, "corner_bottom_right", nil, nil, ViewStyles.page_corner_decoration),
		},
		dynamic = {
			title_text = UIWidget.create_definition({
				{
					pass_type = "text",
					style_id = "mission_header",
					value = "Test title here",
					value_id = "mission_header",
				},
				{
					pass_type = "text",
					style_id = "mission_sub_header",
					value_id = "mission_sub_header",
					value = Utf8.upper(Localize("loc_end_view_mission_sub_header_defeat")),
				},
			}, "title_text", nil, nil, ViewStyles.mission_header_defeat),
			player_panel = UIWidget.create_definition(player_panel_pass_template, "panel", nil, nil, ViewStyles.player_panel_defeat),
		},
	},
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	game_mode_condition_widget_definitions = game_mode_condition_widget_definitions,
}
