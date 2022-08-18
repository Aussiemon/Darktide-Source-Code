local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepTerrorEvent = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_terror_event")
local GameplayInitStepVoiceOver = class("GameplayInitStepVoiceOver")

GameplayInitStepVoiceOver.on_enter = function (self, parent, params)
	local shared_state = params.shared_state
	local is_server = shared_state.is_server
	local level = shared_state.level
	self._shared_state = shared_state

	if is_server then
		Managers.state.voice_over_spawn:on_gameplay_post_init(level)
	end
end

GameplayInitStepVoiceOver.update = function (self, main_dt, main_t)
	local next_step_params = {
		shared_state = self._shared_state
	}

	return GameplayInitStepTerrorEvent, next_step_params
end

implements(GameplayInitStepVoiceOver, GameplayInitStepInterface)

return GameplayInitStepVoiceOver
