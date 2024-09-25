-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_nav_spawn_points.lua

local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepMainPathOcclusion = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_main_path_occlusion")
local GameplayInitStepNavSpawnPoints = class("GameplayInitStepNavSpawnPoints")

GameplayInitStepNavSpawnPoints.init = function (self)
	self._skipped_first_update = false
end

GameplayInitStepNavSpawnPoints.on_enter = function (self, parent, params)
	local shared_state = params.shared_state

	self._shared_state = shared_state

	Managers.state.main_path:on_gameplay_post_init()
end

GameplayInitStepNavSpawnPoints.update = function (self, main_dt, main_t)
	if not self._skipped_first_update then
		self._skipped_first_update = true

		return nil, nil
	end

	local spawn_points_initialized = Managers.state.main_path:update_time_slice_spawn_points()

	if not spawn_points_initialized then
		return nil, nil
	end

	self._shared_state.initialized_steps.GameplayInitStepNavSpawnPoints = true

	local next_step_params = {
		shared_state = self._shared_state,
	}

	return GameplayInitStepMainPathOcclusion, next_step_params
end

implements(GameplayInitStepNavSpawnPoints, GameplayInitStepInterface)

return GameplayInitStepNavSpawnPoints
