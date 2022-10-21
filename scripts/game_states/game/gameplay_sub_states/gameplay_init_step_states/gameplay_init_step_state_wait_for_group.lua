local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepStateLast = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_last")
local GameplayInitStepStateWaitForGroup = class("GameplayInitStepStateWaitForGroup")
local CLIENT_RPCS = {
	"rpc_group_loaded"
}

GameplayInitStepStateWaitForGroup.on_enter = function (self, parent, params)
	local shared_state = params.shared_state
	self._shared_state = shared_state
	self._ready_to_spawn = true
	local is_server = shared_state.is_server
	self._is_server = is_server

	if not is_server then
		local connection_manager = Managers.connection
		local spawn_group_id = shared_state.spawn_group_id
		local host_channel_id = connection_manager:host_channel()

		if host_channel_id then
			RPC.rpc_finished_loading_level(host_channel_id, spawn_group_id)

			local network_event_delegate = connection_manager:network_event_delegate()

			network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
		end

		self._ready_to_spawn = false
	end

	Managers.event:trigger("event_loading_resources_finished")
end

GameplayInitStepStateWaitForGroup.on_exit = function (self)
	local connection_manager = Managers.connection
	local network_event_delegate = connection_manager:network_event_delegate()

	if not self._is_server then
		network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

GameplayInitStepStateWaitForGroup.update = function (self, main_dt, main_t)
	if not self._shared_state.is_server then
		local lost_connection = not Managers.connection:host_channel()

		if lost_connection then
			local next_step_params = {
				shared_state = self._shared_state
			}

			return GameplayInitStepStateLast, next_step_params
		end
	end

	if self._ready_to_spawn then
		local next_step_params = {
			shared_state = self._shared_state
		}

		return GameplayInitStepStateLast, next_step_params
	end

	return nil, nil
end

GameplayInitStepStateWaitForGroup.rpc_group_loaded = function (self, channel_id, spawn_group)
	if spawn_group == self._shared_state.spawn_group_id then
		self._ready_to_spawn = true
	end
end

implements(GameplayInitStepStateWaitForGroup, GameplayInitStepInterface)

return GameplayInitStepStateWaitForGroup
