local SocialConstants = require("scripts/managers/data_service/services/social/social_constants")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ViewStyles = require("scripts/ui/views/social_menu_roster_view/social_menu_roster_view_styles")
local SocialMenuSettings = require("scripts/ui/views/social_menu_view/social_menu_view_settings")
local social_service = Managers.data_service.social
local blueprint_styles = ViewStyles.blueprints
local change_functions = ViewStyles.change_functions
local social_roster_view_blueprints = {}
local _listbutton_label_change_function = ButtonPassTemplates.list_button_label_change_function
local _party_status_in_my_party = SocialConstants.PartyStatus.mine
local _party_status_in_same_mission = SocialConstants.PartyStatus.same_mission
local _party_status_invite_pending = SocialConstants.PartyStatus.invite_pending
local _party_status_in_others_party = SocialConstants.PartyStatus.other
local _online_status_reconnecting = SocialConstants.OnlineStatus.reconnecting
local _in_other_party_format = "%d/" .. SocialMenuSettings.max_num_party_members .. " \ue004"
local _activity_param = {}

local function _player_name_or_status_change_function(content, style)
	local player_info = content.player_info
	local character_name = player_info:character_name()
	local no_character_name = character_name == ""

	if no_character_name then
		local activity_id = player_info:player_activity_id()

		if activity_id ~= content.activity_id then
			if activity_id then
				local activity_loc_string = player_info:player_activity_loc_string()
				_activity_param.activity = Localize(activity_loc_string)
				content.name_or_activity = Localize("loc_social_menu_in_activity", true, _activity_param)
			else
				content.name_or_activity = Localize("loc_social_menu_no_account_name")
				content.activity_id = activity_id
			end
		end
	end

	style.font_size = (no_character_name and style.font_size_small) or style.font_size_default

	if not content.is_own_player then
		local party_status = content.party_status

		if party_status == _party_status_in_my_party or party_status == _party_status_in_same_mission then
			style.default_color = style.party_member_color
		else
			style.default_color = style.not_in_party_color
		end
	end

	_listbutton_label_change_function(content, style)
end

local function _account_name_change_function(content, style)
	local player_info = content.player_info
	content.account_name = player_info:user_display_name()
	local no_character_name = player_info:character_name() == ""
	style.font_size = (no_character_name and style.font_size_large) or style.font_size_default
	style.offset[2] = (no_character_name and style.vertical_offset_large) or style.vertical_offset_default
	style.default_color = (no_character_name and style.default_color_large) or style.default_color_default

	_listbutton_label_change_function(content, style)
end

local function _player_widget_name_function(player_info, optional_unique_id)
	return optional_unique_id or player_info:account_id() or player_info:platform_user_id()
end

social_roster_view_blueprints.player_plaque = {
	size = blueprint_styles.player_plaque.size,
	pass_template = {
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			value = "content/ui/materials/buttons/background_selected",
			style_id = "background",
			pass_type = "texture",
			change_function = change_functions.player_plaque_background
		},
		{
			value = "content/ui/materials/base/ui_portrait_frame_base",
			value_id = "portrait",
			pass_type = "texture",
			style_id = "portrait"
		},
		{
			value_id = "in_party_overlay",
			style_id = "portrait_overlay",
			pass_type = "texture",
			value = "content/ui/materials/icons/portraits/status_party",
			visibility_function = function (content, style)
				local party_status = content.party_status

				return not content.party_panel and (party_status == _party_status_in_my_party or party_status == _party_status_in_same_mission)
			end
		},
		{
			value_id = "invite_overlay",
			style_id = "portrait_overlay",
			pass_type = "texture",
			value = "content/ui/materials/icons/portraits/status_party_invite",
			visibility_function = function (content, style)
				return content.party_status == _party_status_invite_pending or content.online_status == _online_status_reconnecting
			end
		},
		{
			style_id = "name_or_activity",
			pass_type = "text",
			value_id = "name_or_activity",
			value = Localize("loc_social_menu_no_name_or_activity"),
			change_function = _player_name_or_status_change_function
		},
		{
			style_id = "account_name",
			pass_type = "text",
			value_id = "account_name",
			value = Localize("loc_social_menu_no_account_name"),
			change_function = _account_name_change_function
		},
		{
			style_id = "party_membership",
			pass_type = "text",
			value_id = "party_membership",
			value = "",
			change_function = function (content, style)
				local player_info = content.player_info
				local num_members = (player_info:player_activity_id() == "mission" and player_info:num_mission_members()) or player_info:num_party_members()
				content.party_membership = string.format(_in_other_party_format, num_members)

				_listbutton_label_change_function(content, style)
			end,
			visibility_function = function (content, style)
				return content.party_status == _party_status_in_others_party or content.player_info:player_activity_id() == "mission"
			end
		},
		{
			style_id = "highlight",
			pass_type = "texture",
			value = "content/ui/materials/frames/hover",
			visibility_function = ButtonPassTemplates.list_button_focused_visibility_function,
			change_function = ButtonPassTemplates.list_button_highlight_change_function
		}
	},
	style = blueprint_styles.player_plaque,
	init = function (parent, widget, player_info, callback_name, secondary_callback_name, ui_renderer)
		local widget_content = widget.content
		widget_content.player_info = player_info
		widget_content.online_status = player_info:online_status()
		widget_content.party_status = player_info:party_status()
		widget_content.is_blocked = false
		local character_name = parent:formatted_character_name(player_info)

		if character_name ~= "" then
			widget_content.name_or_activity = character_name
			widget_content.activity_id = nil
		end

		if player_info:is_own_player() then
			widget_content.is_own_player = true
			local name_or_activity_style = widget.style.name_or_activity
			name_or_activity_style.default_color = name_or_activity_style.own_player_color
			name_or_activity_style.material = name_or_activity_style.own_player_material
		end

		local hotspot = widget_content.hotspot
		hotspot.use_is_focused = true
		hotspot.pressed_callback = callback(parent, "cb_show_popup_menu_for_player", player_info)
	end,
	get_name_suffix = _player_widget_name_function
}
local _online_status_text_params = {}
social_roster_view_blueprints.player_plaque_platform_online = {
	size = blueprint_styles.player_plaque.size,
	pass_template = {
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			value = "content/ui/materials/buttons/background_selected",
			style_id = "background",
			pass_type = "texture",
			change_function = change_functions.player_plaque_background
		},
		{
			value = "content/ui/materials/base/ui_portrait_frame_base",
			value_id = "portrait",
			pass_type = "texture",
			style_id = "portrait"
		},
		{
			value_id = "invite_overlay",
			style_id = "portrait_overlay",
			pass_type = "texture",
			value = "content/ui/materials/icons/portraits/status_party_invite",
			visibility_function = function (content, style)
				local player_info = content.player_info

				return player_info:party_status() == _party_status_invite_pending
			end
		},
		{
			value_id = "status",
			pass_type = "text",
			style_id = "status",
			change_function = _listbutton_label_change_function
		},
		{
			style_id = "account_name",
			pass_type = "text",
			value_id = "account_name",
			value = "N/A",
			change_function = _listbutton_label_change_function
		},
		{
			style_id = "highlight",
			pass_type = "texture",
			value = "content/ui/materials/frames/hover",
			visibility_function = ButtonPassTemplates.list_button_focused_visibility_function,
			change_function = ButtonPassTemplates.list_button_highlight_change_function
		}
	},
	style = blueprint_styles.player_plaque_platform_online,
	init = function (parent, widget, player_info, callback_name, secondary_callback_name, ui_renderer)
		local text_params = _online_status_text_params

		if not text_params.platform then
			text_params.platform = social_service:platform_display_name()
		end

		local widget_content = widget.content
		widget_content.player_info = player_info
		widget_content.account_name = player_info:user_display_name()
		widget_content.online_status = player_info:online_status()
		widget_content.status = Localize("loc_social_menu_player_online_status_platform_online", false, text_params)
		widget_content.is_blocked = false
		local hotspot = widget_content.hotspot
		hotspot.use_is_focused = true
		hotspot.pressed_callback = callback(parent, "cb_show_popup_menu_for_player", player_info)
	end,
	get_name_suffix = _player_widget_name_function
}
social_roster_view_blueprints.player_plaque_blocked = {
	size = blueprint_styles.player_plaque.size,
	pass_template = {
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			value = "content/ui/materials/buttons/background_selected",
			style_id = "background",
			pass_type = "texture",
			change_function = change_functions.player_plaque_background
		},
		{
			value = "content/ui/materials/frames/line_medium_inner_shadow",
			style_id = "icon_background",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/icons/portraits/status_blocked",
			style_id = "icon_blocked",
			pass_type = "texture"
		},
		{
			style_id = "status",
			pass_type = "text",
			value_id = "status",
			value = Localize("loc_social_menu_player_blocked"),
			change_function = _listbutton_label_change_function
		},
		{
			style_id = "account_name",
			pass_type = "text",
			value_id = "account_name",
			value = "N/A",
			change_function = _listbutton_label_change_function
		},
		{
			style_id = "highlight",
			pass_type = "texture",
			value = "content/ui/materials/frames/hover",
			visibility_function = ButtonPassTemplates.list_button_focused_visibility_function,
			change_function = ButtonPassTemplates.list_button_highlight_change_function
		}
	},
	style = blueprint_styles.player_plaque_blocked,
	init = function (parent, widget, player_info, callback_name, secondary_callback_name, ui_renderer)
		local widget_content = widget.content
		widget_content.player_info = player_info
		widget_content.account_name = player_info:user_display_name()
		widget_content.online_status = player_info:online_status()
		widget_content.is_blocked = true
		local hotspot = widget_content.hotspot
		hotspot.use_is_focused = true
		hotspot.pressed_callback = callback(parent, "cb_show_popup_menu_for_player", player_info)
	end,
	get_name_suffix = _player_widget_name_function
}
social_roster_view_blueprints.player_plaque_offline = {
	size = blueprint_styles.player_plaque.size,
	pass_template = {
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			value = "content/ui/materials/buttons/background_selected",
			style_id = "background",
			pass_type = "texture",
			change_function = change_functions.player_plaque_background
		},
		{
			value = "content/ui/materials/frames/line_medium_inner_shadow",
			style_id = "icon_background",
			pass_type = "texture"
		},
		{
			style_id = "status",
			pass_type = "text",
			value_id = "status",
			value = Localize("loc_social_menu_player_online_status_offline"),
			change_function = _listbutton_label_change_function
		},
		{
			style_id = "account_name",
			pass_type = "text",
			value_id = "account_name",
			value = "N/A",
			change_function = _listbutton_label_change_function
		},
		{
			style_id = "highlight",
			pass_type = "texture",
			value = "content/ui/materials/frames/hover",
			visibility_function = ButtonPassTemplates.list_button_focused_visibility_function,
			change_function = ButtonPassTemplates.list_button_highlight_change_function
		}
	},
	style = blueprint_styles.player_plaque_offline,
	init = function (parent, widget, player_info, callback_name, secondary_callback_name, ui_renderer)
		local widget_content = widget.content
		widget_content.player_info = player_info
		widget_content.account_name = player_info:user_display_name()
		widget_content.online_status = player_info:online_status()
		widget_content.is_blocked = false
		local hotspot = widget_content.hotspot
		hotspot.use_is_focused = true
		hotspot.pressed_callback = callback(parent, "cb_show_popup_menu_for_player", player_info)
	end,
	get_name_suffix = _player_widget_name_function
}
local _header_params = {}
social_roster_view_blueprints.group_header = {
	size = blueprint_styles.group_header.size,
	pass_template = {
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text"
		}
	},
	style = blueprint_styles.group_header,
	init = function (parent, widget, context, callback_name, secondary_callback_name, ui_renderer)
		local widget_content = widget.content
		local header = context.header
		local num_members = context.num_members
		local header_params = _header_params
		header_params.platform = social_service:platform_display_name()
		header_params.num_in_group = num_members
		widget_content.text = Localize(header, true, _header_params)
		widget_content.header = header
		widget_content.num_members = num_members
	end,
	get_name_suffix = function (context)
		return context.group_name .. "_" .. context.num_members
	end
}
social_roster_view_blueprints.list_divider = {
	size = blueprint_styles.list_divider.size,
	pass_template = {
		{
			value = "content/ui/materials/dividers/horizontal_frame_big_middle",
			style_id = "divider",
			pass_type = "texture"
		}
	},
	style = blueprint_styles.list_divider,
	get_name_suffix = function (context)
		return "divider_" .. context.name
	end
}

return social_roster_view_blueprints
