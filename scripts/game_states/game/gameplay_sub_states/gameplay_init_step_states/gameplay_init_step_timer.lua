local AdaptiveClockHandlerClient = require("scripts/managers/player/player_game_states/utilities/adaptive_clock_handler_client")
local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepNavWorldVolume = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_nav_world_volume")
local GameplayInitStepTimer = class("GameplayInitStepTimer")

GameplayInitStepTimer.on_enter = function (self, parent, params)
	local shared_state = params.shared_state
	self._shared_state = shared_state
	local is_server = shared_state.is_server

	self:_register_timer(is_server, shared_state)
end

GameplayInitStepTimer.update = function (self, main_dt, main_t)
	local next_step_params = {
		shared_state = self._shared_state
	}

	return GameplayInitStepNavWorldVolume, next_step_params
end

GameplayInitStepTimer._register_timer = function (self, is_server, out_shared_state)
	out_shared_state.gameplay_timer_registered = true

	if is_server then
		Managers.time:register_timer("gameplay", "main", 0)
	else
		local connection_manager = Managers.connection
		local network_event_delegate = connection_manager:network_event_delegate()
		out_shared_state.clock_handler_client = AdaptiveClockHandlerClient:new(network_event_delegate)
	end
end

implements(GameplayInitStepTimer, GameplayInitStepInterface)

return GameplayInitStepTimer
