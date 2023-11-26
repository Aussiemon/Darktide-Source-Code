-- chunkname: @scripts/multiplayer/session/session_host.lua

local SessionRemoteStateMachine = require("scripts/multiplayer/session/session_remote_state_machine")
local EVENTS = {
	"game_object_sync_done"
}
local SessionHost = class("SessionHost")

local function _warning(...)
	Log.info("SessionHost", ...)
end

SessionHost.init = function (self, network_delegate, approve_channel_delegate, engine_lobby, engine_gamesession)
	self._network_delegate = network_delegate
	self._approve_channel_delegate = approve_channel_delegate
	self._engine_lobby = engine_lobby
	self._lobby_id = engine_lobby:id()
	self._engine_gamesession = engine_gamesession
	self._host_peer_id = Network.peer_id()

	GameSession.make_game_session_host(engine_gamesession)

	if engine_lobby.set_game_session_host then
		engine_lobby:set_game_session_host(self._host_peer_id)
	end

	self._remote_clients = {}

	network_delegate:register_session_events(self, unpack(EVENTS))
	approve_channel_delegate:register(self._lobby_id, "session", self)
end

SessionHost.destroy = function (self)
	self._approve_channel_delegate:unregister(self._lobby_id, "session")
	self._network_delegate:unregister_events(unpack(EVENTS))

	for _, remote_client in pairs(self._remote_clients) do
		remote_client:delete()
	end

	GameSession.leave(self._engine_gamesession, Managers.state.game_session)
end

SessionHost.update = function (self, dt)
	for _, remote_client in pairs(self._remote_clients) do
		remote_client:update(dt)
	end
end

SessionHost.game_session = function (self)
	return self._engine_gamesession
end

SessionHost.add = function (self, peer_id, gameobject_callback_object)
	local remote_client = SessionRemoteStateMachine:new(self._network_delegate, peer_id, self._engine_lobby, self._engine_gamesession, gameobject_callback_object)

	self._remote_clients[peer_id] = remote_client
end

SessionHost.remove = function (self, peer_id)
	local remote_client = self._remote_clients[peer_id]

	remote_client:force_leave()
end

SessionHost.has_client = function (self, peer_id)
	return self._remote_clients[peer_id] ~= nil
end

SessionHost.num_clients = function (self)
	return table.size(self._remote_clients)
end

SessionHost.next_event = function (self)
	for _, remote_client in pairs(self._remote_clients) do
		local event, parameters = remote_client:next_event()

		if event then
			return self:_handle_event(event, parameters)
		end
	end
end

SessionHost.next_event_by_peer = function (self, peer_id)
	local remote_client = self._remote_clients[peer_id]
	local event, parameters = remote_client:next_event()

	if event then
		return self:_handle_event(event, parameters)
	end
end

SessionHost._handle_event = function (self, event, parameters)
	if event == "session_joined" then
		self:_notify_joined(parameters)
	elseif event == "session_left" then
		self:_notify_left(parameters)

		local leaving_peer = parameters.peer_id

		self._remote_clients[leaving_peer]:delete()

		self._remote_clients[leaving_peer] = nil
	end

	return event, parameters
end

SessionHost.approve_channel = function (self, channel_id, remote_peer_id, instance_id, message)
	local remote_client = self._remote_clients[remote_peer_id]

	if remote_client then
		return remote_client:approve_channel(channel_id)
	else
		_warning("Denying session channel %i from %s because the session client is unknown.", channel_id, remote_peer_id)

		return false
	end
end

SessionHost.game_object_sync_done = function (self, peer_id)
	local state_machine = self._remote_clients[peer_id]

	if state_machine then
		state_machine:game_object_sync_done()
	end
end

SessionHost._notify_joined = function (self, parameters)
	local joining_peer = parameters.peer_id

	for peer_id, client in pairs(self._remote_clients) do
		if peer_id == joining_peer then
			for other_peer_id, other_client in pairs(self._remote_clients) do
				if other_client:is_joined() and not client:peer_joined(other_peer_id) then
					RPC.rpc_peer_joined_session(client:channel_id(), other_peer_id)
				end
			end
		elseif client:is_joined() and not client:peer_joined(joining_peer) then
			RPC.rpc_peer_joined_session(client:channel_id(), joining_peer)
		end
	end
end

SessionHost._notify_left = function (self, parameters)
	local leaving_peer = parameters.peer_id

	for peer_id, client in pairs(self._remote_clients) do
		if peer_id ~= leaving_peer and client:is_joined() and client:peer_left(leaving_peer) then
			RPC.rpc_peer_left_session(client:channel_id(), leaving_peer)
		end
	end
end

return SessionHost
