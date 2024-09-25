-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_nvidia_ai_agent.lua

local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepExtensionUnits = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_extension_units")
local NvidiaAIAgent = GameParameters.nvidia_ai_agent and require("scripts/utilities/nvidia_ai_agent")
local GameplayInitStepNvidiaAiAgent = class("GameplayInitStepNvidiaAiAgent")

GameplayInitStepNvidiaAiAgent.on_enter = function (self, parent, params)
	local shared_state = params.shared_state

	self._shared_state = shared_state

	local is_dedicated_server = shared_state.is_dedicated_server

	self:_init_nvidia_ai_agent(is_dedicated_server, shared_state)
end

GameplayInitStepNvidiaAiAgent.update = function (self, main_dt, main_t)
	self._shared_state.initialized_steps.GameplayInitStepNvidiaAiAgent = true

	local next_step_params = {
		shared_state = self._shared_state,
	}

	return GameplayInitStepExtensionUnits, next_step_params
end

GameplayInitStepNvidiaAiAgent._init_nvidia_ai_agent = function (self, is_dedicated_server, out_shared_state)
	if GameParameters.nvidia_ai_agent and not is_dedicated_server then
		out_shared_state.nvidia_ai_agent = NvidiaAIAgent:new()
	end
end

implements(GameplayInitStepNvidiaAiAgent, GameplayInitStepInterface)

return GameplayInitStepNvidiaAiAgent
