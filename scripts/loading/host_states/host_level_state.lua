local AsyncLevelSpawner = require("scripts/loading/async_level_spawner")
local GameplayInitTimeSlice = require("scripts/game_states/game/utilities/gameplay_init_time_slice")
local ScriptTheme = require("scripts/foundation/utilities/script_theme")
local HostLevelState = class("HostLevelState")

HostLevelState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._level_spawner = nil
	local level_name = shared_state.level_name

	self:_spawn_level(level_name)
end

HostLevelState.destroy = function (self)
	if self._level_spawner then
		self._level_spawner:delete()

		self._level_spawner = nil
	end
end

HostLevelState.update = function (self, dt)
	local done, world, level = self._level_spawner:update()

	if done then
		local shared_state = self._shared_state
		shared_state.world = world
		shared_state.level = level

		self._level_spawner:delete()

		self._level_spawner = nil

		return "load_done"
	end
end

HostLevelState._spawn_level = function (self, level_name)
	local world_parameters = {
		timer_name = "gameplay",
		layer = 1
	}
	local shared_state = self._shared_state
	local object_sets_to_hide = ScriptTheme.object_sets_to_hide(shared_state.themes)
	self._level_spawner = AsyncLevelSpawner:new("level_world", level_name, world_parameters, GameplayInitTimeSlice.MAX_DT_IN_SEC, shared_state.world, object_sets_to_hide)
end

return HostLevelState
