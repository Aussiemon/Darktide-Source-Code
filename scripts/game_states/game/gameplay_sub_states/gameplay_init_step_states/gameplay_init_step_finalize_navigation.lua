-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_finalize_navigation.lua

local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitGameModeDependencies = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_game_mode_dependencies")
local GameplayInitStepFinalizeNavigation = class("GameplayInitStepFinalizeNavigation")

GameplayInitStepFinalizeNavigation.on_enter = function (self, parent, params)
	local shared_state = params.shared_state

	self._shared_state = shared_state

	local level_name = shared_state.level_name
	local is_server = shared_state.is_server

	self:_navigation_post_init(is_server, level_name)
end

GameplayInitStepFinalizeNavigation.update = function (self, main_dt, main_t)
	self._shared_state.initialized_steps.GameplayInitStepFinalizeNavigation = true

	local next_step_params = {
		shared_state = self._shared_state,
	}

	return GameplayInitGameModeDependencies, next_step_params
end

GameplayInitStepFinalizeNavigation._navigation_post_init = function (self, is_server, level_name)
	if is_server then
		Managers.state.bot_nav_transition:on_gameplay_post_init(level_name)
	end
end

implements(GameplayInitStepFinalizeNavigation, GameplayInitStepInterface)

return GameplayInitStepFinalizeNavigation
