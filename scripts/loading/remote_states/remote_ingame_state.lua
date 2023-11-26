-- chunkname: @scripts/loading/remote_states/remote_ingame_state.lua

local RemoteIngameState = class("RemoteIngameState")

RemoteIngameState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	shared_state.state = "playing"
end

return RemoteIngameState
