-- chunkname: @scripts/loading/local_states/local_mechanism_level_state.lua

local LocalMechanismLevelState = class("LocalMechanismLevelState")

LocalMechanismLevelState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state

	local mechanism_manager = Managers.mechanism
	local mechanism = mechanism_manager:current_mechanism()
	local levels_spawner = mechanism.levels_spawner and mechanism:levels_spawner()

	if levels_spawner then
		self._levels_spawner = levels_spawner

		local expedition = levels_spawner:expedition()

		for _, segment in ipairs(expedition) do
			local levels_data = segment.levels_data

			for _, level_data in ipairs(levels_data) do
				local level_loader = level_data.level_loader

				if level_loader and level_loader:is_loading_done() and not level_data.spawned then
					levels_spawner:add_level_to_queue(level_data)
				end
			end
		end

		levels_spawner:assign_is_sever(false)

		local world = shared_state.world

		levels_spawner:assign_world(world)
		levels_spawner:spawn_queued_levels()
	end
end

LocalMechanismLevelState.destroy = function (self)
	return
end

LocalMechanismLevelState.update = function (self, dt)
	local levels_spawner = self._levels_spawner

	if levels_spawner then
		levels_spawner:update()

		if levels_spawner:done() then
			levels_spawner:clear_done()

			return "spawning_done"
		end
	else
		return "spawning_done"
	end
end

return LocalMechanismLevelState
