local LocalLoadFailState = class("LocalLoadFailState")

LocalLoadFailState.init = function (self, state_machine, shared_state)
	shared_state.state = "failed"
end

return LocalLoadFailState
