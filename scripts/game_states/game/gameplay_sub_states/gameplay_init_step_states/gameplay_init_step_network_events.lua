-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_network_events.lua

local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepTimer = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_timer")
local GameplayRpcs = require("scripts/game_states/game/utilities/gameplay_rpcs")
local GameplayInitStepNetworkEvents = class("GameplayInitStepNetworkEvents")
local SERVER_RPCS = GameplayRpcs.COMMON_SERVER_RPCS
local CLIENT_RPCS = GameplayRpcs.COMMON_CLIENT_RPCS

GameplayInitStepNetworkEvents.on_enter = function (self, parent, params)
	local shared_state = params.shared_state

	self._shared_state = shared_state

	local gameplay_state = parent:gameplay_state()
	local is_server = shared_state.is_server

	self:_register_network_events(gameplay_state, is_server, shared_state)
end

GameplayInitStepNetworkEvents.update = function (self, main_dt, main_t)
	local next_step_params = {
		shared_state = self._shared_state,
	}

	return GameplayInitStepTimer, next_step_params
end

GameplayInitStepNetworkEvents._register_network_events = function (self, gameplay_state, is_server, shared_state)
	local connection_manager = Managers.connection
	local network_event_delegate = connection_manager:network_event_delegate()

	if is_server then
		network_event_delegate:register_session_events(gameplay_state, unpack(SERVER_RPCS))
	else
		network_event_delegate:register_session_events(gameplay_state, unpack(CLIENT_RPCS))
	end

	shared_state.session_rpcs_registered = true
end

implements(GameplayInitStepNetworkEvents, GameplayInitStepInterface)

return GameplayInitStepNetworkEvents
