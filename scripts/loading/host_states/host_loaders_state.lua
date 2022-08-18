local HostLoadersState = class("HostLoadersState")

HostLoadersState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	local loaders = shared_state.loaders
	self._loaders = loaders
	local mission_name = shared_state.mission_name
	local level_name = shared_state.level_name
	local circumstance_name = shared_state.circumstance_name

	for _, loader in ipairs(loaders) do
		loader:start_loading(mission_name, level_name, circumstance_name)
	end
end

HostLoadersState.update = function (self, dt)
	local loaders = self._loaders

	for i = 1, #loaders, 1 do
		if not loaders[i]:is_loading_done() then
			return
		end
	end

	return "load_done"
end

return HostLoadersState
