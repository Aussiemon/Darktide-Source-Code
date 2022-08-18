local RemoteIngameState = class("RemoteIngameState")

RemoteIngameState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	shared_state.state = "playing"
end

return RemoteIngameState
