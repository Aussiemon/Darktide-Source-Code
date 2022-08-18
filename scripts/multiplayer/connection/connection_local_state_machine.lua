local LocalAwaitHostConnectState = require("scripts/multiplayer/connection/local_states/local_await_host_connect_state")
local LocalConnectChannelState = require("scripts/multiplayer/connection/local_states/local_connect_channel_state")
local LocalConnectedState = require("scripts/multiplayer/connection/local_states/local_connected_state")
local LocalDataSyncState = require("scripts/multiplayer/connection/local_states/local_data_sync_state")
local LocalDisconnectedState = require("scripts/multiplayer/connection/local_states/local_disconnected_state")
local LocalEacCheckState = require("scripts/multiplayer/connection/local_states/local_eac_check_state")
local LocalMasterItemsCheckState = require("scripts/multiplayer/connection/local_states/local_master_items_check_state")
local LocalMechanismVerificationState = require("scripts/multiplayer/connection/local_states/local_mechanism_verification_state")
local LocalPlayersSyncState = require("scripts/multiplayer/connection/local_states/local_players_sync_state")
local LocalProfilesSyncState = require("scripts/multiplayer/connection/local_states/local_profiles_sync_state")
local LocalRequestHostTypeState = require("scripts/multiplayer/connection/local_states/local_request_host_type_state")
local LocalSlotClaimState = require("scripts/multiplayer/connection/local_states/local_slot_claim_state")
local LocalSlotReserveState = require("scripts/multiplayer/connection/local_states/local_slot_reserve_state")
local LocalVersionCheckState = require("scripts/multiplayer/connection/local_states/local_version_check_state")
local LocalWaitForClaimState = require("scripts/multiplayer/connection/local_states/local_wait_for_claim_state")
local StateMachine = require("scripts/foundation/utilities/state_machine")
local ConnectionLocalStateMachine = class("ConnectionLocalStateMachine")
ConnectionLocalStateMachine.TIMEOUT = 15
ConnectionLocalStateMachine.RESERVE_TIMEOUT = 300

ConnectionLocalStateMachine.init = function (self, event_delegate, engine_lobby, host_peer_id, network_hash, host_type, profile_synchronizer_client, slots_to_reserve, jwt_ticket)
	local parent = nil
	local shared_state = {
		has_reserved = false,
		event_delegate = event_delegate,
		engine_lobby = engine_lobby,
		host_peer_id = host_peer_id,
		timeout = ConnectionLocalStateMachine.TIMEOUT,
		reserve_timeout = ConnectionLocalStateMachine.RESERVE_TIMEOUT,
		network_hash = network_hash,
		host_type = host_type,
		slots_to_reserve = slots_to_reserve,
		profile_synchronizer_client = profile_synchronizer_client,
		jwt_ticket = jwt_ticket,
		ready_to_claim_slots = slots_to_reserve == nil,
		event_list = {}
	}
	self._shared_state = shared_state
	local state_machine = StateMachine:new("ConnectionLocalStateMachine", parent, shared_state)
	self._state_machine = state_machine

	state_machine:add_transition("LocalConnectChannelState", "channel connected", LocalVersionCheckState)
	state_machine:add_transition("LocalConnectChannelState", "disconnected", LocalDisconnectedState)
	state_machine:add_transition("LocalVersionCheckState", "versions matched", LocalMasterItemsCheckState)
	state_machine:add_transition("LocalVersionCheckState", "versions mismatched", LocalDisconnectedState)
	state_machine:add_transition("LocalVersionCheckState", "timeout", LocalDisconnectedState)
	state_machine:add_transition("LocalVersionCheckState", "disconnected", LocalDisconnectedState)
	state_machine:add_transition("LocalMasterItemsCheckState", "items ready", LocalRequestHostTypeState)
	state_machine:add_transition("LocalMasterItemsCheckState", "update failed", LocalDisconnectedState)
	state_machine:add_transition("LocalMasterItemsCheckState", "timeout", LocalDisconnectedState)
	state_machine:add_transition("LocalMasterItemsCheckState", "disconnected", LocalDisconnectedState)
	state_machine:add_transition("LocalRequestHostTypeState", "host type reply", LocalMechanismVerificationState)
	state_machine:add_transition("LocalRequestHostTypeState", "timeout", LocalDisconnectedState)
	state_machine:add_transition("LocalRequestHostTypeState", "disconnected", LocalDisconnectedState)
	state_machine:add_transition("LocalMechanismVerificationState", "mechanism matched", (slots_to_reserve and LocalSlotReserveState) or LocalSlotClaimState)
	state_machine:add_transition("LocalMechanismVerificationState", "mechanism mismatched", LocalDisconnectedState)
	state_machine:add_transition("LocalMechanismVerificationState", "timeout", LocalDisconnectedState)
	state_machine:add_transition("LocalMechanismVerificationState", "disconnected", LocalDisconnectedState)
	state_machine:add_transition("LocalSlotReserveState", "slots allocated", LocalWaitForClaimState)
	state_machine:add_transition("LocalSlotReserveState", "slots rejected", LocalDisconnectedState)
	state_machine:add_transition("LocalSlotReserveState", "timeout", LocalDisconnectedState)
	state_machine:add_transition("LocalSlotReserveState", "disconnected", LocalDisconnectedState)
	state_machine:add_transition("LocalWaitForClaimState", "ready to claim", LocalSlotClaimState)
	state_machine:add_transition("LocalWaitForClaimState", "timeout", LocalDisconnectedState)
	state_machine:add_transition("LocalWaitForClaimState", "disconnected", LocalDisconnectedState)
	state_machine:add_transition("LocalSlotClaimState", "slot claimed", LocalPlayersSyncState)
	state_machine:add_transition("LocalSlotClaimState", "slot rejected", LocalDisconnectedState)
	state_machine:add_transition("LocalSlotClaimState", "timeout", LocalDisconnectedState)
	state_machine:add_transition("LocalSlotClaimState", "disconnected", LocalDisconnectedState)
	state_machine:add_transition("LocalPlayersSyncState", "players synced", LocalEacCheckState)
	state_machine:add_transition("LocalPlayersSyncState", "timeout", LocalDisconnectedState)
	state_machine:add_transition("LocalPlayersSyncState", "disconnected", LocalDisconnectedState)
	state_machine:add_transition("LocalEacCheckState", "eac approved", LocalProfilesSyncState)
	state_machine:add_transition("LocalEacCheckState", "eac mismatch", LocalDisconnectedState)
	state_machine:add_transition("LocalEacCheckState", "timeout", LocalDisconnectedState)
	state_machine:add_transition("LocalEacCheckState", "disconnected", LocalDisconnectedState)
	state_machine:add_transition("LocalProfilesSyncState", "profiles synced", LocalDataSyncState)
	state_machine:add_transition("LocalProfilesSyncState", "timeout", LocalDisconnectedState)
	state_machine:add_transition("LocalProfilesSyncState", "disconnected", LocalDisconnectedState)
	state_machine:add_transition("LocalDataSyncState", "data synced", LocalAwaitHostConnectState)
	state_machine:add_transition("LocalDataSyncState", "timeout", LocalDisconnectedState)
	state_machine:add_transition("LocalDataSyncState", "disconnected", LocalDisconnectedState)
	state_machine:add_transition("LocalAwaitHostConnectState", "connected", LocalConnectedState)
	state_machine:add_transition("LocalAwaitHostConnectState", "timeout", LocalDisconnectedState)
	state_machine:add_transition("LocalAwaitHostConnectState", "disconnected", LocalDisconnectedState)
	state_machine:add_transition("LocalConnectedState", "eac mismatch", LocalDisconnectedState)
	state_machine:add_transition("LocalConnectedState", "disconnected", LocalDisconnectedState)
	state_machine:add_transition("LocalDisconnectedState", "disconnected", StateMachine.IGNORE_EVENT)
	state_machine:set_initial_state(LocalConnectChannelState)
end

ConnectionLocalStateMachine.destroy = function (self)
	self:disconnect()
	self._state_machine:update(0)
	self._state_machine:delete()

	self._state_machine = nil
end

ConnectionLocalStateMachine.update = function (self, dt)
	self._state_machine:update(dt)
end

ConnectionLocalStateMachine.disconnect = function (self, optional_game_reason)
	self._state_machine:event("disconnected", {
		game_reason = optional_game_reason or "game_request"
	})
end

ConnectionLocalStateMachine.channel_id = function (self)
	return self._shared_state.channel_id
end

ConnectionLocalStateMachine.host_is_dedicated_server = function (self)
	return self._shared_state.is_dedicated
end

ConnectionLocalStateMachine.max_members = function (self)
	return self._shared_state.max_members
end

ConnectionLocalStateMachine.session_seed = function (self)
	return self._shared_state.session_seed
end

ConnectionLocalStateMachine.has_disconnected = function (self)
	return self._state_machine:state().__class_name == "LocalDisconnectedState"
end

ConnectionLocalStateMachine.has_reserved = function (self)
	return self._shared_state.has_reserved
end

ConnectionLocalStateMachine.ready_to_join = function (self)
	self._shared_state.ready_to_claim_slots = true
end

ConnectionLocalStateMachine.next_event = function (self)
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

return ConnectionLocalStateMachine
