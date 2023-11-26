-- chunkname: @scripts/multiplayer/session/session_remote_state_machine.lua

local StateMachine = require("scripts/foundation/utilities/state_machine")
local RemoteApproveSessionChannelState = require("scripts/multiplayer/session/remote_states/remote_approve_session_channel_state")
local RemoteInSessionState = require("scripts/multiplayer/session/remote_states/remote_in_session_state")
local RemoteLeaveSessionState = require("scripts/multiplayer/session/remote_states/remote_leave_session_state")
local RemoteWaitForGameObjectSyncState = require("scripts/multiplayer/session/remote_states/remote_wait_for_gameobject_sync_state")
local RemoteWaitForJoinState = require("scripts/multiplayer/session/remote_states/remote_wait_for_join_state")

local function _warning(...)
	Log.info("SessionRemoteStateMachine", ...)
end

local SessionRemoteStateMachine = class("SessionRemoteStateMachine")

SessionRemoteStateMachine.TIMEOUT = 30

SessionRemoteStateMachine.init = function (self, network_delegate, client_peer_id, engine_lobby, engine_gamesession, gameobject_callback_object)
	local shared_state = {
		has_been_in_session = false,
		peer_added_to_session = false,
		game_object_sync_done = false,
		peer_id = client_peer_id,
		engine_lobby = engine_lobby,
		engine_gamesession = engine_gamesession,
		gameobject_callback_object = gameobject_callback_object,
		network_delegate = network_delegate,
		timeout = SessionRemoteStateMachine.TIMEOUT,
		event_list = {}
	}

	self._shared_state = shared_state

	local parent
	local state_machine = StateMachine:new("SessionRemoteStateMachine", parent, shared_state)

	self._state_machine = state_machine

	state_machine:add_transition("RemoteApproveSessionChannelState", "approved", RemoteWaitForJoinState)
	state_machine:add_transition("RemoteApproveSessionChannelState", "timeout", RemoteLeaveSessionState)
	state_machine:add_transition("RemoteApproveSessionChannelState", "force_leave", RemoteLeaveSessionState)
	state_machine:add_transition("RemoteWaitForJoinState", "join_requested", RemoteWaitForGameObjectSyncState)
	state_machine:add_transition("RemoteWaitForJoinState", "timeout", RemoteLeaveSessionState)
	state_machine:add_transition("RemoteWaitForJoinState", "disconnect", RemoteLeaveSessionState)
	state_machine:add_transition("RemoteWaitForJoinState", "force_leave", RemoteLeaveSessionState)
	state_machine:add_transition("RemoteWaitForGameObjectSyncState", "synchronized", RemoteInSessionState)
	state_machine:add_transition("RemoteWaitForGameObjectSyncState", "timeout", RemoteLeaveSessionState)
	state_machine:add_transition("RemoteWaitForGameObjectSyncState", "disconnect", RemoteLeaveSessionState)
	state_machine:add_transition("RemoteWaitForGameObjectSyncState", "force_leave", RemoteLeaveSessionState)
	state_machine:add_transition("RemoteInSessionState", "disconnect", RemoteLeaveSessionState)
	state_machine:add_transition("RemoteInSessionState", "force_leave", RemoteLeaveSessionState)
	state_machine:add_transition("RemoteLeaveSessionState", "force_leave", StateMachine.IGNORE_EVENT)
	state_machine:set_initial_state(RemoteApproveSessionChannelState)

	self._known_peers = {}
end

SessionRemoteStateMachine.destroy = function (self)
	self:force_leave()
	self._state_machine:delete()

	self._state_machine = nil
end

SessionRemoteStateMachine.update = function (self, dt)
	self._state_machine:update(dt)
end

SessionRemoteStateMachine.approve_channel = function (self, channel_id)
	local state = self._state_machine:state()

	if state.__class_name == "RemoteApproveSessionChannelState" then
		self._shared_state.channel_id = channel_id

		local shared_state = self._shared_state

		shared_state.event_list[#shared_state.event_list + 1] = {
			name = "session_joining",
			parameters = {
				peer_id = shared_state.peer_id,
				channel_id = channel_id
			}
		}

		return true
	else
		_warning("SessionRemoteStateMachine was in state %s when the approve_channel callback arrived, so it is denied", state.__class_name)

		return false
	end
end

SessionRemoteStateMachine.channel_id = function (self)
	return self._shared_state.channel_id
end

SessionRemoteStateMachine.is_joined = function (self)
	return self._state_machine:state().__class_name == "RemoteInSessionState"
end

SessionRemoteStateMachine.peer_joined = function (self, peer_id)
	local old = self._known_peers[peer_id] or false

	self._known_peers[peer_id] = true

	return old
end

SessionRemoteStateMachine.peer_left = function (self, peer_id)
	local old = self._known_peers[peer_id] or false

	self._known_peers[peer_id] = nil

	return old
end

SessionRemoteStateMachine.next_event = function (self)
	local event_list = self._shared_state.event_list

	if table.is_empty(event_list) then
		return
	end

	local event = event_list[1]

	table.remove(event_list, 1)

	return event.name, event.parameters
end

SessionRemoteStateMachine.force_leave = function (self)
	self._state_machine:event("force_leave", {
		game_reason = "force_leave"
	})
	self._state_machine:update(0)
end

SessionRemoteStateMachine.game_object_sync_done = function (self)
	self._shared_state.game_object_sync_done = true
end

return SessionRemoteStateMachine
