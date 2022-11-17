local CharacterCreate = require("scripts/utilities/character_create")
local MasterItems = require("scripts/backend/master_items")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local Promise = require("scripts/foundation/utilities/promise")
local StateMainMenuTestify = GameParameters.testify and require("scripts/game_states/game/state_main_menu_testify")
local SINGLEPLAY_TYPES = MatchmakingConstants.SINGLEPLAY_TYPES
local StateMainMenu = class("StateMainMenu")

StateMainMenu.on_enter = function (self, parent, params, creation_context)
	self._creation_context = creation_context
	local profiles = params.profiles
	local selected_profile = params.selected_profile
	local has_created_first_character = params.has_created_first_character
	local main_menu_loader = params.main_menu_loader
	self._main_menu_loader = main_menu_loader
	self._is_booting = params.is_booting or false
	self._item_definitions = MasterItems.get_cached()
	self._gear = params.gear
	self._wait_for_character_profile_upload = false
	self._wait_for_character_profile_delete = false
	self._wait_for_character_profiles_refresh = false
	self._profiles = {}
	self._selected_profile = nil
	self._character_is_syncing = false

	Managers.presence:set_presence("main_menu")
	self:_register_menu_events()

	if has_created_first_character or #profiles > 0 then
		self:_stay_in_main_menu(profiles, selected_profile)
	elseif GameParameters.skip_first_character_creation then
		self:_stay_in_main_menu(profiles, selected_profile)
	else
		self._force_create_first_character = true

		self:_create_new_character_start()
	end

	self._reconnect_popup_activated = true

	Managers.frame_rate:request_full_frame_rate("main_menu")

	self._full_frame_rate_enabled = true

	Managers.backend.interfaces.region_latency:pre_get_region_latencies()
end

StateMainMenu._stay_in_main_menu = function (self, profiles, selected_profile)
	self:_set_view_state_cb("main_menu")
	self:_set_profiles(profiles)
	self:_set_selected_profile(selected_profile)
end

StateMainMenu._register_menu_events = function (self)
	local event_manager = Managers.event

	event_manager:register(self, "event_state_main_menu_continue", "event_continue_cb")
	event_manager:register(self, "event_create_new_character_start", "event_create_new_character_start")
	event_manager:register(self, "event_create_new_character_continue", "event_create_new_character_continue")
	event_manager:register(self, "event_create_new_character_back", "event_create_new_character_back")
	event_manager:register(self, "event_request_select_new_profile", "event_request_select_new_profile")
	event_manager:register(self, "event_request_delete_character", "event_request_delete_character")
	event_manager:register(self, "event_main_menu_entered", "event_main_menu_entered")

	self._events_registered = true
end

StateMainMenu._unregister_menu_events = function (self)
	if self._events_registered then
		local event_manager = Managers.event

		event_manager:unregister(self, "event_state_main_menu_continue")
		event_manager:unregister(self, "event_create_new_character_start")
		event_manager:unregister(self, "event_create_new_character_back")
		event_manager:unregister(self, "event_create_new_character_continue")
		event_manager:unregister(self, "event_request_select_new_profile")
		event_manager:unregister(self, "event_request_delete_character")
		event_manager:unregister(self, "event_main_menu_entered")

		self._events_registered = nil
	end
end

StateMainMenu.event_request_select_new_profile = function (self, profile)
	if profile ~= self._selected_profile then
		self:_set_selected_profile(profile)
	end
end

StateMainMenu.event_request_delete_character = function (self, character_id)
	local selected_profile = self._selected_profile
	self._wait_for_character_profile_delete = true

	Managers.data_service.profiles:delete_profile(character_id):next(function ()
		self._wait_for_character_profile_delete = false

		self:_refresh_profiles()
	end):catch(function ()
		self._wait_for_character_profile_delete = false

		self:_set_selected_profile(nil)
	end)
end

StateMainMenu.event_main_menu_entered = function (self)
	Managers.event:trigger("event_main_menu_profiles_changed", self._profiles)
	Managers.event:trigger("event_main_menu_selected_profile_changed", self._selected_profile)
end

StateMainMenu.event_create_new_character_start = function (self)
	self:_create_new_character_start()
end

StateMainMenu.event_create_new_character_continue = function (self, skip_onboarding)
	self:_next_character_create_view(skip_onboarding)
end

StateMainMenu.event_create_new_character_back = function (self)
	self:_previous_character_create_view()
end

StateMainMenu._start_game_or_onboarding = function (self)
	local story_name = Managers.narrative.STORIES.onboarding
	local current_chapter = Managers.narrative:current_chapter(story_name)

	if current_chapter and not self:_skip_prologue() then
		local chapter_data = current_chapter.data
		local mission_name = chapter_data.mission_name

		self:_start_onboarding(mission_name)
	else
		self:_start_game()
	end
end

StateMainMenu.event_continue_cb = function (self)
	local selected_profile = self._selected_profile

	if not selected_profile then
		Log.warning("StateMainMenu", "Tried start game without a selected character!")

		return
	end

	local character_id = selected_profile.character_id

	Log.info("StateMainMenu", "Starting the game with selected character %s", character_id)
	self:_unregister_menu_events()

	local set_selected_character_promise = Managers.data_service.account:set_selected_character_id(character_id)
	local load_narrative_promise = Managers.narrative:load_character_narrative(character_id)

	Promise.all(set_selected_character_promise, load_narrative_promise):next(function (_)
		self:_start_game_or_onboarding()
	end):catch(function ()
		return
	end)
end

StateMainMenu._skip_prologue = function (self)
	return GameParameters.skip_prologue
end

StateMainMenu._refresh_profiles = function (self)
	self._wait_for_character_profiles_refresh = true

	Managers.data_service.profiles:fetch_all_profiles():next(function (profile_data)
		self._wait_for_character_profiles_refresh = false
		local profiles = profile_data.profiles
		local selected_profile = profile_data.selected_profile
		local gear = profile_data.gear

		self:_set_profiles(profiles)
		self:_set_selected_profile(selected_profile)

		self._gear = gear
	end):catch(function ()
		self._wait_for_character_profiles_refresh = false
	end)
end

StateMainMenu._set_profiles = function (self, profiles)
	self._profiles = profiles

	Managers.event:trigger("event_main_menu_profiles_changed", profiles)
end

local function _set_player_profile(profile)
	local local_player_id = 1
	local local_player = Managers.player:local_player(local_player_id)

	local_player:set_profile(profile)
end

StateMainMenu._set_selected_profile = function (self, profile)
	_set_player_profile(profile)

	self._selected_profile = profile

	Managers.event:trigger("event_main_menu_selected_profile_changed", profile)
end

StateMainMenu._create_new_character_start = function (self)
	self:_set_view_state_cb("character_create")

	if not self._character_create then
		self._character_create_state_views = {
			{
				"class_selection_view"
			},
			{
				"character_appearance_view"
			}
		}
		self._character_create = CharacterCreate:new(self._item_definitions, self._gear)
	end

	self:_next_character_create_view()
	Managers.time:register_timer("character_creation_timer", "main")
end

StateMainMenu.new_character_create = function (self)
	self._character_create = CharacterCreate:new(self._item_definitions, self._gear)

	return self._character_create
end

StateMainMenu.in_character_create_state = function (self)
	return self._character_create ~= nil
end

StateMainMenu._waiting_for_profile_synchronization = function (self)
	if self._wait_for_character_profile_upload or self._wait_for_character_profile_delete or self._wait_for_character_profiles_refresh then
		return true
	else
		return false
	end
end

StateMainMenu.waiting_for_profile_synchronization = function (self)
	return self:_waiting_for_profile_synchronization()
end

StateMainMenu._previous_character_create_view = function (self)
	local views_index = (self._current_character_create_state_views_index or 1) - 1
	local success = self:_open_character_create_state_views(views_index)

	if not success then
		if self._force_create_first_character then
			Log.warning("StateMainMenu", "Skipped character creation when force_create_first_character = true")
		end

		self._character_create_state_views = nil

		self._character_create:destroy()

		self._character_create = nil
		self._current_character_create_state_views_index = nil

		self:_set_view_state_cb("main_menu")
		Managers.event:trigger("event_main_menu_profiles_changed", self._profiles)
		Managers.event:trigger("event_main_menu_selected_profile_changed", self._selected_profile)
		Managers.time:unregister_timer("character_creation_timer")
		Log.info("StateMainMenu", "Exit character creator")
	end
end

StateMainMenu._next_character_create_view = function (self, skip_onboarding)
	local views_index = (self._current_character_create_state_views_index or 0) + 1
	local success = self:_open_character_create_state_views(views_index)

	if not success then
		self._character_create:upload_profile()

		self._wait_for_character_profile_upload = true
		self._skip_onboarding_for_created_character = skip_onboarding
	end
end

StateMainMenu.set_wait_for_character_profile_upload = function (self, value)
	self._wait_for_character_profile_upload = value
end

StateMainMenu._on_profile_create_completed = function (self, created_profile)
	self._character_create_state_views = nil

	self._character_create:destroy()

	self._character_create = nil
	self._current_character_create_state_views_index = nil
	self._wait_for_character_profile_upload = false
	local skip_onboarding = self._skip_onboarding_for_created_character or GameParameters.skip_prologue
	self._skip_onboarding_for_created_character = nil

	if created_profile then
		local time = Managers.time:time("character_creation_timer")

		Managers.telemetry_events:character_creation_time(created_profile.character_id, time)
		Managers.time:unregister_timer("character_creation_timer")
		Log.info("StateMainMenu", "Time in character creator %s", time)

		local character_id = created_profile.character_id

		self:_set_selected_profile(created_profile)

		local promises = {
			Managers.data_service.account:set_selected_character_id(character_id),
			Managers.narrative:load_character_narrative(character_id)
		}

		if self._force_create_first_character then
			self._force_create_first_character = nil
			promises[3] = Managers.data_service.account:set_has_created_first_character()
		end

		Promise.all(unpack(promises)):next(function (_)
			if skip_onboarding then
				return Managers.narrative:skip_story(Managers.narrative.STORIES.onboarding)
			else
				return nil
			end
		end):next(function (_)
			self:_start_game_or_onboarding()
		end):catch(function ()
			self:_set_view_state_cb("main_menu")
		end)
	else
		Managers.time:unregister_timer("character_creation_timer")
		self:_set_view_state_cb("main_menu")
	end
end

StateMainMenu._close_current_character_create_state_views = function (self)
	if self._current_character_create_state_views then
		for i = 1, #self._current_character_create_state_views do
			local next_view = self._current_character_create_state_views[i]

			Managers.ui:close_view(next_view)
		end

		self._current_character_create_state_views = nil
	end
end

StateMainMenu._open_character_create_state_views = function (self, index)
	self:_close_current_character_create_state_views()

	local view_index = index
	local next_views = self._character_create_state_views[view_index]

	if next_views then
		local view_context = {
			character_create = self._character_create,
			parent = self,
			force_character_creation = self._force_create_first_character
		}

		for i = 1, #next_views do
			local next_view = next_views[i]

			Managers.ui:open_view(next_view, nil, nil, nil, nil, view_context)

			self._current_character_create_state_views = next_views
			self._current_character_create_state_views_index = view_index
		end

		return true
	end

	return false
end

local state_views = {
	main_menu = {
		"main_menu_background_view"
	}
}

StateMainMenu._close_current_state_views = function (self)
	local current_view_state = self._current_view_state
	local open_views = state_views[current_view_state]
	local ui_manager = Managers.ui
	local leaving_game = Managers.account:leaving_game()

	if open_views then
		for i = 1, #open_views do
			local view_name = open_views[i]

			if ui_manager:view_active(view_name) then
				local force_close = leaving_game

				ui_manager:close_view(view_name, force_close)
			end
		end
	end

	if leaving_game then
		local active_views = ui_manager:active_views()
		local force_close = true

		while not table.is_empty(active_views) do
			local view_name = active_views[1]

			ui_manager:close_view(view_name, force_close)
		end
	end
end

StateMainMenu._set_view_state_cb = function (self, state)
	self:_close_current_state_views()

	self._current_view_state = state
	local new_state_views = state_views[state]

	if new_state_views then
		local view_context = {
			parent = self
		}

		for i = 1, #new_state_views do
			local view_name = new_state_views[i]

			Managers.ui:open_view(view_name, nil, nil, nil, nil, view_context)
		end
	end

	if state == "main_menu" and self._is_booting then
		self:_should_open_news()
	end
end

StateMainMenu._start_game = function (self)
	self:_unregister_menu_events()
	self:_set_view_state_cb(nil)

	self._continue = true
end

StateMainMenu.update = function (self, main_dt, main_t)
	local ui_manager = Managers.ui

	if ui_manager then
		ui_manager:handle_view_hotkeys()
	end

	local session_in_progress = GameParameters.prod_like_backend and Managers.party_immaterium:game_session_in_progress()

	if not self._reconnect_pressed and self._reconnect_popup_activated and session_in_progress then
		if not self._reconnect_popup_id then
			self:_show_reconnect_popup()
		end
	elseif self._reconnect_popup_id then
		Managers.event:trigger("event_remove_ui_popup", self._reconnect_popup_id)

		self._reconnect_popup_id = nil
	end

	if self._wait_for_character_profile_upload then
		local character_create = self._character_create

		if character_create:completed() then
			local success = not character_create:failed()
			local created_profile = success and character_create:created_character_profile()

			self:_on_profile_create_completed(created_profile)
		end
	end

	local context = self._creation_context

	context.network_receive_function(main_dt)
	context.network_transmit_function()

	local error_state, error_state_params = Managers.error:wanted_transition()

	if error_state then
		return error_state, error_state_params
	elseif IS_XBS or IS_GDK then
		local error_state, error_state_params = Managers.account:wanted_transition()

		if error_state then
			return error_state, error_state_params
		end
	end

	local is_syncing = self:_waiting_for_profile_synchronization()

	if self._continue and not is_syncing then
		self._reconnect_pressed = false
		local next_state, state_context = nil

		if self._onboarding_mission_name then
			next_state, state_context = Managers.multiplayer_session:start_singleplayer_session(self._onboarding_mission_name, SINGLEPLAY_TYPES.onboarding)
		else
			next_state, state_context = Managers.multiplayer_session:find_available_session()
		end

		return next_state, state_context
	end

	if is_syncing ~= self._character_is_syncing then
		Managers.event:trigger("update_character_sync_state", is_syncing)

		self._character_is_syncing = is_syncing
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(StateMainMenuTestify, self)
	end
end

StateMainMenu._start_onboarding = function (self, mission_name)
	self._onboarding_mission_name = mission_name

	self:_start_game()
end

StateMainMenu._should_open_news = function (self)
	local save_manager = Managers.save
	local save_data = save_manager:account_data()
	local news_feed_enabled = save_data.interface_settings.news_enabled

	if news_feed_enabled then
		Managers.event:trigger("event_main_menu_load_news")
	end
end

StateMainMenu.on_exit = function (self)
	if self._full_frame_rate_enabled then
		Managers.frame_rate:relinquish_request("main_menu")

		self._full_frame_rate_enabled = false
	end

	self:_close_current_character_create_state_views()
	self:_close_current_state_views()
	self:_unregister_menu_events()

	if Managers.time:has_timer("character_creation_timer") then
		Managers.time:unregister_timer("character_creation_timer")
	end

	if self._main_menu_loader then
		self._main_menu_loader:destroy()

		self._main_menu_loader = nil
	end
end

StateMainMenu._rejoin_game = function (self)
	local selected_profile = self._selected_profile

	if not selected_profile then
		Log.warning("StateMainMenu", "Tried to rejoin a game without a selected character!")

		return
	end

	local character_id = selected_profile.character_id

	Log.info("StateMainMenu", "Rejoining the game with selected character %s", character_id)
	self:_unregister_menu_events()

	local set_selected_character_promise = Managers.data_service.account:set_selected_character_id(character_id)
	local load_narrative_promise = Managers.narrative:load_character_narrative(character_id)

	Promise.all(set_selected_character_promise, load_narrative_promise):next(function (_)
		self:_start_game()
	end):catch(function ()
		return
	end)
end

StateMainMenu._show_reconnect_popup = function (self)
	local context = {
		title_text = "loc_popup_header_reconnect_to_session",
		description_text = "loc_popup_description_reconnect_to_session",
		options = {
			{
				text = "loc_popup_reconnect_to_session_reconnect_button",
				close_on_pressed = true,
				callback = function ()
					self._reconnect_popup_id = nil
					self._reconnect_pressed = true

					self:_rejoin_game()
				end
			},
			{
				text = "loc_popup_reconnect_to_session_leave_button",
				close_on_pressed = true,
				hotkey = "back",
				callback = function ()
					Managers.party_immaterium:leave_party()
				end
			}
		}
	}

	Managers.event:trigger("event_show_ui_popup", context, function (id)
		self._reconnect_popup_id = id
	end)
end

return StateMainMenu
