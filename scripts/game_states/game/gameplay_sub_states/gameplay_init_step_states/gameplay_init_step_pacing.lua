local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepVoiceOver = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_voice_over")
local GameplayInitStepPacing = class("GameplayInitStepPacing")

GameplayInitStepPacing.on_enter = function (self, parent, params)
	local shared_state = params.shared_state
	local is_server = shared_state.is_server
	local level_name = shared_state.level_name
	self._shared_state = shared_state

	if is_server then
		Managers.state.pacing:on_gameplay_post_init(level_name)
	end
end

GameplayInitStepPacing.update = function (self, main_dt, main_t)
	local next_step_params = {
		shared_state = self._shared_state
	}

	return GameplayInitStepVoiceOver, next_step_params
end

implements(GameplayInitStepPacing, GameplayInitStepInterface)

return GameplayInitStepPacing
