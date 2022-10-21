local ConnectionSingleplayer = class("ConnectionSingleplayer")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local ProfileSynchronizerHost = require("scripts/loading/profile_synchronizer_host")
local SingleplayerLobby = require("scripts/multiplayer/connection/singleplayer_lobby")
local HOST_TYPES = MatchmakingConstants.HOST_TYPES

ConnectionSingleplayer.init = function (self, event_delegate, host_type, optional_backend_session_id, optional_backend_mission_data)
	self._event_delegate = event_delegate
	self._host_type = host_type
	self._session_id = optional_backend_session_id
	self._mission_data = optional_backend_mission_data
	self._peer_id = Network.peer_id()
	self._lobby = SingleplayerLobby:new()
	self._profile_synchronizer_host = ProfileSynchronizerHost:new(event_delegate)
	self._session_seed = math.random_seed()

	Log.info("ConnectionSingleplayer", "session_seed created %s", self._session_seed)

	if host_type == HOST_TYPES.singleplay_backend_session then
		Managers.event:register(self, "event_mission_server_initialized", "event_mission_server_initialized")
	end
end

ConnectionSingleplayer.destroy = function (self)
	Managers.event:unregister(self, "event_mission_server_initialized")
end

ConnectionSingleplayer.event_mission_server_initialized = function (self)
	Managers.event:unregister(self, "event_mission_server_initialized")
	Managers.mission_server:allocate_session(self._session_id, self._mission_data)
	Managers.mechanism:trigger_event("all_players_ready")
end

ConnectionSingleplayer.register_profile_synchronizer = function (self)
	local profile_synchronizer_host = self._profile_synchronizer_host

	Managers.profile_synchronization:set_profile_synchroniser_host(profile_synchronizer_host)
end

ConnectionSingleplayer.unregister_profile_synchronizer = function (self)
	if Managers.profile_synchronization then
		Managers.profile_synchronization:set_profile_synchroniser_host(nil)
	end
end

ConnectionSingleplayer.allocation_state = function (self)
	return 1
end

ConnectionSingleplayer.disconnect = function (self, channel_id)
	return
end

ConnectionSingleplayer.kick = function (self, channel_id, reason, option_details)
	return
end

ConnectionSingleplayer.host = function (self)
	return self._peer_id
end

ConnectionSingleplayer.engine_lobby = function (self)
	return self._lobby
end

ConnectionSingleplayer.engine_lobby_id = function (self)
	return self._lobby:id()
end

ConnectionSingleplayer.host_is_dedicated_server = function (self)
	return false
end

ConnectionSingleplayer.host_type = function (self)
	return self._host_type
end

ConnectionSingleplayer.max_members = function (self)
	return 1
end

ConnectionSingleplayer.remove = function (self, channel_id)
	return
end

ConnectionSingleplayer.connecting_peers = function (self)
	return {}
end

ConnectionSingleplayer.update = function (self, dt)
	return
end

ConnectionSingleplayer.next_event = function (self)
	return
end

ConnectionSingleplayer.server_name = function (self)
	return "Singleplayer"
end

ConnectionSingleplayer.session_seed = function (self)
	return self._session_seed
end

ConnectionSingleplayer.session_id = function (self)
	return self._session_id
end

return ConnectionSingleplayer
