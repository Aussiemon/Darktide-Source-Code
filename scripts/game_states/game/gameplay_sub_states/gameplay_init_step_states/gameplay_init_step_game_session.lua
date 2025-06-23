-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_game_session.lua

local GameSessionManager = require("scripts/managers/multiplayer/game_session_manager")
local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepGameMode = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_game_mode")
local SessionHost = require("scripts/multiplayer/session/session_host")
local GameplayInitStepGameSession = class("GameplayInitStepGameSession")

GameplayInitStepGameSession.on_enter = function (self, parent, params)
	local shared_state = params.shared_state

	self._shared_state = shared_state

	local is_server = shared_state.is_server
	local connection_manager = Managers.connection
	local network_event_delegate = connection_manager:network_event_delegate()

	self:_init_game_session(is_server, network_event_delegate)
end

GameplayInitStepGameSession.update = function (self, main_dt, main_t)
	self._shared_state.initialized_steps.GameplayInitStepGameSession = true

	local next_step_params = {
		shared_state = self._shared_state
	}

	return GameplayInitStepGameMode, next_step_params
end

GameplayInitStepGameSession._init_game_session = function (self, is_server, network_event_delegate)
	local connection_manager = Managers.connection
	local approve_channel_delegate = connection_manager:approve_channel_delegate()
	local engine_lobby = connection_manager:engine_lobby()
	local fixed_time_step = self._shared_state.fixed_time_step
	local game_session_manager = GameSessionManager:new(fixed_time_step)
	local game_session = game_session_manager:game_session()

	if is_server then
		local session_host = SessionHost:new(network_event_delegate, approve_channel_delegate, engine_lobby, game_session)

		game_session_manager:set_session_host(session_host)
	end

	Managers.state.game_session = game_session_manager

	Managers.progression:clear_session_report()
end

implements(GameplayInitStepGameSession, GameplayInitStepInterface)

return GameplayInitStepGameSession
