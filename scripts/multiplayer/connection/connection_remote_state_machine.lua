local RemoteConnectedState = require("scripts/multiplayer/connection/remote_states/remote_connected_state")
local RemoteDataSyncState = require("scripts/multiplayer/connection/remote_states/remote_data_sync_state")
local RemoteDisconnectedState = require("scripts/multiplayer/connection/remote_states/remote_disconnected_state")
local RemoteEacCheckState = require("scripts/multiplayer/connection/remote_states/remote_eac_check_state")
local RemoteMasterItemsCheckState = require("scripts/multiplayer/connection/remote_states/remote_master_items_check_state")
local RemoteMechanismVerificationState = require("scripts/multiplayer/connection/remote_states/remote_mechanism_verification_state")
local RemotePlayersSyncState = require("scripts/multiplayer/connection/remote_states/remote_players_sync_state")
local RemoteProfilesSyncState = require("scripts/multiplayer/connection/remote_states/remote_profiles_sync_state")
local RemoteRequestHostTypeState = require("scripts/multiplayer/connection/remote_states/remote_request_host_type_state")
local RemoteSlotClaimState = require("scripts/multiplayer/connection/remote_states/remote_slot_claim_state")
local RemoteSlotReserveState = require("scripts/multiplayer/connection/remote_states/remote_slot_reserve_state")
local RemoteStateSyncState = require("scripts/multiplayer/connection/remote_states/remote_state_sync_state")
local RemoteVersionCheckState = require("scripts/multiplayer/connection/remote_states/remote_version_check_state")
local SlotReserver = require("scripts/multiplayer/connection/slot_reserver")
local StateMachine = require("scripts/foundation/utilities/state_machine")
local ConnectionRemoteStateMachine = class("ConnectionRemoteStateMachine")
ConnectionRemoteStateMachine.TIMEOUT = 15
ConnectionRemoteStateMachine.RESERVE_TIMEOUT = 300

ConnectionRemoteStateMachine.init = function (self, event_delegate, engine_lobby, channel_id, network_hash, slot_reserver, optional_eac_server, is_dedicated_server, host_type, profile_synchronizer_host, max_members, session_seed)
	assert_interface(slot_reserver, SlotReserver)

	self._peer_id = Network.peer_id(channel_id)
	local parent = nil
	local shared_state = {
		is_state_synced = false,
		eac_client_added = false,
		client_entered_connected_state = false,
		event_delegate = event_delegate,
		engine_lobby = engine_lobby,
		channel_id = channel_id,
		peer_id = self._peer_id,
		timeout = ConnectionRemoteStateMachine.TIMEOUT,
		reserve_timeout = ConnectionRemoteStateMachine.RESERVE_TIMEOUT,
		network_hash = network_hash,
		slot_reserver = slot_reserver,
		eac_server = optional_eac_server,
		is_dedicated_server = is_dedicated_server,
		host_type = host_type,
		profile_synchronizer_host = profile_synchronizer_host,
		max_members = max_members,
		session_seed = session_seed,
		player_sync_data = {},
		event_list = {
			{
				name = "connecting",
				parameters = {
					peer_id = self._peer_id,
					channel_id = channel_id
				}
			}
		}
	}

	Log.info("ConnectionRemoteStateMachine", "[init] LoadingTimes: Peer Connection Started", self._peer_id)

	self._shared_state = shared_state
	local state_machine = StateMachine:new("ConnectionRemoteStateMachine", parent, shared_state)
	self._state_machine = state_machine

	state_machine:add_transition("RemoteVersionCheckState", "versions matched", RemoteMasterItemsCheckState)
	state_machine:add_transition("RemoteVersionCheckState", "versions mismatched", RemoteDisconnectedState)
	state_machine:add_transition("RemoteVersionCheckState", "timeout", RemoteDisconnectedState)
	state_machine:add_transition("RemoteVersionCheckState", "disconnected", RemoteDisconnectedState)
	state_machine:add_transition("RemoteMasterItemsCheckState", "version replied", RemoteRequestHostTypeState)
	state_machine:add_transition("RemoteMasterItemsCheckState", "timeout", RemoteDisconnectedState)
	state_machine:add_transition("RemoteMasterItemsCheckState", "disconnected", RemoteDisconnectedState)
	state_machine:add_transition("RemoteRequestHostTypeState", "host type replied", RemoteMechanismVerificationState)
	state_machine:add_transition("RemoteRequestHostTypeState", "timeout", RemoteDisconnectedState)
	state_machine:add_transition("RemoteRequestHostTypeState", "disconnected", RemoteDisconnectedState)
	state_machine:add_transition("RemoteMechanismVerificationState", "mechanism matched", RemoteSlotReserveState)
	state_machine:add_transition("RemoteMechanismVerificationState", "mechanism mismatched", RemoteDisconnectedState)
	state_machine:add_transition("RemoteMechanismVerificationState", "timeout", RemoteDisconnectedState)
	state_machine:add_transition("RemoteMechanismVerificationState", "disconnected", RemoteDisconnectedState)
	state_machine:add_transition("RemoteSlotReserveState", "reserved", RemoteSlotClaimState)
	state_machine:add_transition("RemoteSlotReserveState", "claimed", RemotePlayersSyncState)
	state_machine:add_transition("RemoteSlotReserveState", "rejected", RemoteDisconnectedState)
	state_machine:add_transition("RemoteSlotReserveState", "timeout", RemoteDisconnectedState)
	state_machine:add_transition("RemoteSlotReserveState", "disconnected", RemoteDisconnectedState)
	state_machine:add_transition("RemoteSlotClaimState", "claimed", RemotePlayersSyncState)
	state_machine:add_transition("RemoteSlotClaimState", "rejected", RemoteDisconnectedState)
	state_machine:add_transition("RemoteSlotClaimState", "timeout", RemoteDisconnectedState)
	state_machine:add_transition("RemoteSlotClaimState", "disconnected", RemoteDisconnectedState)
	state_machine:add_transition("RemotePlayersSyncState", "players synced", RemoteEacCheckState)
	state_machine:add_transition("RemotePlayersSyncState", "timeout", RemoteDisconnectedState)
	state_machine:add_transition("RemotePlayersSyncState", "disconnected", RemoteDisconnectedState)
	state_machine:add_transition("RemoteEacCheckState", "eac approved", RemoteProfilesSyncState)
	state_machine:add_transition("RemoteEacCheckState", "eac mismatch", RemoteDisconnectedState)
	state_machine:add_transition("RemoteEacCheckState", "timeout", RemoteDisconnectedState)
	state_machine:add_transition("RemoteEacCheckState", "disconnected", RemoteDisconnectedState)
	state_machine:add_transition("RemoteProfilesSyncState", "profiles synced", RemoteDataSyncState)
	state_machine:add_transition("RemoteProfilesSyncState", "timeout", RemoteDisconnectedState)
	state_machine:add_transition("RemoteProfilesSyncState", "disconnected", RemoteDisconnectedState)
	state_machine:add_transition("RemoteDataSyncState", "data synced", RemoteStateSyncState)
	state_machine:add_transition("RemoteDataSyncState", "timeout", RemoteDisconnectedState)
	state_machine:add_transition("RemoteDataSyncState", "disconnected", RemoteDisconnectedState)
	state_machine:add_transition("RemoteStateSyncState", "state sync done", RemoteConnectedState)
	state_machine:add_transition("RemoteStateSyncState", "disconnected", RemoteDisconnectedState)
	state_machine:add_transition("RemoteConnectedState", "eac mismatch", RemoteDisconnectedState)
	state_machine:add_transition("RemoteConnectedState", "disconnected", RemoteDisconnectedState)
	state_machine:add_transition("RemoteDisconnectedState", "disconnected", StateMachine.IGNORE_EVENT)
	state_machine:set_initial_state(RemoteVersionCheckState)

	self._known_peers = {}
end

ConnectionRemoteStateMachine.destroy = function (self)
	self:disconnect()
	self._state_machine:update(0)
	self._state_machine:delete()

	self._state_machine = nil
end

ConnectionRemoteStateMachine.update = function (self, dt)
	self._state_machine:update(dt)
end

ConnectionRemoteStateMachine.is_connected = function (self)
	local state_name = self._state_machine:state().__class_name

	return state_name == "RemoteConnectedState"
end

ConnectionRemoteStateMachine.is_disconnected = function (self)
	local state_name = self._state_machine:state().__class_name

	return state_name == "RemoteDisconnectedState"
end

ConnectionRemoteStateMachine.is_connecting = function (self)
	return not self:is_connected() and not self:is_disconnected()
end

ConnectionRemoteStateMachine.client_entered_connected_state = function (self)
	local shared_state = self._shared_state

	return shared_state.client_entered_connected_state
end

ConnectionRemoteStateMachine.connection_notification_parameters = function (self)
	local shared_state = self._shared_state

	return {
		peer_id = shared_state.peer_id,
		channel_id = shared_state.channel_id,
		player_sync_data = shared_state.player_sync_data
	}
end

ConnectionRemoteStateMachine.peer_joined = function (self, peer_id)
	local old = self._known_peers[peer_id] or false
	self._known_peers[peer_id] = true

	return old
end

ConnectionRemoteStateMachine.peer_left = function (self, peer_id)
	local old = self._known_peers[peer_id] or false
	self._known_peers[peer_id] = nil

	return old
end

ConnectionRemoteStateMachine.peer_id = function (self)
	return self._peer_id
end

ConnectionRemoteStateMachine.disconnect = function (self, optional_game_reason)
	self._state_machine:event("disconnected", {
		game_reason = optional_game_reason or "game_request"
	})
end

ConnectionRemoteStateMachine.next_event = function (self)
	local event_list = self._shared_state.event_list

	if table.is_empty(event_list) then
		return nil
	end

	local event = event_list[1]

	if type(event) == "function" then
		event = event()
	end

	table.remove(event_list, 1)

	return event.name, event.parameters
end

return ConnectionRemoteStateMachine
