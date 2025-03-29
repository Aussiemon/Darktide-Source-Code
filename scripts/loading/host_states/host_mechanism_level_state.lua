-- chunkname: @scripts/loading/host_states/host_mechanism_level_state.lua

local HostMechanismLevelState = class("HostMechanismLevelState")

HostMechanismLevelState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
end

HostMechanismLevelState.destroy = function (self)
	return
end

HostMechanismLevelState.update = function (self, dt)
	return "spawning_done"
end

return HostMechanismLevelState
