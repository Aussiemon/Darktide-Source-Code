local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepNvidiaAiAgent = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_nvidia_ai_agent")
local GameplayInitStepPresence = class("GameplayInitStepPresence")

GameplayInitStepPresence.on_enter = function (self, parent, params)
	self._shared_state = params.shared_state

	self:_init_presence()
end

GameplayInitStepPresence.update = function (self, main_dt, main_t)
	local next_step_params = {
		shared_state = self._shared_state
	}

	return GameplayInitStepNvidiaAiAgent, next_step_params
end

GameplayInitStepPresence._init_presence = function (self)
	local presence_name = Managers.state.game_mode:presence_name()

	if presence_name then
		Managers.presence:set_presence(presence_name)
	end
end

implements(GameplayInitStepPresence, GameplayInitStepInterface)

return GameplayInitStepPresence
