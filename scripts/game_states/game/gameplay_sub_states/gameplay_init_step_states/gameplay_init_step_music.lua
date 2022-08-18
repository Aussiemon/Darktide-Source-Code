local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepNetworkStory = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_network_story")
local GameplayInitStepMusic = class("GameplayInitStepMusic")

GameplayInitStepMusic.on_enter = function (self, parent, params)
	local shared_state = params.shared_state
	local level = shared_state.level
	local is_dedicated_server = shared_state.is_dedicated_server
	self._shared_state = shared_state

	self:_music_post_init(level, is_dedicated_server)
end

GameplayInitStepMusic.update = function (self, main_dt, main_t)
	local next_step_params = {
		shared_state = self._shared_state
	}

	return GameplayInitStepNetworkStory, next_step_params
end

GameplayInitStepMusic._music_post_init = function (self, level, is_dedicated_server)
	if not is_dedicated_server then
		Managers.wwise_game_sync:on_gameplay_post_init(level)
	end
end

implements(GameplayInitStepMusic, GameplayInitStepInterface)

return GameplayInitStepMusic
