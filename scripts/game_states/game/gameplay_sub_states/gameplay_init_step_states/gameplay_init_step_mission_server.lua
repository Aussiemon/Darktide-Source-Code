local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepLastChecks = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_last_checks")
local GameplayInitStepMissionServer = class("GameplayInitStepMissionServer")

GameplayInitStepMissionServer.on_enter = function (self, parent, params)
	local shared_state = params.shared_state
	self._shared_state = shared_state

	if Managers.mission_server then
		Managers.mission_server:on_gameplay_post_init()
	end
end

GameplayInitStepMissionServer.update = function (self, main_dt, main_t)
	local next_step_params = {
		shared_state = self._shared_state
	}

	return GameplayInitStepLastChecks, next_step_params
end

implements(GameplayInitStepMissionServer, GameplayInitStepInterface)

return GameplayInitStepMissionServer
