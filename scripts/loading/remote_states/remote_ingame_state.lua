-- chunkname: @scripts/loading/remote_states/remote_ingame_state.lua

local RemoteIngameState = class("RemoteIngameState")

RemoteIngameState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state

	if Managers.mission_server then
		Managers.mission_server:on_in_game_state_reached()
	end

	shared_state.state = "playing"
end

return RemoteIngameState
