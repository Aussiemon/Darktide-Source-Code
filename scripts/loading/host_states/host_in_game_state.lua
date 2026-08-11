-- chunkname: @scripts/loading/host_states/host_in_game_state.lua

local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local HOST_TYPES = MatchmakingConstants.HOST_TYPES
local HostIngameState = class("HostIngameState")

HostIngameState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state

	local host_type = Managers.multiplayer_session:host_type()

	if Managers.mission_server and (host_type == HOST_TYPES.player or host_type == HOST_TYPES.singleplay or host_type == HOST_TYPES.singleplay_backend_session) then
		Managers.mission_server:on_in_game_state_reached()
	end

	local spawn_group = shared_state.spawn_group

	shared_state.done_loading_level_func(spawn_group, Network.peer_id())

	shared_state.state = "playing"
end

return HostIngameState
