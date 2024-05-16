-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_mutator.lua

local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepFinalizeDebug = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_finalize_debug")
local GameplayInitStepMutator = class("GameplayInitStepMutator")

GameplayInitStepMutator.on_enter = function (self, parent, params)
	local shared_state = params.shared_state
	local level = shared_state.level
	local themes = shared_state.themes

	self._shared_state = shared_state

	Managers.state.mutator:on_gameplay_post_init(level, themes)
end

GameplayInitStepMutator.update = function (self, main_dt, main_t)
	local next_step_params = {
		shared_state = self._shared_state,
	}

	return GameplayInitStepFinalizeDebug, next_step_params
end

implements(GameplayInitStepMutator, GameplayInitStepInterface)

return GameplayInitStepMutator
