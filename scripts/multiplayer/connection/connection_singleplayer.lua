local ConnectionSingleplayer = class("ConnectionSingleplayer")
local ProfileSynchronizerHost = require("scripts/loading/profile_synchronizer_host")
local SingleplayerLobby = require("scripts/multiplayer/connection/singleplayer_lobby")

ConnectionSingleplayer.init = function (self, event_delegate)
	fassert(event_delegate, "Event delegate is required")

	self._event_delegate = event_delegate
	self._peer_id = Network.peer_id()
	self._lobby = SingleplayerLobby:new()
	self._profile_synchronizer_host = ProfileSynchronizerHost:new(event_delegate)
	self._session_seed = math.random_seed()

	Log.info("ConnectionSingleplayer", "session_seed created %s", self._session_seed)
end

ConnectionSingleplayer.destroy = function (self)
	return
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
	return "singleplay"
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
	return "static_singleplayer_session_id"
end

return ConnectionSingleplayer
