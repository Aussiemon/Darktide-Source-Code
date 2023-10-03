local ConnectionSingleplayer = require("scripts/multiplayer/connection/connection_singleplayer")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local SessionBootBase = require("scripts/multiplayer/session_boot_base")
local HOST_TYPES = MatchmakingConstants.HOST_TYPES
local STATES = table.enum("ready", "failed")
local SingleplayerSessionBoot = class("SingleplayerSessionBoot", "SessionBootBase")

SingleplayerSessionBoot.init = function (self, event_object)
	SingleplayerSessionBoot.super.init(self, STATES, event_object)

	local connection_manager = Managers.connection
	local event_delegate = connection_manager:network_event_delegate()
	self._connection_singleplayer = ConnectionSingleplayer:new(event_delegate, HOST_TYPES.singleplay, GameParameters.tick_rate)

	self:_set_state(STATES.ready)
end

SingleplayerSessionBoot.update = function (self, dt)
	SingleplayerSessionBoot.super.update(self, dt)
end

SingleplayerSessionBoot.result = function (self)
	self:_set_window_title("singleplayer %s", Network.peer_id())

	local connection_singleplayer = self._connection_singleplayer
	self._connection_singleplayer = nil

	return connection_singleplayer
end

SingleplayerSessionBoot.destroy = function (self)
	if self._connection_singleplayer then
		self._connection_singleplayer:delete()

		self._connection_singleplayer = nil
	end
end

implements(SingleplayerSessionBoot, SessionBootBase.INTERFACE)

return SingleplayerSessionBoot
