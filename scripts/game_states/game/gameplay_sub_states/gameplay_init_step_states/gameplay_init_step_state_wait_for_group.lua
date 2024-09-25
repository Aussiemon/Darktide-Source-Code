-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_wait_for_group.lua

local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepStateLast = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_last")
local GameplayInitStepStateWaitForGroup = class("GameplayInitStepStateWaitForGroup")
local CLIENT_RPCS = {
	"rpc_group_loaded",
}

GameplayInitStepStateWaitForGroup.on_enter = function (self, parent, params)
	local shared_state = params.shared_state

	self._shared_state = shared_state
	self._ready_to_spawn = true

	local is_server = shared_state.is_server

	self._is_server = is_server

	if Managers.connection:host_type() == "hub_server" then
		self._report_time_out = 60
	end

	if not is_server then
		local connection_manager = Managers.connection
		local spawn_group_id = shared_state.spawn_group_id
		local host_channel_id = connection_manager:host_channel()

		if host_channel_id then
			RPC.rpc_finished_loading_level(host_channel_id, spawn_group_id)

			local network_event_delegate = connection_manager:network_event_delegate()

			network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))

			self._network_events_registered = true
		end

		self._ready_to_spawn = false
	end

	Managers.event:trigger("event_loading_resources_finished")
end

GameplayInitStepStateWaitForGroup.on_exit = function (self)
	local connection_manager = Managers.connection
	local network_event_delegate = connection_manager:network_event_delegate()

	if self._network_events_registered then
		network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	if self._is_server and Managers.connection:num_members() == 0 then
		Managers.event:trigger("spawn_group_loaded")
	end
end

GameplayInitStepStateWaitForGroup.update = function (self, main_dt, main_t)
	if self._report_time_out then
		self._report_time_out = self._report_time_out - main_dt

		if self._report_time_out < 0 then
			Crashify.print_exception("GameplayInitStepStateWaitForGroup", "No rpc_group_loaded within 60 seconds")

			self._report_time_out = nil
		end
	end

	if not self._shared_state.is_server then
		local lost_connection = not Managers.connection:host_channel()

		if lost_connection then
			self._shared_state.initialized_steps.GameplayInitStepStateWaitForGroup = true

			local next_step_params = {
				shared_state = self._shared_state,
			}

			return GameplayInitStepStateLast, next_step_params
		end
	end

	if self._ready_to_spawn then
		self._shared_state.initialized_steps.GameplayInitStepStateWaitForGroup = true

		local next_step_params = {
			shared_state = self._shared_state,
		}

		return GameplayInitStepStateLast, next_step_params
	end

	return nil, nil
end

GameplayInitStepStateWaitForGroup.rpc_group_loaded = function (self, channel_id, spawn_group)
	local expected_spawn_group = self._shared_state.spawn_group_id

	Log.info("StateGameplay", "[GameplayInitStepStateWaitForGroup][rpc_group_loaded] channel_id(%d), spawn_group(%d), expected_spawn_group(%d), peer_id(%s)", channel_id, spawn_group, expected_spawn_group, Network.peer_id())

	if spawn_group == expected_spawn_group then
		self._ready_to_spawn = true

		Managers.event:trigger("spawn_group_loaded")
	end
end

implements(GameplayInitStepStateWaitForGroup, GameplayInitStepInterface)

return GameplayInitStepStateWaitForGroup
