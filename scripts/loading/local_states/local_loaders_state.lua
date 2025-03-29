-- chunkname: @scripts/loading/local_states/local_loaders_state.lua

local LocalLoadersState = class("LocalLoadersState")

LocalLoadersState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state

	local loaders = shared_state.loaders

	self._loaders = loaders

	for _, loader in ipairs(loaders) do
		loader:cleanup()
		loader:start_loading(shared_state)
	end

	shared_state.mission_seed = nil
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
