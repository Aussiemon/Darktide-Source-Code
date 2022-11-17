local SessionLocalStateMachine = require("scripts/multiplayer/session/session_local_state_machine")
local EVENTS = {
	"rpc_peer_joined_session",
	"rpc_peer_left_session"
}
local SessionClient = class("SessionClient")

SessionClient.init = function (self, network_delegate, engine_lobby, engine_gamesession, gameobject_callback_object, clock_handler_client)
	self._network_delegate = network_delegate
	self._engine_gamesession = engine_gamesession
	self._host_session = SessionLocalStateMachine:new(network_delegate, engine_lobby, self._engine_gamesession, gameobject_callback_object, clock_handler_client)
	self._remote_clients = {}
	self._events = {}

	network_delegate:register_session_events(self, unpack(EVENTS))
end

SessionClient.destroy = function (self)
	self._network_delegate:unregister_events(unpack(EVENTS))
	self._host_session:delete()

	self._host_session = nil
	self._remote_clients = nil
end

SessionClient.update = function (self, dt)
	self._host_session:update(dt)
end

SessionClient.host = function (self)
	return self._host_session:host()
end

SessionClient.host_channel = function (self)
	return self._host_session:host_channel()
end

SessionClient.game_session = function (self)
	return self._engine_gamesession
end

SessionClient.leave = function (self)
	self._host_session:leave()
end

SessionClient.next_event = function (self)
	local event_list = self._events

	if not table.is_empty(event_list) then
		local event = event_list[1]

		table.remove(event_list, 1)

		if type(event) == "function" then
			event = event()
		end

		return event.name, event.parameters
	end

	local event, parameters = self._host_session:next_event()

	if event then
		return event, parameters
	end
end

SessionClient.rpc_peer_joined_session = function (self, channel_id, peer_id)
	local remote_clients = self._remote_clients

	self._events[#self._events + 1] = function ()
		remote_clients[peer_id] = {}

		return {
			name = "session_joined",
			parameters = {
				peer_id = peer_id
			}
		}
	end
end

SessionClient.rpc_peer_left_session = function (self, channel_id, peer_id)
	local remote_clients = self._remote_clients

	self._events[#self._events + 1] = function ()
		remote_clients[peer_id] = nil

		return {
			name = "session_left",
			parameters = {
				peer_id = peer_id
			}
		}
	end
end

return SessionClient
