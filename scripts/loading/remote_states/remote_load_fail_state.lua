local RemoteLoadFailState = class("RemoteLoadFailState")

RemoteLoadFailState.init = function (self, state_machine, shared_state)
	shared_state.state = "failed"
end

return RemoteLoadFailState
