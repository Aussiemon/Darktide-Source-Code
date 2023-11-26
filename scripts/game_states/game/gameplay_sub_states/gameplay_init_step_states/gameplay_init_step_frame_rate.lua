-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_frame_rate.lua

local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepOutOfBounds = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_out_of_bounds")
local GameplayInitStepFrameRate = class("GameplayInitStepFrameRate")

GameplayInitStepFrameRate.on_enter = function (self, parent, params)
	self._shared_state = params.shared_state

	Managers.frame_rate:request_full_frame_rate("gameplay")
end

GameplayInitStepFrameRate.update = function (self, main_dt, main_t)
	local next_step_params = {
		shared_state = self._shared_state
	}

	return GameplayInitStepOutOfBounds, next_step_params
end

implements(GameplayInitStepFrameRate, GameplayInitStepInterface)

return GameplayInitStepFrameRate
