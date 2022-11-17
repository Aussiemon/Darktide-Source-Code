local LocalConnectSessionChannelState = require("scripts/multiplayer/session/local_states/local_connect_session_channel_state")
local LocalInSessionState = require("scripts/multiplayer/session/local_states/local_in_session_state")
local LocalLeftSessionState = require("scripts/multiplayer/session/local_states/local_left_session_state")
local LocalRequestJoinSessionState = require("scripts/multiplayer/session/local_states/local_request_join_session_state")
local LocalWaitForGameObjectSyncState = require("scripts/multiplayer/session/local_states/local_wait_for_gameobject_sync_state")
local LocalWaitForSessionHostState = require("scripts/multiplayer/session/local_states/local_wait_for_session_host_state")
local StateMachine = require("scripts/foundation/utilities/state_machine")
local SessionLocalStateMachine = class("SessionLocalStateMachine")
SessionLocalStateMachine.TIMEOUT = 15

SessionLocalStateMachine.init = function (self, network_delegate, engine_lobby, engine_gamesession, gameobject_callback_object, clock_handler_client)
	local shared_state = {
		has_joined_session = false,
		engine_lobby = engine_lobby,
		engine_gamesession = engine_gamesession,
		network_delegate = network_delegate,
		timeout = SessionLocalStateMachine.TIMEOUT,
		gameobject_callback_object = gameobject_callback_object,
		clock_handler_client = clock_handler_client,
		event_list = {}
	}
	self._shared_state = shared_state
	local parent = nil
	local state_machine = StateMachine:new("SessionLocalStateMachine", parent, shared_state)
	self._state_machine = state_machine

	state_machine:add_transition("LocalWaitForSessionHostState", "game_session_host_set", LocalConnectSessionChannelState)
	state_machine:add_transition("LocalWaitForSessionHostState", "timeout", LocalLeftSessionState)
	state_machine:add_transition("LocalWaitForSessionHostState", "leave", LocalLeftSessionState)
	state_machine:add_transition("LocalConnectSessionChannelState", "approved", LocalRequestJoinSessionState)
	state_machine:add_transition("LocalConnectSessionChannelState", "denied", LocalLeftSessionState)
	state_machine:add_transition("LocalConnectSessionChannelState", "leave", LocalLeftSessionState)
	state_machine:add_transition("LocalRequestJoinSessionState", "in_session", LocalWaitForGameObjectSyncState)
	state_machine:add_transition("LocalRequestJoinSessionState", "timeout", LocalLeftSessionState)
	state_machine:add_transition("LocalRequestJoinSessionState", "leave", LocalLeftSessionState)
	state_machine:add_transition("LocalRequestJoinSessionState", "lost_session", LocalLeftSessionState)
	state_machine:add_transition("LocalWaitForGameObjectSyncState", "synchronized", LocalInSessionState)
	state_machine:add_transition("LocalWaitForGameObjectSyncState", "timeout", LocalLeftSessionState)
	state_machine:add_transition("LocalWaitForGameObjectSyncState", "leave", LocalLeftSessionState)
	state_machine:add_transition("LocalWaitForGameObjectSyncState", "lost_session", LocalLeftSessionState)
	state_machine:add_transition("LocalInSessionState", "leave", LocalLeftSessionState)
	state_machine:add_transition("LocalInSessionState", "lost_session", LocalLeftSessionState)
	state_machine:add_transition("LocalLeftSessionState", "leave", StateMachine.IGNORE_EVENT)
	state_machine:set_initial_state(LocalWaitForSessionHostState)
end

SessionLocalStateMachine.destroy = function (self)
	self:leave()
	self._state_machine:delete()

	self._state_machine = nil
end

SessionLocalStateMachine.update = function (self, dt)
	self._state_machine:update(dt)
end

SessionLocalStateMachine.host = function (self)
	return self._shared_state.peer_id
end

SessionLocalStateMachine.host_channel = function (self)
	return self._shared_state.channel_id
end

SessionLocalStateMachine.next_event = function (self)
	local event_list = self._shared_state.event_list

	if table.is_empty(event_list) then
		return
	end

	local event = event_list[1]

	table.remove(event_list, 1)

	return event.name, event.parameters
end

SessionLocalStateMachine.leave = function (self)
	while self._state_machine:state().__class_name ~= "LocalLeftSessionState" do
		self._state_machine:event("leave", {
			game_reason = "game_request"
		})
		self._state_machine:update(0)
	end
end

return SessionLocalStateMachine
