-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_game_mode_dependencies.lua

local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepPlayerEnterGame = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_player_enter_game")
local GameplayInitGameModeDependencies = class("GameplayInitGameModeDependencies")

GameplayInitGameModeDependencies.on_enter = function (self, parent, params)
	local shared_state = params.shared_state

	self._shared_state = shared_state

	Managers.state.game_mode:on_gameplay_init()
end

GameplayInitGameModeDependencies.update = function (self, main_dt, main_t)
	local can_player_enter_game = Managers.state.game_mode:can_player_enter_game()

	if can_player_enter_game then
		self._shared_state.initialized_steps.GameplayInitGameModeDependencies = true

		local next_step_params = {
			shared_state = self._shared_state,
		}

		return GameplayInitStepPlayerEnterGame, next_step_params
	end
end

implements(GameplayInitGameModeDependencies, GameplayInitStepInterface)

return GameplayInitGameModeDependencies
