local ConnectionSingleplayer = require("scripts/multiplayer/connection/connection_singleplayer")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local SessionBootBase = require("scripts/multiplayer/session_boot_base")
local HOST_TYPES = MatchmakingConstants.HOST_TYPES
local STATES = table.enum("creating_backend_session", "ready", "failed")
local SingleplayerBackendSessionBoot = class("SingleplayerBackendSessionBoot", "SessionBootBase")

SingleplayerBackendSessionBoot.init = function (self, event_object, backend_mission_data)
	SingleplayerBackendSessionBoot.super.init(self, STATES, event_object)

	local mission_id = backend_mission_data.id

	self:_set_state(STATES.creating_backend_session)
	Managers.party_immaterium:create_single_player_game(mission_id):next(function (response)
		local session_id = response.game_session_id

		Log.info("SingleplayerBackendSessionBoot", "Created backend session %s", session_id)

		local event_delegate = Managers.connection:network_event_delegate()
		self._connection_singleplayer = ConnectionSingleplayer:new(event_delegate, HOST_TYPES.singleplay_backend_session, session_id, backend_mission_data)

		self:_set_state(STATES.ready)
	end):catch(function (error)
		local is_error = true

		self._event_object:failed_to_boot(is_error, "game", "FAILED_CREATING_BACKEND_SESSION", error)
		self:_set_state(STATES.failed)
	end)
end

SingleplayerBackendSessionBoot.update = function (self, dt)
	SingleplayerBackendSessionBoot.super.update(self, dt)
end

SingleplayerBackendSessionBoot.result = function (self)
	self:_set_window_title("singleplayer %s", Network.peer_id())

	local connection_singleplayer = self._connection_singleplayer
	self._connection_singleplayer = nil

	return connection_singleplayer
end

SingleplayerBackendSessionBoot.destroy = function (self)
	if self._connection_singleplayer then
		self._connection_singleplayer:delete()

		self._connection_singleplayer = nil
	end
end

implements(SingleplayerBackendSessionBoot, SessionBootBase.INTERFACE)

return SingleplayerBackendSessionBoot
