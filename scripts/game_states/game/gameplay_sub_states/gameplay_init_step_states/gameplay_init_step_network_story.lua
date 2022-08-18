local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepLevelSpawned = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_level_spawned")
local GameplayInitStepNetworkStory = class("GameplayInitStepNetworkStory")

GameplayInitStepNetworkStory.on_enter = function (self, parent, params)
	local shared_state = params.shared_state
	local level = shared_state.level
	self._shared_state = shared_state

	Managers.state.network_story:on_gameplay_post_init(level)
end

GameplayInitStepNetworkStory.update = function (self, main_dt, main_t)
	local next_step_params = {
		shared_state = self._shared_state
	}

	return GameplayInitStepLevelSpawned, next_step_params
end

implements(GameplayInitStepNetworkStory, GameplayInitStepInterface)

return GameplayInitStepNetworkStory
