local MechanismBase = require("scripts/managers/mechanism/mechanisms/mechanism_base")
local Missions = require("scripts/settings/mission/mission_templates")
local PlayerVOStoryStage = require("scripts/utilities/player_vo_story_stage")
local Promise = require("scripts/foundation/utilities/promise")
local StateGameplay = require("scripts/game_states/game/state_gameplay")
local StateLoading = require("scripts/game_states/game/state_loading")
local MechanismHub = class("MechanismHub", "MechanismBase")

MechanismHub.init = function (self, ...)
	MechanismHub.super.init(self, ...)

	local mission_name = "hub_ship"
	self._hub_mission_name = mission_name
	self._hub_level_name = Missions[mission_name].level
	self._hub_circumstance_name = "default"
	self._hub_config_request = false
	self._fetching_client_data = false
	self._refresh_vo_story_stage = not DEDICATED_SERVER
	self._last_auto_joined_game_session_id = nil
end

MechanismHub.sync_data = function (self)
	return
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
	local promises = {}

	if Managers.narrative then
		promises[#promises + 1] = Managers.narrative:_get_missions()
	end

	Managers.data_service.store:invalidate_wallets_cache()

	return Promise.all(unpack(promises))
end

MechanismHub.wanted_transition = function (self)
	local state = self._state

	if state == "init" then
		if DEDICATED_SERVER then
			self:_set_state("request_hub_config")

			return false, StateLoading, {}
		end

		if not self._fetching_client_data then
			if Managers.backend:authenticated() then
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
		if not DEDICATED_SERVER or GameParameters.circumstance and GameParameters.circumstance ~= "default" then
			self._hub_circumstance_name = GameParameters.circumstance

			self:_set_state("init_hub")

			return false
		end

		if not self._hub_config_request then
			if Managers.backend:authenticated() then
				Managers.backend.interfaces.hub_session:get_hub_config():next(function (config)
					Log.info("MechanismHub", "Loaded circumstance_name %s", config.circumstanceName)

					self._hub_circumstance_name = config.circumstanceName

					self:_set_state("init_hub")
				end):catch(function (error)
					Log.error("MechanismHub", "Could not load hub_config from backend, falling back to default circumstance_name, error=%s", table.tostring(error, 3))

					self._hub_circumstance_name = "default"

					self:_set_state("init_hub")
				end)
			else
				Log.error("MechanismHub", "Could not load hub_config from backend, not authenticated, falling back to default circumstance_name")

				self._hub_circumstance_name = "default"

				self:_set_state("init_hub")
			end

			self._hub_config_request = true
		end

		return false
	elseif state == "init_hub" then
		self:_set_state("in_hub")

		local challenge = DevParameters.challenge
		local resistance = DevParameters.resistance
		local side_mission = GameParameters.side_mission

		Log.info("MechanismHub", "Using dev parameters for challenge and resistance (%s/%s)", challenge, resistance)

		local mechanism_data = {
			challenge = challenge,
			resistance = resistance,
			circumstance_name = self._hub_circumstance_name,
			side_mission = side_mission
		}

		return false, StateLoading, {
			level = self._hub_level_name,
			mission_name = self._hub_mission_name,
			circumstance_name = self._hub_circumstance_name,
			side_mission = side_mission,
			next_state = StateGameplay,
			next_state_params = {
				mechanism_data = mechanism_data
			}
		}
	elseif state == "in_hub" then
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
		local dialogue_system = Managers.state.extension:system_by_extension("DialogueActorExtension")

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
		title_text = "loc_popup_header_reconnect_to_session",
		description_text = "loc_popup_description_reconnect_to_session",
		options = {
			{
				text = "loc_popup_reconnect_to_session_reconnect_button",
				close_on_pressed = true,
				callback = function ()
					self._retry_popup_id = nil

					self:_retry_join()
				end
			},
			{
				text = "loc_popup_reconnect_to_session_leave_button",
				close_on_pressed = true,
				hotkey = "back",
				callback = function ()
					self._retry_popup_id = nil

					Managers.party_immaterium:leave_party()
				end
			}
		}
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
	if self._client_data_promise and self._client_data_promise:is_pending() then
		self._client_data_promise:cancel()

		self._client_data_promise = nil
	end

	self._joining_party_game_session = nil

	if self._retry_popup_id then
		Managers.event:trigger("event_remove_ui_popup", self._retry_popup_id)

		self._retry_popup_id = nil
	end
end

implements(MechanismHub, MechanismBase.INTERFACE)

return MechanismHub
