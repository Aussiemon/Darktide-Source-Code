-- chunkname: @scripts/loading/local_states/local_mechanism_level_state.lua

local LocalMechanismLevelState = class("LocalMechanismLevelState")

LocalMechanismLevelState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
end

LocalMechanismLevelState.destroy = function (self)
	return
end

LocalMechanismLevelState.update = function (self, dt)
	return "spawning_done"
end

return LocalMechanismLevelState
