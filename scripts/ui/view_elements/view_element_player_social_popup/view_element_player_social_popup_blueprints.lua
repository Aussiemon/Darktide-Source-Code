local SocialConstants = require("scripts/managers/data_service/services/social/social_constants")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local PopupStyles = require("scripts/ui/view_elements/view_element_player_social_popup/view_element_player_social_popup_styles")
local SocialMenuSettings = require("scripts/ui/views/social_menu_view/social_menu_view_settings")
local TextInputPassTemplates = require("scripts/ui/pass_templates/text_input_pass_templates")
local ViewStyles = require("scripts/ui/views/social_menu_roster_view/social_menu_roster_view_styles")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local blueprint_styles = PopupStyles.blueprints
local OnlineStatus = SocialConstants.OnlineStatus
local view_element_player_popup_blueprints = {}
local temp_text_size = {}

local function get_style_text_size(text, style, ui_renderer)
	local text_font_data = UIFonts.data_by_type(style.font_type)
	local text_font = text_font_data.path
	local text_size = style.size
	local size_addition = style.size_addition

	if text_size then
		temp_text_size[1] = text_size[1]
		temp_text_size[2] = text_size[2]

		if size_addition then
			temp_text_size[1] = temp_text_size[1] + (size_addition[1] or 0)
			temp_text_size[2] = temp_text_size[2] + (size_addition[2] or 0)
		end
	end

	local use_max_extents = true
	local text_options = UIFonts.get_font_options_by_style(style)
	local text_width, text_height = UIRenderer.text_size(ui_renderer, text, style.font_type, style.font_size, text_size and temp_text_size, text_options, use_max_extents)

	return text_width, text_height
end

view_element_player_popup_blueprints.button = {
	size = {
		PopupStyles.column_width,
		ButtonPassTemplates.list_button_default_height
	},
	pass_template = ButtonPassTemplates.list_button,
	init = function (parent, widget, context, _, ui_renderer)
		local widget_content = widget.content
		widget_content.text = context.label
		widget_content.show_background_with_hover = true
		local widget_style = widget.style
		widget_style.text.size_addition = {
			-100,
			0
		}
		local current_size = widget_content.size
		local text_style = widget.style.text
		text_style.size = current_size
		local text_width, text_height = get_style_text_size(context.label, text_style, ui_renderer)
		current_size[2] = math.max(current_size[2], text_height + 30)
		local hotspot = widget_content.hotspot
		hotspot.disabled = context.is_disabled
		hotspot.pressed_callback = context.callback
		local on_pressed_sound = context.on_pressed_sound

		if on_pressed_sound then
			widget.style.hotspot.on_pressed_sound = on_pressed_sound
		end
	end
}
view_element_player_popup_blueprints.disabled_button_with_explanation = {
	size = {
		PopupStyles.column_width,
		ButtonPassTemplates.list_button_default_height
	},
	pass_template = ButtonPassTemplates.list_button_two_rows_with_icon,
	style = blueprint_styles.disabled_button_with_explanation,
	init = function (parent, widget, context)
		local widget_content = widget.content
		widget_content.text = context.label
		widget_content.second_row = context.reason_for_disabled
		widget_content.show_background_with_hover = true
		widget_content.icon = "content/ui/materials/icons/list_buttons/block"
		local hotspot = widget_content.hotspot
		hotspot.disabled = true
		local on_pressed_sound = context.on_pressed_sound

		if on_pressed_sound then
			widget.style.hotspot.on_pressed_sound = on_pressed_sound
		end
	end
}
view_element_player_popup_blueprints.search_header = {
	size = blueprint_styles.search_header.size,
	pass_template = {
		{
			style_id = "search_text",
			value_id = "text",
			pass_type = "text"
		}
	},
	style = blueprint_styles.search_header,
	init = function (parent, widget, context)
		local widget_content = widget.content
		widget_content.text = context.label
		local style = widget.style.search_text
		local text_width, text_height = UIRenderer.text_size(parent._ui_renderer, context.label, style.font_type, style.font_size, {
			blueprint_styles.search_header.size[1],
			math.huge
		})
		widget_content.size[1] = math.max(widget_content.size[1], text_width)
		widget_content.size[2] = math.max(widget_content.size[2], text_height)
	end
}
view_element_player_popup_blueprints.choice_header = {
	size = blueprint_styles.choice_header.size,
	pass_template = {
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text"
		}
	},
	style = blueprint_styles.choice_header,
	init = function (parent, widget, context)
		local widget_content = widget.content
		widget_content.text = context.label
	end
}
view_element_player_popup_blueprints.choice_button = {
	size = {
		PopupStyles.column_width,
		ButtonPassTemplates.list_button_default_height
	},
	pass_template = ButtonPassTemplates.list_button_with_background_and_icon,
	style = blueprint_styles.choice_button,
	init = function (parent, widget, context)
		local widget_content = widget.content
		widget_content.text = context.label
		local icon = context.icon

		if icon then
			widget_content.icon = icon
		end

		local hotspot = widget_content.hotspot
		hotspot.disabled = context.is_disabled
		hotspot.pressed_callback = context.callback
		local on_pressed_sound = context.on_pressed_sound

		if on_pressed_sound then
			widget.style.hotspot.on_pressed_sound = on_pressed_sound
		end
	end
}
view_element_player_popup_blueprints.checkbox_button = {
	size = {
		PopupStyles.column_width,
		ButtonPassTemplates.list_button_default_height
	},
	pass_template = {
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot",
			content = {
				use_is_focused = true
			}
		},
		{
			style_id = "background_selected",
			pass_type = "texture",
			value = "content/ui/materials/buttons/background_selected",
			change_function = function (content, style)
				style.color[1] = 255 * content.hotspot.anim_select_progress
			end,
			visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
		},
		{
			style_id = "highlight",
			pass_type = "texture",
			value = "content/ui/materials/frames/hover",
			change_function = ButtonPassTemplates.list_button_highlight_change_function,
			visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
		},
		{
			style_id = "checkbox_background",
			pass_type = "texture",
			value_id = "checkbox_background",
			value = "content/ui/materials/icons/list_buttons/box",
			change_function = ButtonPassTemplates.list_button_label_change_function
		},
		{
			style_id = "check_mark",
			pass_type = "texture",
			value_id = "check_mark",
			value = "content/ui/materials/icons/list_buttons/check",
			change_function = ButtonPassTemplates.list_button_label_change_function,
			visibility_function = function (content, style)
				return content.checked
			end
		},
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			change_function = ButtonPassTemplates.list_button_label_change_function
		}
	},
	style = blueprint_styles.checkbox_button,
	init = function (parent, widget, context)
		local widget_content = widget.content
		local widget_style = widget.style
		local is_disabled = context.is_disabled
		widget_content.text = context.label
		widget_content.checked = context.is_checked or false
		local hotspot = widget_content.hotspot
		widget_content.pressed_callback = context.callback

		hotspot.pressed_callback = function ()
			local content = widget_content
			local pressed_callback = content.pressed_callback
			content.checked = not content.checked

			pressed_callback(content.checked)
		end

		hotspot.disabled = is_disabled
		local on_pressed_sound = context.on_pressed_sound

		if on_pressed_sound then
			widget_style.hotspot.on_pressed_sound = on_pressed_sound
		end
	end
}
view_element_player_popup_blueprints.group_divider = {
	size = blueprint_styles.group_divider.size,
	pass_template = {
		{
			value = "content/ui/materials/dividers/skull_rendered_center_04",
			style_id = "divider",
			pass_type = "texture"
		}
	},
	style = blueprint_styles.group_divider
}
view_element_player_popup_blueprints.text_entry_field = {
	size = {
		PopupStyles.column_width,
		ButtonPassTemplates.list_button_default_height
	},
	pass_template = TextInputPassTemplates.terminal_input_field,
	init = function (parent, widget)
		local content = widget.content
		content.input_text = ""
		content.max_length = 10
		content.virtual_keyboard_title = Localize("loc_social_menu_find_player_virtual_keyboard_title")
		local hotspot = content.hotspot
		hotspot.use_is_focused = true
	end,
	update = function (parent, widget)
		local content = widget.content
		local previous_fatshark_id = parent:previously_searched_fatshark_id()
		local fatshark_id = widget.content.input_text

		if type(fatshark_id) == "string" and string.len(fatshark_id) == 10 and fatshark_id ~= previous_fatshark_id then
			parent:_search_for_player(fatshark_id)

			local hotspot = content.hotspot
			hotspot.use_is_focused = false
			hotspot.disabled = true
			content.is_writing = false
		end
	end
}
local change_functions = ViewStyles.change_functions
local _listbutton_label_change_function = ButtonPassTemplates.list_button_label_change_function
local _party_status_in_my_party = SocialConstants.PartyStatus.mine
local _party_status_in_same_mission = SocialConstants.PartyStatus.same_mission
local _party_status_invite_pending = SocialConstants.PartyStatus.invite_pending
local _party_status_in_others_party = SocialConstants.PartyStatus.other
local _online_status_reconnecting = SocialConstants.OnlineStatus.reconnecting
local _in_other_party_format = "%d/" .. SocialMenuSettings.max_num_party_members .. " "
local _activity_param = {}

local function _player_widget_name_function(player_info, optional_unique_id)
	if not player_info then
		return "invalid user id"
	end

	return optional_unique_id or player_info:account_id() or player_info:platform_user_id()
end

local function _player_name_or_status_change_function(content, style)
	if not content.player_info then
		return
	end

	local player_info = content.player_info
	local character_name = player_info:character_name()
	local no_character_name = character_name == ""

	if no_character_name then
		local online_status = player_info:online_status()

		if online_status == OnlineStatus.offline then
			content.name_or_activity = Localize("loc_social_menu_player_online_status_offline")
		else
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
	end

	style.font_size = no_character_name and style.font_size_small or style.font_size_default

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
	if not content.player_info then
		return
	end

	local player_info = content.player_info
	local platform = player_info:platform()
	content.account_name = player_info:user_display_name()
	local no_character_name = player_info:character_name() == ""
	style.font_size = no_character_name and style.font_size_large or style.font_size_default
	style.offset[2] = no_character_name and style.vertical_offset_large or style.vertical_offset_default
	style.default_color = no_character_name and style.default_color_large or style.default_color_default

	_listbutton_label_change_function(content, style)
end

local _formatted_character_name_character_name_params = {}

local function _formatted_character_name(player_info)
	local character_name = player_info:character_name()

	if character_name ~= "" then
		local character_name_params = _formatted_character_name_character_name_params
		character_name_params.character_name = character_name
		character_name_params.character_level = player_info:character_level()
		character_name = Localize("loc_social_menu_character_name_format", true, character_name_params)
	end

	return character_name
end

view_element_player_popup_blueprints.player_plaque = {
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
			value_id = "portrait",
			style_id = "portrait",
			pass_type = "texture",
			value = "content/ui/materials/base/ui_portrait_frame_base",
			visibility_function = function (content, style)
				local player_info = content.player_info

				return not not player_info and content.portrait
			end
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
			value = "",
			change_function = _player_name_or_status_change_function
		},
		{
			value_id = "search_status_text",
			pass_type = "text",
			style_id = "search_status_text",
			value = Localize("loc_social_menu_find_player_wait_for_input")
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
				if not content.player_info then
					return
				end

				local player_info = content.player_info
				local num_members = player_info:player_activity_id() == "mission" and player_info:num_mission_members() or player_info:num_party_members()
				content.party_membership = string.format(_in_other_party_format, num_members)

				_listbutton_label_change_function(content, style)
			end,
			visibility_function = function (content, style)
				return content.player_info and (content.party_status == _party_status_in_others_party or content.player_info:player_activity_id() == "mission")
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
		widget_content.parent = parent
		widget_content.player_info_updated = true
		widget_content.online_status = ""
		widget_content.party_status = ""
	end,
	update = function (parent, widget)
		local widget_content = widget.content

		if widget_content.player_info and widget_content.player_info_updated then
			local player_info = widget_content.player_info
			widget_content.online_status = player_info:online_status()
			widget_content.party_status = player_info:party_status()
			widget_content.is_blocked = false
			widget_content.player_info_updated = false
			local character_name = _formatted_character_name(player_info)

			if character_name ~= "" then
				widget_content.name_or_activity = character_name
				widget_content.activity_id = nil
			end

			local hotspot = widget_content.hotspot
			hotspot.use_is_focused = true
			hotspot.pressed_callback = callback(parent, "cb_set_player_info", player_info)
		elseif not widget_content.player_info and widget_content.player_info_updated then
			widget_content.name_or_activity = ""
			widget_content.online_status = ""
			widget_content.party_status = ""
			widget_content.account_name = ""
			widget_content.is_own_player = false
			local hotspot = widget_content.hotspot
			hotspot.use_is_focused = false
			hotspot.pressed_callback = nil
		end
	end,
	get_name_suffix = _player_widget_name_function
}

return settings("ViewElementPlayerPopupBlueprints", view_element_player_popup_blueprints)
