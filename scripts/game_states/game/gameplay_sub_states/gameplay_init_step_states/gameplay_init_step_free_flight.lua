-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_free_flight.lua

local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepGameSession = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_game_session")
local GameplayInitStepFreeFlight = class("GameplayInitStepFreeFlight")

GameplayInitStepFreeFlight.on_enter = function (self, parent, params)
	local shared_state = params.shared_state

	self._shared_state = shared_state

	local is_server = shared_state.is_server
end

GameplayInitStepFreeFlight.update = function (self, main_dt, main_t)
	local next_step_params = {
		shared_state = self._shared_state
	}

	return GameplayInitStepGameSession, next_step_params
end

implements(GameplayInitStepFreeFlight, GameplayInitStepInterface)

return GameplayInitStepFreeFlight
