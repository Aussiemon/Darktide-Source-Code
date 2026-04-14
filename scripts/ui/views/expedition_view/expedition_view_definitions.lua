-- chunkname: @scripts/ui/views/expedition_view/expedition_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local Styles = require("scripts/ui/views/expedition_view/expedition_view_styles")
local Settings = require("scripts/ui/views/expedition_view/expedition_view_settings")
local InputDevice = require("scripts/managers/input/input_device")
local InputUtils = require("scripts/managers/input/input_utils")
local ExpeditionService = require("scripts/managers/data_service/services/expedition_service")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UNLOCK_STATUS = ExpeditionService.UNLOCK_STATUS
local MATCH_VISIBILITY = table.enum("private", "public")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			1870,
			995,
		},
		position = {
			0,
			25,
			3,
		},
	},
	sidebar = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			483,
			995,
		},
		position = {
			0,
			0,
			4,
		},
	},
	mission_info = {
		horizontal_alignment = "center",
		parent = "sidebar",
		vertical_alignment = "top",
		size = {
			483,
			415,
		},
		position = {
			0,
			65,
			5,
		},
	},
	mission_info_tabs = {
		horizontal_alignment = "center",
		parent = "mission_info",
		vertical_alignment = "top",
		size = {
			483,
			80,
		},
		position = {
			0,
			0,
			6,
		},
	},
	mission_info_page = {
		horizontal_alignment = "center",
		parent = "mission_info",
		vertical_alignment = "top",
		size = {
			482,
			250,
		},
		position = {
			0,
			80,
			6,
		},
	},
	mission_info_stats = {
		horizontal_alignment = "center",
		parent = "mission_info",
		vertical_alignment = "top",
		size = {
			483,
			80,
		},
		position = {
			0,
			80,
			6,
		},
	},
	mapwide_stats = {
		horizontal_alignment = "center",
		parent = "sidebar",
		vertical_alignment = "top",
		size = {
			483,
			80,
		},
		position = {
			0,
			0,
			6,
		},
	},
	sidebar_interactables = {
		horizontal_alignment = "center",
		parent = "sidebar",
		vertical_alignment = "bottom",
		size = {
			375,
			240,
		},
		position = {
			0,
			0,
			5,
		},
	},
	difficulty_stepper = {
		horizontal_alignment = "center",
		parent = "sidebar_interactables",
		vertical_alignment = "top",
		size = {
			336,
			94,
		},
		position = {
			0,
			0,
			6,
		},
	},
	difficulty_stepper_indicators = {
		horizontal_alignment = "center",
		parent = "difficulty_stepper",
		vertical_alignment = "top",
		size = {
			280,
			0,
		},
		position = {
			0,
			0,
			7,
		},
	},
	play_button = {
		horizontal_alignment = "center",
		parent = "sidebar_interactables",
		vertical_alignment = "bottom",
		size = {
			375,
			110,
		},
		position = {
			0,
			0,
			6,
		},
	},
	unlock_button = {
		horizontal_alignment = "center",
		parent = "sidebar_interactables",
		vertical_alignment = "bottom",
		size = {
			375,
			110,
		},
		position = {
			0,
			0,
			6,
		},
	},
	quickplay_button = {
		horizontal_alignment = "center",
		parent = "sidebar_interactables",
		vertical_alignment = "bottom",
		size = {
			280,
			48,
		},
		position = {
			-380,
			-30,
			6,
		},
	},
	tutorial_popup_pivot = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			170,
		},
	},
}
local widget_definitions = {}
local play_button_content_overrides = {
	gamepad_action = "confirm_pressed",
	original_text = Utf8.upper(Localize("loc_mission_board_view_accept_mission")),
}
local play_button_style_overrides = {
	text = {
		line_spacing = 0.7,
	},
}

local function _get_input_text(action)
	local service_type = "View"
	local alias_key = Managers.ui:get_input_alias_key(action, service_type)

	return InputUtils.input_text_for_current_input_device(service_type, alias_key)
end

local play_button_definition = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style_id = "hotspot",
		style = Styles.play_button.hotspot,
	},
	{
		pass_type = "texture",
		style_id = "play_button_default",
		value = "content/ui/materials/buttons/mb_play_button",
		style = Styles.play_button.default,
		visibility_function = function (content, style)
			return not content.hotspot.disabled
		end,
	},
	{
		pass_type = "texture",
		style_id = "play_button_hover",
		value = "content/ui/materials/buttons/mb_play_button_selected",
		style = Styles.play_button.hover,
		change_function = function (content, style, animations, dt)
			local hotspot_data = content.hotspot

			style.color[1] = 255 * hotspot_data.anim_hover_progress
		end,
		visibility_function = function (content, style)
			return not content.hotspot.disabled
		end,
	},
	{
		pass_type = "text",
		style_id = "default_text",
		value_id = "default_text",
		value = Utf8.upper(Localize("loc_mission_board_view_accept_mission")),
		style = Styles.play_button.default_text,
		visibility_function = function (content, style)
			return not content.hotspot.disabled
		end,
		change_function = function (content, style, animations, dt)
			local hotspot_data = content.hotspot

			style.font_size = 28 + 4 * hotspot_data.anim_hover_progress

			if content.is_gamepad_active then
				local input_action = content.gamepad_action or "confirm_pressed"
				local input_text = _get_input_text(input_action)

				content.default_text = input_text .. " " .. content.original_text
			else
				content.default_text = content.original_text
			end
		end,
	},
	{
		pass_type = "texture",
		style_id = "play_button_disable",
		value = "content/ui/materials/buttons/mb_play_button_disabled",
		style = Styles.play_button.disabled,
		visibility_function = function (content, style)
			return content.hotspot.disabled
		end,
	},
	{
		pass_type = "text",
		style_id = "disabled_text",
		value = "n/a",
		value_id = "disabled_text",
		style = Styles.play_button.disabled_text,
		visibility_function = function (content, style)
			return content.hotspot.disabled
		end,
	},
}

widget_definitions.play_button = UIWidget.create_definition(play_button_definition, "play_button", play_button_content_overrides, nil, play_button_style_overrides)
widget_definitions.play_button_legend = UIWidget.create_definition({
	{
		pass_type = "text",
		style_id = "text",
		value = "",
		value_id = "text",
		style = {
			horizontal_alignment = "center",
		},
	},
}, "play_button", nil, nil, {
	text = {
		font_size = 14,
		font_type = "mono_tide_medium",
		text_horizontal_alignment = "center",
		text_vertical_alignment = "center",
		text_color = Settings.colors.text_dark,
		offset = {
			0,
			58,
			2,
		},
	},
})
widget_definitions.sidebar_fade = UIWidget.create_definition({
	{
		pass_type = "texture",
		style_id = "sidebar_fade",
		value = "content/ui/materials/masks/gradient_right_one_third",
		value_id = "sidebar_fade",
		style = Styles.sidebar_fade,
	},
}, "screen")

local unlock_button_definition = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style_id = "hotspot",
		style = Styles.play_button.hotspot,
	},
	{
		pass_type = "texture",
		style_id = "play_button_default",
		value = "content/ui/materials/buttons/mb_play_button",
		style = Styles.play_button.default,
	},
	{
		pass_type = "texture",
		style_id = "play_button_hover",
		value = "content/ui/materials/buttons/mb_play_button_selected",
		style = Styles.play_button.hover,
		change_function = function (content, style, animations, dt)
			local pulse_speed = 3
			local pulse_anim_progress = 1 - (0.5 + math.sin(Application.time_since_launch() * pulse_speed) * 0.5)
			local hotspot_data = content.hotspot

			style.color[1] = 255 * (pulse_anim_progress * 0.5 + hotspot_data.anim_hover_progress * 0.5)
		end,
	},
	{
		pass_type = "text",
		style_id = "default_text",
		value_id = "default_text",
		value = Utf8.upper(Localize("loc_action_interaction_unlock")),
		style = Styles.play_button.default_text,
		change_function = function (content, style, animations, dt)
			local hotspot_data = content.hotspot

			style.font_size = 28 + 4 * hotspot_data.anim_hover_progress

			if content.is_gamepad_active then
				local input_action = content.gamepad_action or "confirm_pressed"
				local input_text = _get_input_text(input_action)

				content.default_text = input_text .. " " .. content.original_text
			else
				content.default_text = content.original_text
			end
		end,
	},
}
local unlock_button_content_overrides = {
	gamepad_action = "confirm_pressed",
	original_text = Utf8.upper(Localize("loc_action_interaction_unlock")),
}

widget_definitions.unlock_button = UIWidget.create_definition(unlock_button_definition, "unlock_button", unlock_button_content_overrides, nil, play_button_style_overrides)
widget_definitions.mapwide_stats = UIWidget.create_definition({
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = Styles.mapwide_stats.frame,
	},
	{
		pass_type = "rect",
		style_id = "background",
		style = Styles.mapwide_stats.background,
	},
	{
		pass_type = "text",
		style_id = "title",
		value_id = "title",
		value = Localize("loc_expedition_map_total_title"),
		style = Styles.mapwide_stats.title,
	},
	{
		pass_type = "rect",
		style_id = "divider_line",
		style = Styles.mapwide_stats.divider_line,
	},
	{
		pass_type = "text",
		style_id = "personal_total_text",
		value_id = "personal_total_text",
		value = Localize("loc_expeditions_personal_total_mapwide"),
		style = Styles.mapwide_stats.personal_total_text,
	},
	{
		pass_type = "text",
		style_id = "personal_total_number",
		value = "0",
		value_id = "personal_total_number",
		style = Styles.mapwide_stats.personal_total_number,
	},
	{
		pass_type = "texture",
		style_id = "personal_total_icon",
		value_id = "personal_total_icon",
		value = Settings.loot_icon,
		style = Styles.mapwide_stats.personal_total_icon,
	},
}, "mapwide_stats")

local background_world_params = {
	level_name = "content/levels/ui/expedition/world",
	register_camera_event = "event_register_camera",
	shading_environment = "content/shading_environments/ui/havoc",
	table_pivot_event = "event_register_table_spawn_pivot",
	timer_name = "ui",
	total_blur_duration = 0.5,
	viewport_layer = 1,
	viewport_name = "ui_expedition_background_world_viewport",
	viewport_type = "default",
	world_layer = 1,
	world_name = "ui_expedition_background_world",
}
local input_legend_params = {
	layer = 10,
	buttons_params = {
		{
			alignment = "left_alignment",
			display_name = "loc_settings_menu_close_menu",
			input_action = "back",
			on_pressed_callback = "cb_on_back_pressed",
		},
		{
			alignment = "left_alignment",
			display_name = "loc_mission_board_view_unlock_node",
			input_action = "confirm_pressed",
			on_pressed_callback = "cb_on_unlock_node_input_pressed",
			visibility_function = function (parent)
				return InputDevice.gamepad_active and parent.selected_node and parent.selected_node.unlock_status == UNLOCK_STATUS.unlockable and parent:node_enter_anim_finished()
			end,
		},
		{
			alignment = "right_alignment",
			display_name = "loc_mission_board_view_options",
			input_action = "hotkey_menu_special_1",
			on_pressed_callback = "cb_on_options_pressed",
			visibility_function = function (parent)
				return parent:node_enter_anim_finished()
			end,
		},
		{
			alignment = "right_alignment",
			display_name = "loc_contracts_contract_complexity_tutorial",
			input_action = "expedition_menu_show_tutorial",
			on_pressed_callback = "cb_show_tutorial",
			visibility_function = function (parent)
				return parent:node_enter_anim_finished()
			end,
		},
		{
			alignment = "right_alignment",
			display_name = "loc_switch_tab",
			input_action = "mission_board_show_mission_list",
			on_pressed_callback = "cb_switch_tab",
			visibility_function = function (parent)
				local view_element_expedition_view_mission_info = parent:_element("view_element_expedition_view_mission_info")
				local multiple_tabs

				if view_element_expedition_view_mission_info and view_element_expedition_view_mission_info._mission_info_tabs then
					local tab_count = #view_element_expedition_view_mission_info._mission_info_tabs

					multiple_tabs = tab_count > 1
				end

				return view_element_expedition_view_mission_info and view_element_expedition_view_mission_info:visible() and multiple_tabs and parent:node_enter_anim_finished()
			end,
		},
	},
}

return {
	MATCH_VISIBILITY = MATCH_VISIBILITY,
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	background_world_params = background_world_params,
	input_legend_params = input_legend_params,
}
