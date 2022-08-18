local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepFreeFlight = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_free_flight")
local GameplayInitStepDebug = class("GameplayInitStepDebug")

GameplayInitStepDebug.on_enter = function (self, parent, params)
	local shared_state = params.shared_state
	self._shared_state = shared_state
	local level_name = shared_state.level_name
	local is_server = shared_state.is_server
	local world = shared_state.world
end

GameplayInitStepDebug.update = function (self, main_dt, main_t)
	local next_step_params = {
		shared_state = self._shared_state
	}

	return GameplayInitStepFreeFlight, next_step_params
end

implements(GameplayInitStepDebug, GameplayInitStepInterface)

return GameplayInitStepDebug
