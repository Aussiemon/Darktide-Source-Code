local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepLastChecks = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_last_checks")
local GameplayInitStepClientWaitForCinematicsLoaded = class("GameplayInitStepClientWaitForCinematicsLoaded")

GameplayInitStepClientWaitForCinematicsLoaded.on_enter = function (self, parent, params)
	local shared_state = params.shared_state
	self._shared_state = shared_state
end

GameplayInitStepClientWaitForCinematicsLoaded.update = function (self, main_dt, main_t)
	if not DEDICATED_SERVER and Managers.state.cinematic:is_loading_cinematic_levels() then
		return nil, nil
	end

	local next_step_params = {
		shared_state = self._shared_state
	}

	return GameplayInitStepLastChecks, next_step_params
end

implements(GameplayInitStepClientWaitForCinematicsLoaded, GameplayInitStepInterface)

return GameplayInitStepClientWaitForCinematicsLoaded
