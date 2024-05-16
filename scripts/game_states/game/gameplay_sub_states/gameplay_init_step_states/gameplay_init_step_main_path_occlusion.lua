-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_main_path_occlusion.lua

local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepFinalizeNavigation = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_finalize_navigation")
local GameplayInitStepMainPathOcclusion = class("GameplayInitStepMainPathOcclusion")

GameplayInitStepMainPathOcclusion.init = function (self)
	self._skipped_first_update = false
end

GameplayInitStepMainPathOcclusion.on_enter = function (self, parent, params)
	local shared_state = params.shared_state

	self._shared_state = shared_state
end

GameplayInitStepMainPathOcclusion.update = function (self, main_dt, main_t)
	if not self._skipped_first_update then
		self._skipped_first_update = true

		return nil, nil
	end

	local main_path_manager = Managers.state.main_path
	local main_path_initialized = main_path_manager:update_time_slice_generate_occluded_points()

	if not main_path_initialized then
		return nil, nil
	end

	local next_step_params = {
		shared_state = self._shared_state,
	}

	return GameplayInitStepFinalizeNavigation, next_step_params
end

implements(GameplayInitStepMainPathOcclusion, GameplayInitStepInterface)

return GameplayInitStepMainPathOcclusion
