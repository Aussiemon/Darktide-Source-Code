local AsyncLevelSpawner = require("scripts/loading/async_level_spawner")
local HostCreateWorldState = class("HostCreateWorldState")

HostCreateWorldState.init = function (self, state_machine, shared_state)
	local world_parameters = {
		timer_name = "gameplay",
		layer = 1
	}
	local world = AsyncLevelSpawner.setup_world("level_world", world_parameters)
	shared_state.world = world
end

HostCreateWorldState.update = function (self, dt)
	return "load_done"
end

return HostCreateWorldState
