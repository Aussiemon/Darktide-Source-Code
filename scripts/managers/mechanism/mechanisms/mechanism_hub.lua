-- chunkname: @scripts/managers/mechanism/mechanisms/mechanism_hub.lua

local MechanismBase = require("scripts/managers/mechanism/mechanisms/mechanism_base")
local Missions = require("scripts/settings/mission/mission_templates")
local PlayerProgressionUnlocks = require("scripts/settings/player/player_progression_unlocks")
local PlayerVOStoryStage = require("scripts/utilities/player_vo_story_stage")
local Popups = require("scripts/utilities/ui/popups")
local Promise = require("scripts/foundation/utilities/promise")
local StateGameplay = require("scripts/game_states/game/state_gameplay")
local StateLoading = require("scripts/game_states/game/state_loading")
local MechanismHub = class("MechanismHub", "MechanismBase")

MechanismHub.init = function (self, ...)
	MechanismHub.super.init(self, ...)

	local mission_name = "hub_ship"
	local level_name = Missions[mission_name].level
	local circumstance_name = "default"
	local data = self._mechanism_data

	data.challenge = DevParameters.challenge
	data.resistance = DevParameters.resistance
	data.level_name = level_name
	data.mission_name = mission_name
	data.circumstance_name = circumstance_name
	data.side_mission = GameParameters.side_mission
	self._hub_config_request = false
	self._fetching_client_data = false
	self._refresh_vo_story_stage = not DEDICATED_SERVER
	self._last_auto_joined_game_session_id = nil

	local context = self._context
	local server_channel = context.server_channel

	self._is_owner = server_channel == nil
	self._is_syncing = not self._is_owner

	if self._is_syncing then
		self._network_event_delegate:register_connection_channel_events(self, server_channel, "rpc_sync_mechanism_data_hub")
	end
end

MechanismHub.sync_data = function (self, channel_id)
	local data = self._mechanism_data

	RPC.rpc_sync_mechanism_data_hub(channel_id, NetworkLookup.circumstance_templates[data.circumstance_name])
end

MechanismHub.client_exit_gameplay = function (self)
	self:_set_state("client_exit_gameplay")
end

MechanismHub.all_players_ready = function (self)
	return
end

MechanismHub.failed_fetching_session_report = function (self)
	return
end

local function _fetch_client_data()
	local player = Managers.player:local_player(1)
	local character_id = player:character_id()
	local narrative_promise = Managers.narrative:load_character_narrative(character_id)
	local account_id = player:account_id()
	local contracts_promise, player_journey_promise, campaign_skip_promise

	if math.is_uuid(character_id) then
		local mission_board_service = Managers.data_service.mission_board

		player_journey_promise = mission_board_service:fetch_player_journey_data(account_id, character_id)
		campaign_skip_promise = mission_board_service:fetch_character_campaign_skip_data(account_id, character_id)

		local contract_service = Managers.data_service.contracts

		contracts_promise = Promise.all(player_journey_promise, narrative_promise):next(function ()
			return contract_service:has_contract(character_id)
		end):next(function (contract_exist)
			local block_reason, _ = Managers.data_service.mission_board:get_block_reason("hub_facility", PlayerProgressionUnlocks.contracts)
			local has_visited_contracts = Managers.narrative:is_event_complete("level_unlock_contract_store_visited")
			local should_create_contract = has_visited_contracts and not block_reason

			if not contract_exist and should_create_contract then
				Managers.event:trigger("event_add_notification_message", "default", Localize("loc_notification_new_contract"))
			end

			if contract_exist or should_create_contract then
				return contract_service:get_contract(character_id, should_create_contract)
			end
		end):next(function (contract)
			if contract and contract.fulfilled and not contract.rewarded then
				local reward = contract.reward
				local reason = Localize("loc_notification_title_contract_completed")

				Managers.event:trigger("event_add_notification_message", "currency", {
					reason = reason,
					currency = reward.type,
					amount = reward.amount,
				})

				return contract_service:complete_contract(character_id)
			end
		end)
	end

	local promises = {}

	promises[#promises + 1] = narrative_promise
	promises[#promises + 1] = Managers.data_service.havoc:refresh_havoc_status()
	promises[#promises + 1] = Managers.data_service.havoc:refresh_havoc_rank()
	promises[#promises + 1] = Managers.data_service.havoc:refresh_ever_received_havoc_order()
	promises[#promises + 1] = Managers.data_service.havoc:refresh_havoc_unlock_status()
	promises[#promises + 1] = Managers.data_service.havoc:refresh_havoc_cadence_status()
	promises[#promises + 1] = contracts_promise
	promises[#promises + 1] = player_journey_promise
	promises[#promises + 1] = campaign_skip_promise
	promises[#promises + 1] = Managers.data_service.news:claim_rewards()

	Managers.data_service.store:invalidate_wallets_cache()

	return Promise.all(unpack(promises))
end

MechanismHub.wanted_transition = function (self)
	local state = self._state
	local mechanism_data = self._mechanism_data

	if state == "init" then
		if DEDICATED_SERVER then
			self:_set_state("request_hub_config")

			return false, StateLoading, {}
		end

		if not self._fetching_client_data then
			if Managers.backend:authenticated() then
				Managers.live_event:refresh_progress()

				self._client_data_promise = _fetch_client_data()

				self._client_data_promise:next(function ()
					self._client_data_promise = nil

					self:_set_state("request_hub_config")
				end):catch(function ()
					self._client_data_promise = nil

					self:_set_state("request_hub_config")
				end)
			else
				self:_set_state("request_hub_config")
			end

			self._fetching_client_data = true

			return false, StateLoading, {}
		else
			return false
		end
	elseif state == "request_hub_config" then
		if self._is_syncing then
			return false
		end

		if self._is_synced then
			self:_set_state("init_hub")

			return false
		end

		if not self._hub_config_request then
			if Managers.backend:authenticated() then
				Managers.backend.interfaces.hub_session:get_hub_config():next(function (config)
					Log.info("MechanismHub", "Loaded circumstance_name %s", config.circumstanceName)

					mechanism_data.circumstance_name = config.circumstanceName

					self:_set_state("init_hub")
				end):catch(function (error)
					Log.error("MechanismHub", "Could not load hub_config from backend, falling back to default circumstance_name, error=%s", table.tostring(error, 3))

					mechanism_data.circumstance_name = GameParameters.circumstance or "default"

					self:_set_state("init_hub")
				end)
			else
				Log.error("MechanismHub", "Could not load hub_config from backend, not authenticated, falling back to default circumstance_name")

				mechanism_data.circumstance_name = GameParameters.circumstance or "default"

				self:_set_state("init_hub")
			end

			self._hub_config_request = true
		end

		return false
	elseif state == "init_hub" then
		self:_set_state("in_hub")

		local mission_name = mechanism_data.mission_name
		local level_name = mechanism_data.level_name
		local side_mission = mechanism_data.side_mission
		local circumstance_name = mechanism_data.circumstance_name

		Log.info("MechanismHub", "Loading hub level %s with mission %s and circumstance %s.", level_name, mission_name, circumstance_name)

		return false, StateLoading, {
			level = level_name,
			mission_name = mission_name,
			circumstance_name = circumstance_name,
			side_mission = side_mission,
			next_state = StateGameplay,
			next_state_params = {
				mechanism_data = mechanism_data,
			},
		}
	elseif state == "in_hub" then
		if not DEDICATED_SERVER then
			local mission_board_service = Managers.data_service.mission_board

			if not self._campaign_skip_popup_id and not mission_board_service:get_has_character_been_asked_to_skip_campaign() and mission_board_service:get_is_character_eligible_to_skip_campaign() and Managers.narrative:is_event_complete("onboarding_step_chapel_cutscene_played") and not Managers.ui:handling_popups() and not Managers.ui:has_active_view() then
				local local_player_id = 1
				local player_manager = Managers.player
				local player = player_manager and player_manager:local_player(local_player_id)
				local character_id = player and player:character_id()
				local account_id = player and player:account_id()

				Popups.skip_player_journey.hub(function (id)
					self._campaign_skip_popup_id = id
				end, function ()
					local level = Managers.state.mission and Managers.state.mission:mission_level()

					if not level then
						return
					end

					if level then
						Level.trigger_event(level, "event_onboarding_step_mission_board_introduction")
					end

					if mission_board_service then
						Managers.telemetry_events:player_journey_popup_play_journey("hub", true)
						mission_board_service:skip_and_unlock_campaign(account_id, character_id):next(function (data)
							return mission_board_service:set_character_has_been_shown_skip_campaign_popup(account_id, character_id)
						end)
					end
				end, function ()
					local level = Managers.state.mission and Managers.state.mission:mission_level()

					if not level then
						return
					end

					if level then
						Level.trigger_event(level, "event_onboarding_step_mission_board_introduction")
					end

					if mission_board_service then
						Managers.telemetry_events:player_journey_popup_play_journey("hub", false)

						return mission_board_service:set_character_has_been_shown_skip_campaign_popup(account_id, character_id)
					end
				end)
			end
		end

		local party_immaterium = Managers.party_immaterium
		local session_in_progress = party_immaterium and party_immaterium:game_session_in_progress()

		if session_in_progress then
			local game_session_id = party_immaterium:current_game_session_id()

			if self._last_auto_joined_game_session_id ~= game_session_id then
				self._last_auto_joined_game_session_id = game_session_id

				self:_retry_join()
			elseif not self._retry_popup_id then
				self:_show_retry_popup()
			end

			return false
		end

		if self._refresh_vo_story_stage then
			local local_player_id = 1
			local player = Managers.player:local_player(local_player_id)

			if player and player:unit_is_alive() then
				PlayerVOStoryStage.refresh_hub_story_stage()

				self._refresh_vo_story_stage = false
			end
		end

		return false
	elseif state == "joining_party_game_session" then
		if self._joining_party_game_session:is_dead() then
			self:_set_state("in_hub")

			self._joining_party_game_session = nil
		end

		return false
	elseif state == "client_exit_gameplay" then
		local dialogue_system = Managers.state.extension:system_by_extension("DialogueExtension")

		if dialogue_system then
			dialogue_system:force_stop_all()
		end

		self:_set_state("client_wait_for_server")

		return false, StateLoading, {}
	elseif state == "client_wait_for_server" then
		return false
	end
end

MechanismHub._retry_join = function (self)
	if self._state == "in_hub" and Managers.party_immaterium:game_session_in_progress() then
		self._joining_party_game_session = Managers.party_immaterium:join_game_session()

		self:_set_state("joining_party_game_session")
	end
end

MechanismHub._show_retry_popup = function (self)
	local context = {
		description_text = "loc_popup_description_reconnect_to_session",
		title_text = "loc_popup_header_reconnect_to_session",
		options = {
			{
				close_on_pressed = true,
				text = "loc_popup_reconnect_to_session_reconnect_button",
				callback = function ()
					self._retry_popup_id = nil

					self:_retry_join()
				end,
			},
			{
				close_on_pressed = true,
				hotkey = "back",
				text = "loc_popup_reconnect_to_session_leave_button",
				callback = function ()
					self._retry_popup_id = nil

					Managers.party_immaterium:leave_party()
				end,
			},
		},
	}

	Managers.event:trigger("event_show_ui_popup", context, function (id)
		self._retry_popup_id = id
	end)
end

MechanismHub.is_allowed_to_reserve_slots = function (self, peer_ids)
	return true
end

MechanismHub.peers_reserved_slots = function (self, peer_ids)
	return
end

MechanismHub.peer_freed_slot = function (self, peer_id)
	return
end

MechanismHub.destroy = function (self)
	if self._is_syncing then
		self._network_event_delegate:unregister_channel_events(self._context.server_channel, "rpc_sync_mechanism_data_hub")
	end

	if self._client_data_promise and self._client_data_promise:is_pending() then
		self._client_data_promise:cancel()

		self._client_data_promise = nil
	end

	self._joining_party_game_session = nil

	if self._retry_popup_id then
		Managers.event:trigger("event_remove_ui_popup", self._retry_popup_id)

		self._retry_popup_id = nil
	end

	if self._campaign_skip_popup_id then
		Managers.event:trigger("event_remove_ui_popup", self._campaign_skip_popup_id)

		self._campaign_skip_popup_id = nil
	end
end

MechanismHub.rpc_sync_mechanism_data_hub = function (self, channel_id, circumstance_name_id)
	local circumstance_name = NetworkLookup.circumstance_templates[circumstance_name_id]
	local data = self._mechanism_data

	data.circumstance_name = circumstance_name

	self._network_event_delegate:unregister_channel_events(self._context.server_channel, "rpc_sync_mechanism_data_hub")

	self._is_syncing = false
	self._is_synced = true
end

MechanismHub._get_current_character_level = function (self)
	local local_player_id = 1
	local player_manager = Managers.player
	local player = player_manager and player_manager:local_player(local_player_id)
	local player_profile = player and player:profile()
	local character_level = player_profile and player_profile.character_level

	return character_level
end

implements(MechanismHub, MechanismBase.INTERFACE)

return MechanismHub
