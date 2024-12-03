-- chunkname: @scripts/loading/host_states/host_loaders_state.lua

local HostLoadersState = class("HostLoadersState")

HostLoadersState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state

	local loaders = shared_state.loaders

	self._loaders = loaders

	local mission_name = shared_state.mission_name
	local level_name = shared_state.level_name
	local circumstance_name = shared_state.circumstance_name
	local havoc_data = shared_state.havoc_data

	for _, loader in ipairs(loaders) do
		loader:start_loading(mission_name, level_name, circumstance_name, havoc_data)
	end
end

HostLoadersState.update = function (self, dt)
	local loaders = self._loaders

	for i = 1, #loaders do
		if not loaders[i]:is_loading_done() then
			return
		end
	end

	return "load_done"
end

return HostLoadersState
