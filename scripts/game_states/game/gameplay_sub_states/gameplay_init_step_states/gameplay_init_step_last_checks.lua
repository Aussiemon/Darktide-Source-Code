-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_last_checks.lua

local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepStateWaitForGroup = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_wait_for_group")
local GameplayInitStepStateLastChecks = class("GameplayInitStepStateLastChecks")

GameplayInitStepStateLastChecks.on_enter = function (self, parent, params)
	local shared_state = params.shared_state

	self._shared_state = shared_state

	local level = shared_state.level
end

GameplayInitStepStateLastChecks.update = function (self, main_dt, main_t)
	local next_step_params = {
		shared_state = self._shared_state
	}

	return GameplayInitStepStateWaitForGroup, next_step_params
end

implements(GameplayInitStepStateLastChecks, GameplayInitStepInterface)

return GameplayInitStepStateLastChecks
