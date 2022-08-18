local SocialConstants = require("scripts/managers/data_service/services/social/social_constants")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local FriendStatus = SocialConstants.FriendStatus
local OnlineStatus = SocialConstants.OnlineStatus
local PartyStatus = SocialConstants.PartyStatus
local Platforms = SocialConstants.Platforms
local _popup_menu_items = {}
local _num_menu_items = 0

local function _new_menu_items_list()
	local popup_menu_items = _popup_menu_items
	_num_menu_items = 0

	return popup_menu_items
end

local function _get_next_list_item(at_index)
	local popup_menu_items = _popup_menu_items
	local last_item_index = _num_menu_items + 1
	local new_item = popup_menu_items[last_item_index]

	if new_item then
		table.clear(new_item)
	else
		new_item = {}
		popup_menu_items[last_item_index] = new_item
	end

	if at_index then
		popup_menu_items[last_item_index] = nil

		table.insert(popup_menu_items, at_index, new_item)
	end

	_num_menu_items = last_item_index

	return new_item, last_item_index
end

local function _add_divider(at_index)
	local item, num_items = _get_next_list_item(at_index)
	item.blueprint = "group_divider"
	item.label = "divider_" .. num_items
end

local function _add_party_management_items(parent, player_info, is_own_player)
	local party_status = player_info:party_status()

	if is_own_player then
		local list_item = _get_next_list_item()
		list_item.blueprint = "button"
		list_item.label = Localize("loc_social_menu_leave_party")
		list_item.callback = callback(parent, "cb_leave_party", player_info)
		list_item.is_disabled = player_info:num_party_members() < 2
		list_item.on_pressed_sound = UISoundEvents.social_menu_leave_party
	elseif party_status == PartyStatus.mine or party_status == PartyStatus.same_mission then
		local can_kick, cannot_kick_reason = Managers.data_service.social:can_kick_from_party(player_info)
		local list_item = _get_next_list_item()
		list_item.blueprint = not can_kick and "disabled_button_with_explanation" or "button"
		list_item.label = Localize("loc_social_menu_vote_to_kick_from_party")
		list_item.callback = callback(parent, "cb_vote_to_kick_player_from_party", player_info)
		list_item.is_disabled = not can_kick
		list_item.reason_for_disabled = cannot_kick_reason and Localize(cannot_kick_reason) or ""
		list_item.on_pressed_sound = UISoundEvents.social_menu_initiate_kick_vote
	elseif party_status == PartyStatus.invite_pending then
		local list_item = _get_next_list_item()
		list_item.blueprint = "button"
		list_item.label = Localize("loc_social_menu_cancel_party_invite")
		list_item.callback = callback(parent, "cb_cancel_party_invite", player_info)
		list_item.on_pressed_sound = UISoundEvents.social_menu_cancel_invite
	else
		local social_service = Managers.data_service.social
		local can_invite, cannot_invite_reason = social_service:can_invite_to_party(player_info)
		local can_join, cannot_join_reason = social_service:can_join_party(player_info)
		local list_item = _get_next_list_item()
		list_item.blueprint = cannot_invite_reason and "disabled_button_with_explanation" or "button"
		list_item.label = Localize("loc_social_menu_invite_to_party")
		list_item.reason_for_disabled = cannot_invite_reason and Localize(cannot_invite_reason)
		list_item.callback = callback(parent, "cb_invite_player_to_party", player_info)
		list_item.is_disabled = not can_invite
		list_item.on_pressed_sound = UISoundEvents.social_menu_send_invite
		list_item = _get_next_list_item()
		list_item.blueprint = cannot_join_reason and "disabled_button_with_explanation" or "button"
		list_item.label = Localize("loc_social_menu_join_party")
		list_item.reason_for_disabled = cannot_join_reason and Localize(cannot_join_reason)
		list_item.callback = callback(parent, "cb_join_players_party", player_info)
		list_item.is_disabled = not can_join
	end
end

local function _add_friend_management_items(parent, player_info)
	local friend_status = player_info:friend_status()

	if friend_status == FriendStatus.none then
		local list_item = _get_next_list_item()
		list_item.blueprint = "button"
		list_item.label = Localize("loc_social_menu_send_friend_request")
		list_item.callback = callback(parent, "cb_send_friend_request", player_info)
		list_item.is_disabled = not player_info:account_id()
		list_item.on_pressed_sound = UISoundEvents.social_menu_send_friend_request

		_add_divider()
	elseif friend_status == FriendStatus.friend then
		_add_divider()

		local list_item = _get_next_list_item()
		list_item.blueprint = "button"
		list_item.label = Localize("loc_social_menu_unfriend_player")
		list_item.callback = callback(parent, "cb_unfriend_player", player_info)
		list_item.on_pressed_sound = UISoundEvents.social_menu_unfriend_player
	elseif friend_status == FriendStatus.invited then
		local list_item = _get_next_list_item()
		list_item.blueprint = "button"
		list_item.label = Localize("loc_social_menu_cancel_friend_request")
		list_item.callback = callback(parent, "cb_cancel_friend_request", player_info)
		list_item.on_pressed_sound = UISoundEvents.social_menu_cancel_friend_request

		_add_divider()
	elseif friend_status == FriendStatus.invite then
		local can_accept, cannot_befriend_reason = Managers.data_service.social:can_befriend()
		local request_header_params = {
			player = player_info:user_display_name()
		}
		local list_item = _get_next_list_item(1)
		list_item.blueprint = "choice_header"
		list_item.label = Localize("loc_social_menu_received_friend_request_header", true, request_header_params)
		list_item = _get_next_list_item(2)
		list_item.blueprint = not can_accept and "disabled_button_with_explanation" or "choice_button"
		list_item.label = Localize("loc_social_menu_accept_friend_request")
		list_item.icon = "content/ui/materials/icons/list_buttons/check"
		list_item.reason_for_disabled = cannot_befriend_reason and Localize(cannot_befriend_reason)
		list_item.callback = callback(parent, "cb_accept_friend_request", player_info)
		list_item.is_disabled = not can_accept
		list_item = _get_next_list_item(3)
		list_item.blueprint = "choice_button"
		list_item.label = Localize("loc_social_menu_reject_friend_request")
		list_item.icon = "content/ui/materials/icons/list_buttons/cross"
		list_item.callback = callback(parent, "cb_reject_friend_request", player_info)

		_add_divider(4)
	end
end

local function _add_communication_management_items(parent, player_info, is_blocked)
	local social_service = Managers.data_service.social
	local account_id = player_info:account_id()
	local can_mute_text, cannot_mute_text_reason = social_service:can_mute_player_in_text_chat(account_id)
	local is_text_muted = player_info:is_text_muted()
	local list_item = _get_next_list_item()
	list_item.blueprint = not is_blocked and cannot_mute_text_reason and "disabled_button_with_explanation" or "checkbox_button"
	list_item.label = Localize("loc_social_menu_mute_chat")
	list_item.is_checked = is_text_muted or is_blocked
	list_item.callback = callback(parent, "cb_mute_text_chat", player_info)
	list_item.is_disabled = not can_mute_text or is_blocked
	list_item.reason_for_disabled = cannot_mute_text_reason and Localize(cannot_mute_text_reason)
	list_item.on_pressed_sound = is_text_muted and UISoundEvents.social_menu_unmute_player_text or UISoundEvents.social_menu_mute_player_text
	local can_mute_voice, cannot_mute_voice_reason = social_service:can_mute_player_in_voice_chat(account_id)
	local is_voice_muted = player_info:is_voice_muted()
	list_item = _get_next_list_item()
	list_item.blueprint = not is_blocked and cannot_mute_text_reason and "disabled_button_with_explanation" or "checkbox_button"
	list_item.label = Localize("loc_social_menu_mute_voice")
	list_item.is_checked = is_voice_muted or is_blocked
	list_item.callback = callback(parent, "cb_mute_voice_chat", player_info)
	list_item.is_disabled = not can_mute_voice or is_blocked
	list_item.reason_for_disabled = cannot_mute_voice_reason and Localize(cannot_mute_voice_reason)
	list_item.on_pressed_sound = is_voice_muted and UISoundEvents.social_menu_unmute_player_voice or UISoundEvents.social_menu_mute_player_voice

	if is_blocked then
		list_item = _get_next_list_item()
		list_item.blueprint = "button"
		list_item.label = Localize("loc_social_menu_unblock")
		list_item.callback = callback(parent, "cb_unblock_player", player_info)
		list_item.on_pressed_sound = UISoundEvents.social_menu_unblock_player
	else
		local can_block, cannot_block_reason = social_service:can_block(account_id)
		list_item = _get_next_list_item()
		list_item.blueprint = cannot_block_reason and "disabled_button_with_explanation" or "button"
		list_item.label = Localize("loc_social_menu_block")
		list_item.callback = callback(parent, "cb_block_player", player_info)
		list_item.is_disabled = not can_block
		list_item.reason_for_disabled = cannot_block_reason and Localize(cannot_block_reason)
		list_item.on_pressed_sound = UISoundEvents.social_menu_block_player
	end
end

local view_element_player_social_popup_content_list = {
	from_player_info = function (parent, player_info)
		local social_service = Managers.data_service.social
		local is_own_player = player_info:is_own_player()
		local is_blocked = player_info:is_blocked()
		local popup_menu_items = _new_menu_items_list()

		if not is_blocked then
			_add_party_management_items(parent, player_info, is_own_player)
			_add_divider()
		end

		local player_profile_item = _get_next_list_item()
		player_profile_item.blueprint = "button"
		player_profile_item.label = Localize("loc_social_menu_player_profile")
		player_profile_item.callback = callback(parent, "cb_show_player_profile", player_info)
		player_profile_item.is_disabled = true
		player_profile_item.on_pressed_sound = UISoundEvents.social_menu_see_player_profile
		local xbox_platform = Platforms.xbox

		if social_service:platform() == xbox_platform and player_info:platform() == xbox_platform then
			local xbox_profile_item = _get_next_list_item()
			xbox_profile_item.blueprint = "button"
			xbox_profile_item.label = Localize("loc_social_menu_xbox_profile")
			xbox_profile_item.callback = callback(parent, "cb_show_xbox_profile", player_info)
			xbox_profile_item.on_pressed_sound = UISoundEvents.social_menu_see_player_profile
		end

		if not is_own_player then
			if not is_blocked then
				_add_friend_management_items(parent, player_info)
			else
				_add_divider()
			end

			_add_communication_management_items(parent, player_info, is_blocked)
		end

		return popup_menu_items, _num_menu_items
	end
}

return settings("ViewElementPlayerSocialPopupContentList", view_element_player_social_popup_content_list)
