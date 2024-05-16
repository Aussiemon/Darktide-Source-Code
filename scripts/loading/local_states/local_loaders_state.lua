-- chunkname: @scripts/loading/local_states/local_loaders_state.lua

local LocalLoadersState = class("LocalLoadersState")

LocalLoadersState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state

	local loaders = shared_state.loaders

	self._loaders = loaders

	local mission_name = shared_state.mission_name
	local level_name = shared_state.level_name
	local circumstance_name = shared_state.circumstance_name

	for _, loader in ipairs(loaders) do
		loader:cleanup()
		loader:start_loading(mission_name, level_name, circumstance_name)
	end
end

LocalLoadersState.update = function (self, dt)
	local all_loaded = true

	for _, loader in ipairs(self._loaders) do
		if not loader:is_loading_done() then
			all_loaded = false
		end
	end

	if all_loaded then
		return "load_done"
	end
end

return LocalLoadersState
