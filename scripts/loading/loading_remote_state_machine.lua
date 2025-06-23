-- chunkname: @scripts/loading/loading_remote_state_machine.lua

local RemoteCreateSessionState = require("scripts/loading/remote_states/remote_create_session_state")
local RemoteDetermineSpawnGroupState = require("scripts/loading/remote_states/remote_determine_spawn_group_state")
local RemoteIngameState = require("scripts/loading/remote_states/remote_ingame_state")
local RemoteLoadFailState = require("scripts/loading/remote_states/remote_load_fail_state")
local RemoteLoadState = require("scripts/loading/remote_states/remote_load_state")
local RemoteInitState = require("scripts/loading/remote_states/remote_init_state")
local StateMachine = require("scripts/foundation/utilities/state_machine")
local LoadingRemoteStateMachine = class("LoadingRemoteStateMachine")

LoadingRemoteStateMachine.TIMEOUT = 30

LoadingRemoteStateMachine.init = function (self, network_delegate, client_channel_id, spawn_queue, done_loading_level_func, mission_seed)
	local shared_state = {
		state = "loading",
		added_to_game_session = false,
		network_delegate = network_delegate,
		client_channel_id = client_channel_id,
		client_peer_id = Network.peer_id(client_channel_id),
		timeout = LoadingRemoteStateMachine.TIMEOUT,
		spawn_queue = spawn_queue,
		done_loading_level_func = done_loading_level_func,
		mission_seed = mission_seed
	}

	self._shared_state = shared_state

	Log.info("LoadingRemoteStateMachine", "[init] LoadingTimes: Peer(%s) Started Loading", shared_state.client_peer_id)

	local parent
	local state_machine = StateMachine:new("LoadingRemoteStateMachine", parent, shared_state)

	state_machine:add_transition("RemoteInitState", "init_done", RemoteDetermineSpawnGroupState)
	state_machine:add_transition("RemoteInitState", "disconnected", RemoteLoadFailState)
	state_machine:add_transition("RemoteDetermineSpawnGroupState", "spawn_group_done", RemoteLoadState)
	state_machine:add_transition("RemoteDetermineSpawnGroupState", "disconnected", RemoteLoadFailState)
	state_machine:add_transition("RemoteLoadState", "load_done", RemoteCreateSessionState)
	state_machine:add_transition("RemoteLoadState", "disconnected", RemoteLoadFailState)
	state_machine:add_transition("RemoteCreateSessionState", "in_session", RemoteIngameState)
	state_machine:add_transition("RemoteCreateSessionState", "disconnected", RemoteLoadFailState)
	state_machine:add_transition("RemoteIngameState", "disconnected", RemoteLoadFailState)
	state_machine:add_transition("RemoteLoadFailState", "disconnected", StateMachine.IGNORE_EVENT)
	state_machine:set_initial_state(RemoteInitState)

	self._state_machine = state_machine

	network_delegate:register_connection_channel_events(self, client_channel_id, "rpc_request_mission_seed")
end

LoadingRemoteStateMachine.rpc_request_mission_seed = function (self, channel_id)
	if self._shared_state.mission_seed then
		RPC.rpc_set_mission_seed(channel_id, self._shared_state.mission_seed)
		Log.info("LoadingRemoteStateMachine", "[rpc_request_mission_seed] Sent mission seed to peer(%s)", self._shared_state.client_peer_id)
	else
		Log.info("LoadingRemoteStateMachine", "[rpc_request_mission_seed] Mission seed not available yet, ignoring request")
	end
end

LoadingRemoteStateMachine.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.network_delegate:unregister_channel_events(shared_state.client_channel_id, "rpc_request_mission_seed")
	self._state_machine:event("disconnected")
	self._state_machine:update(0)
	self._state_machine:delete()

	self._state_machine = nil

	if shared_state.added_to_game_session then
		local game_session_manager = Managers.state.game_session

		if game_session_manager and game_session_manager:is_host() then
			Managers.state.game_session:remove_peer(shared_state.client_peer_id)
		end
	end
end

LoadingRemoteStateMachine.peer_id = function (self)
	return self._shared_state.client_peer_id
end

LoadingRemoteStateMachine.state = function (self)
	return self._shared_state.state
end

LoadingRemoteStateMachine.spawn_group_ready = function (self, spawn_group)
	local state = self._state_machine:state()

	if state.spawn_group_ready then
		state:spawn_group_ready(spawn_group)
	else
		local state_name = StateMachine._current_state_name(self._state_machine)

		Log.warning("RemoteLoadState", "LoadingRemoteStateMachine:spawn_group_ready() called, but state machine wasn't ready to handle it. Machine was in state: %s", state_name)
	end
end

LoadingRemoteStateMachine.update = function (self, dt)
	self._state_machine:update(dt)
end

return LoadingRemoteStateMachine
