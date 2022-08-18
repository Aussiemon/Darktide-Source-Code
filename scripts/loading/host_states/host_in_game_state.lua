local HostIngameState = class("HostIngameState")

HostIngameState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	local spawn_group = shared_state.spawn_group

	shared_state.done_loading_level_func(spawn_group, Network.peer_id())

	shared_state.state = "playing"
end

return HostIngameState
