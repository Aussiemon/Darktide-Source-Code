local Promise = require("scripts/foundation/utilities/promise")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local Definitions = require("scripts/ui/views/social_menu_roster_view/social_menu_roster_view_definitions")
local Blueprints = require("scripts/ui/views/social_menu_roster_view/social_menu_roster_view_blueprints")
local RosterViewStyles = require("scripts/ui/views/social_menu_roster_view/social_menu_roster_view_styles")
local SocialConstants = require("scripts/managers/data_service/services/social/social_constants")
local SocialMenuSettings = require("scripts/ui/views/social_menu_view/social_menu_view_settings")
local ViewElementPlayerSocialPopup = require("scripts/ui/view_elements/view_element_player_social_popup/view_element_player_social_popup")
local ViewSettings = require("scripts/ui/views/social_menu_roster_view/social_menu_roster_view_settings")
local XboxLive = require("scripts/foundation/utilities/xbox_live")
local OnlineStatus = SocialConstants.OnlineStatus
local PartyStatus = SocialConstants.PartyStatus
local FriendStatus = SocialConstants.FriendStatus
local social_service = Managers.data_service.social
local SocialMenuRosterView = class("SocialMenuRosterView", "BaseView")
local POPUP_NAME = "player_social_popup"
local FRIENDS_LIST = 1
local PREVIOUS_MISSION_COMPANIONS_LIST = 2
local HUB_PLAYERS_LIST = 3
local FRIEND_INVITES_LIST = 4
local BLOCKED_PLAYERS_LIST = 5
local ROSTER_GRID_SCENEGRAPH_ID = "roster_grid_content"
local PARTY_GRID_SCENEGRAPH_ID = "party_grid"
local PARTY_GRID_ID = 1
local ROSTER_GRID_ID = 2
local _SCENEGRAPH_IDS = {
	[PARTY_GRID_ID] = PARTY_GRID_SCENEGRAPH_ID,
	[ROSTER_GRID_ID] = ROSTER_GRID_SCENEGRAPH_ID
}

local function _debug_warning(function_name, format, ...)
	local message_format = string.format("%s(): %s", function_name, format)

	Log.exception("SocialMenuRosterView", message_format, ...)
end

local function _default_group_selection_function(player_info)
	local online_status = player_info:online_status(true)

	if online_status == OnlineStatus.online or online_status == OnlineStatus.reconnecting then
		return 1
	elseif online_status == OnlineStatus.platform_online then
		return 2
	else
		return 3
	end
end

local function _group_by_invite(player_info)
	local friend_status = player_info:friend_status()
	local online_status = player_info:online_status(true)

	if friend_status == FriendStatus.invite then
		if online_status == OnlineStatus.online then
			return 1
		elseif online_status == OnlineStatus.platform_online then
			return 2
		else
			return 3
		end
	elseif friend_status == FriendStatus.invited then
		if online_status == OnlineStatus.online then
			return 4
		elseif online_status == OnlineStatus.platform_online then
			return 5
		else
			return 6
		end
	else
		return 7
	end
end

local function _sort_by_name(a, b)
	return a:user_display_name(true) < b:user_display_name(true)
end

local function _sort_by_default_group_selection(a, b)
	local a_group_id = _default_group_selection_function(a)
	local b_group_id = _default_group_selection_function(b)

	if a_group_id == b_group_id then
		return _sort_by_name(a, b)
	end

	return a_group_id < b_group_id
end

local function _sort_by_invite(a, b)
	local a_group_id = _group_by_invite(a)
	local b_group_id = _group_by_invite(b)

	if a_group_id == b_group_id then
		return _sort_by_name(a, b)
	end

	return a_group_id < b_group_id
end

local _groups_by_online_status = {
	{
		blueprint = "group_header",
		header = "loc_social_menu_friend_list_group_header_in_game",
		group_name = "in_game",
		item_blueprint = "player_plaque",
		members = {}
	},
	{
		blueprint = "group_header",
		header = "loc_social_menu_friend_list_group_header_online",
		group_name = "platform_online",
		item_blueprint = "player_plaque_platform_online",
		members = {}
	},
	{
		blueprint = "group_header",
		header = "loc_social_menu_friend_list_group_header_offline",
		group_name = "offline",
		item_blueprint = "player_plaque_offline",
		members = {}
	}
}

SocialMenuRosterView.init = function (self, settings, context)
	self._parent = context and context.parent
	self._players_by_account_id = {}
	local roster_lists = {
		[FRIENDS_LIST] = {
			group_select_function = _default_group_selection_function,
			primary_sort_function = _sort_by_default_group_selection,
			groups = _groups_by_online_status,
			sorted_list = {}
		},
		[PREVIOUS_MISSION_COMPANIONS_LIST] = {
			group_select_function = _default_group_selection_function,
			primary_sort_function = _sort_by_default_group_selection,
			groups = _groups_by_online_status,
			sorted_list = {}
		},
		[HUB_PLAYERS_LIST] = {
			group_select_function = function (player_info)
				return 1
			end,
			primary_sort_function = _sort_by_name,
			groups = {
				{
					blueprint = "group_header",
					header = "loc_social_menu_friend_list_group_header_in_game",
					group_name = "in_hub",
					item_blueprint = "player_plaque",
					members = {}
				},
				{
					blueprint = "group_header",
					header = "loc_social_menu_friend_list_group_header_not_in_hub",
					group_name = "not_in_hub",
					item_blueprint = "player_plaque_offline",
					members = {}
				}
			},
			sorted_list = {}
		},
		[FRIEND_INVITES_LIST] = {
			group_select_function = _group_by_invite,
			primary_sort_function = _sort_by_invite,
			groups = {
				{
					blueprint = "group_header",
					header = "loc_social_menu_friend_list_group_header_received_invites",
					group_name = "received_invites",
					item_blueprint = "player_plaque",
					members = {}
				},
				{
					no_divider = true,
					item_blueprint = "player_plaque_platform_online",
					group_name = "received_invites_platform_online",
					members = {}
				},
				{
					no_divider = true,
					item_blueprint = "player_plaque_offline",
					group_name = "received_invites_offline",
					members = {}
				},
				{
					blueprint = "group_header",
					header = "loc_social_menu_friend_list_group_header_sent_invites",
					group_name = "sent_invites",
					item_blueprint = "player_plaque",
					members = {}
				},
				{
					no_divider = true,
					item_blueprint = "player_plaque_platform_online",
					group_name = "sent_invites_platform_online",
					members = {}
				},
				{
					no_divider = true,
					item_blueprint = "player_plaque_offline",
					group_name = "sent_invites_offline",
					members = {}
				},
				{
					blueprint = "group_header",
					header = "loc_social_menu_friend_list_group_header_no_invites",
					group_name = "no_invites",
					item_blueprint = "player_plaque_offline",
					members = {}
				}
			},
			sorted_list = {}
		},
		[BLOCKED_PLAYERS_LIST] = {
			group_select_function = function (player_info)
				return 1
			end,
			primary_sort_function = _sort_by_name,
			groups = {
				{
					blueprint = "group_header",
					header = "loc_social_menu_friend_list_group_header_blocked",
					group_name = "blocked",
					item_blueprint = "player_plaque_blocked",
					members = {}
				}
			},
			sorted_list = {}
		}
	}
	self._party_promise = Promise.resolved()
	self._roster_lists_promise = Promise.resolved()
	self._roster_lists = roster_lists
	self._tab_ids = {}
	self._grids = {
		[PARTY_GRID_ID] = nil,
		[ROSTER_GRID_ID] = nil
	}
	self._grid_widget_definitions = {
		[PARTY_GRID_ID] = {},
		[ROSTER_GRID_ID] = {}
	}
	self._focused_grid_id = nil
	self._popup_menu = nil
	self._refresh_list_delay = 0
	self._roster_widgets = {}
	self._party_widgets = {}
	self._widgets_with_portraits = {}
	self._num_pending_invites = 0
	self._platform_id_to_display_name_lut = {}
	self._widgets_are_fading = nil
	self._fade_time = 0
	self._widget_fade_time = SocialMenuSettings.widget_fade_time
	self._fade_delay = 0
	self._selected_roster_widget_column_last_frame = 1

	SocialMenuRosterView.super.init(self, Definitions, settings)
end

SocialMenuRosterView.on_enter = function (self)
	SocialMenuRosterView.super.on_enter(self)

	self._pass_input = true
	self._allow_close_hotkey = false
	local view_element_definitions = self._definitions.view_elements

	for element_name, params in pairs(view_element_definitions) do
		local element = self:_add_element(params.class, element_name, params.layer, params.context)
		local element_init = callback(self, params.init)

		element_init(element, params.init_params)
	end

	self:_create_offscreen_renderer()
	self:_create_party_grid()

	local force_refresh_lists = true

	self:_refresh_roster_lists(force_refresh_lists)
	self:_refresh_party_list()
	self:set_next_roster_filter(FRIENDS_LIST)
	self:_fade_widgets("in")

	if self._parent then
		self._parent:set_active_view_instance(self)
	end
end

SocialMenuRosterView.on_exit = function (self)
	local widgets_with_portraits = self._widgets_with_portraits

	while #widgets_with_portraits > 0 do
		self:_unload_widget_portrait(widgets_with_portraits[#widgets_with_portraits])
	end

	self:_destroy_renderer()
	SocialMenuRosterView.super.on_exit(self)
end

SocialMenuRosterView.set_can_exit = function (self, value, apply_next_frame)
	if not apply_next_frame then
		self._can_close = value

		self._parent:set_can_navigate(value)
	else
		self._next_frame_can_close = value
		self._can_close_frame_counter = 1
	end
end

SocialMenuRosterView.update = function (self, dt, t, input_service)
	local next_list_index = self._next_list_index

	if not self._roster_lists_promise:is_pending() then
		local new_list_data = self._new_list_data
		local current_list_index = self._current_list_index

		if next_list_index == current_list_index then
			next_list_index = nil
			self._next_list_index = nil
		end

		if new_list_data then
			for i = 1, #new_list_data do
				local list = new_list_data[i]

				if list then
					self:_update_roster_list(i, list, i == current_list_index and not next_list_index)
				end
			end

			self._new_list_data = nil
		end

		self:_check_can_exit()
		self:_update_list_refreshes(dt)
	end

	if next_list_index then
		local list_items_metadata = self._roster_lists[next_list_index]
		local list_items = list_items_metadata.sorted_list

		self:_setup_roster_grid(list_items)

		self._current_list_index = next_list_index
		self._next_list_index = nil
	end

	self:_update_portraits()
	self:_update_view_visibility(dt, t, input_service)

	local grid_input_service = self._popup_menu and input_service:null_service() or input_service
	local grids = self._grids

	for i = 1, #grids do
		grids[i]:update(dt, t, grid_input_service)
	end

	return SocialMenuRosterView.super.update(self, dt, t, input_service)
end

SocialMenuRosterView.draw = function (self, dt, t, input_service, layer)
	local offscreen_renderer = self._offscreen_renderer
	local render_settings = self._render_settings
	local alpha_multiplier = render_settings.alpha_multiplier or 0

	if offscreen_renderer and alpha_multiplier > 0 and self._grids[ROSTER_GRID_ID] then
		UIRenderer.begin_pass(offscreen_renderer, self._ui_scenegraph, input_service, dt, render_settings)
		self:_draw_roster_grid(dt, t, input_service, offscreen_renderer)
		UIRenderer.end_pass(offscreen_renderer)
	end

	SocialMenuRosterView.super.draw(self, dt, t, input_service, layer)
end

SocialMenuRosterView.on_resolution_modified = function (self)
	SocialMenuRosterView.super.on_resolution_modified(self)
	self:_position_tab_bar()
end

SocialMenuRosterView._on_navigation_input_changed = function (self)
	SocialMenuRosterView.super._on_navigation_input_changed(self)

	local is_using_cursor_navigation = self._using_cursor_navigation
	local popup_menu = self._popup_menu

	if popup_menu then
		popup_menu:on_navigation_input_changed(is_using_cursor_navigation)
	end

	local focused_grid_id = not is_using_cursor_navigation and (self._focused_grid_id or PARTY_GRID_ID) or nil
	local grids = self._grids

	for i = #grids, 1, -1 do
		local grid = grids[i]
		local selected_grid_index = nil
		local is_focused_grid = i == focused_grid_id

		if is_focused_grid then
			selected_grid_index = grid:selected_grid_index()

			if not selected_grid_index then
				grid:select_first_index()

				selected_grid_index = grid:selected_grid_index()

				if not selected_grid_index then
					focused_grid_id = math.max(focused_grid_id - 1, 1)
				end
			end
		end

		local grid_widgets = grid:widgets()

		if grid_widgets then
			for j = 1, #grid_widgets do
				local widget = grid_widgets[j]
				local widget_hotspot = widget.content.hotspot

				if widget_hotspot then
					widget_hotspot.is_focused = j == selected_grid_index
				end
			end
		end
	end

	self._focused_grid_id = focused_grid_id
end

SocialMenuRosterView.set_next_roster_filter = function (self, list_index)
	local tab_id = self._tab_ids[list_index]

	if self._player_list_tab_bar:tab_disabled(tab_id) then
		local num_lists = #self._roster_lists
		local current_list_index = self._current_list_index

		if current_list_index < list_index or current_list_index == num_lists and list_index == 1 then
			list_index = math.index_wrapper(list_index + 1, num_lists)
		else
			list_index = math.index_wrapper(list_index - 1, num_lists)
		end
	end

	self._player_list_tab_bar:set_selected_index(list_index)

	self._next_list_index = list_index
end

local _formatted_character_name_character_name_params = {}

SocialMenuRosterView.formatted_character_name = function (self, player_info)
	local character_name = player_info:character_name()

	if character_name ~= "" then
		local character_name_params = _formatted_character_name_character_name_params
		character_name_params.character_name = character_name
		character_name_params.character_level = player_info:character_level()
		character_name = Localize("loc_social_menu_character_name_format", true, character_name_params)
	end

	return character_name
end

SocialMenuRosterView.cb_switch_roster_filter = function (self, index)
	if self._using_cursor_navigation then
		self:set_next_roster_filter(index)
	end
end

SocialMenuRosterView.cb_close_popup_menu = function (self)
	self:_close_popup_menu()
end

SocialMenuRosterView.cb_on_popup_menu_closed = function (self)
	self:_remove_popup_menu()
end

SocialMenuRosterView.cb_leave_party = function (self)
	self:_close_popup_menu()
	self:_show_confirmation_popup(nil, "leave_party")
end

SocialMenuRosterView.cb_vote_to_kick_player_from_party = function (self, player_info)
	if social_service:can_kick_from_party(player_info) then
		self:_show_confirmation_popup(player_info, "initiate_kick_vote", player_info)
	else
		_debug_warning("cb_vote_to_kick_player_from_party", "Cannot initiate vote; Not all requirements met.")
	end

	self:_close_popup_menu()
end

SocialMenuRosterView.cb_invite_player_to_party = function (self, player_info)
	social_service:send_party_invite(player_info)
	self:_close_popup_menu()
end

SocialMenuRosterView.cb_cancel_party_invite = function (self, player_info)
	social_service:cancel_party_invite(player_info)
	self:_close_popup_menu()
end

SocialMenuRosterView.cb_join_players_party = function (self, player_info)
	self:_close_popup_menu()

	local party_id = player_info:party_id()

	if party_id then
		social_service:join_party(party_id, player_info:account_id() or ""):next(function (party)
			if not self._destroyed then
				self:_refresh_party_list()
			end
		end):catch(function (error)
			self:_play_sound(UISoundEvents.notification_join_party_failed)
		end)
	else
		self:_play_sound(UISoundEvents.notification_join_party_failed)
	end
end

SocialMenuRosterView.cb_show_player_profile = function (self, player_info)
	self:_close_popup_menu()
end

SocialMenuRosterView.cb_show_xbox_profile = function (self, player_info)
	self:_close_popup_menu()

	local xuid = player_info:platform_user_id()

	XboxLive.show_player_profile_card(xuid)
end

SocialMenuRosterView.cb_invite_player_to_guild = function (self, player_info)
	self:_close_popup_menu()
end

SocialMenuRosterView.cb_send_friend_request = function (self, player_info)
	local account_id = player_info:account_id()
	local friend_status = player_info:friend_status()

	if friend_status == FriendStatus.none then
		social_service:send_friend_request(account_id)
	else
		_debug_warning("cb_send_friend_request", "FriendStatus is [%s] for account %s, expected: [%s]", tostring(friend_status), account_id, FriendStatus.none)
	end

	self:_close_popup_menu()
end

SocialMenuRosterView.cb_cancel_friend_request = function (self, player_info)
	local account_id = player_info:account_id()
	local friend_status = player_info:friend_status()

	if account_id and friend_status == FriendStatus.invited then
		social_service:cancel_friend_request(account_id)
	else
		_debug_warning("cb_cancel_friend_request", "FriendStatus is [%s] for account %s, expected: [%s]", tostring(friend_status), account_id, FriendStatus.invited)
	end

	self:_close_popup_menu()
end

SocialMenuRosterView.cb_accept_friend_request = function (self, player_info)
	local account_id = player_info:account_id()
	local friend_status = player_info:friend_status()

	if friend_status == FriendStatus.invite then
		social_service:accept_friend_request(account_id)
	else
		_debug_warning("cb_accept_friend_request", "FriendStatus is [%s] for account %s, expected: [%s]", tostring(friend_status), account_id, FriendStatus.invite)
	end

	self:_close_popup_menu()
end

SocialMenuRosterView.cb_reject_friend_request = function (self, player_info)
	local account_id = player_info:account_id()
	local friend_status = player_info:friend_status()

	if friend_status == FriendStatus.invite then
		social_service:reject_friend_request(account_id)
	else
		_debug_warning("cb_reject_friend_request", "FriendStatus is [%s] for account %s, expected: [%s]", tostring(friend_status), account_id, FriendStatus.invite)
	end

	self:_close_popup_menu()
end

SocialMenuRosterView.cb_unfriend_player = function (self, player_info)
	local account_id = player_info:account_id()
	local friend_status = player_info:friend_status()

	if friend_status == FriendStatus.friend then
		self:_show_confirmation_popup(player_info, "unfriend_player")
	else
		_debug_warning("cb_unfriend_player", "FriendStatus is [%s] for account %s, expected: [%s]", tostring(friend_status), account_id, FriendStatus.friend)
	end

	self:_close_popup_menu()
end

SocialMenuRosterView.cb_mute_text_chat = function (self, player_info, is_muted)
	local account_id = player_info:account_id()

	if account_id then
		social_service:mute_player_in_text_chat(account_id, is_muted)
	else
		_debug_warning("cb_mute_text_chat", "Cannot mute player; no account_id")
	end
end

SocialMenuRosterView.cb_mute_voice_chat = function (self, player_info, is_muted)
	local account_id = player_info:account_id()
	local friend_status = player_info:friend_status()

	if account_id then
		social_service:mute_player_in_voice_chat(account_id, is_muted)
	else
		_debug_warning("cb_mute_text_chat", "Cannot mute player; no account_id")
	end
end

SocialMenuRosterView.cb_unblock_player = function (self, player_info)
	self:_close_popup_menu()
	self:_show_confirmation_popup(player_info, "unblock_account")
end

SocialMenuRosterView.cb_block_player = function (self, player_info)
	self:_close_popup_menu()
	self:_show_confirmation_popup(player_info, "block_account")
end

SocialMenuRosterView.cb_report_player = function (self, player_info)
	self:_close_popup_menu()
end

SocialMenuRosterView.cb_update_roster = function (self, results)
	if self._destroyed then
		return
	end

	self:_fetch_platform_player_data(results)
end

local XUIDS = {}

SocialMenuRosterView._fetch_platform_player_data = function (self, results)
	if IS_XBS or IS_GDK then
		table.clear(XUIDS)

		for i = 1, #results do
			local entries = results[i]

			for j = 1, #entries do
				local entry = entries[j]
				local platform = entry:platform()

				if platform == "xbox" then
					local xuid = entry:platform_user_id()

					if not self._platform_id_to_display_name_lut[xuid] then
						XUIDS[#XUIDS + 1] = xuid
					end
				end
			end
		end

		if table.size(XUIDS) > 0 then
			XboxLive.get_user_profiles(XUIDS):next(function (profiles)
				for _, profile in ipairs(profiles) do
					self._platform_id_to_display_name_lut[profile.xuid] = profile
				end

				self._new_list_data = results
				self._refresh_list_delay = SocialMenuSettings.list_refresh_time
			end)
		else
			self._new_list_data = results
			self._refresh_list_delay = SocialMenuSettings.list_refresh_time
		end
	else
		self._new_list_data = results
		self._refresh_list_delay = SocialMenuSettings.list_refresh_time
	end
end

SocialMenuRosterView.cb_show_popup_menu_for_player = function (self, player_info)
	local popup_menu = self._popup_menu

	if popup_menu then
		return
	end

	local start_layer = SocialMenuSettings.popup_start_layer
	popup_menu = self:_add_element(ViewElementPlayerSocialPopup, POPUP_NAME, start_layer)
	self._popup_menu = popup_menu

	self:set_can_exit(false)
	self:_fade_widgets("out")

	local material_values = nil
	local widgets_with_portraits = self._widgets_with_portraits

	for i = 1, #widgets_with_portraits do
		local widget = widgets_with_portraits[i]
		local content = widget.content

		if content.player_info == player_info then
			local portrait_style = widget.style.portrait
			material_values = portrait_style.material_values
		end
	end

	popup_menu:set_player_info(self, player_info, material_values)
	popup_menu:on_navigation_input_changed(self._using_cursor_navigation)
	popup_menu:set_close_popup_request_callback(callback(self, "cb_close_popup_menu"))
end

SocialMenuRosterView.on_back_pressed = function (self)
	local back_pressed_handled = false

	if self._popup_menu then
		self:_close_popup_menu()

		back_pressed_handled = true
	end

	return back_pressed_handled or not self._can_close
end

SocialMenuRosterView._cb_set_player_icon = function (self, widget, grid_index, rows, columns, render_target)
	local widget_content = widget.content
	widget_content.awaiting_portrait_callback = nil
	local portrait_style = widget.style.portrait
	local material_values = portrait_style.material_values
	material_values.use_placeholder_texture = 0
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.texture_icon = render_target
end

SocialMenuRosterView._cb_set_player_frame = function (self, widget, item)
	local widget_content = widget.content
	widget_content.awaiting_frame_callback = nil
	local profile = widget_content.player_info:profile()
	local loadout = profile and profile.loadout
	local frame_item = loadout and loadout.slot_portrait_frame
	local frame_item_gear_id = frame_item and frame_item.gear_id
	local icon = nil

	if frame_item_gear_id == item.gear_id then
		icon = item.icon
	else
		icon = RosterViewStyles.default_frame_material
	end

	local portrait_style = widget.style.portrait
	portrait_style.material_values.portrait_frame_texture = icon
end

SocialMenuRosterView._update_list_refreshes = function (self, dt)
	local delay = self._refresh_list_delay or 0
	delay = delay - dt

	if delay < 0 then
		self:_refresh_party_list()
		self:_refresh_roster_lists()

		delay = SocialMenuSettings.list_refresh_time
	end

	self._refresh_list_delay = delay
end

SocialMenuRosterView._update_portraits = function (self)
	local widgets_with_portraits = self._widgets_with_portraits

	for i = #widgets_with_portraits, 1, -1 do
		local widget = widgets_with_portraits[i]
		local content = widget.content
		local player_info = content.player_info
		local profile = player_info:profile()

		if not profile then
			self:_unload_widget_portrait(widget)

			content.profile_hash = nil
		elseif profile.character_id ~= content.portrait_character_id then
			self:_load_widget_portrait(widget, profile, content.portrait_renderer)
		elseif profile.hash ~= content.profile_hash then
			local character_name = self:formatted_character_name(player_info)

			if character_name ~= "" then
				content.name_or_activity = character_name
				content.activity_id = nil

				Managers.event:trigger("event_player_profile_updated", nil, nil, profile)

				content.profile_hash = profile.hash
			end
		end
	end
end

SocialMenuRosterView._update_view_visibility = function (self, dt, t, input_service)
	local widgets_are_fading = self._widgets_are_fading

	if widgets_are_fading then
		local fade_time = self._fade_time
		local fade_delay = self._fade_delay

		if fade_delay > 0 then
			self._fade_delay = math.max(fade_delay - dt, 0)
		else
			fade_time = fade_time + dt
			self._fade_time = fade_time
		end

		local normalized_time = fade_time / self._widget_fade_time

		if normalized_time >= 1 then
			normalized_time = 1
			self._widgets_are_fading = nil
		end

		if widgets_are_fading == "out" then
			self._render_settings.alpha_multiplier = 1 - normalized_time
		else
			self._render_settings.alpha_multiplier = normalized_time
		end
	end
end

SocialMenuRosterView._draw_widgets = function (self, dt, t, input_service, ui_renderer)
	if self._popup_menu then
		input_service = input_service:null_service()
	end

	local widget_alpha_multiplier = ui_renderer.render_settings.alpha_multiplier or 0

	if widget_alpha_multiplier > 0 then
		local party_widgets = self._party_widgets

		for i = 1, #party_widgets do
			UIWidget.draw(party_widgets[i], ui_renderer)
		end

		SocialMenuRosterView.super._draw_widgets(self, dt, t, input_service, ui_renderer)
	end
end

SocialMenuRosterView._draw_roster_grid = function (self, dt, t, input_service, ui_renderer)
	local widgets = self._roster_widgets
	local grid = self._grids[ROSTER_GRID_ID]
	local margin = RosterViewStyles.roster_grid.mask_expansion[2]
	local interaction_widget = self._widgets_by_name.roster_grid_interaction
	local is_grid_hovered = not self._using_cursor_navigation or interaction_widget.content.hotspot.is_hover

	for i = 1, #widgets do
		local widget = widgets[i]

		if grid:is_widget_visible(widget, margin) then
			local hotspot = widget.content.hotspot

			if hotspot then
				hotspot.force_disabled = not is_grid_hovered
			end

			UIWidget.draw(widget, ui_renderer)
		end
	end
end

SocialMenuRosterView._position_tab_bar = function (self)
	local scenegraph_id = "roster_panel_tabs"
	local position = self:_scenegraph_world_position(scenegraph_id, 1)
	local size_x = self:_scenegraph_size(scenegraph_id)
	local center_position = position[1] + size_x / 2

	self._player_list_tab_bar:set_pivot_offset(center_position, position[2])
end

SocialMenuRosterView._create_offscreen_renderer = function (self)
	local view_name = self.view_name
	local world_layer = 10
	local world_name = self.__class_name .. "_ui_offscreen_world"
	local world = Managers.ui:create_world(world_name, world_layer, nil, view_name)
	local viewport_name = "offscreen_viewport"
	local viewport_type = "overlay_offscreen"
	local viewport_layer = 1
	local shading_environment = SocialMenuSettings.shading_environment
	local viewport = Managers.ui:create_viewport(world, viewport_name, viewport_type, viewport_layer, shading_environment)
	local renderer_name = self.__class_name .. "offscreen_renderer"
	self._offscreen_renderer = Managers.ui:create_renderer(renderer_name, world)
	self._offscreen_world = {
		name = world_name,
		world = world,
		viewport = viewport,
		viewport_name = viewport_name,
		renderer_name = renderer_name
	}
end

SocialMenuRosterView._destroy_renderer = function (self)
	if self._offscreen_renderer then
		self._offscreen_renderer = nil
	end

	local world_data = self._offscreen_world

	if world_data then
		Managers.ui:destroy_renderer(world_data.renderer_name)
		ScriptWorld.destroy_viewport(world_data.world, world_data.viewport_name)
		Managers.ui:destroy_world(world_data.world)

		self._offscreen_world = nil
	end
end

SocialMenuRosterView._setup_tab_bar = function (self, tab_bar, params)
	self._player_list_tab_bar = tab_bar
	local tab_button_template = params.tab_button_template
	local tabs = params.tabs

	for i = 1, #tabs do
		local tab_params = tabs[i]
		local title = tab_params
		local update_function = nil

		if i == FRIEND_INVITES_LIST then
			function update_function(content, style)
				local num_pending_invites = self._num_pending_invites

				if num_pending_invites ~= content.num_pending_invites then
					local localized_label = Localize(title)

					if num_pending_invites > 99 then
						localized_label = string.format("%s (99+)", localized_label)
					elseif num_pending_invites > 0 then
						localized_label = string.format("%s (%d)", localized_label, num_pending_invites)
					end

					content.text = localized_label
					content.num_pending_invites = num_pending_invites

					return true
				end

				return false
			end
		end

		local callback = callback(self, "cb_switch_roster_filter", i)
		local tab_id = tab_bar:add_entry(title, callback, tab_button_template, nil, update_function)
		self._tab_ids[i] = tab_id
	end

	local input_action_left = "navigate_secondary_left_pressed"
	local input_action_right = "navigate_secondary_right_pressed"

	tab_bar:set_input_actions(input_action_left, input_action_right)
	self:_position_tab_bar()
end

SocialMenuRosterView._create_party_grid = function (self)
	local party_widgets = self._party_widgets
	local grid_direction = "down"
	local grid_spacing = RosterViewStyles.grid_spacing
	self._grids[PARTY_GRID_ID] = UIWidgetGrid:new(party_widgets, nil, self._ui_scenegraph, PARTY_GRID_SCENEGRAPH_ID, grid_direction, grid_spacing, nil, true)

	self:_update_party_list(party_widgets, true)
end

SocialMenuRosterView._check_can_exit = function (self)
	local can_exit = self._popup_menu == nil

	if can_exit ~= self._can_close and not self._next_frame_can_close then
		self:set_can_exit(can_exit, can_exit)
	end
end

SocialMenuRosterView._update_portrait_frame = function (self, widget, profile)
	local widget_content = widget.content
	local frame_style = widget.style.portrait

	if widget_content.awaiting_frame_callback and profile ~= nil then
		return
	end

	local frame_load_id = widget_content.frame_load_id

	if frame_load_id then
		local portrait_renderer = widget_content.portrait_renderer

		UIWidget.set_visible(widget, portrait_renderer, false)
		UIWidget.set_visible(widget, portrait_renderer, true)

		local material_values = frame_style.material_values
		local portrait_frame_texture = material_values.portrait_frame_texture
		material_values.portrait_frame_texture = RosterViewStyles.default_frame_material

		Log.info("SocialMenuRosterView", "Destroying frame: %s", portrait_frame_texture)
		Managers.ui:unload_item_icon(frame_load_id)
	end

	local loadout = profile and profile.loadout
	local frame_item = loadout and loadout.slot_portrait_frame
	local frame_id = frame_item and frame_item.gear_id
	widget_content.frame_id = frame_id

	if frame_item then
		local cb = callback(self, "_cb_set_player_frame", widget)
		widget_content.frame_load_id = Managers.ui:load_item_icon(frame_item, cb)
		widget_content.awaiting_frame_callback = true
	else
		widget_content.frame_load_id = nil
	end
end

SocialMenuRosterView._load_widget_portrait = function (self, widget, profile, portrait_renderer)
	local widget_content = widget.content

	if widget_content.awaiting_portrait_callback then
		return
	end

	local portrait_load_id = widget_content.portrait_load_id

	if portrait_load_id then
		self:_unload_widget_portrait(widget)
	end

	local profile_icon_loaded_callback = callback(self, "_cb_set_player_icon", widget)
	widget_content.awaiting_portrait_callback = true
	widget_content.portrait_load_id = profile and Managers.ui:load_profile_portrait(profile, profile_icon_loaded_callback)
	widget_content.portrait_character_id = profile and profile.character_id
	widget_content.portrait_renderer = portrait_renderer
	local widgets_with_portraits = self._widgets_with_portraits
	widgets_with_portraits[#widgets_with_portraits + 1] = widget
end

SocialMenuRosterView._unload_widget_portrait = function (self, widget)
	local widget_content = widget.content
	local portrait_style = widget.style.portrait

	self:_update_portrait_frame(widget, nil)

	local portrait_load_id = widget_content.portrait_load_id

	if not portrait_load_id then
		return
	end

	local material_values = portrait_style.material_values
	material_values.use_placeholder_texture = 1

	Managers.ui:unload_profile_portrait(portrait_load_id)

	widget_content.portrait_load_id = nil
	local widgets_with_portraits = self._widgets_with_portraits

	for i = #widgets_with_portraits, 1, -1 do
		if widgets_with_portraits[i] == widget then
			table.remove(widgets_with_portraits, i)

			break
		end
	end
end

SocialMenuRosterView._setup_roster_grid = function (self, widget_data)
	local widgets, widget_alignments = self:_create_roster_widgets(widget_data)
	self._roster_widgets = widgets
	self._roster_alignment_widgets = widget_alignments
	local grid_direction = "down"
	local grid_spacing = RosterViewStyles.grid_spacing
	local roster_grid = UIWidgetGrid:new(widgets, widget_alignments, self._ui_scenegraph, ROSTER_GRID_SCENEGRAPH_ID, grid_direction, grid_spacing, nil, true)
	self._grids[ROSTER_GRID_ID] = roster_grid

	self:_assign_roster_grid_scrollbar(roster_grid, widgets)

	if not self._using_cursor_navigation then
		self:_on_navigation_input_changed()
	end
end

SocialMenuRosterView._assign_roster_grid_scrollbar = function (self, roster_grid, widgets)
	local scrollbar_widget = self._widgets_by_name.roster_scrollbar
	local interaction_scenegraph_id = "roster_grid"

	roster_grid:assign_scrollbar(scrollbar_widget, ROSTER_GRID_SCENEGRAPH_ID, interaction_scenegraph_id)

	local scrollbar_visible = roster_grid:can_scroll()
	local list_divider_style = RosterViewStyles.blueprints.list_divider
	local divider_width = scrollbar_visible and list_divider_style.width_with_scrollbar or list_divider_style.width_without_scrollbar

	for i = 1, #widgets do
		local widget = widgets[i]
		local divider_style = widget.style.divider

		if divider_style then
			divider_style.size[1] = divider_width
		end
	end
end

SocialMenuRosterView._create_roster_widgets = function (self, widget_data)
	local widgets = {}
	local widget_alignments = {}
	local current_default_blueprint_name = "list_divider"

	for i = 1, #widget_data do
		local widget_info = widget_data[i]
		local blueprint_name = current_default_blueprint_name

		if not widget_info.account_id then
			blueprint_name = widget_info.blueprint

			if widget_info.item_blueprint then
				current_default_blueprint_name = widget_info.item_blueprint
			end
		end

		if blueprint_name then
			local widget = self:_get_roster_widget(widget_info, blueprint_name, ROSTER_GRID_ID)
			widgets[#widgets + 1] = widget
			widget_alignments[#widget_alignments + 1] = widget
		end
	end

	widget_alignments[#widget_alignments + 1] = {
		size = {
			RosterViewStyles.player_panel_size[1] * 2,
			0
		}
	}

	return widgets, widget_alignments
end

SocialMenuRosterView.get_platform_profile = function (self, xuid)
	return self._platform_id_to_display_name_lut[xuid]
end

SocialMenuRosterView._get_roster_widget = function (self, context, blueprint_name, grid_id, optional_unique_id)
	local scenegraph_id = _SCENEGRAPH_IDS[grid_id]
	local widget_blueprint = Blueprints[blueprint_name]
	local name_suffix = widget_blueprint.get_name_suffix(context, optional_unique_id)
	local widget_name = scenegraph_id .. "_" .. name_suffix

	if self._widgets_by_name[widget_name] then
		local widget = self._widgets_by_name[widget_name]
		local content = widget.content

		if content.blueprint_name == blueprint_name then
			return widget
		else
			self:_unregister_widget_name(widget.name)

			if content.portrait_load_id then
				self:_unload_widget_portrait(widget)
			end
		end
	end

	local grid_widget_definitions = self._grid_widget_definitions[grid_id]
	local widget_definition = grid_widget_definitions[blueprint_name]

	if not widget_definition then
		widget_definition = UIWidget.create_definition(widget_blueprint.pass_template, scenegraph_id, {
			blueprint_name = blueprint_name
		}, widget_blueprint.size, widget_blueprint.style)
		grid_widget_definitions[blueprint_name] = widget_definition
	end

	local widget = self:_create_widget(widget_name, widget_definition)

	if widget_blueprint.init then
		widget_blueprint.init(self, widget, context, callback(self, "cb_show_popup_menu_for_player", context))
	end

	return widget
end

SocialMenuRosterView._handle_input = function (self, input_service, dt, t)
	if self._popup_menu then
		return
	end

	local focused_grid_id = self._focused_grid_id

	if focused_grid_id then
		local grids = self._grids
		local party_grid = grids[PARTY_GRID_ID]
		local roster_grid = grids[ROSTER_GRID_ID]

		if focused_grid_id == ROSTER_GRID_ID then
			local roster_grid_selected_index = roster_grid:selected_grid_index()
			local widget = self._roster_widgets[roster_grid_selected_index]
			local widget_column = widget.content.column
			local num_party_members = #self._party_widgets

			if input_service:get("navigate_left_continuous") and self._selected_roster_widget_column_last_frame == 1 then
				local roster_grid_first_visible_row = self:_get_roster_grid_first_visible_row()
				local visible_content_row = widget.content.row - (roster_grid_first_visible_row - 1)
				local party_selected_index = math.clamp(visible_content_row, 1, num_party_members)

				party_grid:focus_grid_index(party_selected_index)
				roster_grid:focus_grid_index(nil)

				self._selected_roster_widget_column_last_frame = nil
				self._focused_grid_id = PARTY_GRID_ID

				self:_on_navigation_input_changed()
			else
				self._selected_roster_widget_column_last_frame = widget_column
			end
		elseif input_service:get("navigate_right_continuous") and #self._roster_widgets > 0 then
			local party_selected_index = party_grid:selected_grid_index()
			local roster_widgets = self._roster_widgets
			local roster_grid_first_visible_row = self:_get_roster_grid_first_visible_row()
			local desired_row = roster_grid_first_visible_row - 1 + party_selected_index

			for i = #roster_widgets, 1, -1 do
				local widget_content = roster_widgets[i].content

				if widget_content.hotspot and widget_content.row <= desired_row and widget_content.column == 1 then
					party_grid:focus_grid_index(nil)
					roster_grid:focus_grid_index(i)

					self._focused_grid_id = ROSTER_GRID_ID

					self:_on_navigation_input_changed()

					break
				end
			end
		end
	end

	if input_service:get("navigate_secondary_right_pressed") then
		self:_play_sound(UISoundEvents.tab_secondary_button_pressed)

		local next_index = math.index_wrapper(self._current_list_index + 1, #self._roster_lists)

		self:set_next_roster_filter(next_index)
	elseif input_service:get("navigate_secondary_left_pressed") then
		self:_play_sound(UISoundEvents.tab_secondary_button_pressed)

		local previous_index = math.index_wrapper(self._current_list_index - 1, #self._roster_lists)

		self:set_next_roster_filter(previous_index)
	end
end

SocialMenuRosterView._get_roster_grid_first_visible_row = function (self)
	local roster_grid = self._grids[ROSTER_GRID_ID]
	local roster_widgets = self._roster_widgets
	local half_row_height = (RosterViewStyles.player_panel_size[2] + RosterViewStyles.grid_spacing[2]) / 2

	for i = 1, #roster_widgets do
		local widget = roster_widgets[i]
		local widget_hotspot = widget.content.hotspot

		if widget_hotspot and roster_grid:is_widget_visible(widget, -half_row_height) then
			return widget.content.row
		end
	end

	return 0
end

local _list_dividers = {}

SocialMenuRosterView._prepare_list = function (self, roster_list_data, roster_list, new_list_items)
	for i = 1, #new_list_items do
		roster_list[i] = new_list_items[i]
	end

	for i = #new_list_items + 1, #roster_list do
		roster_list[i] = nil
	end

	local sort_function = roster_list_data.primary_sort_function

	table.sort(roster_list, sort_function)

	local prev_index = #roster_list
	local prev_item = roster_list[prev_index]

	for i = prev_index - 1, 1, -1 do
		local current_item = roster_list[i]

		if current_item == prev_item then
			table.remove(roster_list, prev_index)
		end

		prev_index = i
		prev_item = current_item
	end

	local group_select_function = roster_list_data.group_select_function
	local groups = roster_list_data.groups
	local group_counter = 0
	local current_group_id = #groups

	for i = #roster_list, 1, -1 do
		local player_info = roster_list[i]
		local group_id = group_select_function(player_info)

		if group_id ~= current_group_id and group_counter > 0 then
			local group = groups[current_group_id]
			group.num_members = group_counter

			table.insert(roster_list, i + 1, group)

			if not group.header then
				while group_id < current_group_id and not group.header do
					current_group_id = current_group_id - 1
					group = groups[current_group_id]
				end

				if current_group_id ~= group_id then
					group.num_members = group_counter

					table.insert(roster_list, i + 1, group)
				end
			end

			if not group.no_divider then
				group_counter = 0
				local divider = _list_dividers[group_id]

				if not divider then
					divider = {
						blueprint = "list_divider",
						name = group_id
					}
					_list_dividers[divider] = divider
				end

				table.insert(roster_list, i + 1, divider)
			end

			current_group_id = group_id
		elseif current_group_id ~= group_id then
			current_group_id = group_id
			group_counter = 0
		end

		group_counter = group_counter + 1
	end

	local group = groups[current_group_id]
	group.num_members = group_counter

	table.insert(roster_list, 1, group)

	if not group.header then
		while not group.header do
			current_group_id = current_group_id - 1
			group = groups[current_group_id]
		end

		group.num_members = group_counter

		table.insert(roster_list, 1, group)
	end
end

SocialMenuRosterView._close_popup_menu = function (self)
	self._popup_menu:close(callback(self, "cb_on_popup_menu_closed"))
	self:_fade_widgets("in", true)
end

SocialMenuRosterView._remove_popup_menu = function (self)
	self._popup_menu = nil

	self:_remove_element(POPUP_NAME)
end

SocialMenuRosterView._fade_widgets = function (self, direction, should_delay)
	self._widgets_are_fading = direction
	self._fade_time = 0
	self._fade_delay = should_delay and SocialMenuSettings.widget_fade_delay or 0
end

SocialMenuRosterView._update_roster_list = function (self, list_index, new_list_items, should_update_widgets)
	local roster_list_data = self._roster_lists[list_index]
	local roster_list = roster_list_data.sorted_list

	self:_prepare_list(roster_list_data, roster_list, new_list_items)

	if should_update_widgets then
		local widgets = self._roster_widgets
		local num_items = widgets and #widgets or 0
		local lists_are_identical = #roster_list == num_items
		local i = 1

		while lists_are_identical and i <= num_items do
			local old_item_content = widgets[i].content
			local old_item_player_info = old_item_content.player_info
			local new_item = roster_list[i]

			if old_item_player_info and old_item_player_info == new_item then
				lists_are_identical = old_item_content.online_status == new_item:online_status() and old_item_content.is_blocked == new_item:is_blocked()
			elseif not old_item_player_info and not new_item.online_status then
				lists_are_identical = old_item_content.header == new_item.header and old_item_content.num_members == new_item.num_members
			else
				lists_are_identical = false
			end

			i = i + 1
		end

		if lists_are_identical and self._grids[ROSTER_GRID_ID] then
			self:_update_current_list_widgets(roster_list)
		elseif not lists_are_identical then
			self:_setup_roster_grid(roster_list)
		end
	end
end

SocialMenuRosterView._update_party_list = function (self, party_members, force_update)
	local current_party_widgets = self._party_widgets
	local list_is_changed = force_update or false

	for i = #current_party_widgets, 1, -1 do
		local party_widget = current_party_widgets[i]
		local party_member_content = party_widget.content
		local unique_id = party_member_content.unique_id

		if not party_members[unique_id] then
			table.remove(current_party_widgets, i)

			list_is_changed = true
		else
			local player_info = party_member_content.player_info
			party_member_content.party_status = player_info:party_status()
			party_member_content.online_status = player_info:online_status()
		end
	end

	for unique_id, player_info in pairs(party_members) do
		local is_in_party = false

		for i = 1, #current_party_widgets do
			local widget = current_party_widgets[i]
			local content = widget.content

			if unique_id == content.unique_id then
				is_in_party = true
			end
		end

		if not is_in_party then
			Log.info("SocialMenuRosterView", "%s not in party. Adding to party", unique_id)
			self:_add_to_party(unique_id, player_info)

			list_is_changed = true
		end
	end

	if list_is_changed then
		self._grids[PARTY_GRID_ID]:force_update_list_size()

		local party_panel_widget = self._widgets_by_name.party_panel
		local content = party_panel_widget.content
		local num_party_members = #current_party_widgets
		content.num_party_members = num_party_members
		content.header = Managers.localization:localize("loc_social_menu_party_header", true, content)

		self:_on_navigation_input_changed()
	end
end

SocialMenuRosterView._update_current_list_widgets = function (self)
	local max_num_portraits = SocialMenuSettings.max_num_portraits
	local widgets_with_portraits = self._widgets_with_portraits
	local current_widgets = self._roster_widgets
	local ui_renderer = self._offscreen_renderer

	for i = 1, #current_widgets do
		local widget = current_widgets[i]
		local content = widget.content
		local player_info = content.player_info

		if player_info then
			content.party_status = player_info:party_status()
			local player_blocked_status = content.is_blocked
			local player_online_status = content.online_status
			local is_online = player_online_status == OnlineStatus.online and not player_blocked_status
			local profile = player_info:profile()

			if is_online and profile and not content.portrait_load_id and content.blueprint_name == "player_plaque" and max_num_portraits > #widgets_with_portraits then
				self:_load_widget_portrait(widget, profile, ui_renderer)
			end
		end
	end
end

SocialMenuRosterView._add_to_party = function (self, unique_id, player_info)
	local party_widgets = self._party_widgets
	local num_party_members = #party_widgets

	if num_party_members < SocialConstants.max_num_party_members then
		local name_extra_identifier = nil
		local blueprint_name = "player_plaque"
		local party_member_widget = self:_get_roster_widget(player_info, blueprint_name, PARTY_GRID_ID, name_extra_identifier)
		local widget_content = party_member_widget.content
		widget_content.party_panel = true
		widget_content.unique_id = unique_id

		if not widget_content.is_own_player then
			local name_or_activity_style = party_member_widget.style.name_or_activity
			name_or_activity_style.default_color = name_or_activity_style.party_member_color
		end

		local profile = party_member_widget.content.player_info:profile()

		if profile then
			self:_load_widget_portrait(party_member_widget, profile, self._ui_renderer)
		end

		party_widgets[num_party_members + 1] = party_member_widget
	end
end

SocialMenuRosterView._refresh_party_list = function (self)
	local promise = self._party_promise

	if not promise:is_pending() then
		promise = social_service:fetch_party_members()
		promise = promise:next(function (party_members)
			if not self._destroyed then
				self:_update_party_list(party_members)
			end
		end)
		self._party_promise = promise
	end
end

SocialMenuRosterView._refresh_roster_lists = function (self, force_refresh)
	local blocked_promise = social_service:fetch_blocked_players()
	local player = self:_player()
	local character_id = player:character_id()
	local invites_promise = social_service:fetch_friend_invites():next(function (response)
		local num_invites = 0

		for i = 1, #response do
			local player_info = response[i]

			if player_info:friend_status() == FriendStatus.invite then
				num_invites = num_invites + 1
			end
		end

		self._num_pending_invites = num_invites

		return response
	end)
	local friends_promise = social_service:fetch_friends(force_refresh)
	local recent_companions_promise = social_service:fetch_recent_companions(character_id, force_refresh)
	local players_on_server_promise = social_service:fetch_players_on_server()
	local on_done = callback(self, "cb_update_roster")
	local roster_lists_promise = Promise.all(friends_promise, recent_companions_promise, players_on_server_promise, invites_promise, blocked_promise):next(on_done, on_done):catch(function (e)
		Log.error("Failed fetching social players")
	end)
	self._roster_lists_promise = roster_lists_promise
end

local _show_confirmation_popup_context = nil

SocialMenuRosterView._show_confirmation_popup = function (self, player_info, command_name, callback_parameter)
	local context = _show_confirmation_popup_context

	if not context then
		context = {
			description_text_params = {},
			options = {
				{
					close_on_pressed = true,
					text = "loc_social_menu_confirmation_popup_confirm_button"
				},
				{
					text = "loc_social_menu_confirmation_popup_decline_button",
					template_type = "terminal_button_small",
					close_on_pressed = true,
					hotkey = "back"
				}
			}
		}
		context.title_text_params = context.description_text_params
		_show_confirmation_popup_context = context
	end

	local account_id = player_info and player_info:account_id()

	if account_id then
		local player_name = self:formatted_character_name(player_info)

		if player_name == "" then
			player_name = player_info:user_display_name()
		end

		context.description_text_params.player_name = player_name
	end

	local command_params = ViewSettings.command_confirmation_params[command_name]

	if account_id or not player_info then
		context.title_text = command_params.title
		context.description_text = command_params.description
		context.options[1].callback = callback(social_service, command_name, callback_parameter or account_id)
		context.options[1].on_pressed_sound = command_params.on_confirm_sound

		Managers.event:trigger("event_show_ui_popup", context)
	end
end

return SocialMenuRosterView
