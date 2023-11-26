-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_level_spawned.lua

local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepFinalizeExtensions = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_finalize_extensions")
local GameplayInitLevelSpawned = class("GameplayInitLevelSpawned")

GameplayInitLevelSpawned.on_enter = function (self, parent, params)
	local shared_state = params.shared_state
	local level = shared_state.level

	self._shared_state = shared_state

	self:_trigger_level_spawned(level)
end

GameplayInitLevelSpawned.update = function (self, main_dt, main_t)
	local next_step_params = {
		shared_state = self._shared_state
	}

	return GameplayInitStepFinalizeExtensions, next_step_params
end

GameplayInitLevelSpawned._trigger_level_spawned = function (self, level)
	local nested_levels = Level.nested_levels(level)
	local num_nested_levels = Level.num_nested_levels(level)

	for i = 1, num_nested_levels do
		self:_trigger_level_spawned(nested_levels[i])
	end

	Level.trigger_level_spawned(level)
end

implements(GameplayInitLevelSpawned, GameplayInitStepInterface)

return GameplayInitLevelSpawned
