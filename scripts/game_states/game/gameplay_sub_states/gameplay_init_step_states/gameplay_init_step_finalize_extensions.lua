-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_finalize_extensions.lua

local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepPacing = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_pacing")
local GameplayInitStepFinalizeExtensions = class("GameplayInitStepFinalizeExtensions")

GameplayInitStepFinalizeExtensions.init = function (self)
	self._skipped_first_update = false
end

GameplayInitStepFinalizeExtensions.on_enter = function (self, parent, params)
	local shared_state = params.shared_state

	self._shared_state = shared_state

	local themes = shared_state.themes
	local level = shared_state.level

	Managers.state.extension:init_time_slice_on_gameplay_post_init(level, themes)
end

GameplayInitStepFinalizeExtensions.update = function (self, main_dt, main_t)
	if not self._skipped_first_update then
		self._skipped_first_update = true

		return nil, nil
	end

	local extension_manager = Managers.state.extension
	local is_system_holder_post_initialized = extension_manager:update_time_slice_post_init()

	if not is_system_holder_post_initialized then
		return nil, nil
	end

	self._shared_state.initialized_steps.GameplayInitStepFinalizeExtensions = true

	local next_step_params = {
		shared_state = self._shared_state,
	}

	return GameplayInitStepPacing, next_step_params
end

implements(GameplayInitStepFinalizeExtensions, GameplayInitStepInterface)

return GameplayInitStepFinalizeExtensions
