local LocalResetState = class("LocalResetState")

LocalResetState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	shared_state.state = "loading"
	self._mission_name = nil
end

LocalResetState.destroy = function (self)
	self._mission_name = nil
end

LocalResetState.update = function (self)
	if self._mission_name ~= nil then
		return "start_load"
	end
end

LocalResetState.load_mission = function (self)
	local shared_state = self._shared_state
	local mission_name = shared_state.mission_name
	self._mission_name = mission_name
end

return LocalResetState
