-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_last.lua

local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local SessionClient = require("scripts/multiplayer/session/session_client")
local GameplayInitStepStateLast = class("GameplayInitStepStateLast")

GameplayInitStepStateLast.on_enter = function (self, parent, params)
	local shared_state = params.shared_state

	self._shared_state = shared_state

	local is_server = shared_state.is_server

	self:_finalize_network_init(is_server, shared_state)
end

GameplayInitStepStateLast.update = function (self, main_dt, main_t)
	self._shared_state.initialized_steps.GameplayInitStepStateLast = true

	return nil, nil
end

GameplayInitStepStateLast._finalize_network_init = function (self, is_server, shared_state)
	if is_server then
		local fixed_frame_transmit_rate = GameParameters.fixed_frame_transmit_rate

		Network.set_max_transmit_rate(fixed_frame_transmit_rate)
		Managers.loading:end_load()
	else
		local lost_connection = not Managers.connection:host_channel()

		if lost_connection then
			return
		end

		local connection_manager = Managers.connection
		local game_session_manager = Managers.state.game_session
		local network_delegate = connection_manager:network_event_delegate()
		local engine_lobby = connection_manager:engine_lobby()
		local engine_game_session = game_session_manager:game_session()
		local clock_handler_client = shared_state.clock_handler_client
		local session_client = SessionClient:new(network_delegate, engine_lobby, engine_game_session, game_session_manager, clock_handler_client)

		game_session_manager:set_session_client(session_client)
	end
end

implements(GameplayInitStepStateLast, GameplayInitStepInterface)

return GameplayInitStepStateLast
