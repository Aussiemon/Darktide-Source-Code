-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_finalize_debug.lua

local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepBreedTester = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_breed_tester")
local GameplayInitStepFinalizeDebug = class("GameplayInitStepFinalizeDebug")

GameplayInitStepFinalizeDebug.on_enter = function (self, parent, params)
	local shared_state = params.shared_state
	local level = shared_state.level

	self._shared_state = shared_state
end

GameplayInitStepFinalizeDebug.update = function (self, main_dt, main_t)
	local next_step_params = {
		shared_state = self._shared_state,
	}

	return GameplayInitStepBreedTester, next_step_params
end

implements(GameplayInitStepFinalizeDebug, GameplayInitStepInterface)

return GameplayInitStepFinalizeDebug
