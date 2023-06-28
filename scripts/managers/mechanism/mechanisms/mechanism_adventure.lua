local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local MechanismBase = require("scripts/managers/mechanism/mechanisms/mechanism_base")
local Missions = require("scripts/settings/mission/mission_templates")
local StateGameplay = require("scripts/game_states/game/state_gameplay")
local StateLoading = require("scripts/game_states/game/state_loading")
local HOST_TYPES = MatchmakingConstants.HOST_TYPES
local MechanismAdventure = class("MechanismAdventure", "MechanismBase")
local READY_FOR_SCORE_TIMEOUT = 400

MechanismAdventure.init = function (self, ...)
	MechanismAdventure.super.init(self, ...)

	self._pending_state_change = false
	local context = self._context

	if context.server_channel then
		self._is_owner = false
		self._is_syncing = true

		self._network_event_delegate:register_connection_channel_events(self, context.server_channel, "rpc_sync_mechanism_data_adventure")
	else
		self._is_owner = true
		self._is_owner_mission_server = Managers.connection:is_dedicated_mission_server()
		local mission_name = context.mission_name
		local challenge, resistance, circumstance_name, side_mission, backend_mission_id = nil
		local host_type = Managers.connection:host_type()

		if self._is_owner_mission_server then
			challenge = context.challenge
			resistance = context.resistance
			circumstance_name = context.circumstance_name
			side_mission = context.side_mission
			backend_mission_id = context.backend_mission_id

			Log.info("MechanismAdventure", "Using mission backend data for challenge(%s), resistance (%s), circumstance(%s), side_mission(%s)", challenge, resistance, circumstance_name, side_mission)
		else
			challenge = context.challenge or DevParameters.challenge
			resistance = context.resistance or DevParameters.resistance
			circumstance_name = context.circumstance_name or GameParameters.circumstance
			side_mission = context.side_mission or GameParameters.side_mission
			backend_mission_id = nil

			Log.info("MechanismAdventure", "Using context or dev parameters for challenge(%s), resistance (%s), circumstance(%s), side_mission(%s)", challenge, resistance, circumstance_name, side_mission)
		end

		local data = self._mechanism_data
		data.mission_name = mission_name
		data.circumstance_name = circumstance_name
		data.side_mission = side_mission
		data.level_name = Missions[mission_name].level
		data.end_result = nil
		data.ready_for_transition = false
		data.level_load_initiated = false
		data.victory_defeat_done = false
		data.game_score_done = false
		data.challenge = challenge
		data.resistance = resistance
		data.mission_giver_vo_override = context.mission_giver_vo_override or "none"
		data.backend_mission_id = backend_mission_id
		data.ready_voting_completed = false
		data.pacing_control = context.pacing_control
		local do_vote = self._is_owner_mission_server

		if do_vote then
			local voting_params = {
				mission_data = data
			}

			Managers.voting:start_voting("mission_lobby_ready", voting_params):next(function (voting_id)
				self._mission_ready_voting_id = voting_id
			end):catch(function (error)
				Log.error("MechanismAdventure", "Failed start voting 'mission_lobby_ready', skipping voting. Error: %s", table.tostring(error, 3))
				self:_on_vote_finished()

				data.ready_for_transition = true
			end)
		end
	end
end

MechanismAdventure.destroy = function (self)
	if self._is_syncing then
		self._network_event_delegate:unregister_channel_events(self._context.server_channel, "rpc_sync_mechanism_data_adventure")
	end
end

MechanismAdventure.sync_data = function (self, channel_id)
	local data = self._mechanism_data

	RPC.rpc_sync_mechanism_data_adventure(channel_id, NetworkLookup.missions[data.mission_name], NetworkLookup.circumstance_templates[data.circumstance_name], NetworkLookup.mission_objective_names[data.side_mission], self._state_index, NetworkLookup.game_mode_outcomes[data.end_result or "n/a"], data.ready_for_transition, data.victory_defeat_done, data.game_score_done, self._is_owner_mission_server, data.challenge, data.resistance, NetworkLookup.mission_giver_vo_overrides[data.mission_giver_vo_override], data.backend_mission_id, data.ready_voting_completed)
end

MechanismAdventure.rpc_sync_mechanism_data_adventure = function (self, channel_id, mission_name_id, circumstance_name_id, side_mission_id, state_index, end_result_id, ready_for_transition, victory_defeat_done, game_score_done, is_owner_mission_server, challenge, resistance, mission_giver_vo_override_id, backend_mission_id, ready_voting_completed)
	local mission_name = NetworkLookup.missions[mission_name_id]
	local circumstance_name = NetworkLookup.circumstance_templates[circumstance_name_id]
	local side_mission = NetworkLookup.mission_objective_names[side_mission_id]
	local mission_giver_vo_override = NetworkLookup.mission_giver_vo_overrides[mission_giver_vo_override_id]
	self._state_index = state_index
	self._state = self._states_lookup[state_index]
	local end_result = NetworkLookup.game_mode_outcomes[end_result_id]

	if end_result == "n/a" then
		end_result = nil
	end

	local data = self._mechanism_data
	data.level_name = Missions[mission_name].level
	data.mission_name = mission_name
	data.circumstance_name = circumstance_name
	data.side_mission = side_mission
	data.end_result = end_result
	data.ready_for_transition = ready_for_transition
	data.victory_defeat_done = victory_defeat_done
	data.game_score_done = game_score_done
	data.challenge = challenge
	data.resistance = resistance
	data.mission_giver_vo_override = mission_giver_vo_override
	data.backend_mission_id = backend_mission_id
	data.ready_voting_completed = ready_voting_completed

	self._network_event_delegate:unregister_channel_events(self._context.server_channel, "rpc_sync_mechanism_data_adventure")

	self._is_syncing = false
	self._is_owner_mission_server = is_owner_mission_server
	self._pending_state_change = true

	if ready_voting_completed then
		Managers.party_immaterium:ready_voting_completed()
	end
end

MechanismAdventure.all_players_ready = function (self)
	self._mechanism_data.ready_for_transition = true
end

MechanismAdventure.victory_defeat_done = function (self)
	self._mechanism_data.victory_defeat_done = true
end

MechanismAdventure.game_score_done = function (self)
	self._mechanism_data.game_score_done = true
end

MechanismAdventure.game_mode_end = function (self, reason, session_id)
	self._mechanism_data.end_result = reason
	self._mechanism_data.session_id = session_id

	if self._is_owner then
		self._peers_ready_for_score = {}
		self._peers_ready_for_score_timeout = Managers.time:time("main") + READY_FOR_SCORE_TIMEOUT
		local peer_ids = {}

		for channel_id, _ in pairs(Managers.mechanism:clients()) do
			peer_ids[#peer_ids + 1] = Network.peer_id(channel_id)
		end

		Log.info("MechanismAdventure", "Mechanism host is waiting for peers to get ready for state 'score': %s", table.tostring(peer_ids))
	end
end

MechanismAdventure.client_exit_gameplay = function (self)
	self:_set_state("client_exit_gameplay")
end

MechanismAdventure.failed_fetching_session_report = function (self, peer_id)
	Log.info("MechanismAdventure", "Peer %s failed fetching session report", peer_id)
end

MechanismAdventure.profile_changes_are_allowed = function (self)
	if self._mission_ready_voting_id then
		return true
	else
		return false
	end
end

local not_ready_peers = {}

MechanismAdventure._on_vote_finished = function (self)
	Managers.mechanism:trigger_event("all_players_ready")

	self._mission_ready_voting_id = nil
	self._mechanism_data.ready_voting_completed = true
end

MechanismAdventure._check_state_change = function (self, state, data)
	local changed, done = nil

	if state == "adventure_selected" then
		if self._mission_ready_voting_id then
			local finished, result, abort_reason = Managers.voting:voting_result(self._mission_ready_voting_id)

			if finished then
				self:_on_vote_finished()
			end
		end

		if data.ready_for_transition then
			self:_set_state("adventure")

			changed = true
			done = false
		end
	elseif state == "adventure" then
		if data.end_result then
			self:_set_state("score")

			changed = true
			done = false

			if GameParameters.enable_stay_in_party_feature and self._is_owner and self._is_owner_mission_server then
				Managers.grpc:create_empty_party(Managers.connection.combined_hash):next(function (response)
					Log.info("MechanismAdventure", "response:%s", table.tostring(response))

					return Managers.voting:start_voting("stay_in_party", {
						new_party_id = response.party_id,
						new_party_invite_token = response.invite_token
					}):next(function (voting_id)
						Log.info("MechanismAdventure", "stay_in_party_voting_id:%s", voting_id)

						self._stay_in_party_voting_id = voting_id
					end)
				end)
			end
		end
	elseif state == "score" then
		if data.game_score_done then
			self:_set_state("mission_server_exit")

			changed = true
			done = false

			if GameParameters.enable_stay_in_party_feature and self._is_owner and self._is_owner_mission_server then
				local stay_in_party_voting_id = self._stay_in_party_voting_id

				if stay_in_party_voting_id and Managers.voting:voting_exists(stay_in_party_voting_id) then
					Managers.voting:complete_vote(stay_in_party_voting_id)
				end
			end
		end
	elseif state == "mission_server_exit" then
		changed = false
		done = false
	elseif state == "client_exit_gameplay" then
		changed = true
		done = false
	end

	return self._state, changed, done
end

MechanismAdventure.wanted_transition = function (self)
	if self._is_syncing then
		return false
	end

	local data = self._mechanism_data
	local state = self._state
	local state_change = self._pending_state_change
	local done = nil
	local needs_load = false

	if state_change then
		self._pending_state_change = false
		needs_load = true
	else
		state, state_change, done = self:_check_state_change(state, data)
	end

	if done then
		return true
	elseif state_change then
		if state == "adventure_selected" then
			local next_state_context = {
				level = data.level_name,
				mission_name = data.mission_name,
				circumstance_name = data.circumstance_name,
				mission_giver_vo = data.mission_giver_vo_override,
				side_mission = data.side_mission
			}

			return false, StateLoading, next_state_context
		elseif state == "adventure" then
			local next_state_context = {
				level = data.level_name,
				mission_name = data.mission_name,
				circumstance_name = data.circumstance_name,
				mission_giver_vo = data.mission_giver_vo_override,
				side_mission = data.side_mission,
				next_state = StateGameplay,
				next_state_params = {
					mechanism_data = self._mechanism_data
				}
			}

			return false, StateLoading, next_state_context
		elseif state == "client_exit_gameplay" then
			self:_set_state("client_wait_for_server")

			return false, StateLoading, {}
		elseif needs_load then
			local next_state_context = {
				next_state = self._game_states[state],
				next_state_params = {
					mission_name = data.mission_name,
					mechanism_data = self._mechanism_data
				}
			}

			return false, StateLoading, next_state_context
		else
			local next_state_context = {
				mission_name = data.mission_name,
				mechanism_data = self._mechanism_data
			}

			return false, self._game_states[state], next_state_context
		end
	elseif state == "client_wait_for_server" then
		return false
	else
		return false
	end
end

MechanismAdventure.game_score_end_time = function (self, end_time)
	if self._is_owner then
		return
	end

	Managers.progression:set_game_score_end_time(end_time)
	Log.info("MechanismAdventure", "set_game_score_end_time: %s", end_time)
end

MechanismAdventure.is_allowed_to_reserve_slots = function (self, peer_ids)
	return true
end

MechanismAdventure.peers_reserved_slots = function (self, peer_ids)
	return
end

MechanismAdventure.peer_freed_slot = function (self, peer_id)
	return
end

implements(MechanismAdventure, MechanismBase.INTERFACE)

return MechanismAdventure
