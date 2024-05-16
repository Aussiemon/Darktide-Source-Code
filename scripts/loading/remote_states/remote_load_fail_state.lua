-- chunkname: @scripts/loading/remote_states/remote_load_fail_state.lua

local RemoteLoadFailState = class("RemoteLoadFailState")

RemoteLoadFailState.init = function (self, state_machine, shared_state)
	shared_state.state = "failed"
end

return RemoteLoadFailState
