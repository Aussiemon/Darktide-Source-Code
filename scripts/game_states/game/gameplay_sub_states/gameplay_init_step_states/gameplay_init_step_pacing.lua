-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_pacing.lua

local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepTerrorEvent = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_terror_event")
local GameplayInitStepPacing = class("GameplayInitStepPacing")

GameplayInitStepPacing.on_enter = function (self, parent, params)
	local shared_state = params.shared_state
	local is_server = shared_state.is_server
	local level_name = shared_state.level_name

	self._shared_state = shared_state

	if is_server then
		Managers.state.pacing:on_gameplay_post_init(level_name)
	end

	local level_seed = shared_state.level_seed

	Managers.state.collectibles:on_gameplay_post_init(level_seed)
end

GameplayInitStepPacing.update = function (self, main_dt, main_t)
	self._shared_state.initialized_steps.GameplayInitStepPacing = true

	local next_step_params = {
		shared_state = self._shared_state
	}

	return GameplayInitStepTerrorEvent, next_step_params
end

implements(GameplayInitStepPacing, GameplayInitStepInterface)

return GameplayInitStepPacing
