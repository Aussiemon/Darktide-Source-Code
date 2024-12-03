-- chunkname: @scripts/game_states/game/state_title.lua

local HumanPlayer = require("scripts/managers/player/human_player")
local MainMenuLoader = require("scripts/loading/loaders/main_menu_loader")
local Popups = require("scripts/utilities/ui/popups")
local PrivilegesManager = require("scripts/managers/privileges/privileges_manager")
local Promise = require("scripts/foundation/utilities/promise")
local SigninLoader = require("scripts/loading/loaders/signin_loader")
local StateMainMenu = require("scripts/game_states/game/state_main_menu")
local SteamOfflineError = require("scripts/managers/error/errors/steam_offline_error")
local TaskbarFlash = require("scripts/utilities/taskbar_flash")
local StateTitle = class("StateTitle")
local STATES = table.enum("idle", "account_signin", "signing_in", "loading_packages", "authenticating_eos", "legal_verification", "name_verification", "done", "error")

local function _should_skip(skip_title_screen_on_invite)
	if (IS_XBS or IS_PLAYSTATION) and BUILD == "release" then
		return false
	end

	if Managers.data_service.social:has_invite() and skip_title_screen_on_invite then
		return true
	end

	local skip_title = LEVEL_EDITOR_TEST or GameParameters.mission or not Managers.ui

	return skip_title
end

local function _create_player(account_id, selected_profile)
	local local_player_id = 1
	local local_player = Managers.player:local_player(local_player_id)

	if not local_player then
		local telemetry_game_session = Managers.telemetry_events._session.game
		local slot = 0

		local_player = Managers.player:add_human_player(HumanPlayer, nil, Network.peer_id(), local_player_id, selected_profile, slot, account_id, "player1", telemetry_game_session)

		Managers.telemetry_events:local_player_spawned(local_player)
	end

	return local_player
end

StateTitle._check_start_requirements = function (self, is_booting)
	local can_continue = true

	if HAS_STEAM and not Steam.connected() then
		local err = SteamOfflineError:new(is_booting)

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

	local skip_title_screen_on_invite = params.skip_title_screen_on_invite

	params.skip_title_screen_on_invite = nil
	self._auth_queue_position = nil
	self._queue_update_time = 0
	self._queue_changed = false
	self._state = STATES.idle

	if self._is_booting and not self:_check_start_requirements(true) then
		return
	end

	if Managers.stats:user_state(1) ~= nil then
		Managers.stats:remove_user(1)
	end

	if Managers.achievements:has_player(1) then
		Managers.achievements:remove_player(1)
	end

	Managers.account:reset()

	if IS_XBS then
		Managers.save:reset()
	end

	if _should_skip(skip_title_screen_on_invite) then
		local raw_input_device

		raw_input_device = (not IS_XBS or not GameParameters.testify) and raw_input_device

		self:_continue_cb(raw_input_device)
	else
		local context = {
			parent = self,
		}
		local view_name = "title_view"

		Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
		Managers.event:register(self, "event_state_title_continue", "_continue_cb")
	end

	TaskbarFlash.flash_window()
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
	self:_set_state(STATES.account_signin)
	Managers.account:signin_profile(callback(self, "cb_profile_signed_in"), optional_input_device)
end

StateTitle.cb_profile_signed_in = function (self)
	Managers.data_service.social:on_profile_signed_in()
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
		return true, false, "loc_title_screen_signing_in"
	elseif state == states.signing_in then
		return true, false, "loc_title_screen_signing_in"
	elseif state == states.loading_packages then
		return true, false, "loc_title_screen_signing_in"
	elseif state == states.authenticating_eos then
		return true, false, "loc_title_screen_signing_in"
	end

	return false
end

StateTitle._legal_verification = function (self)
	if GameParameters.testify then
		return self:_set_state(STATES.done)
	end

	self:_set_state(STATES.legal_verification)

	local legal_promises = {
		Managers.backend.interfaces.account:get_data("legal", "eula"),
		Managers.backend.interfaces.account:get_data("legal", "privacy_policy"),
	}

	legal_promises[#legal_promises + 1] = Managers.backend.interfaces.account:get_data("legal", "cross_play_support")

	local save_manager = Managers.save
	local cross_play_support_status, account_data

	if save_manager then
		account_data = save_manager:account_data()
		cross_play_support_status = account_data.crossplay_accepted
	end

	Promise.all(unpack(legal_promises)):next(function (results)
		local eula_status, privacy_policy_status = unpack(results, 1, 2)
		local cross_play_support_status_backend = unpack(results, 3)

		if cross_play_support_status_backend and cross_play_support_status == false then
			if account_data then
				account_data.crossplay_accepted = true

				save_manager:queue_save()
			end

			cross_play_support_status = true
		end

		if cross_play_support_status == nil then
			cross_play_support_status = true
		end

		if not privacy_policy_status then
			local options = {}

			if IS_XBS or IS_PLAYSTATION then
				options[#options + 1] = {
					margin_bottom = 20,
					template_type = "text",
					text = "loc_privacy_policy_privacy_url",
				}
			else
				options[#options + 1] = {
					margin_bottom = 20,
					template_type = "url_button",
					text = "loc_privacy_policy_read_privacy_policy",
					callback = function ()
						Application.open_url_in_browser(Localize("loc_privacy_policy_privacy_url"))
					end,
				}
			end

			options[#options + 1] = {
				close_on_pressed = true,
				text = "loc_privacy_policy_accept_button_label",
				callback = function ()
					Managers.backend.interfaces.account:set_data("legal", {
						privacy_policy = privacy_policy_status and privacy_policy_status + 1 or 1,
					}):next(function ()
						self:_legal_verification()
					end):catch(function (error)
						Managers.event:trigger("event_add_notification_message", "alert", {
							text = Localize("loc_popup_description_backend_error"),
						})
						self:_on_error()
					end)
				end,
			}
			options[#options + 1] = {
				close_on_pressed = true,
				hotkey = "back",
				text = PLATFORM == "win32" and "loc_privacy_policy_decline_button_label" or "loc_privacy_policy_decline_button_console_label",
				callback = function ()
					if PLATFORM == "win32" then
						Application.quit()
					else
						self:_reset_state()
					end
				end,
			}

			local context = {
				description_text = "loc_privacy_policy_information_01b",
				title_text = "loc_privacy_policy_title",
				options = options,
			}

			Managers.event:trigger("event_show_ui_popup", context)
		elseif not eula_status and (not HAS_STEAM or not Steam.connected()) then
			local options = {}

			if IS_XBS or IS_PLAYSTATION then
				options[#options + 1] = {
					margin_bottom = 20,
					template_type = "text",
					text = "loc_privacy_policy_eula_url",
				}
			else
				options[#options + 1] = {
					margin_bottom = 20,
					template_type = "url_button",
					text = "loc_privacy_policy_read_eula",
					callback = function ()
						Application.open_url_in_browser(Localize("loc_privacy_policy_eula_url"))
					end,
				}
			end

			options[#options + 1] = {
				close_on_pressed = true,
				text = "loc_privacy_policy_accept_eula_button_label",
				callback = function ()
					Managers.backend.interfaces.account:set_data("legal", {
						eula = eula_status and eula_status + 1 or 1,
					}):next(function ()
						self:_legal_verification()
					end):catch(function (error)
						Managers.event:trigger("event_add_notification_message", "alert", {
							text = Localize("loc_popup_description_backend_error"),
						})
						self:_on_error()
					end)
				end,
			}
			options[#options + 1] = {
				close_on_pressed = true,
				hotkey = "back",
				text = PLATFORM == "win32" and "loc_privacy_policy_decline_button_label" or "loc_privacy_policy_decline_button_console_label",
				callback = function ()
					if PLATFORM == "win32" then
						Application.quit()
					else
						self:_reset_state()
					end
				end,
			}

			local context = {
				description_text = "loc_privacy_policy_information_01c",
				title_text = "loc_eula_title",
				options = options,
			}

			Managers.event:trigger("event_show_ui_popup", context)
		elseif not cross_play_support_status then
			local options = {}

			options[#options + 1] = {
				close_on_pressed = true,
				text = "loc_cross_play_support_accept_button_label",
				callback = function ()
					if account_data then
						account_data.crossplay_accepted = true

						save_manager:queue_save()
					end

					Managers.backend.interfaces.account:set_data("legal", {
						cross_play_support = cross_play_support_status and cross_play_support_status + 1 or 1,
					})
					self:_legal_verification()
				end,
			}

			local context = {
				description_text = "loc_cross_play_support_information",
				title_text = "loc_cross_play_support_title",
				options = options,
			}

			Managers.event:trigger("event_show_ui_popup", context)
		else
			self:_verify_name()
		end
	end):catch(function (error)
		Managers.event:trigger("event_add_notification_message", "alert", {
			text = Localize("loc_popup_description_backend_error"),
		})
		self:_on_error()
	end)
end

StateTitle._verify_name = function (self)
	if GameParameters.testify then
		return self:_set_state(STATES.done)
	end

	self:_set_state(STATES.name_verification)
	Managers.backend.interfaces.account:get():next(function (account_data)
		local rename_status = account_data.rename
		local forced = rename_status and rename_status.forced

		if forced then
			Popups.rename(callback(self, "_set_state", STATES.done), true)
		else
			self:_set_state(STATES.done)
		end
	end):catch(function (_)
		Managers.event:trigger("event_add_notification_message", "alert", {
			text = Localize("loc_popup_description_backend_error"),
		})
		self:_on_error()
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
	next_state_params.migration_data = nil

	local backend_promise = self._backend_promise

	self._backend_promise = nil

	if backend_promise and backend_promise:is_pending() then
		backend_promise:cancel()
	end

	if Managers.stats:user_state(1) ~= nil then
		Managers.stats:remove_user(1)
	end

	if Managers.achievements:has_player(1) then
		Managers.achievements:remove_player(1)
	end

	self._backend_data_synced = nil

	self:_set_state(STATES.idle)
	Managers.event:register(self, "event_state_title_continue", "_continue_cb")
	Managers.event:trigger("event_state_title_reset")
	Managers.account:reset()

	if IS_XBS then
		Managers.save:reset()
	end

	Managers.data_service:reset()

	if GameParameters.prod_like_backend then
		Managers.presence:reset()
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
	elseif IS_XBS or IS_GDK or IS_PLAYSTATION then
		local error_state, error_state_params = Managers.account:wanted_transition()

		if error_state then
			error_state_params.is_booting = self._is_booting

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

		if not self._backend_data_synced then
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
		Managers.ui:render_black_background()

		local authenticated = Managers.eac_client:authenticated()

		if authenticated then
			self:_legal_verification()
		end
	elseif state == states.done then
		Managers.telemetry_events:crashify_properties()

		return self._next_state, self._next_state_params
	end
end

local UPDATE_QUEUE_POSITION_INTERVAL = 5

StateTitle._update_queue_position = function (self, main_t)
	self._queue_changed = false

	if main_t >= self._queue_update_time then
		self._auth_queue_position = Backend.get_auth_queue_position()
		self._queue_update_time = main_t + UPDATE_QUEUE_POSITION_INTERVAL
		self._queue_changed = true
	end
end

StateTitle.on_exit = function (self)
	local view_name = "title_view"
	local ui_manager = Managers.ui

	if ui_manager then
		local leaving_game = Managers.account:leaving_game()

		if leaving_game then
			local active_views = ui_manager:active_views()
			local force_close = true

			while not table.is_empty(active_views) do
				local view_name = active_views[1]

				ui_manager:close_view(view_name, force_close)
			end

			local main_menu_loader = self._next_state_params and self._next_state_params.main_menu_loader

			if main_menu_loader then
				main_menu_loader:delete()

				self._next_state_params.main_menu_loader = nil
			end
		elseif ui_manager:view_active(view_name) then
			ui_manager:close_view(view_name)
		end
	end

	Managers.event:unregister(self, "event_state_title_continue")
end

StateTitle._signin = function (self)
	if not self:_check_start_requirements(false) then
		return
	end

	self:_set_state(STATES.signing_in)

	self._signin_loader = SigninLoader:new()

	self._signin_loader:start_loading()

	self._is_booting = false

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
		local vivox_token = result.vivox_token
		local profiles = result.profiles
		local gear = result.gear
		local selected_profile = result.selected_profile
		local has_created_first_character = result.has_created_first_character
		local migration_data = result.migration_data
		local save_manager = Managers.save

		save_manager:set_save_data_account_id(account_id)

		local account_data = save_manager:account_data()

		if account_data and migration_data then
			local current_index = migration_data.latest_completed and migration_data.latest_completed.index or -1
			local added_index = migration_data.migrations and #migration_data.migrations or 0

			account_data.latest_backend_migration_index = current_index + added_index

			save_manager:queue_save()
		end

		Managers.event:trigger("event_player_authenticated")
		Managers.input:load_settings()

		local local_player = _create_player(account_id, selected_profile)

		Managers.live_event:add_player(1, account_id, true)
		Managers.live_event:refresh()

		local stats_promise = Managers.stats:add_user(1, account_id)
		local backend_settings_promise = Managers.backend:update_backend_settings()
		local sync_promises = Promise.all(stats_promise, backend_settings_promise)

		self._backend_promise = sync_promises
		self._backend_data_synced = false

		sync_promises:next(function ()
			local narrative_promise = Promise.resolved()

			if selected_profile then
				local character_id = selected_profile.character_id

				narrative_promise = Managers.narrative:load_character_narrative(character_id)
			end

			local achievement_promise = Managers.achievements:add_player(local_player)
			local all_promise = Promise.all(narrative_promise, achievement_promise)

			self._backend_promise = all_promise

			return all_promise
		end):next(function ()
			self._backend_promise = nil
			self._backend_data_synced = true
		end):catch(function ()
			Managers.event:trigger("event_add_notification_message", "alert", {
				text = Localize("loc_popup_description_backend_error"),
			})
			self:_on_error()
		end)

		local main_menu_loader = MainMenuLoader:new()

		main_menu_loader:start_loading()

		local next_state_params = self._next_state_params

		next_state_params.main_menu_loader = main_menu_loader
		next_state_params.profiles = profiles
		next_state_params.gear = gear
		next_state_params.selected_profile = selected_profile
		next_state_params.has_created_first_character = has_created_first_character
		next_state_params.migration_data = migration_data and migration_data.migrations

		self:_set_state(STATES.loading_packages)

		if Managers.chat then
			if not Managers.chat:is_initialized() then
				Managers.chat:initialize()
			elseif Managers.chat:is_connected() then
				Managers.chat:login(Network.peer_id(), account_id, vivox_token)
			end
		end

		if not DEDICATED_SERVER then
			Managers.dlc:initialize()
		end

		Managers.account:refresh_communication_restrictions()
		Managers.account:fetch_crossplay_restrictions()

		if GameParameters.prod_like_backend then
			Managers.presence:initialize()
		end

		if GameParameters.prod_like_backend then
			local privileges_manager = PrivilegesManager:new()

			privileges_manager:cross_play():next(function (res)
				local cross_play_disabled = not res.has_privilege

				Managers.presence:set_cross_play_disabled(cross_play_disabled)
			end)
			Managers.data_service.havoc:refresh_havoc_status()
			Managers.data_service.havoc:refresh_havoc_rank()
		end
	end)
end

return StateTitle
