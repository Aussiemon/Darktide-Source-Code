local MainMenuLoader = require("scripts/loading/loaders/main_menu_loader")
local SigninLoader = require("scripts/loading/loaders/signin_loader")
local HumanPlayer = require("scripts/managers/player/human_player")
local StateMainMenu = require("scripts/game_states/game/state_main_menu")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local SteamOfflineError = require("scripts/managers/error/errors/steam_offline_error")
local Promise = require("scripts/foundation/utilities/promise")
local StateTitle = class("StateTitle")
local STATES = table.enum("idle", "account_signin", "signing_in", "loading_packages", "authenticating_eos", "legal_verification", "done", "error")

local function _should_skip()
	if IS_XBS and BUILD == "release" then
		return false
	end

	local skip_title = LEVEL_EDITOR_TEST or GameParameters.mission or Managers.data_service.social:has_invite() or not Managers.ui

	return skip_title
end

local function _create_player(account_id, selected_profile)
	local local_player_id = 1
	local local_player = Managers.player:local_player(local_player_id)

	if not local_player then
		local telemetry_game_session = Managers.telemetry_events._session.game
		local slot = 0
		local_player = Managers.player:add_human_player(HumanPlayer, nil, Network.peer_id(), local_player_id, selected_profile, slot, account_id, "player1", telemetry_game_session)
	end

	return local_player
end

StateTitle._check_start_requirements = function (self)
	local can_continue = true

	if HAS_STEAM and not Steam.connected() then
		local err = SteamOfflineError:new()

		Managers.error:report_error(err)

		can_continue = err:level() < Managers.error.ERROR_LEVEL.error
	end

	return can_continue
end

StateTitle.on_enter = function (self, parent, params, creation_context)
	self._creation_context = creation_context
	self._next_state = StateMainMenu
	self._next_state_params = params
	self._is_booting = params.is_booting or false
	self._auth_queue_position = nil
	self._queue_update_time = 0
	self._queue_changed = false
	self._state = STATES.idle

	if not self:_check_start_requirements() then
		return
	end

	Managers.account:reset()

	if IS_XBS then
		Managers.save:reset()
	end

	if _should_skip() then
		if IS_XBS or IS_GDK then
			local raw_input_device = nil

			if IS_XBS then
				-- Nothing
			end

			self:_signin_profile(raw_input_device)
		else
			self:_signin()
		end
	else
		local context = {
			parent = self
		}
		local view_name = "title_view"

		Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
		Managers.event:register(self, "event_state_title_continue", "_continue_cb")
	end

	Managers.presence:set_presence("title_screen")
end

StateTitle._set_state = function (self, state)
	Log.info("StateTitle", "Changing state %s -> %s", self._state, state)

	self._state = state
end

StateTitle.state = function (self)
	return self._state
end

StateTitle._continue_cb = function (self, optional_input_device)
	Managers.event:unregister(self, "event_state_title_continue")

	if IS_XBS or IS_GDK then
		self:_signin_profile(optional_input_device)
	else
		self:_signin()
	end
end

StateTitle._signin_profile = function (self, optional_input_device)
	self:_set_state(STATES.account_signin)
	Managers.account:signin_profile(callback(self, "cb_profile_signed_in"), optional_input_device)
end

StateTitle.cb_profile_signed_in = function (self)
	self:_signin()
end

local queue_loc_table = {}

StateTitle.is_loading = function (self)
	local state = self._state
	local states = STATES

	if self._auth_queue_position and self._auth_queue_position > 0 then
		if self._queue_changed then
			queue_loc_table.position = self._auth_queue_position
		end

		return true, self._queue_changed, "loc_state_title_authenticating_queue", true, queue_loc_table
	elseif state == states.account_signin then
		return true, false, Managers.account:signin_state()
	elseif state == states.signing_in then
		return true, false, "loc_state_title_authenticating_backend"
	elseif state == states.loading_packages then
		return true, false, "loc_state_title_loading_packages"
	elseif state == states.authenticating_eos then
		return true, false, "loc_state_title_authenticating_eos"
	end

	return false
end

StateTitle._legal_verification = function (self)
	self:_set_state(STATES.legal_verification)

	local legal_promises = {
		Managers.backend.interfaces.account:get_data("legal", "eula"),
		Managers.backend.interfaces.account:get_data("legal", "privacy_policy")
	}

	Promise.all(unpack(legal_promises)):next(function (results)
		local eula_status, privacy_policy_status = unpack(results)

		if not privacy_policy_status then
			local context = {
				title_text = "loc_privacy_policy_title",
				description_text = "loc_privacy_policy_information_01b",
				options = {
					{
						text = "loc_privacy_policy_read_privacy_policy",
						template_type = "url_button",
						margin_bottom = 20,
						callback = function ()
							Application.open_url_in_browser(Localize("loc_popup_link_eac_error"))
						end
					},
					{
						text = "loc_privacy_policy_accept_button_label",
						close_on_pressed = true,
						callback = function ()
							Managers.backend.interfaces.account:set_data("legal", {
								privacy_policy = privacy_policy_status and privacy_policy_status + 1 or 1
							}):next(function ()
								self:_legal_verification()
							end)
						end
					},
					{
						text = "loc_privacy_policy_decline_button_label",
						close_on_pressed = true,
						hotkey = "back",
						callback = function ()
							if PLATFORM == "win32" then
								Application.quit()
							else
								self:_reset_state()
							end
						end
					}
				}
			}

			Managers.event:trigger("event_show_ui_popup", context)
		elseif not eula_status and (not HAS_STEAM or not Steam.connected()) then
			local context = {
				title_text = "loc_eula_title",
				description_text = "loc_privacy_policy_information_01c",
				options = {
					{
						text = "loc_privacy_policy_read_eula",
						template_type = "url_button",
						margin_bottom = 20,
						callback = function ()
							Application.open_url_in_browser(Localize("loc_popup_link_eac_error"))
						end
					},
					{
						text = "loc_eula_accept_button_label",
						close_on_pressed = true,
						callback = function ()
							Managers.backend.interfaces.account:set_data("legal", {
								eula = eula_status and eula_status + 1 or 1
							}):next(function ()
								self:_legal_verification()
							end)
						end
					},
					{
						text = "loc_eula_decline_button_label",
						close_on_pressed = true,
						hotkey = "back",
						callback = function ()
							if PLATFORM == "win32" then
								Application.quit()
							else
								self:_reset_state()
							end
						end
					}
				}
			}

			Managers.event:trigger("event_show_ui_popup", context)
		else
			self:_set_state(STATES.done)
		end
	end)
end

StateTitle._on_error = function (self)
	self:_set_state(STATES.error)
	Managers.error:show_errors():next(function ()
		self:_reset_state()
	end)
end

StateTitle._reset_state = function (self)
	local next_state_params = self._next_state_params

	if next_state_params.main_menu_loader then
		next_state_params.main_menu_loader:delete()

		next_state_params.main_menu_loader = nil
	end

	next_state_params.profiles = nil
	next_state_params.selected_profile = nil
	next_state_params.has_created_first_character = nil

	if self._narrative_promise and self._narrative_promise:is_pending() then
		self._narrative_promise:cancel()

		self._narrative_promise = nil
	end

	self:_set_state(STATES.idle)
	Managers.event:register(self, "event_state_title_continue", "_continue_cb")
	Managers.event:trigger("event_state_title_reset")
	Managers.account:reset()

	if IS_XBS then
		Managers.save:reset()
	end
end

StateTitle.update = function (self, main_dt, main_t)
	local context = self._creation_context

	context.network_receive_function(main_dt)
	context.network_transmit_function()

	local state = self._state
	local states = STATES

	if state == states.error then
		return
	end

	local error_state, _ = Managers.error:wanted_transition()

	if error_state then
		self:_on_error()

		return
	elseif IS_XBS or IS_GDK then
		local error_state, error_state_params = Managers.account:wanted_transition()

		if error_state then
			return error_state, error_state_params
		end
	end

	if state == states.idle then
		return
	elseif state == states.account_signin then
		self:_update_queue_position(main_t)
		Managers.ui:render_loading_icon()
		Managers.ui:render_black_background()
	elseif state == states.signing_in then
		self:_update_queue_position(main_t)
		Managers.ui:render_loading_icon()
		Managers.ui:render_black_background()
	elseif state == states.legal_verification then
		self:_update_queue_position(main_t)
		Managers.ui:render_loading_icon()
		Managers.ui:render_black_background()
	elseif state == states.loading_packages then
		Managers.ui:render_loading_icon()
		Managers.ui:render_black_background()

		local loading_done = true

		if self._signin_loader and not self._signin_loader:is_loading_done() then
			loading_done = false
		end

		local main_menu_loader = self._next_state_params.main_menu_loader

		if main_menu_loader and not main_menu_loader:is_loading_done() then
			loading_done = false
		end

		if self._narrative_promise and not self._narrative_promise:is_fulfilled() then
			loading_done = false
		end

		if loading_done then
			local has_eac = false

			if has_eac then
				self:_set_state(states.authenticating_eos)
			else
				self:_legal_verification()
			end
		end
	elseif state == states.authenticating_eos then
		Managers.ui:render_loading_icon()

		local authenticated = Managers.eac_client:authenticated()

		if authenticated then
			self:_legal_verification()
		end
	elseif state == states.done then
		return self._next_state, self._next_state_params
	end
end

local UPDATE_QUEUE_POSITION_INTERVAL = 5

StateTitle._update_queue_position = function (self, main_t)
	self._queue_changed = false

	if self._queue_update_time <= main_t then
		self._auth_queue_position = Backend.get_auth_queue_position()
		self._queue_update_time = main_t + UPDATE_QUEUE_POSITION_INTERVAL
		self._queue_changed = true
	end
end

StateTitle.on_exit = function (self)
	local view_name = "title_view"
	local ui_manager = Managers.ui

	if ui_manager and ui_manager:view_active(view_name) then
		local force_close = Managers.account:leaving_game()

		ui_manager:close_view(view_name, force_close)
	end
end

StateTitle._signin = function (self)
	self:_set_state(STATES.signing_in)

	if self._is_booting then
		self._signin_loader = SigninLoader:new()

		self._signin_loader:start_loading()
	end

	local has_eac = false

	if has_eac then
		Log.info("StateTitle", "Managers.eac_client:authenticate()")
		Managers.eac_client:authenticate()
	end

	Managers.narrative:reset()
	Managers.data_service.account:signin():next(function (result)
		if not result then
			return
		end

		local account_id = result.account_id
		local profiles = result.profiles
		local gear = result.gear
		local selected_profile = result.selected_profile
		local has_created_first_character = result.has_created_first_character
		local account_data = Managers.save:account_data()
		local input_layout = account_data and account_data.input_settings.controller_layout or "default"

		Managers.input:change_input_layout(input_layout)
		Managers.input:load_settings()
		_create_player(account_id, selected_profile)

		if selected_profile then
			local character_id = selected_profile.character_id
			self._narrative_promise = Managers.narrative:load_character_narrative(character_id)
		end

		local main_menu_loader = MainMenuLoader:new()

		main_menu_loader:start_loading()

		local next_state_params = self._next_state_params
		next_state_params.main_menu_loader = main_menu_loader
		next_state_params.profiles = profiles
		next_state_params.gear = gear
		next_state_params.selected_profile = selected_profile
		next_state_params.has_created_first_character = has_created_first_character

		self:_set_state(STATES.loading_packages)

		if Managers.chat and not Managers.chat:is_initialized() then
			Managers.chat:initialize()
		end

		if GameParameters.prod_like_backend and result.account_id ~= PlayerManager.NO_ACCOUNT_ID then
			Managers.party_immaterium:start()
		end

		if not DEDICATED_SERVER then
			Managers.dlc:initialize()
		end

		Managers.account:refresh_communcation_restrictions()
		Managers.account:fetch_crossplay_restrictions()
	end)
end

return StateTitle
