local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local SessionClient = require("scripts/multiplayer/session/session_client")
local GameplayInitStepStateLast = class("GameplayInitStepStateLast")

GameplayInitStepStateLast.on_enter = function (self, parent, params)
	local shared_state = params.shared_state
	local is_server = shared_state.is_server

	self:_finalize_network_init(is_server)
end

GameplayInitStepStateLast.update = function (self, main_dt, main_t)
	return nil, nil
end

GameplayInitStepStateLast._finalize_network_init = function (self, is_server)
	if is_server then
		local fixed_frame_transmit_rate = GameParameters.fixed_frame_transmit_rate

		Network.set_max_transmit_rate(fixed_frame_transmit_rate)
		Managers.loading:end_load()
	else
		local connection_manager = Managers.connection
		local game_session_manager = Managers.state.game_session

		fassert(game_session_manager, "[GameplayInitStepStateLast] Game Session Manager not initialized.")

		local network_delegate = connection_manager:network_event_delegate()
		local engine_lobby = connection_manager:engine_lobby()
		local engine_game_session = game_session_manager:game_session()
		local session_client = SessionClient:new(network_delegate, engine_lobby, engine_game_session, game_session_manager)

		game_session_manager:set_session_client(session_client)
	end
end

implements(GameplayInitStepStateLast, GameplayInitStepInterface)

return GameplayInitStepStateLast
